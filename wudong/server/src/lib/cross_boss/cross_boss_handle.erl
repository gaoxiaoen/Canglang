%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 31. 五月 2016 22:51
%%%-------------------------------------------------------------------
-module(cross_boss_handle).

-author("hxming").
-include("common.hrl").
-include("cross_boss.hrl").
-include("goods.hrl").
-include("scene.hrl").
-include("battle.hrl").
%% API
-export([handle_call/3, handle_cast/2, handle_info/2]).

-export([gm/0]).

gm() ->
    cross_boss_proc:get_server_pid() ! notice_boss_hp_clinet.

handle_call({get_drop_has_key, MonId}, _From, State) ->
    case lists:keyfind(MonId, 1, State#st_cross_boss.boss_drop_has_list) of
        false ->
            {reply, 0, State};
        {MonId, Pkey} ->
            {reply, Pkey, State}
    end;

handle_call(get_state_remain_time, _From, State) ->
    #st_cross_boss{
        open_state = OpenState,
        time = Time
    } = State,
    {reply, {OpenState, max(0, Time - util:unixtime())}, State};

handle_call(get_act_state, _From, State) ->
    Code = ?IF_ELSE(State#st_cross_boss.open_state == ?CROSS_BOSS_STATE_START, 1, 0),
    {reply, Code, State};

handle_call(_msg, _From, State) ->
    ?DEBUG("udef msg ~p~n", [_msg]),
    {reply, ok, State}.


handle_cast({get_state_remain_time, Sid, DropNum, BaseHasNum}, State) ->
    #st_cross_boss{
        open_state = OpenState,
        time = Time
    } = State,
    cross_boss:get_state_remain_time_cast(Sid, DropNum, BaseHasNum, OpenState, Time-util:unixtime()),
    {noreply, State};


%%查询活动图标状态
handle_cast({check_state, Node, Sid}, State) ->
    if
        State#st_cross_boss.open_state == ?CROSS_BOSS_STATE_CLOSE -> skip;
        true ->
            Now = util:unixtime(),
            {ok, Bin} = pt_570:write(57001, {State#st_cross_boss.open_state, max(0, State#st_cross_boss.time - Now)}),
            server_send:send_to_sid(Node,Sid,Bin)
%%            center:apply(Node, server_send, send_to_sid, [Sid, Bin])
    end,
    {noreply, State};

%%检查进入
handle_cast({check_enter, Mb, Layer}, State0) ->
    %% 进入新的战场前，先切入
    {noreply, State} = handle_cast({check_quit, Mb#cb_damage.key}, State0),
    {Ret, NewState} =
        if
            State#st_cross_boss.open_state /= ?CROSS_BOSS_STATE_START ->
                {5, State};
            true ->
                %%通知玩家进入
                {X, Y} = util:list_rand(data_cross_boss_p_born:get(cross_boss:get_scene_id_by_layer(Layer))),
                server_send:send_node_pid(Mb#cb_damage.node, Mb#cb_damage.pid, {enter_cross_boss, 0, X, Y, Layer}),
                case lists:keytake(Mb#cb_damage.key, #cb_damage.key, State#st_cross_boss.damage_list) of
                    false ->
                        {1, State#st_cross_boss{
                            damage_list = [Mb | State#st_cross_boss.damage_list],
                            damage_guild_list = cross_boss:update_guild(Mb, State#st_cross_boss.damage_guild_list)}
                        };
                    {value, OldMb, Rest} ->
                        {1, State#st_cross_boss{damage_list = [cross_boss:update_mb(OldMb, Mb, Layer) | Rest]}}
                end
        end,
    {ok, Bin} = pt_570:write(57003, {Ret}),
    server_send:send_to_sid(Mb#cb_damage.node,Mb#cb_damage.sid,Bin),
%%    center:apply(Mb#cb_damage.node, server_send, send_to_sid, [Mb#cb_damage.sid, Bin]),

    %%%% 进入后通知血量
    spawn(fun() -> timer:sleep(1000), notice_boss_hp_clinet(NewState, Mb) end),
    {noreply, NewState};


%%检查退出
handle_cast({check_quit, Pkey}, State) ->
    case lists:keytake(Pkey, #cb_damage.key, State#st_cross_boss.damage_list) of
        false ->
            {noreply, State};
        {value, Mb, T} ->
            DamageList = [Mb#cb_damage{is_online = 0, pid = none} | T],
            #st_cross_boss{boss_pid_list = BossPidList, boss_drop_has_list = BossDropHasList} = State,
            F = fun({_Key, Pid}) -> Pid ! {clean_cross_player, Pkey} end,
            lists:map(F, BossPidList),
            F1 = fun({_MonId, Pkey1}) -> Pkey1 /= Pkey end,
            NewBossDropHasList = lists:filter(F1, BossDropHasList),
            {noreply, State#st_cross_boss{damage_list = DamageList, boss_drop_has_list = NewBossDropHasList}}
    end;

%% 击杀boss
handle_cast({kill_boss, Mon, Attacker, Klist}, State) ->
    case data_cross_boss:get(Mon#mon.mid) of
        [] ->
            {noreply, State};
        #base_cross_boss{type = Type} = BaseCrossBoss ->
            NewState =
                case Type of
                    1 -> %% boss
                        lists:foreach(fun(#st_hatred{pid = Pid}) ->
                            act_hi_fan_tian:trigger_finish_api(#player{pid = Pid},11,1)
                            end,Klist),
                        kill_boss(BaseCrossBoss, Attacker, State);
                    2 -> %% mon
                        kill_mon(BaseCrossBoss, Attacker, State)
                end,
            spawn(fun() -> mon_reward(NewState, Mon#mon.mid) end),
            ?DEBUG("Klist:~p", [Klist]),
            {noreply, NewState2} = handle_info({update_cross_has_pkey, Mon, Klist}, NewState),
            spawn(fun() -> notice_boss_hp_clinet(NewState2) end),
            case lists:keytake(Mon#mon.mid, 1, NewState2#st_cross_boss.boss_drop_has_list) of
                false ->
                    spawn(fun() -> score_notice_client(NewState2#st_cross_boss.damage_list, NewState2#st_cross_boss.damage_guild_list) end),
                    {noreply, NewState2};
                {value, {MonId, Pkey}, _Rest} ->
                    ?DEBUG("MonId:~p Pkey:~p", [MonId, Pkey]),
                    case lists:keytake(Pkey, #cb_damage.key, NewState2#st_cross_boss.damage_list) of
                        false ->
                            NewState99 = NewState2;
                        {value, CbDamage, RestDamageList} ->
                            NewDamageList =
                                [CbDamage#cb_damage{
                                    boss_drop_num = CbDamage#cb_damage.boss_drop_num + 1
                                } | RestDamageList],
                            center:apply(CbDamage#cb_damage.node, cross_boss, update_player_data, [Pkey, MonId]),
                            NewState99 = NewState2#st_cross_boss{damage_list = NewDamageList}
%%                             get_self_data(NewState99, Pkey, CbDamage#cb_damage.node, CbDamage#cb_damage.sid)
                    end,
                    spawn(fun() -> score_notice_client(NewState99#st_cross_boss.damage_list, NewState99#st_cross_boss.damage_guild_list) end),
                    {noreply, NewState99}
            end
    end;
%%击杀玩家
handle_cast({kill_player, Player, Attacker}, State) ->
    NewState = kill_player(Player, Attacker, State),
    {noreply, NewState};
%%更新在线信息
handle_cast(update_online, State) ->
    NewState = update_online(State),
    {noreply, NewState};
%%凌晨清除
handle_cast(midnight_clean, State) ->
    util:cancel_ref([State#st_cross_boss.ref]),
    util:cancel_ref([State#st_cross_boss.ref_boss_hp]),
    NewState0 = State#st_cross_boss{damage_list = [], damage_guild_list = [], boss_hp_list = [], boss_pid_list = [], boss_ids = [], boss_drop_has_list = []},
    NewState = cross_boss_proc:set_timer(NewState0, util:unixtime()),
    {noreply, NewState};
%%获取统计信息
handle_cast({get_tatal_data, Pkey, Node, Sid}, State) ->
    get_tatal_data(State, Pkey, Node, Sid),
    {noreply, State};
handle_cast({get_self_data, Pkey, Node, Sid}, State) ->
    get_self_data(State, Pkey, Node, Sid),
    {noreply, State};

handle_cast({drop_mon_reward, Mid}, State) ->
    F0 = fun(Id) ->
        #base_cross_boss_box_mon{boss_id = BossId} = data_cross_boss_mon_reward:get(Id),
        BossId == Mid
         end,
    Ids = lists:filter(F0, data_cross_boss_mon_reward:ids()),
    #base_cross_boss{x = X, y = Y, layer = Layer} = data_cross_boss:get(Mid),
    SceneId = cross_boss:get_scene_id_by_layer(Layer),
    XYList = util:list_filter_repeat(get_create_mon_box_xy_list(SceneId, X, Y)),
    F = fun
            (_Id, []) ->
                [];
            (Id, AccList) ->
                {X0, Y0} = util:list_rand(AccList),
                #base_cross_boss_box_mon{mon_id = MonId} = data_cross_boss_mon_reward:get(Id),
                mon_agent:create_mon_cast([MonId, SceneId, X0, Y0, 0, 1, []]),
                AccList -- [{X0, Y0}]
        end,
    lists:foldl(F, XYList, Ids),
    {noreply, State};

handle_cast(drop_mon_reward, State) ->
    Ids = data_cross_boss_mon_reward:ids(),
    F = fun(Id) ->
        #base_cross_boss_box_mon{x = X, y = Y, mon_id = MonId} = data_cross_boss_mon_reward:get(Id),
        SceneId = cross_boss:get_scene_id_by_mon(MonId),
        mon_agent:create_mon_cast([MonId, SceneId, X, Y, 0, 1, []])
        end,
    lists:map(F, Ids),
    {noreply, State};

handle_cast({recv_score_reward, Pkey, Score, Node, Pid, Sid}, State) ->
    #st_cross_boss{damage_list = DamageList} = State,
    case lists:keytake(Pkey, #cb_damage.key, DamageList) of
        false -> NewCbDamageList = DamageList;
        {value, CbDamege, Rest} ->
            case lists:member(Score, CbDamege#cb_damage.recv_score_reward) of
                true -> NewCbDamage = CbDamege;
                false ->
                    if
                        CbDamege#cb_damage.score < Score ->
                            NewCbDamage = CbDamege;
                        true ->
                            NewCbDamage =
                                CbDamege#cb_damage{
                                    recv_score_reward = [Score | CbDamege#cb_damage.recv_score_reward]
                                },
                            server_send:send_node_pid(Node, Pid, {cross_boss_score_reward, Score})
                    end
            end,
            NewCbDamageList = [NewCbDamage | Rest]
    end,
    NewState = State#st_cross_boss{damage_list = NewCbDamageList},
    get_self_data(NewState, Pkey, Node, Sid),
    {noreply, NewState};

handle_cast(_msg, State) ->
%%     ?DEBUG("udef msg ~p~n", [_msg]),
    {noreply, State}.

%%更新在线信息
handle_info(update_online, State) ->
    NewState = update_online(State),
    {noreply, NewState};

handle_info(gm_start, State) ->
    Ref = erlang:send_after(1000, self(), {start, ?ONE_HOUR_SECONDS}),
    State0 = State#st_cross_boss{open_state = ?CROSS_BOSS_STATE_READY, ref = Ref, time = util:unixtime() + 2 * ?ONE_HOUR_SECONDS},
    {noreply, State0};

handle_info({clean_cross_player, Pkey}, State) ->
    #st_cross_boss{boss_pid_list = BossPidList, boss_drop_has_list = BossDropHasList} = State,
    F = fun({_Key, Pid}) ->
        Pid ! {clean_cross_player, Pkey}
        end,
    lists:map(F, BossPidList),
    F1 = fun({_MonId, Pkey1}) -> Pkey1 /= Pkey end,
    NewBossDropHasList = lists:filter(F1, BossDropHasList),
    {noreply, State#st_cross_boss{boss_drop_has_list = NewBossDropHasList}};

handle_info(gm_box_mon, State) ->
    ?DEBUG("gm_box_mon~n", []),
    {ok, Bin} = pt_570:write(57002, {1}),
    server_send:send_to_scene(?SCENE_ID_CROSS_BOSS_ONE, Bin),
    spawn(fun() -> timer:sleep(5000), ?CAST(cross_boss_proc:get_server_pid(), drop_mon_reward) end),
    {noreply, State};

%%准备
handle_info({ready, ReadyTime, LastTime}, State) when State#st_cross_boss.open_state == ?CROSS_BOSS_STATE_CLOSE ->
    ?DEBUG("cross boss ready ~p~n", [ReadyTime]),
    util:cancel_ref([State#st_cross_boss.ref]),
    util:cancel_ref([State#st_cross_boss.ref_boss_hp]),
    Now = util:unixtime(),
    {ok, Bin} = pt_570:write(57001, {?CROSS_BOSS_STATE_READY, ReadyTime}),
    F = fun(Node) ->
        center:apply(Node, server_send, send_to_all, [Bin])
        end,
    lists:foreach(F, center:get_nodes()),
    Ref = erlang:send_after(ReadyTime * 1000, self(), {start, LastTime}),
    NewState = State#st_cross_boss{open_state = ?CROSS_BOSS_STATE_READY, time = Now + ReadyTime, ref = Ref},
    {noreply, NewState};

%%开始
handle_info({start, LastTime}, State0) when State0#st_cross_boss.open_state /= ?CROSS_BOSS_STATE_START ->
    State = State0#st_cross_boss{damage_list = [], damage_guild_list = []},
    util:cancel_ref([State#st_cross_boss.ref]),
    util:cancel_ref([State#st_cross_boss.ref_boss_hp]),
    Now = util:unixtime(),
    {ok, Bin} = pt_570:write(57001, {?CROSS_BOSS_STATE_START, LastTime}),
    F = fun(Node) ->
        center:apply(Node, server_send, send_to_all, [Bin])
        end,
    lists:foreach(F, center:get_nodes()),
    Ref = erlang:send_after(LastTime * 1000, self(), close),
    RefBossHp = erlang:send_after(5 * 1000, self(), notice_boss_hp_clinet),
    BossIdList = cross_boss_init:init_boss(),
    BossPidList = lists:flatmap(fun(BossId) -> cross_boss:create_boss(BossId, 0) end, BossIdList),
    NewState = State#st_cross_boss{
        open_state = ?CROSS_BOSS_STATE_START,
        is_kill = 0,
        time = Now + LastTime,
        start_time = Now,
        ref = Ref,
        ref_boss_hp = RefBossHp,
        damage_list = [],
        boss_pid_list = BossPidList,
        boss_hp_list = cross_boss_init:init_boss_hp()
    },
    ?DEBUG("cross boss start ~n"),
    {noreply, NewState};

%%关闭
handle_info(close, State) ->
    util:cancel_ref([State#st_cross_boss.ref]),
    util:cancel_ref([State#st_cross_boss.ref_boss_hp]),
    Now = util:unixtime(),
    {ok, Bin} = pt_570:write(57001, {?CROSS_BOSS_STATE_CLOSE, 0}),
    F = fun(Node) ->
        center:apply(Node, server_send, send_to_all, [Bin])
        end,
    lists:foreach(F, center:get_nodes()),
    NState = update_online(State),
    spawn(fun() -> to_client_reward(NState) end),
    NewState = cross_boss_proc:set_timer(NState#st_cross_boss{ref = []}, Now),
    spawn(fun() -> scene_cross:send_out_cross(?SCENE_TYPE_CROSS_BOSS) end),
    erlang:send_after(5000, self(), clean),
    {noreply, NewState};


%%清除数据--譬如踢人
handle_info(clean, State) ->
    scene_agent:clean_scene_area(?SCENE_ID_CROSS_BOSS_ONE, 0),
    scene_agent:clean_scene_area(?SCENE_ID_CROSS_BOSS_TWO, 0),
    scene_agent:clean_scene_area(?SCENE_ID_CROSS_BOSS_THREE, 0),
    scene_agent:clean_scene_area(?SCENE_ID_CROSS_BOSS_FOUR, 0),
    scene_agent:clean_scene_area(?SCENE_ID_CROSS_BOSS_FIVE, 0),
    BossPidList = State#st_cross_boss.boss_pid_list,
    F = fun({_Key, MonPid}) ->
        case misc:is_process_alive(MonPid) of
            true -> %% 关闭当前还存活的怪物进程
                monster:stop_broadcast(MonPid);
            false ->
                skip
        end
    end,
    lists:map(F, BossPidList),
    {noreply, State#st_cross_boss{boss_ids = [], boss_pid_list = [], boss_drop_has_list = []}};

%% 更新血量
handle_info({update_cross_boss, Mon, KList}, State) ->
%%     ?DEBUG("update_cross_boss####", []),
    Mid = Mon#mon.mid, Hp = Mon#mon.hp, HpLim = Mon#mon.hp_lim,
    #st_cross_boss{boss_hp_list = BossHpList} = State,
    case lists:keytake(Mid, 1, BossHpList) of
        false ->
            NewBossHpList = BossHpList;
        {value, {Mid, _HpLim, _}, Rest} ->
            NewBossHpList = [{Mid, HpLim, Hp} | Rest]
    end,
    self() ! {update_cross_has_pkey, Mon, KList},
    {noreply, State#st_cross_boss{boss_hp_list = NewBossHpList}};

handle_info({update_cross_has_pkey, Mon, Klist}, State) ->
    case data_cross_boss:get(Mon#mon.mid) of
        [] ->
            NewState = State;
        #base_cross_boss{type = Type} ->
            if
                Type /= 1 ->
                    NewState = State;
                true ->
                    FF = fun(#st_hatred{key = Key} = R) ->
                        case lists:keyfind(Key, #cb_damage.key, State#st_cross_boss.damage_list) of
                            false -> [];
                            #cb_damage{lv = Lv} ->
                                MonLayer = cross_boss:get_layer_by_mon(Mon#mon.mid),
                                if %% 过滤掉不合格的玩家
                                    MonLayer > 2 -> [R];
                                    Lv - Mon#mon.lv < 30 -> [R];
                                    true -> []
                                end
                        end
                    end,
                    F = fun(#st_hatred{hurt = Hurt1}, #st_hatred{hurt = Hurt2}) ->
                        Hurt1 > Hurt2
                    end,
                    NKList = lists:sort(F, lists:flatmap(FF, Klist)),
                    F2 = fun(#st_hatred{key = Pkey}) ->
                        case lists:keyfind(Pkey, #cb_damage.key, State#st_cross_boss.damage_list) of
                            false -> false;
                            CbDamage ->
                                CbDamage#cb_damage.boss_drop_num < data_cross_boss_has_num:get()
                        end
                    end,
                    NewKList = lists:filter(F2, NKList),
                    if
                        NewKList == [] ->
                            NewState = State;
                        true ->
                            #st_hatred{key = Pkey} = hd(NewKList),
                            case lists:keytake(Mon#mon.mid, 1, State#st_cross_boss.boss_drop_has_list) of
                                false ->
                                    NewState = State#st_cross_boss{boss_drop_has_list = [{Mon#mon.mid, Pkey} | State#st_cross_boss.boss_drop_has_list]};
                                {value, _, Rest} ->
                                    NewState = State#st_cross_boss{boss_drop_has_list = [{Mon#mon.mid, Pkey} | Rest]}
                            end
                    end
            end
    end,
    {noreply, NewState};

handle_info(notice_boss_hp_clinet, State) ->
    util:cancel_ref([State#st_cross_boss.ref_boss_hp]),
    spawn(fun() -> notice_boss_hp_clinet(State) end),
    RefBossHp = erlang:send_after(5 * 1000, self(), notice_boss_hp_clinet),
    {noreply, State#st_cross_boss{ref_boss_hp = RefBossHp}};

handle_info(_msg, State) ->
    ?DEBUG("udef msg ~p~n", [_msg]),
    {noreply, State}.

%%击杀公告
kill_boss_msg(BaseCrossBoss, Attacker, _State) ->
    #base_cross_boss{boss_id = MonId, layer = Layer} = BaseCrossBoss,
    #mon{name = MonName} = data_mon:get(MonId),
    #attacker{sn = Sn, gname = GName} = Attacker,
    SnName = center:get_sn_name_by_sn(Sn),
    notice_sys:add_notice(cross_boss_kill, [Sn, SnName, MonName, GName, Layer]).

%%击杀公告
kill_player_msg(Attacker, Player, State) ->
    #st_cross_boss{damage_list = DamageList, damage_guild_list = _DamageGuildList} = State,
    #attacker{sign = Sign, sn = AttSn, name = AttName, gname = AttGName, key = Pkey} = Attacker,
    if
        Sign == 0 -> %% 怪物
            skip;
        true ->
            #player{sn = DefSn, nickname = DefName, sn_name = DefSnName0, key = DefKey} = Player,
            AttSnName = center:get_sn_name_by_sn(AttSn),
            #cb_damage{guild_main = GuildMain, layer = Layer} = lists:keyfind(Pkey, #cb_damage.key, DamageList),
            AttPos = ?IF_ELSE(GuildMain == 1, ?T("盟主"), ?T("成员")),
            #cb_damage{guild_main = DefGuildMain, guild_name = DefGuildName} = lists:keyfind(DefKey, #cb_damage.key, DamageList),
            DefPos = ?IF_ELSE(DefGuildMain == 1, ?T("盟主"), ?T("成员")),
            DefSnName = ?IF_ELSE(DefSnName0 == null, ?T("未知"), DefSnName0),
            notice_sys:add_notice(cross_player_kill, [Pkey, AttSn, AttSnName, AttGName, AttPos, AttName, DefKey, DefSn, DefSnName, DefGuildName, DefPos, DefName, Layer])
    end.

kill_boss(BaseCrossBoss, Attacker, State) ->
    #base_cross_boss_score{
        kill_boss = KillBossScore,
        max_kill_boss = MaxKillBossScore
    } = data_cross_boss_score:get(),
    #st_cross_boss{damage_list = DamageList, kill_total_num = KillTotalNum} = State,
    #attacker{key = Key, gkey = GKey} = Attacker,
    case lists:keytake(Key, #cb_damage.key, DamageList) of
        false ->
            NDamageList = DamageList;
        {value, CbDamage, Rest} ->
            NewCbDamage = CbDamage#cb_damage{kill_boss_num = CbDamage#cb_damage.kill_boss_num + 1},
            NDamageList = [NewCbDamage | Rest]
    end,
    F = fun(#cb_damage{guild_key = GuildKey} = Cb) ->
        if
            GKey == GuildKey ->
                update_score(Cb#cb_damage{kill_boss_score = min(MaxKillBossScore, Cb#cb_damage.kill_boss_score + KillBossScore)});
            true ->
                Cb
        end
        end,
    NewDamageList = lists:map(F, NDamageList),
    NewState0 = State#st_cross_boss{damage_list = NewDamageList, kill_total_num = KillTotalNum + 1},
    spawn(fun() -> kill_boss_msg(BaseCrossBoss, Attacker, NewState0) end),
    NewState = update_online(NewState0),
    spawn(fun() ->
        score_notice_client(NewState#st_cross_boss.damage_list, NewState#st_cross_boss.damage_guild_list) end),
    NewState.

kill_mon(_BaseCrossBoss, Attacker, State) ->
    #base_cross_boss_score{
        kill_mon = KillMonScore,
        max_kill_mon = MaxKillMon
    } = data_cross_boss_score:get(),
    #st_cross_boss{damage_list = DamageList, kill_total_num = KillTotalNum} = State,
    #attacker{key = Key, gkey = GKey} = Attacker,
    case lists:keytake(Key, #cb_damage.key, DamageList) of
        false ->
            NDamageList = DamageList;
        {value, CbDamage, Rest} ->
            NewCbDamage = CbDamage#cb_damage{kill_mon_num = CbDamage#cb_damage.kill_mon_num + 1},
            NDamageList = [NewCbDamage | Rest]
    end,
    F = fun(#cb_damage{guild_key = GuildKey} = Cb) ->
        if
            GKey == GuildKey ->
                update_score(Cb#cb_damage{kill_mon_score = min(MaxKillMon, Cb#cb_damage.kill_mon_score + KillMonScore)});
            true ->
                Cb
        end
        end,
    NewDamageList = lists:map(F, NDamageList),
    NewState0 = State#st_cross_boss{damage_list = NewDamageList, kill_total_num = KillTotalNum + 1},
    NewState = update_online(NewState0),
    spawn(fun() ->
        score_notice_client(NewState#st_cross_boss.damage_list, NewState#st_cross_boss.damage_guild_list) end),
    NewState.

%% 击杀玩家
kill_player(Player, Attacker, State) ->
    #base_cross_boss_score{
        max_kill_guild_player = MaxKillGuildPlayerScore,
        kill_guild_player = KillGuildPlayerScore,
        max_kill_guild_main = MaxKillGuildMainScore,
        kill_guild_main = KillGuildMainScore
    } = data_cross_boss_score:get(),
    #st_cross_boss{damage_list = DamageList} = State,
    #attacker{key = Pkey} = Attacker,
    #st_guild{guild_position = GuildPos} = Player#player.guild,
    spawn(fun() -> kill_player_msg(Attacker, Player, State) end),
    case lists:keytake(Pkey, #cb_damage.key, DamageList) of
        false ->
            State;
        {value, CbDemage, Rest} ->
            case lists:keytake(Player#player.key, 1, CbDemage#cb_damage.kill_log_list) of
                false ->
                    if
                        GuildPos == 1 -> %% 击杀帮主
                            NewCbDemage0 =
                                CbDemage#cb_damage{
                                    kill_player_num = CbDemage#cb_damage.kill_player_num + 1,
                                    kill_player_main_score = min(CbDemage#cb_damage.kill_player_main_score + KillGuildMainScore, MaxKillGuildMainScore),
                                    kill_log_list = [{Player#player.key,1}|CbDemage#cb_damage.kill_log_list]
                                };
                        true ->
                            NewCbDemage0 =
                                CbDemage#cb_damage{
                                    kill_player_num = CbDemage#cb_damage.kill_player_num + 1,
                                    kill_player_score = min(CbDemage#cb_damage.kill_player_score + KillGuildPlayerScore, MaxKillGuildPlayerScore),
                                    kill_log_list = [{Player#player.key,1}|CbDemage#cb_damage.kill_log_list]
                                }
                    end,
                    NewCbDemage = update_score(NewCbDemage0);
                {value, {_DefPkey, KillNum}, RestKillLogList} ->
                    BaseKillNum = data_cross_boss_kill_num:get(),
                    if
                        KillNum >= BaseKillNum -> NewCbDemage0 = CbDemage;
                        GuildPos == 1 -> %% 击杀帮主
                            NewCbDemage0 =
                                CbDemage#cb_damage{
                                    kill_player_num = CbDemage#cb_damage.kill_player_num + 1,
                                    kill_player_main_score = min(CbDemage#cb_damage.kill_player_main_score + KillGuildMainScore, MaxKillGuildMainScore),
                                    kill_log_list = [{Player#player.key,KillNum+1}|RestKillLogList]
                                };
                        true ->
                            NewCbDemage0 =
                                CbDemage#cb_damage{
                                    kill_player_num = CbDemage#cb_damage.kill_player_num + 1,
                                    kill_player_score = min(CbDemage#cb_damage.kill_player_score + KillGuildPlayerScore, MaxKillGuildPlayerScore),
                                    kill_log_list = [{Player#player.key,KillNum+1}|RestKillLogList]
                                }
                    end,
                    NewCbDemage = update_score(NewCbDemage0)
            end,

            NewState0 = State#st_cross_boss{damage_list = [NewCbDemage | Rest]},
            NewState = update_guild_score(CbDemage#cb_damage.guild_key, NewCbDemage#cb_damage.score - CbDemage#cb_damage.score, NewState0),
            score_notice_client([NewCbDemage], NewState#st_cross_boss.damage_guild_list),
            NewState
    end.
%% 每分钟触发
update_online(State) ->
    #base_cross_boss_score{
        online = BaseOnlineScore,
        max_online = BaseMaxOnlineScore
    } = data_cross_boss_score:get(),
    #st_cross_boss{
        damage_list = DamageList,
        damage_guild_list = DamageGuildList
    } = State,
    %%处理在线积分计算
    F0 = fun(#cb_damage{is_online = IsOnline, online_score = OnlineScore, online_min = OnlineMin} = Cb) ->
        ?IF_ELSE(IsOnline == 1, update_score(Cb#cb_damage{online_min = OnlineMin + 1, online_score = min(OnlineScore + BaseOnlineScore, BaseMaxOnlineScore)}), Cb)
         end,
    NDamageList = lists:map(F0, DamageList),
    F1 = fun(#cb_damage{score = Sc1}, #cb_damage{score = Sc2}) ->
        Sc1 > Sc2
         end,
    NewDamageList0 = lists:sort(F1, NDamageList),
    %% 处理玩家积分排名
    F2 = fun(Cb, {Acc, Count}) -> {[Cb#cb_damage{rank = Count} | Acc], Count + 1} end,
    {NewDamageList, _Count} = lists:foldl(F2, {[], 1}, NewDamageList0),
    F3 = fun(#cb_damage{guild_key = GuildKey, score = Score}, AccDamageGuildList) ->
        case lists:keytake(GuildKey, #cb_guild_damage.guild_key, AccDamageGuildList) of
            false ->
                AccDamageGuildList;
            {value, Acc, Rest} ->
                [Acc#cb_guild_damage{score = Acc#cb_guild_damage.score + Score} | Rest]
        end
         end,
    NDamageGuildList = lists:map(fun(R) -> R#cb_guild_damage{score = 0} end, DamageGuildList),
    %% 统计公会积分总数
    NewDamageGuildList0 = lists:foldl(F3, NDamageGuildList, NewDamageList),
    F4 = fun(#cb_guild_damage{score = Sc1}, #cb_guild_damage{score = Sc2}) ->
        Sc1 > Sc2
         end,
    NewDamageGuildList1 = lists:sort(F4, NewDamageGuildList0),
    %% 处理公会积分排名
    F5 = fun(Cb, {Acc, Count}) -> {[Cb#cb_guild_damage{rank = Count} | Acc], Count + 1} end,
    {NewDamageGuildList, _Count0} = lists:foldl(F5, {[], 1}, NewDamageGuildList1),
    spawn(fun() -> score_notice_client(NewDamageList, NewDamageGuildList) end),
    State#st_cross_boss{damage_list = NewDamageList, damage_guild_list = NewDamageGuildList}.

update_score(Cb) ->
    #cb_damage{
        kill_player_score = Score1, %% 击杀其他仙盟玩家获得积分
        kill_mon_score = Score2, %% 击杀boss获得积分
        kill_boss_score = Score3, %% 击杀终极boss获得积分
        online_score = Score4, %% 在线时间获得积分
        kill_player_main_score = Score5, %% 击杀盟主获得积分
        score = _Score
    } = Cb,
    Cb#cb_damage{score = Score1 + Score2 + Score3 + Score4 + Score5}.

get_tatal_data(State, Pkey, Node, Sid) ->
    #st_cross_boss{damage_list = DamageList, damage_guild_list = DamageGuildList} = State,
    F1 = fun(#cb_damage{
        rank = Rank,
        name = Name,
        kill_mon_num = KillMonNum,
        kill_boss_num = KillBossNum,
        kill_player_num = KillPlayerNum,
        online_min = OnlineMin,
        score = Score
    }) ->
        if
            Rank == 0 -> [];
            Rank =< 10 -> [[Rank, Name, KillMonNum, KillBossNum, KillPlayerNum, OnlineMin, Score]];
            true -> []
        end
         end,
%%     ProDamageList = lists:flatmap(F1, lists:sublist(DamageList, 10)),
    ProDamageList = lists:sort(lists:flatmap(F1, DamageList)),
    F2 = fun(#cb_guild_damage{
        rank = Rank,
        guild_name = GuildName,
        guild_main_name = GuildMainName,
        player_num = PlayerNum,
        score = GuildScore
    }) ->
        if
            Rank == 0 -> [];
            Rank =< 10 -> [[Rank, GuildName, GuildMainName, PlayerNum, GuildScore]];
            true -> []
        end
         end,
%%     ProDamageGuildList = lists:flatmap(F2, lists:sublist(DamageGuildList, 10)),
    ProDamageGuildList = lists:sort(lists:flatmap(F2, DamageGuildList)),
    #cb_damage{
        guild_key = GuildKey,
        rank = MyRank,
        score = MyScore,
        kill_mon_num = MyKillMonNum,
        kill_boss_num = MyKillBossNum,
        kill_player_num = MyKillPlayerNum,
        online_min = MyOnlineMin
    } =
        case lists:keyfind(Pkey, #cb_damage.key, DamageList) of
            false ->
                #cb_damage{};
            CbDamage ->
                CbDamage
        end,
    #cb_guild_damage{
        rank = MyGuildRank,
        guild_name = MyGuildName,
        guild_main_name = MyGuildMainName,
        player_num = MyPlayerNum,
        score = MyGuildScore
    } =
        case lists:keyfind(GuildKey, #cb_guild_damage.guild_key, DamageGuildList) of
            false ->
                #cb_guild_damage{};
            CbGuildDamage ->
                CbGuildDamage
        end,
    {ok, Bin} = pt_570:write(57005, {MyRank, MyScore, MyGuildScore, MyKillMonNum, MyKillBossNum, MyKillPlayerNum, MyOnlineMin, MyGuildRank, MyGuildName, MyGuildMainName, MyPlayerNum, MyGuildScore, ProDamageList, ProDamageGuildList}),
    server_send:send_to_sid(Node,Sid,Bin).
%%    center:apply(Node, server_send, send_to_sid, [Sid, Bin]).

get_self_data(State, Pkey, Node, Sid) ->
    ?DEBUG("Pkey:~p Node:~p", [Pkey, Node]),
    #st_cross_boss{damage_list = DamageList, damage_guild_list = DamageGuildList} = State,
    case lists:keyfind(Pkey, #cb_damage.key, DamageList) of
        false ->
            MyScore = 0, GKey = 0, RecvScore = 0, HasDropNum = 0;
        #cb_damage{score = MyScore0, guild_key = GKey0, recv_score_reward = RecvList, boss_drop_num = HasDropNum0} ->
            MyScore = MyScore0, GKey = GKey0, RecvScore = ?IF_ELSE(RecvList == [], 0, lists:max(RecvList)), HasDropNum = HasDropNum0
    end,
    case lists:keyfind(GKey, #cb_guild_damage.guild_key, DamageGuildList) of
        false ->
            MyGuildScore = 0;
        #cb_guild_damage{score = MyGuildScore} ->
            MyGuildScore
    end,
    BaseHasNum = data_cross_boss_has_num:get(),
    {ok, Bin} = pt_570:write(57006, {MyScore, MyGuildScore, RecvScore, min(HasDropNum, BaseHasNum), BaseHasNum}),
    server_send:send_to_sid(Node,Sid,Bin),
%%    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    ok.

update_guild_score(GKey, AddScore, State) ->
    #st_cross_boss{damage_guild_list = DamageGuildList} = State,
    case lists:keytake(GKey, #cb_guild_damage.guild_key, DamageGuildList) of
        false -> State;
        {value, DamageGuild, Rest} ->
            State#st_cross_boss{damage_guild_list = [DamageGuild#cb_guild_damage{score = DamageGuild#cb_guild_damage.score + AddScore} | Rest]}
    end.

to_client_reward(State) ->
    #st_cross_boss{
        damage_guild_list = DamageGuildList
    } = State,
    F = fun(#cb_guild_damage{rank = Rank, node = Node, guild_key = GuidKey}) ->
        case data_cross_boss_reward:get_by_rank(Rank) of
            [] ->
                skip;
            {Reward1, Reward2} ->
                center:apply(Node, cross_boss, to_client_reward, [GuidKey, Rank, Reward1, Reward2]),
                ok
        end
        end,
    lists:map(F, DamageGuildList),
    ok.

%% 场景内怪物全部死亡后，触发
mon_reward(_State, Mid) ->
    {ok, Bin} = pt_570:write(57002, {1}),
    server_send:send_to_scene(cross_boss:get_scene_id_by_mon(Mid), 0, Bin),
    timer:sleep(15000),
    ?CAST(cross_boss_proc:get_server_pid(), {drop_mon_reward, Mid}).

notice_boss_hp_clinet(State) ->
    #st_cross_boss{
        boss_hp_list = BossHpList,
        boss_drop_has_list = BossDropHasList,
        damage_list = DamageList
    } = State,
    FF = fun(SceneId) ->
        F0 = fun({Mid, HpLim, Hp}) ->
            case cross_boss:get_scene_id_by_mon(Mid) == SceneId of
                true -> [[Mid, HpLim, Hp]];
                false -> []
            end
        end,
        ProList = lists:flatmap(F0, BossHpList),
        F2 = fun({Mid2, Key2}) ->
            case lists:keyfind(Key2, #cb_damage.key, DamageList) of
                false ->
                    Sex = 0, Lv = 0, Avatar = "";
                #cb_damage{sex = Sex0, lv = Lv0, avatar = Avatar0} ->
                    Sex = Sex0, Lv = Lv0, Avatar = Avatar0
            end,
            [Mid2, Key2, Sex, Lv, Avatar]
        end,
        ProList2 = lists:map(F2, BossDropHasList),
        {ok, Bin} = pt_570:write(57007, {ProList, ProList2}),
        server_send:send_to_scene(SceneId, 0, Bin)
    end,
    lists:map(FF, [?SCENE_ID_CROSS_BOSS_ONE, ?SCENE_ID_CROSS_BOSS_TWO, ?SCENE_ID_CROSS_BOSS_THREE, ?SCENE_ID_CROSS_BOSS_FOUR, ?SCENE_ID_CROSS_BOSS_FIVE]),
    ok.

notice_boss_hp_clinet(State, Mb) ->
    #cb_damage{node = Node, sid = Sid, layer = Layer} = Mb,
    #st_cross_boss{
        boss_hp_list = BossHpList,
        boss_drop_has_list = BossDropHasList,
        damage_list = DamageList
    } = State,
    F0 = fun({Mid, HpLim, Hp}) ->
        BaseLayer = data_cross_boss:get_layer_by_monId(Mid),
        if
            BaseLayer == Layer -> [[Mid, HpLim, Hp]];
            true -> []
        end
    end,
    ProList = lists:flatmap(F0, BossHpList),
    F2 = fun({Mid2, Key2}) ->
        case lists:keyfind(Key2, #cb_damage.key, DamageList) of
            false ->
                Sex = 0, Lv = 0, Avatar = "";
            #cb_damage{sex = Sex0, lv = Lv0, avatar = Avatar0} ->
                Sex = Sex0, Lv = Lv0, Avatar = Avatar0
        end,
        [Mid2, Key2, Sex, Lv, Avatar]
    end,
    ProList2 = lists:map(F2, BossDropHasList),
    {ok, Bin} = pt_570:write(57007, {ProList, ProList2}),
    server_send:send_to_sid(Node,Sid,Bin),
%%    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    ok.

score_notice_client(DamageList, DamageGuildList) ->
    F = fun(#cb_damage{node = Node, pid = Pid, is_online = IsOnline, boss_drop_num = HasDropNum, score = Score, guild_key = GuildKey, recv_score_reward = RecvList}) ->
        if
            IsOnline == 0 -> skip;
            true ->
                case lists:keyfind(GuildKey, #cb_guild_damage.guild_key, DamageGuildList) of
                    false ->
                        skip;
                    #cb_guild_damage{score = GuildScore} ->
                        MaxRecvScore = ?IF_ELSE(RecvList == [], 0, lists:max(RecvList)),
                        BaseHasNum = data_cross_boss_has_num:get(),
                        {ok, Bin} = pt_570:write(57006, {Score, GuildScore, MaxRecvScore, HasDropNum, BaseHasNum}),
                        center:apply(Node, server_send, send_to_pid, [Pid, Bin])
                end
        end
        end,
    lists:map(F, DamageList).

get_create_mon_box_xy_list(SceneId, X, Y) ->
    F0 = fun(XX) ->
        if
            XX rem 4 == 0 ->
                F1 = fun(YY) ->
                    if
                        YY rem 5 == 0 ->
                            case scene:can_moved(SceneId, XX, YY) of
                                true -> [{XX, YY}];
                                false -> []
                            end;
                        true -> []
                    end
                     end,
                lists:flatmap(F1, lists:seq(max(0, Y - 15), Y + 15));
            true -> []
        end
         end,
    lists:flatmap(F0, lists:seq(max(0, X - 15), X + 15)).