%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 怪物进程
%%% @end
%%% Created : 30. 十月 2015 下午2:53
%%%-------------------------------------------------------------------
-module(monster).
-author("fancy").
-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("battle.hrl").
-include("guild_war.hrl").
-include("invade.hrl").
-include("skill.hrl").
-include("dungeon.hrl").
-include("marry.hrl").
-include("party.hrl").
-include("cross_scuffle_elite.hrl").
-behaviour(gen_server).

%% API
-export([
    start/1, stop/1, stop_broadcast/1, trace_info_back/3, get_hatred_max/1, sync_mon_pid/1, sync_mon_hp/1, get_mon/1
]).

%% state fun
-export([
    sleep/1, trace/1, back/1, die/1, revive/1, hold/1, patrol/1, wait/1, walk/1
]).

%% gen_server callbacks
-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).

-define(SERVER, ?MODULE).

-define(RETIME, 10000).                             %回血时间
-define(MOVE_TIME, 20000).                          %自动移动时间
-define(SCAN, 8).                                   %怪物扫描距离
-define(SHORT_EVENT_TIME, 600).                     %怪物反应时间1
-define(NORMAL_EVENT_TIME, 1000).                    %怪物反应时间2
-define(LONG_EVENT_TIME, 5000).                     %怪物反应时间3

-define(AI_ROBOT, 1).            %%机器人ai

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @end
%%--------------------------------------------------------------------

start(Mon) ->
    gen_server:start(?MODULE, Mon, []).

stop(Aid) ->
    Aid ! clear.

stop_broadcast(Aid) ->
        catch Aid ! clear_broadcast.

%% 追踪信息返回
trace_info_back(MonAid, Sign, AttInfo) ->
    MonAid ! {att_target_info, Sign, AttInfo}.

%% 通过怪物进程获取怪物信息
get_mon(Aid) ->
    case ?CALL(Aid, get_mon) of
        {ok, Mon} ->
            Mon;
        [] ->
            []
    end.

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------

%%怪物信息初始化
init([Mkey, KeyList, MonId, Scene, X, Y, Copy, BroadCast, Arg]) ->
    process_flag(trap_exit, true),
    case data_mon:get(MonId) of
        [] ->
            ?ERR("mon create fail monid:~p,sceneId:~p~n ", [MonId, Scene]),
            {stop, normal};
        M ->
            M0 = mon_util:mon_init_helper(Arg, M#mon{hp = M#mon.hp_lim}),
            Self = self(),
            M1 = M0#mon{key = Mkey, scene = Scene, copy = Copy, base_speed = M0#mon.speed, mp = M0#mon.mp_lim, x = X, y = Y, d_x = X, d_y = Y, pid = Self},
            mon_agent:update(M1),
            %% 是否需要在生成的时候广播
            ?DO_IF(BroadCast == 1, mon_util:show_mon(M1)),
            ?DO_IF(M1#mon.life /= 0, erlang:send_after(round(M1#mon.life * 1000), Self, clear_broadcast)),
            %% %%
            if is_pid(Copy) -> link(Copy);
                true ->
                    case scene:get_scene_pid(Scene, Copy) of
                        Pid when is_pid(Pid) ->
                            link(Pid);
                        _ -> ok
                    end
            end,
            Ref = erlang:send_after(?SHORT_EVENT_TIME, Self, tick),
            ActState0 = ?IF_ELSE(M0#mon.type /= ?ATTACK_TENDENCY_PEACE, trace, ?IF_ELSE(M0#mon.patrol /= 0, patrol, sleep)),
            ActState = ?IF_ELSE(M0#mon.walk == [], ActState0, walk),
            init_default_skill(M1),
            {ok, #mon_act{minfo = M1, key_list = KeyList, ref = Ref, self = Self, state = ActState, node = node()}}
    end.

init_default_skill(Mon) ->
    if
        Mon#mon.scene == ?SCENE_ID_ARENA orelse Mon#mon.scene == ?SCENE_ID_CROSS_ARENA ->
            put(shadow_default_skill, util:list_shuffle(data_skill:career_skills(6)));
        true ->
            ok
    end.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @end
%%--------------------------------------------------------------------
handle_call(Request, _From, State) ->
    case catch call(Request, State) of
        {'EXIT', _Err} ->
            {reply, fail, State};
        Reply ->
            Reply
    end.

call(get_mon, State) ->
    Mon = State#mon_act.minfo,
    {reply, {ok, Mon}, State};

call(_request, State) ->
    {reply, fail, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @end
%%--------------------------------------------------------------------

handle_cast(_Request, State) ->
    {noreply, State}.


handle_info(Info, State) ->
    case catch info(Info, State) of
        {'EXIT', Err} ->
            ?PRINT("monster handle_info err:~p  /  ~p  ~n", [Info, Err]),
            {noreply, State};
        {noreply, NewState} ->
            case NewState#mon_act.state == die of
                false ->
                    {noreply, NewState};
                true ->
                    handle_info(tick, NewState)
            end;
        {stop, normal, NewState} ->
            {stop, normal, NewState};
        _Err ->
            ?DEBUG("monster handle_info err:~p  /  ~p  ~n", [_Err]),
            {noreply, State}
    end.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
%% %怪物状态机|心跳时间
info(tick, State) ->
        catch erlang:cancel_timer(State#mon_act.ref),
    StateName = State#mon_act.state,
    Tick = State#mon_act.tick,
%%    Wait = State#mon_act.wait,
    Minfo = State#mon_act.minfo,
    case lists:member(Minfo#mon.boss, [?BOSS_TYPE_FIELD, ?BOSS_TYPE_CROSS, ?BOSS_ACT_FESTIVE]) of
        true -> skip;
        false ->
            ?DO_IF(Tick >= 10000 andalso Minfo#mon.retime == 0, self() ! clear)%%怪物最大心跳
    end,
    ?DO_IF(Tick rem 250 == 0, mon_agent:update(Minfo)),
    Fun = fun ?MODULE:StateName/1,
    case Fun(State) of
        {noreply, State2} ->
            ActState = State2#mon_act.state,
            EventTime =
                if
                    ActState == trace orelse ActState == hold ->
                        ?SHORT_EVENT_TIME;
                    ActState == patrol ->
                        ?LONG_EVENT_TIME;
                    true ->
                        ?NORMAL_EVENT_TIME
                end,
            NewWait = State2#mon_act.wait,
            TickTime = ?IF_ELSE(NewWait > 0, NewWait, EventTime),
            Ref = erlang:send_after(TickTime, State#mon_act.self, tick),
            {noreply, State2#mon_act{ref = Ref, tick = Tick + 1, wait = 0}};
        Result ->
            Result
    end;

%% 采集怪
%% Pkey 玩家key
%% Pid 玩家进程
%% Action 采集动作 1采集开始2采集结束
info({collect, Node, Pkey, Pid, Nickname, Gkey, Action, _Figure, Plv, PartyTimes}, State) ->
    Minfo = State#mon_act.minfo,
    Clist = State#mon_act.clist,
    Now = util:unixtime(),
    CanCollect = ?IF_ELSE(Minfo#mon.is_collect == 1, true, false),
    if CanCollect andalso Minfo#mon.hp > 0 ->
        case Action of
            1 -> %% 开启采集
                {Ret, NewState} = start_collect(State, Minfo, Clist, Pkey, Pid, Plv, Now, Gkey, PartyTimes),
                if Ret /= 1 ->
                    {ok, Bin} = pt_200:write(20003, {Ret}),
                    server_send:send_to_pid(Pid, Bin),
                    ok;
%%                    if State#mon_act.node == Node orelse Node == none ->
%%                        server_send:send_to_pid(Pid, Bin);
%%                        true ->
%%                            server_send:rpc_node_apply(Node, server_send, send_to_pid, [Pid, Bin])
%%                    end;
                    true -> skip
                end,
                {noreply, NewState};
            2 -> %% 结束采集
                NewState = finish_collect(State, Minfo, Clist, Pkey, Pid, Plv, _Figure, Now, Node, Nickname),
                {noreply, NewState};
            3 ->%%中断采集
                NewClist = lists:keydelete(Pkey, 1, State#mon_act.clist),
                {noreply, State#mon_act{clist = NewClist}};
            _ ->
                {noreply, State}
        end;
        true ->
            {noreply, State}
    end;

%%记录战斗结果
info({battle_info_mon, Data, AttackerInfo}, State) ->
    Minfo = State#mon_act.minfo,
    case Minfo#mon.hp > 0 of
        true ->
            case catch info({do_battle, Data, AttackerInfo}, State) of
                {'EXIT', R} ->
                    ?PRINT("=====MON_DIE=====:~p", [R]),
                    {noreply, State#mon_act{state = die}};
                Rs ->
                    Rs
            end;
        false ->
            {noreply, State#mon_act{state = die}}
    end;

%% 怪物攻击怪物
info({do_battle, {Hp, Mp, X, Y, IsMove, Speed, LongTime, TimeMark, BuffList, SkillCd, Tatt, Tdef, Mana, ManaLim}, Attacker}, State) when
    (Attacker#attacker.sign == ?SIGN_MON orelse Attacker#attacker.is_shadow == 1) andalso (State#mon_act.minfo#mon.sync_time < LongTime orelse Hp =< 0) ->  %% 怪物攻击怪物
    #attacker{is_shadow = IsShadow, key = AttKey, pid = AttPid, sign = Attsign} = Attacker,
    Minfo = State#mon_act.minfo,
    Attlist = State#mon_act.attlist,
    CanBattle = ?IF_ELSE(Minfo#mon.is_att_by_mon == 1, true, false),
    LongTime2 = util:longunixtime(),
    {NewX, NewY} = ?IF_ELSE(IsMove /= 0, {X, Y}, {Minfo#mon.x, Minfo#mon.y}),
    {NewTatt, NewTdef} = ?IF_ELSE(Hp =< 0, {0, 0}, {Tatt, Tdef}),
    NewSkillCd = scene_agent_info:upgrade_skill_cd(SkillCd, Minfo#mon.skill_cd),
    Minfo1 = Minfo#mon{hp = Hp, mp = Mp, x = NewX, y = NewY, speed = Speed, sync_time = LongTime2, buff_list = BuffList, skill_cd = NewSkillCd, time_mark = TimeMark, t_att = NewTatt, t_def = NewTdef, mana = Mana, mana_lim = ManaLim},
    sync_mon_hp(Minfo1),
    Klist1 = ?IF_ELSE(IsShadow == 1, lists:sublist(add_hatred_list(State#mon_act.klist, Attacker), 200), State#mon_act.klist),
    Attlist1 = lists:sublist(add_attacker_list(Attlist, Attacker), 200),
    DefaultStateName =
        if
            Minfo#mon.att_area == 0 andalso Minfo#mon.trace_area == 0 -> sleep;
            true -> trace
        end,
    State1 = State#mon_act{minfo = Minfo1, klist = Klist1, attlist = Attlist1, trace_hold = max(IsMove, State#mon_act.trace_hold)},
    ?DO_IF(Minfo1#mon.hp =< 0, mon_die(Minfo1, Attacker, Klist1, State#mon_act.total_hurt)),
    if
        Minfo1#mon.shadow_key /= 0 ->
            if
                Minfo1#mon.hp =< 0 ->
                    {noreply, State1#mon_act{state = die}};
                true ->
                    {noreply, State1#mon_act{state = DefaultStateName}}
            end;
        CanBattle == true ->
            if
                Minfo1#mon.hp =< 0 ->
                    {noreply, State1#mon_act{state = die}};
                true ->
                    DfGroup = ?IF_ELSE(Minfo1#mon.group /= 0, Minfo1#mon.group /= Attacker#attacker.group andalso AttKey /= Minfo1#mon.owner_key andalso Minfo1#mon.group /= -1, true),
                    AttTarget =
                        if
                            State1#mon_act.att == [] andalso DfGroup ->
                                [AttKey, AttPid, Attsign];
                            true ->
                                State1#mon_act.att
                        end,
                    {noreply, State1#mon_act{att = AttTarget, state = DefaultStateName}}
            end;
        true -> %%其他怪物
            if
                Minfo1#mon.hp =< 0 ->
                    {noreply, State1#mon_act{state = die}};
                true ->
                    {noreply, State1#mon_act{state = DefaultStateName}}
            end
    end;

%% 玩家攻击怪物
%%AttId2   %% 唯一id(玩家/怪物)
%%Att2     %% 进程id(玩家/怪物)
%%Att2Type %% 攻击者类型(1怪物, 2玩家)
%% {battle_info_mon,{Hp,Mp,X,Y,BuffList},Attacker}
info({do_battle, {Hp, Mp, X, Y, IsMove, Speed, LongTime, TimeMark, BuffList, SkillCd, Tatt, Tdef, Mana, ManaLim}, Attacker}, State) when
    (Attacker#attacker.sign == ?SIGN_PLAYER orelse Attacker#attacker.sign == ?SIGN_PET orelse Attacker#attacker.sign == ?SIGN_MAGIC_WEAPON orelse Attacker#attacker.sign == ?SIGN_GOD_WEAPON orelse Attacker#attacker.sign == ?SIGN_BABY)
        andalso (State#mon_act.minfo#mon.sync_time < LongTime orelse Hp =< 0) ->
    #attacker{key = AttKey, pid = AttPid, sign = AttSign, hurt = Hurt, node = AttNode, field_boss_times = FieldBossTimes} = Attacker,
    #mon_act{minfo = Minfo, klist = Klist, attlist = Attlist, total_hurt = HurtBefore, first_att_key = FirstAttKey} = State,
    FirstAttKey2 = ?IF_ELSE(State#mon_act.first_att_key == [], AttKey, FirstAttKey),
    TotalHurt = HurtBefore + Hurt,
    Klist1 = lists:sublist(add_hatred_list(Klist, Attacker), 200),
    Attlist1 = lists:sublist(add_attacker_list(Attlist, Attacker), 200),
    {NewX, NewY} = ?IF_ELSE(IsMove /= 0, {X, Y}, {Minfo#mon.x, Minfo#mon.y}),
    {NewTatt, NewTdef} = ?IF_ELSE(Hp =< 0, {0, 0}, {Tatt, Tdef}),
    NewSkillCd = scene_agent_info:upgrade_skill_cd(SkillCd, Minfo#mon.skill_cd),
    Minfo1 = Minfo#mon{hp = Hp, mp = Mp, x = NewX, y = NewY, speed = Speed, sync_time = LongTime, time_mark = TimeMark, buff_list = BuffList, skill_cd = NewSkillCd, t_att = NewTatt, t_def = NewTdef, mana = Mana, mana_lim = ManaLim},
    sync_mon_hp(Minfo1),
    DefaultStateName = ?IF_ELSE(Minfo#mon.att_area == 0 andalso Minfo#mon.trace_area == 0, sleep, trace),
    DfGroup = ?IF_ELSE(Minfo1#mon.group /= 0, Minfo1#mon.group /= Attacker#attacker.group andalso Minfo1#mon.group /= Attacker#attacker.key andalso Minfo1#mon.group /= -1, true),

    Atttarget = ?IF_ELSE((State#mon_act.att == [] orelse kindom_guard:is_kindom_guard_dun(Minfo1#mon.scene) orelse dungeon_guard:is_dun_guard_td(Minfo1#mon.scene) orelse dungeon_util:is_dungeon_guard_cross(Minfo1#mon.scene)) andalso DfGroup, [AttKey, AttPid, ?SIGN_PLAYER], State#mon_act.att),
%%    Klist2 = cross_hunt:update_cross_hunt_boss_klist(Minfo1, Klist1, Attacker),
%%     Klist3 = cross_boss:update_cross_boss_klist(Minfo1, Klist1, Attacker),
    Klist3 = Klist1,
    NewKlist = manor_war:update_flag_hurt(Minfo1, Attacker, Klist3),
    NewState = State#mon_act{minfo = Minfo1, last_att_key = AttKey, first_att_key = FirstAttKey2, total_hurt = TotalHurt, klist = NewKlist, attlist = Attlist1, trace_hold = max(IsMove, State#mon_act.trace_hold)},
    CanBattle = ?IF_ELSE(Minfo1#mon.is_att_by_player == 1, true, false),

    ?DO_IF(State#mon_act.att == [], State#mon_act.self ! tick),
    %%野外boss伤害更新
    field_boss:update_field_boss_klist(Minfo1, NewKlist, AttKey, AttNode, FieldBossTimes),
    cross_boss:update_cross_boss_klist(Minfo1, NewKlist, AttKey, AttNode),
    cross_war:update_cross_war_mon_klist(Minfo1, NewKlist, AttKey, AttNode),
    elite_boss:update_boss_klist(Minfo1, NewKlist, AttKey, AttNode),
    guild_boss:update_boss_klist(Minfo1, NewKlist, AttKey, AttNode),
    ?DO_IF(Minfo1#mon.hp =< 0, mon_die(Minfo1, Attacker, Klist3, TotalHurt)),
    if
    %%影子
        Minfo1#mon.shadow_key /= 0 andalso Minfo1#mon.kind /= ?MON_KIND_TREASURE_MON ->
            if
                Minfo1#mon.hp =< 0 ->
                    {noreply, NewState#mon_act{state = die}};
                true ->
                    ShadowStatus = Minfo1#mon.shadow_status,
                    ShadowKey = ShadowStatus#player.key,
                    Atttarget2 = ?IF_ELSE(NewState#mon_act.att == [] andalso ShadowKey /= AttKey, [AttKey, AttPid, AttSign], NewState#mon_act.att),
                    {noreply, NewState#mon_act{att = Atttarget2, state = DefaultStateName}}
            end;
    %%普通怪物会有掉落
        CanBattle == true ->
            if
                Minfo1#mon.hp =< 0 ->
                    {noreply, NewState#mon_act{state = die}};
                true ->
                    {noreply, NewState#mon_act{att = Atttarget, state = DefaultStateName}}

            end;
        Minfo1#mon.kind == 1 -> %% 采集任务用
            {noreply, State};
        true ->
            if
                Minfo1#mon.hp =< 0 ->
                    {noreply, NewState#mon_act{state = die}};
                true ->
                    {noreply, NewState#mon_act{att = Atttarget, state = DefaultStateName}}
            end
    end;

%%怪物发起攻击的数据同步
info({do_battle, {Hp, Mp, X, Y, IsMove, Speed, LongTime, TimeMark, BuffList, SkillCd, Tatt, Tdef, _Mana}, Attacker}, State) when
    Attacker#attacker.sign == 0 andalso (State#mon_act.minfo#mon.sync_time < LongTime orelse Hp =< 0) ->
    Minfo = State#mon_act.minfo,
    {NewX, NewY} = ?IF_ELSE(IsMove /= 0, {X, Y}, {Minfo#mon.x, Minfo#mon.y}),
    {NewTatt, NewTdef} = ?IF_ELSE(Hp =< 0, {0, 0}, {Tatt, Tdef}),
    NewSkillCd = scene_agent_info:upgrade_skill_cd(SkillCd, Minfo#mon.skill_cd),
    Minfo2 = Minfo#mon{hp = Hp, mp = Mp, x = NewX, y = NewY, speed = Speed, sync_time = LongTime, time_mark = TimeMark, buff_list = BuffList, skill_cd = NewSkillCd, t_att = NewTatt, t_def = NewTdef},
    ?DO_IF(Minfo2#mon.hp =< 0, mon_die(Minfo2, Attacker, State#mon_act.klist, State#mon_act.total_hurt)),
    if
        Hp =< 0 ->
            mon_util:hide_mon(Minfo),
            {noreply, State#mon_act{state = die, minfo = Minfo2}};
        true ->
            {noreply, State#mon_act{minfo = Minfo2, trace_hold = max(IsMove, State#mon_act.trace_hold)}}
    end;

info({do_battle, _Data, _Attacker}, State) ->
    {noreply, State};

info({clean_cross_player, Pkey}, State) ->
    #mon_act{klist = KList, minfo = Minfo} = State,
    NewKList =
        case lists:keytake(Pkey, #st_hatred.key, KList) of
            false ->
                KList;
            {value, _R, Rest} ->
                Rest
        end,
    cross_boss:update_cross_boss_klist(Minfo, NewKList, 0, 0),
    {noreply, State#mon_act{klist = NewKList}};

%% 跟踪目标信息返回
info({att_target_info, Sign, Result}, State) ->
    #mon_act{minfo = Minfo, self = Self, unatt = UnAtt, att = AttTarget} = State,
    Now = util:unixtime(),
    {NewStateName, NewState} =
        case handle_battle_status(State, Now) of
            {ok, Minfo1, Attack, Move, Speed} ->
                case Result of
                    false when Minfo#mon.kind == ?MON_KIND_TREASURE_MON ->
                        {back, State#mon_act{att = []}};
                    false when Minfo#mon.type =/= ?ATTACK_TENDENCY_PEACE ->
                        {trace, State#mon_act{att = []}};
                    false when Speed /= 0 ->
                        {back, State#mon_act{att = []}};
                    {true, Key, X, Y} when Minfo#mon.key /= Key ->
                        {SkillId, SkillArea, _SkillTarget} = mon_ai:skill_ai(State, Now),

                        AttArea = ?IF_ELSE(SkillArea > 0, SkillArea, Minfo#mon.att_area),
                        CanAttack = not lists:member(Key, UnAtt),
                        case is_attack(Minfo1, X, Y, AttArea) of
                            attack when Move andalso Attack andalso CanAttack ->
                                DataSkill = data_skill:get(SkillId),
                                case mon_ai:skill_ready(Minfo, DataSkill) of
                                    {true, Yctime, SingRes} -> %% 吟唱
                                        {Tx, Ty} = {Minfo#mon.x, Minfo#mon.y},
%%                                            get_att_obj_xy(Minfo#mon.x, Minfo#mon.y, AttTarget, Minfo#mon.scene, Minfo#mon.copy),
                                        {ok, BinReady} = pt_200:write(20018, {Minfo#mon.key, SkillId, Yctime, SingRes, DataSkill#skill.effectTarget, Tx, Ty}),
                                        server_send:send_to_scene(Minfo#mon.scene, Minfo#mon.copy, BinReady),
                                        Cd = Now + DataSkill#skill.cd,
                                        ReadyRef = erlang:send_after(Yctime * 1000, Self, {ready_attack, SkillId, Cd}),
                                        BattleData = [?SIGN_MON, Minfo#mon.key, {SkillId, Tx, Ty}, [[Sign, Key]]],
                                        {wait, State#mon_act{ready_skill = BattleData, ready_ref = ReadyRef, once_skill = 0}};
                                    {true, Skill} ->
                                        case Skill#skill.mod of
                                            ?SKILL_MOD_ALL when Minfo#mon.shadow_key == 0 ->
                                                {Tx, Ty} = get_att_obj_xy(Minfo#mon.x, Minfo#mon.y, AttTarget, Minfo#mon.scene, Minfo#mon.copy),
                                                BattleData = [?SIGN_MON, Minfo#mon.key, {SkillId, Tx, Ty}, []],
                                                scene_agent:apply_cast(Minfo1#mon.scene, Minfo1#mon.copy, battle, battle, BattleData);
                                            _SKILL_MOD_SINGLE ->
                                                BattleData = [?SIGN_MON, Minfo#mon.key, {SkillId, 0, 0}, [[Sign, Key]]],
                                                scene_agent:apply_cast(Minfo1#mon.scene, Minfo1#mon.copy, battle, battle, BattleData)
                                        end,
                                        Wait = Minfo#mon.att_speed,
                                        {trace, State#mon_act{minfo = Minfo, once_skill = 0, last_skill = SkillId, wait = Wait}};
                                    false ->
                                        BattleData = [?SIGN_MON, Minfo#mon.key, {SkillId, 0, 0}, [[Sign, Key]]],
                                        scene_agent:apply_cast(Minfo1#mon.scene, Minfo1#mon.copy, battle, battle, BattleData),
                                        Wait = Minfo#mon.att_speed,
                                        {trace, State#mon_act{minfo = Minfo, once_skill = 0, last_skill = SkillId, wait = Wait}}
                                end;
                            trace when Move ->
                                if Minfo1#mon.scene == ?DUNGEON_ID_GUARD ->
                                    [New_x, New_y] =
                                        get_next_step(Minfo#mon.scene, Minfo#mon.copy, Minfo#mon.x, Minfo#mon.y, Minfo#mon.att_area, X, Y),
                                    case move(New_x, New_y, Minfo1, Speed, 1) of
                                        {true, AfterMoveMinfo, Wait} ->
                                            {trace, State#mon_act{minfo = AfterMoveMinfo, wait = Wait}};
                                        false -> %% 不可移动
                                            {trace, State#mon_act{minfo = Minfo1}}
                                    end;
                                    true ->
                                        case trace_line(Minfo1, X, Y, AttArea) of
                                            block ->
                                                %%分身穿越障碍区
                                                if Minfo#mon.shadow_key =/= 0 ->
                                                    %% 直接传送到目标位置
                                                    Minfo2 = Minfo1#mon{x = X, y = Y},
                                                    mon_agent:update_xy(Minfo2),
                                                    mon_move(Minfo1#mon.x, Minfo1#mon.y, Minfo2, 6),
                                                    {trace, State#mon_act{minfo = Minfo2}};
                                                    true ->
                                                        {back, State#mon_act{minfo = Minfo1}}
                                                end;
                                            {MoveType, X1, Y1} ->
                                                case move(X1, Y1, Minfo1, Speed, MoveType) of
                                                    {true, AfterMoveMinfo, Wait} ->
                                                        {trace, State#mon_act{minfo = AfterMoveMinfo, wait = Wait}};
                                                    false -> %% 不可移动
                                                        {trace, State#mon_act{minfo = Minfo1}}
                                                end;
                                            false ->
                                                {trace, State#mon_act{minfo = Minfo1}}
                                        end
                                end;
                            back when Move ->
                                {back, State#mon_act{minfo = Minfo1}};

                            _ ->
                                {hold, State}

                        end;
                    _ ->
                        {back, State#mon_act{att = []}}
                end;
            hold ->
                {hold, State};
            die ->
                {die, State}
        end,
    {noreply, NewState#mon_act{state = NewStateName}};

%%攻击目标返回
info({attack, Att}, State) when State#mon_act.state /= revive ->
    State2 = ?IF_ELSE(State#mon_act.att == [], State#mon_act{att = Att, state = trace}, State),
    info(tick, State2);

%%吟唱完毕施放技能
info({ready_attack, SkillId, Cd}, State) ->
    Minfo = State#mon_act.minfo,
    BattleData = State#mon_act.ready_skill,
    scene_agent:apply_cast(Minfo#mon.scene, Minfo#mon.copy, battle, battle, BattleData),
    SkillCd = [{SkillId, Cd} | lists:keydelete(SkillId, 1, Minfo#mon.skill_cd)],
    NewMinfo = Minfo#mon{skill_cd = SkillCd},
    {noreply, State#mon_act{state = trace, ready_skill = [], minfo = NewMinfo, last_skill = SkillId, ready_ref = none}};

%%打断吟唱
info({stop_ready}, State) ->
    case catch erlang:read_timer(State#mon_act.ready_ref) of
        N when is_integer(N) andalso N > 0 ->
            Minfo = State#mon_act.minfo,
            LongTime = util:longunixtime(),
            BuffList2 = if
                            State#mon_act.block_buff > 0 ->
                                BS = battle:init_data(Minfo, LongTime),
                                BS2 = buff:add_buff(BS, [State#mon_act.block_buff], 888, 1, #attacker{}),
                                BS2#bs.buff_list;
                            true ->
                                Minfo#mon.buff_list
                        end,
            {ok, Bin} = pt_200:write(20013, {?SIGN_MON, Minfo#mon.key}),
            server_send:send_to_scene(Minfo#mon.scene, Minfo#mon.copy, Bin),
            erlang:cancel_timer(State#mon_act.ready_ref),
            Minfo2 = Minfo#mon{buff_list = BuffList2},
            mon_agent:update(Minfo2),
            {noreply, State#mon_act{state = trace, minfo = Minfo2, ready_ref = none}};
        _ ->
            {noreply, State}
    end;
%%打断吟唱buff
info({block_buff, BuffId}, State) ->
    {noreply, State#mon_act{block_buff = BuffId}};

%% 跟随
info({trace, Key, Pid, Sign}, State) ->
    UnAtt = [Key, Pid, Sign],
    {noreply, State#mon_act{att = [Key, Pid, Sign], unatt = UnAtt, state = trace}};

%% 移动
info({move, X, Y}, State) ->
    Minfo = State#mon_act.minfo,
    case move(X, Y, Minfo, Minfo#mon.speed, 1) of
        {true, Minfo2, Wait} ->
            {noreply, State#mon_act{minfo = Minfo2, att = [], state = hold, wait = Wait}};
        _ ->
            {noreply, State}
    end;

%% 释放技能
info({once_skill, SkillId}, State) ->
    {noreply, State#mon_act{once_skill = SkillId}};

%% 清除进程
info(clear, State) ->
    {stop, normal, State};

%% 清除进程
info(clear_broadcast, State) ->
    Minfo = State#mon_act.minfo,
    bomb:bomb(Minfo),
%%    ?DEBUG("clean mon sid ~p/~p/~p mid ~p~n", [Minfo#mon.scene, Minfo#mon.x, Minfo#mon.y, Minfo#mon.mid]),
    mon_util:hide_mon(Minfo),
    {stop, normal, State};

%% 设置hp
info({hp, Hp}, State) ->
    handle_info({hp, Hp, 0}, State);

%% 设置持续伤害产生的hp
info({hp, Hp, _Hurt}, State) ->
    Minfo = State#mon_act.minfo,
    Minfo1 = Minfo#mon{hp = Hp},
%%mod_battle:hp_broadcast(Minfo1,Hurt),
    {noreply, State#mon_act{minfo = Minfo1}};

info({speed_reset, Notice}, State) ->
    Minfo = State#mon_act.minfo,
    Minfo2 = Minfo#mon{speed = Minfo#mon.base_speed},
    mon_agent:update(Minfo2),
    if
        Notice ->
            {ok, Bin} = pt_200:write(20006, {2, Minfo#mon.key, Minfo#mon.base_speed}),
            server_send:send_to_scene(Minfo#mon.scene, Minfo#mon.copy, Minfo#mon.x, Minfo#mon.y, Bin);
        true ->
            skip
    end,
    {noreply, State#mon_act{minfo = Minfo2}};

%% 怪物死亡 注意这里死亡的功能差别
info(die, State) ->
    Minfo = State#mon_act.minfo,
%% 怪物消失
    mon_util:hide_mon(Minfo),
    {noreply, State#mon_act{state = die}};


%% @特殊接口 直接清除怪物, 不重生, 不执行lib_mon_ai:die
info(remove, State) ->
    Minfo = State#mon_act.minfo,
    mon_util:hide_mon(Minfo),
    handle_info(clear, State#mon_act{att = [], minfo = Minfo, klist = [], clist = [], ref = []});


%% @更新怪物属性
info({change_attr, AttrList}, State) ->
    Minfo = State#mon_act.minfo,
    NewMinfo = case mon_util:change_attr(AttrList, Minfo) of
                   M when is_record(M, mon) ->
                       M;
                   _ -> Minfo
               end,
    mon_agent:update(NewMinfo),
    case NewMinfo#mon.hp > 0 of
        true ->
            {noreply, State#mon_act{minfo = NewMinfo}};
        false ->
            handle_info(die, State#mon_act{minfo = NewMinfo})
    end;

%%设置无敌时间
info({godt, Time}, State) ->
    Minfo = State#mon_act.minfo,
    NewMinfo = Minfo#mon{time_mark = Minfo#mon.time_mark#time_mark{godt = Time}},
    mon_agent:update(NewMinfo),
    {noreply, State#mon_act{minfo = NewMinfo}};

%%怪物名称
info({mon_name, Name}, State) ->
    Minfo = State#mon_act.minfo,
    NewMinfo = Minfo#mon{name = Name},
    mon_agent:update(NewMinfo),
    mon_util:show_mon(NewMinfo),
%%    {ok, Bin} = pt_120:write(12042, {Minfo#mon.key, Name}),
%%    server_send:send_to_scene(Minfo#mon.scene, Minfo#mon.copy, Minfo#mon.x, Minfo#mon.y, Bin),
    {noreply, State#mon_act{minfo = NewMinfo}};

info({buff_list, BuffList, Attacker}, State) ->
    Minfo = State#mon_act.minfo,
    Mon = buff:add_buff_list_to_mon(Minfo, BuffList, Attacker),
    case Mon#mon.scene == ?SCENE_ID_CROSS_WAR of
        true ->
            cross_war:update_cross_war_mon_klist(Mon, [], 0, []);
        false ->
            skip
    end,
    {noreply, State#mon_act{minfo = Mon}};

info({buff_timeout, BuffId}, State) ->
    Minfo = buff:buff_timeout(?SIGN_MON, State#mon_act.minfo, BuffId, []),
    mon_agent:update(Minfo),
    {noreply, State#mon_act{minfo = Minfo}};

%%设置减速效果标记
info({set_speed_eff, Key}, State) ->
    put(speed_eff, Key),
    {noreply, State};
%%取消减速
info({cancel_speed_eff, Key}, State) ->
    case get(Key) of
        undefined ->
            {noreply, State};
        _ ->
            info({speed_reset, true}, State)
    end;

info({act_state, Type}, State) ->
    Minfo = State#mon_act.minfo,
    NewMinfo = Minfo#mon{type = Type},
    mon_agent:update(NewMinfo),
    StateName = ?IF_ELSE(Type /= ?ATTACK_TENDENCY_PEACE, trace, State#mon_act.state),
    {noreply, State#mon_act{minfo = NewMinfo, state = StateName}};


info({'EXIT', _from, normal}, State) ->
    {stop, normal, State};

info(_Msg, State) ->
%%     ?PRINT("REC unexpected msg:~p~n ", [_Msg]),
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------

terminate(_Reason, State) ->
    mon_agent:del_mon(State#mon_act.minfo),
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
% =========处理怪物所有状态=========
%% 定身状态 还会追踪
hold(State) ->
    {noreply, State#mon_act{state = trace}}.

%% 停止状态，直到状态被修改
wait(State) ->
    {noreply, State}.

%%正常静止状态并回血
sleep(State) ->
    Minfo = State#mon_act.minfo,
    %%判断是否死亡
    case Minfo#mon.hp > 0 of
        true ->
            CanBattle = ?IF_ELSE(Minfo#mon.is_att_by_mon == 1 orelse Minfo#mon.is_att_by_player == 1, true, false),


            case CanBattle of
                true -> %% 怪物
                    [Type, Minfo1] = auto_revert(Minfo),
                    NewKlist = case Minfo#mon.boss > 0 of %% boss不清伤害列表
                                   true -> State#mon_act.klist;
                                   false -> []
                               end,
                    case Type == 1 of
                        true ->
                            {noreply, State#mon_act{att = [], minfo = Minfo1, klist = NewKlist}};
                        false ->
                            %回血完毕
                            StName = ?IF_ELSE(Minfo#mon.patrol == 1, patrol, sleep),
                            {noreply, State#mon_act{att = [], minfo = Minfo, klist = NewKlist, state = StName}}
                    end;
                false ->
                    {noreply, State#mon_act{att = []}}
            end;
        false ->
            {noreply, State#mon_act{state = die}}
    end.

%%
%%%%镜像跟踪目标
trace(State) when State#mon_act.trace_hold > 0 ->
    {noreply, State#mon_act{state = trace, trace_hold = max(0, State#mon_act.trace_hold - 1)}};
%%尾随
trace(State) when State#mon_act.unatt /= [] ->
    [Key, _Pid, AttType] = State#mon_act.unatt,
    Minfo = State#mon_act.minfo,
    case AttType == ?SIGN_PLAYER of
        true ->
            scene_agent:apply_cast(Minfo#mon.scene, Minfo#mon.copy, scene_agent, trace_target_info_by_id, [[Minfo#mon.pid, Key, Minfo#mon.group]]);
        false ->
            scene_agent:apply_cast(Minfo#mon.scene, Minfo#mon.copy, mon_agent, trace_target_info_by_id, [[Minfo#mon.pid, Key, Minfo#mon.group]])
    end,
    {noreply, State#mon_act{state = trace}};
%%普通跟踪目标
trace(State) when State#mon_act.att /= [] ->
    [Key, _Pid, AttType] = State#mon_act.att,
    Minfo = State#mon_act.minfo,
    case AttType == ?SIGN_PLAYER of
        true ->
            scene_agent:apply_cast(Minfo#mon.scene, Minfo#mon.copy, scene_agent, trace_target_info_by_id, [[Minfo#mon.pid, Key, Minfo#mon.group]]);
        false ->
            scene_agent:apply_cast(Minfo#mon.scene, Minfo#mon.copy, mon_agent, trace_target_info_by_id, [[Minfo#mon.pid, Key, Minfo#mon.group]])
    end,
    {noreply, State#mon_act{state = trace}};
%%主动怪
trace(State) when State#mon_act.minfo#mon.type =/= ?ATTACK_TENDENCY_PEACE ->
    Minfo = State#mon_act.minfo,
    {Att, Trace} =
        if
            State#mon_act.att == [] ->
                get_att_target(Minfo),
                {[], false};
            true ->
                %%分身不攻击本身
                case hd(State#mon_act.att) == State#mon_act.minfo#mon.shadow_key andalso Minfo#mon.kind /= ?MON_KIND_TREASURE_MON of
                    true ->
                        {[], false};
                    false ->
                        {State#mon_act.att, true}
                end
        end,
    if
        Trace ->
            [Key, _Pid, AttType] = Att,
            case AttType == ?SIGN_PLAYER of
                true ->
                    scene_agent:apply_cast(Minfo#mon.scene, Minfo#mon.copy, scene_agent, trace_target_info_by_id, [[Minfo#mon.pid, Key, Minfo#mon.group]]);
                false ->
                    scene_agent:apply_cast(Minfo#mon.scene, Minfo#mon.copy, mon_agent, trace_target_info_by_id, [[Minfo#mon.pid, Key, Minfo#mon.group]])
            end,
            {noreply, State#mon_act{state = trace, att = Att, minfo = Minfo}};
        true ->
            {noreply, State#mon_act{state = trace, att = Att}}
    end;

trace(State) ->
    {noreply, State#mon_act{state = back}}.

%%返回默认出生点
back(State) ->
    Minfo = State#mon_act.minfo,
    case Minfo#mon.x == Minfo#mon.d_x andalso Minfo#mon.y == Minfo#mon.d_y of
        false ->
            Minfo2 = Minfo#mon{
                x = Minfo#mon.d_x,
                y = Minfo#mon.d_y
            },
            mon_move(Minfo#mon.x, Minfo#mon.y, Minfo2, 1),
            mon_agent:update(Minfo2);
        true ->
            Minfo2 = Minfo
    end,
    StateName = ?IF_ELSE(Minfo#mon.type == 0, sleep, trace),
    {noreply, State#mon_act{minfo = Minfo2, state = StateName, att = []}}.

%%死亡复活
die(State) ->
    Minfo = State#mon_act.minfo,
    buff_proc:logout(self()),
    if
        Minfo#mon.retime == 0 ->
            mon_agent:del_mon(Minfo),
            {stop, normal, State};
        Minfo#mon.hp =/= 0 ->
            {noreply, State#mon_act{state = sleep}};
        true ->
            util:sleep(round(Minfo#mon.retime * 1000)),
            mon_agent:del_mon(Minfo),
            [Key | KeyList] = State#mon_act.key_list,
            Minfo2 = Minfo#mon{
                key = Key,
                hp = Minfo#mon.hp_lim,
                mp = Minfo#mon.mp_lim,
                x = Minfo#mon.d_x,
                y = Minfo#mon.d_y,
                time_mark = #time_mark{},
                skill_cd = [],
                buff_list = []
            },
            mon_agent:update(Minfo2),
            %%通知客户端我已经重生了
            mon_util:show_mon(Minfo2),
            StateName = ?IF_ELSE(Minfo#mon.type == 0, sleep, trace),
            {noreply, State#mon_act{minfo = Minfo2, key_list = KeyList ++ [Key], att = [], unatt = [], klist = [], attlist = [], clist = [], state = StateName}}
    end.

revive(_State) -> ok.
%%    Minfo = State#mon_act.minfo,
%%    if
%%        Minfo#mon.hp =/= 0 -> {noreply, State#mon_act{state = sleep}};
%%        true ->
%%            util:sleep(round(Minfo#mon.retime * 1000)),
%%            mon_agent:del_mon(Minfo),
%%            [Key | KeyList] = State#mon_act.key_list,
%%            Minfo2 = Minfo#mon{
%%                key = Key,
%%                hp = Minfo#mon.hp_lim,
%%                mp = Minfo#mon.mp_lim,
%%                x = Minfo#mon.d_x,
%%                y = Minfo#mon.d_y,
%%                time_mark = #time_mark{},
%%                skill_cd = [],
%%                buff_list = []
%%            },
%%            mon_agent:update(Minfo2),
%%            %%通知客户端我已经重生了
%%            mon_util:show_mon(Minfo2),
%%            StateName = ?IF_ELSE(Minfo#mon.type == 0, sleep, trace),
%%            {noreply, State#mon_act{minfo = Minfo2, key_list = KeyList ++ [Key], att = [], unatt = [], klist = [], attlist = [], clist = [], state = StateName}}
%%    end.

%% 巡逻
patrol(State) ->
    Minfo = State#mon_act.minfo,
    Rand = util:rand(1, 50),
    N = Rand rem 2 + 1,
    if
        Rand == 1 ->      %%右
            X = Minfo#mon.d_x + N,
            Y = Minfo#mon.y;
        Rand == 2 ->      %%上
            X = Minfo#mon.x,
            Y = Minfo#mon.d_y + N;
        Rand == 3 ->      %左
            X = abs(Minfo#mon.d_x - N),
            Y = Minfo#mon.y;
        Rand == 4 ->      %下
            X = Minfo#mon.x,
            Y = abs(Minfo#mon.d_y - N);
        Rand == 5 ->      %左上
            X = abs(Minfo#mon.d_x - N),
            Y = Minfo#mon.d_y + N;
        Rand == 6 ->      %左下
            X = abs(Minfo#mon.d_x - N),
            Y = abs(Minfo#mon.d_y - N);
        Rand == 7 ->      %右上
            X = Minfo#mon.d_x + N,
            Y = Minfo#mon.d_y + N;
        Rand == 8 ->          %右下
            X = Minfo#mon.d_x + N,
            Y = abs(Minfo#mon.d_y - N);
        true ->
            X = Minfo#mon.x,
            Y = Minfo#mon.y

    end,
    case move(X, Y, Minfo, Minfo#mon.speed, 1) of
        {true, NewMinfo, Wait} ->
            {noreply, State#mon_act{minfo = NewMinfo, wait = Wait}};
        _ ->
            {noreply, State}
    end.

walk(State) ->
    Minfo = State#mon_act.minfo,
    case Minfo#mon.walk of
        [] ->
            ?DO_IF(Minfo#mon.mid == ?WEEDING_CAR_MID, marry_cruise:weeding_car_move_end(Minfo#mon.key)),
            self() ! remove,
            {noreply, State};
        [Item | Tail] ->
            {NewX, NewY, Sleep} =
                case Item of
                    {_, _, _} ->
                        Item;
                    {X, Y} ->
                        {X, Y, 0}
                end,
            case move(NewX, NewY, Minfo, Minfo#mon.speed, 1) of
                {true, NewMinfo, Wait} ->
                    NewMinfo1 = NewMinfo#mon{walk = Tail},
                    ?DO_IF(Minfo#mon.mid == ?WEEDING_CAR_MID, marry_cruise:update_weeding_car_position(Minfo#mon.key, NewX, NewY)),
                    {noreply, State#mon_act{minfo = NewMinfo1, wait = Wait + round(Sleep * 1000)}};
                _ ->
                    NewMinfo1 = Minfo#mon{walk = []},
                    {noreply, State#mon_act{minfo = NewMinfo1, wait = 0}}
            end
    end.

% =========处理怪物所有状态结束 =========


%% 辅助函数 -----

%% 判断距离是否可以发动攻击了
is_attack(Mon, X, Y, SkillAttArea) ->
    D_x = abs(Mon#mon.x - X),
    D_y = abs(Mon#mon.y - Y),
    Att_area = case SkillAttArea == 0 of
                   true -> Mon#mon.att_area;
                   false -> SkillAttArea
               end,
    case Att_area >= D_x of
        true ->
            case Att_area >= D_y of
                true ->
                    attack;
                false ->
                    trace_area(Mon, X, Y)
            end;
        false ->
            trace_area(Mon, X, Y)
    end.

%% 追踪区域
trace_area(Mon, X, Y) ->
    Trace_area = Mon#mon.trace_area,
    D_x = abs(Mon#mon.d_x - X),
    D_y = abs(Mon#mon.d_y - Y),
    %不在攻击范围内了停止追踪
    case Trace_area + 2 >= D_x of
        true ->
            case Trace_area + 2 >= D_y of
                true ->
                    trace;
                false ->
                    back
            end;
        false ->
            back
    end.

%%先进入曼哈顿距离遇到障碍物再转向A*
%%每次移动2格
%%X1,Y1 原位置
%%X2,Y2 目标位置
trace_line(Mon, TarX, TarY, AttArea) ->
    {MoveType, X, Y} = do_trace_line(Mon#mon.shadow_key, Mon#mon.scene, Mon#mon.x, Mon#mon.y, TarX, TarY, AttArea),
    case scene_mark:is_crash(Mon#mon.scene, Mon#mon.copy, X, Y, Mon#mon.x, Mon#mon.y) of
        false ->
%%            %%守护副本无视障碍
%%            if Mon#mon.scene == ?DUNGEON_ID_GUARD ->
%%                {MoveType, X, Y};
%%                true ->
            block;
%%            end;
        {NewX, NewY} ->
            {MoveType, NewX, NewY}
    end.

do_trace_line(ShadowKey, Scene, X1, Y1, X2, Y2, AttArea) ->
    {MoveType, MoveArea} =
        if Scene == ?SCENE_ID_ARENA orelse Scene == ?SCENE_ID_CROSS_ARENA orelse Scene == ?SCENE_ID_CROSS_1VN_WAR orelse Scene == ?SCENE_ID_CROSS_1VN_FINAL_WAR ->
            {1, 2};
            ShadowKey /= 0 ->
                AbsX12 = abs(X1 - X2),
                AbsY12 = abs(Y1 - Y2),
                if (AbsX12 >= 4 andalso AbsX12 =< 6) orelse (AbsY12 >= 4 andalso AbsY12 =< 6) ->
                    case util:odds(50, 100) of
                        true ->
                            {6, util:rand(4, 6)};
                        false ->
                            {1, 2}
                    end;
                    true -> {1, 2}
                end;
            true -> {1, 2}
        end,
    %%先判断方向
    {TarX, TarY} =
        case MoveType of
            1 ->
                trace_line_direction(X1, Y1, X2, Y2, AttArea, MoveArea);
            _ ->
                trace_straight_line(X1, Y1, X2, Y2)
        end,

    {MoveType, TarX, TarY}.

%%直线寻路,用于冲刺
%%1右 2下 3左 4上 5右上 6右下 7左下 8左上 0 重叠
trace_straight_line(X1, Y1, X2, Y2) ->
    case util:get_direction(X1, Y1, X2, Y2) of
        1 ->
            {X2 + 2, Y2};
        2 ->
            {X2, Y2 + 2};
        3 ->
            {X2 - 2, Y2};
        4 ->
            {X2, Y2 - 2};
        5 ->
            {X2 + 2, Y2 - 2};
        6 ->
            {X2 + 2, Y2 + 2};
        7 ->
            {X2 - 2, Y2 + 2};
        8 ->
            {X2 - 2, Y2 - 2};
        0 ->
            {X1, Y1}
    end.

trace_line_direction(X1, Y1, X2, Y2, AttArea, MoveArea) ->
    case util:get_direction(X1, Y1, X2, Y2) of
        1 -> %%右
            X = X2 - X1,
            if
                X < AttArea ->
                    {X1, Y1};
                X < MoveArea ->
                    {X2 - AttArea, Y1};
                true ->
                    {X1 + MoveArea, Y1}
            end;
        2 -> %%下
            Y = Y2 - Y1,
            if
                Y < AttArea ->
                    {X1, Y1};
                Y < MoveArea ->
                    {X1, Y2 - AttArea};
                true ->
                    {X1, Y1 + MoveArea}
            end;
        3 -> %% 左
            X = X1 - X2,
            if
                X < AttArea ->
                    {X1, Y1};
                X < MoveArea ->
                    {X2 + AttArea, Y1};
                true ->
                    {X1 - MoveArea, Y1}
            end;
        4 ->%% 上
            Y = Y1 - Y2,
            if
                Y < AttArea ->
                    {X1, Y1};
                Y < MoveArea ->
                    {X1, Y2 + AttArea};
                true ->
                    {X1, Y1 - MoveArea}
            end;
        5 ->%% 右上
            Y = Y1 - Y2,
            X = X2 - X1,
            Dis = math:sqrt(X * X + Y * Y),
            if
                Dis < AttArea ->
                    {X1, Y1};
                Y < MoveArea ->
                    if
                        X < MoveArea -> {X2 - AttArea, Y2 + AttArea};
                        true -> {X1 + MoveArea, Y2 + AttArea}
                    end;
                true ->
                    if
                        X < MoveArea -> {X2 - AttArea, Y1 - MoveArea};
                        true -> {X1 + MoveArea, Y1 - MoveArea}
                    end
            end;
        6 ->%% 右下
            Y = Y2 - Y1,
            X = X2 - X1,
            Dis = math:sqrt(X * X + Y * Y),
            if
                Dis < AttArea ->
                    {X1, Y1};
                Y < MoveArea ->
                    if
                        X < MoveArea -> {X2 - AttArea, Y2 - AttArea};
                        true -> {X1 + MoveArea, Y2 - AttArea}
                    end;
                true ->
                    if
                        X < MoveArea -> {X2 - AttArea, Y1 + MoveArea};
                        true -> {X1 + MoveArea, Y1 + MoveArea}
                    end
            end;
        7 ->%% 左下
            Y = Y2 - Y1,
            X = X1 - X2,
            Dis = math:sqrt(X * X + Y * Y),
            if
                Dis < AttArea ->
                    {X1, Y1};
                Y < MoveArea ->
                    if
                        X < MoveArea -> {X2 + AttArea, Y2 - AttArea};
                        true -> {X1 - MoveArea, Y2 - AttArea}
                    end;
                true ->
                    if
                        X < MoveArea -> {X2 + AttArea, Y1 + MoveArea};
                        true -> {X1 - MoveArea, Y1 + MoveArea}
                    end
            end;
        8 -> %%左上
            Y = Y1 - Y2,
            X = X1 - X2,
            Dis = math:sqrt(X * X + Y * Y),
            if
                Dis < AttArea ->
                    {X1, Y1};
                Y < MoveArea ->
                    if
                        X < MoveArea -> {X2 + AttArea, Y2 + AttArea};
                        true -> {X1 - MoveArea, Y2 + AttArea}
                    end;
                true ->
                    if
                        X < MoveArea -> {X2 + AttArea, Y1 - MoveArea};
                        true -> {X1 - MoveArea, Y1 - MoveArea}
                    end
            end;
        0 ->
            {X1, Y1}
    end.


% A星算法自动寻路
get_next_step(Sid, Copy, X, Y, AttArea, TarX, TarY) ->
    case [X, Y] =:= [TarX, TarY] of
        true ->
            [X, Y];
        _ ->
            case trace_line_direction(X, Y, TarX, TarY, AttArea, 2) of
                true ->
                    a_star(X, Y, Sid, AttArea, TarX, TarY);
                {N_x, N_y} ->
                    case scene_mark:is_crash(Sid, Copy, N_x, N_y, X, Y) of
                        false ->
                            a_star(X, Y, Sid, AttArea, TarX, TarY);
                        {NewX, NewY} ->
                            [NewX, NewY]
                    end
            end
    end.

%% A*算法
a_star(X, Y, Sid, _, A_x, A_y) ->
    List = [[X + 1, Y],
        [X, Y + 1],
        [X - 1, Y],
        [X, Y - 1],
        [X + 1, Y + 1],
        [X - 1, Y + 1],
        [X + 1, Y - 1],
        [X - 1, Y - 1]], %% 周围8格子
    F = fun(P, _P0) ->
        [X2, Y2] = P,
        case scene:can_moved(Sid, X2, Y2) of
            true ->
                %非障碍点
                [X1, Y1] = _P0,
                [X2, Y2] = P,
                Dis1 = abs(X1 - A_x) * abs(X1 - A_x) + abs(Y1 - A_y) * abs(Y1 - A_y),
                Dis2 = abs(X2 - A_x) * abs(X2 - A_x) + abs(Y2 - A_y) * abs(Y2 - A_y),
                case (Dis2 =< Dis1 orelse [X, Y] =:= _P0) of
                    true ->
                        {P, P};
                    _ ->
                        {P, _P0}
                end;
            _ ->
                {P, _P0}
        end
        end,
    %障碍点筛选
    P0 = [X, Y],
    {_, P1} = lists:mapfoldl(F, P0, List),
    P1.

%%怪物移动
move(X, Y, Minfo, Speed, MoveType) ->
    if
        {X, Y} == {Minfo#mon.x, Minfo#mon.y} ->
            false;
        Speed == 0 ->
            false;
        true ->
            Dis = abs(X - Minfo#mon.x) * 60 + abs(Y - Minfo#mon.y) * 30,
            Minfo2 = Minfo#mon{
                x = X,
                y = Y
            },
            mon_move(Minfo#mon.x, Minfo#mon.y, Minfo2, MoveType),
            mon_agent:update_xy(Minfo2), %% 同步怪物状态
            Time = case Dis == 0 of
                       true -> ?SHORT_EVENT_TIME;
                       false ->
                           if Minfo#mon.shadow_key /= 0 ->
                               round(Dis * 1000 / Speed);
                               true ->
                                   round(Dis * 900 / Speed)
                           end
                   end,
            {true, Minfo2, Time}
    end.

%% 自动回复血和蓝
auto_revert(Minfo) ->
    case Minfo#mon.hp_num =:= 0 orelse Minfo#mon.hp >= Minfo#mon.hp_lim of
        true ->
            [0, Minfo];
        false ->
            %%判断是否超过气血上限
            AddHp = round(Minfo#mon.hp_lim * Minfo#mon.hp_num / 100),
            CurHp = min(Minfo#mon.hp_lim, Minfo#mon.hp + AddHp),
            %%判断是否超过内力上限
            AddMp = round(Minfo#mon.mp_lim * Minfo#mon.mp_num / 100),
            CurMp = min(Minfo#mon.mp_lim, Minfo#mon.mp + AddMp),
            Minfo1 = Minfo#mon{hp = CurHp, mp = CurMp},
            %%  广播给附近玩家
            {ok, BinData} = pt_200:write(20004, {[[2, Minfo#mon.key, 1, AddHp, CurHp]]}),
            broadcast(Minfo1, BinData),
            mon_agent:update(Minfo1),
            [1, Minfo1]
    end.

%%处理状态
handle_battle_status(State, Now) ->
    Minfo = State#mon_act.minfo,
    if
        State#mon_act.ready_ref == none ->
            if
                Minfo#mon.hp > 0 ->
                    TimeMrak = Minfo#mon.time_mark,
                    Move = ?IF_ELSE(Now > TimeMrak#time_mark.umt, true, false),
                    Attack = ?IF_ELSE(Now > TimeMrak#time_mark.uat, true, false),
                    Speed = Minfo#mon.speed,
                    {ok, Minfo, Attack, Move, Speed};
                true ->
                    die
            end;
        true ->
            hold
    end.


%% 加入仇恨列表#st_hatred{}
add_hatred_list(Klist, Attacker) ->
    Hatred = #st_hatred{
        sign = Attacker#attacker.sign,
        key = Attacker#attacker.key,
        nickname = Attacker#attacker.name,
        lv = Attacker#attacker.lv,
        gkey = Attacker#attacker.gkey,
        gname = Attacker#attacker.gname,
        pid = Attacker#attacker.pid,
        team_pid = Attacker#attacker.team,
        hurt = Attacker#attacker.hurt,
        node = Attacker#attacker.node,
        sn = Attacker#attacker.sn,
        cbp = Attacker#attacker.cbp,
        field_boss_times = Attacker#attacker.field_boss_times
    },
    case lists:keytake(Attacker#attacker.key, #st_hatred.key, Klist) of
        false ->
            [Hatred | Klist];
        {value, HatredOld, L} ->
            [Hatred#st_hatred{hurt = Attacker#attacker.hurt + HatredOld#st_hatred.hurt} | L]
    end.

%%计算仇恨列表
get_hatred_max([]) ->
    0;
get_hatred_max(List) ->
    Hatred = lists:last(lists:keysort(#st_hatred.hurt, List)),
    Hatred#st_hatred.key.

%% 攻击者信息更新
add_attacker_list(Attlist, Attacker) ->
    Key = Attacker#attacker.key,
    case lists:keytake(Key, #attacker.key, Attlist) of
        false ->
            [Attacker | Attlist];
        {value, _, T} ->
            [Attacker | T]
    end.


%%怪物移动
%% X 原点 Y原点
mon_move(X, Y, Mon, MoveType) ->
    %%mon_walk_ai(S#mon.scene, S#mon.copy, S#mon.x, S#mon.y, S#mon.key, S#mon.pid, S#mon.group),
    % 移动
    {ok, BinData} = pt_120:write(12008, {Mon#mon.key, Mon#mon.x, Mon#mon.y, MoveType}),
    % 移除
    {ok, BinData1} = pt_120:write(12007, {[Mon#mon.key]}),
    % 怪物进入
    {ok, BinData2} = pt_120:write(12006, {[scene_pack:trans12006(Mon, util:unixtime())]}),
    case scene:is_broadcast_scene(Mon#mon.scene) of
        true ->
            server_send:send_to_scene(Mon#mon.scene, Mon#mon.copy, BinData);
        false ->
            scene_agent:apply_cast(Mon#mon.scene, Mon#mon.copy, scene_calc, move_broadcast, [Mon#mon.copy, Mon#mon.x, Mon#mon.y, X, Y, BinData, BinData1, BinData2, []])
    end.


%% 怪物信息广播
broadcast(Minfo, BinData) ->
    case scene:is_broadcast_scene(Minfo#mon.scene) of
        true ->
            server_send:send_to_scene(Minfo#mon.scene, Minfo#mon.copy, BinData);
        false ->
            server_send:send_to_scene(Minfo#mon.scene, Minfo#mon.copy, Minfo#mon.x, Minfo#mon.y, BinData)
    end.


%%获取攻击目标
get_att_target(Mon) ->
        catch scene:get_scene_pid(Mon#mon.scene, Mon#mon.copy) !
        {mon_att_target,
            Mon#mon.pid,
            Mon#mon.mid,
            Mon#mon.key,
            Mon#mon.type,
            Mon#mon.copy,
            Mon#mon.x,
            Mon#mon.y,
            Mon#mon.trace_area,
            Mon#mon.group,
            Mon#mon.guild_key,
            Mon#mon.shadow_key
        }.

%%开始采集
start_collect(State, Minfo, Clist, Pkey, Pid, _Plv, Now, Gkey, PartyTimes) ->
    %%去掉超时采集
    EffClist = [{Pkey1, Pid1, Time1, S1} || {Pkey1, Pid1, Time1, S1} <- Clist, Now - Time1 < Minfo#mon.collect_time + 3, Pkey =/= Pkey1],
    Res =
        if
            Minfo#mon.kind == ?MON_KIND_GRACE_COLLECT ->
                if
                    EffClist == [] ->
                        case ?CALL(grace_proc:get_server_pid(), {collect_count, Pkey}) of
                            false ->
                                ok;
                            _ -> {false, 15}
                        end;
                    true -> {false, 10}
                end;
            Minfo#mon.kind == ?MON_KIND_CROSS_BOSS_BOX ->
                if
                    EffClist == [] ->
                        ok;
                    true -> {false, 10}
                end;
            Minfo#mon.kind == ?MON_KIND_CROSS_SCUFFLE_ELITE_PARTY_DESK ->
                Count =
                    case cache:get({Minfo#mon.cross_scuff_elite_fight_num, Pkey}) of
                        [] -> 0;
                        Count0 -> Count0
                    end,
                Base = data_cross_scuffle_elite_party:get(Minfo#mon.cross_scuff_elite_fight_num),
                if Count < Base#base_desk.count ->
                    ok;
                    true ->
                        case Minfo#mon.cross_scuff_elite_fight_num of
                            1 -> {false, 43};
                            2 -> {false, 44};
                            3 -> {false, 45};
                            4 -> {false, 46};
                            _ -> {false, 0}
                        end
%%                         end;
%%                     true -> {false, 10}
                end;
            Minfo#mon.kind == ?MON_KIND_BATTLEFIELD ->
                if
                    EffClist == [] ->
                        ok;
                    true -> {false, 10}
                end;
            Minfo#mon.kind == ?MON_KIND_FIELD_BOSS_BOX ->
                case lists:keyfind(Pkey, 1, Minfo#mon.cl_auth) of
                    false -> {false, 17};
                    {_, ClState} ->
                        if ClState == 1 ->
                            {false, 18};
                            true -> ok
                        end
                end;
            Minfo#mon.kind == ?MON_KIND_MANOR_PARTY_TABLE ->
                if
                    Minfo#mon.guild_key /= Gkey -> {false, 32};
                    true ->
                        case manor_war_party:check_manor_party_table_collect_times(Minfo#mon.scene, Gkey, Pkey) of
                            false -> {false, 33};
                            true -> ok
                        end
                end;
            Minfo#mon.kind == ?MON_KIND_PARTY ->
                if PartyTimes >= ?EAT_TIME_LIM -> {false, 39};
                    true ->
                        case lists:member(Pkey, State#mon_act.eat_keys) of
                            true -> {false, 40};
                            false ->
                                ok
                        end
                end;
            Minfo#mon.kind == ?MON_KIND_CROSS_WAR_KING_GOLD ->
                DoorList = ?CALL(cross_war_proc:get_server_pid(), get_door_list),
                ?IF_ELSE(DoorList == [], {false, 0}, ok);
            true ->
                case kindom_guard:is_kindom_guard_dun(Minfo#mon.scene) of
                    true ->
                        if
                            EffClist == [] -> ok;
                            true -> {false, 10}
                        end;
                    false ->
                        ok
                end
        end,
    case Res of
        ok ->
            NewClist = [{Pkey, Pid, Now, 0} | lists:keydelete(Pkey, 1, EffClist)],
            {1, State#mon_act{clist = NewClist}};
        {false, Reason} ->
            {Reason, State}
    end.

%%采集结束
finish_collect(State, Minfo, Clist, Pkey, Pid, _Plv, _Figure, Now, Node, Nickname) ->
    case lists:keyfind(Pkey, 1, Clist) of
        false ->
            {ok, Bin} = pt_200:write(20003, {0}),
            server_send:send_to_pid(Pid, Bin),
            State;
        {Pkey, _pid, Time, ReqTimes} ->
            NewCollectTime = Minfo#mon.collect_time,
            case Now - Time >= NewCollectTime - 1 andalso ReqTimes =< 1 of
                true ->
                    {ok, Bin} = pt_200:write(20003, {3}),
                    server_send:send_to_pid(Pid, Bin),
                    Pid ! {task_event_collect, [Minfo#mon.mid]},
                    if

                        Minfo#mon.kind == ?MON_KIND_GRACE_COLLECT ->
                            grace:update_collect_count(Pkey),
                            act_hi_fan_tian:trigger_finish_api(#player{pid = Pid}, 12, 1),
                            Hatred = #st_hatred{key = Pkey, pid = Pid, hurt = 1, node = Node},
                            drop:mon_drop(Minfo, [Hatred], 1, #attacker{key = Pkey, sign = ?SIGN_PLAYER});
                        Minfo#mon.kind == ?MON_KIND_CROSS_SCUFFLE_ELITE_PARTY_DESK ->
                            Count =
                                case cache:get({Minfo#mon.cross_scuff_elite_fight_num, Pkey}) of
                                    [] -> 0;
                                    Count0 -> Count0
                                end,
                            cache:set({Minfo#mon.cross_scuff_elite_fight_num, Pkey}, Count + 1, 5 * 60),
                            Pid ! {cross_scuffle_elite_party_collect, Minfo#mon.cross_scuff_elite_fight_num};
                        Minfo#mon.kind == ?MON_KIND_FIELD_BOSS_BOX ->
                            Hatred = #st_hatred{key = Pkey, pid = Pid, hurt = 1, node = Node},
                            drop:mon_drop(Minfo, [Hatred], 1, #attacker{key = Pkey, sign = ?SIGN_PLAYER});
                        Minfo#mon.kind == ?MON_KIND_ELIMINATE_COLLECT ->
                            cross_eliminate_play:mon_die(Minfo, Pkey);
                        Minfo#mon.kind == ?MON_KIND_MARRY_SHOW_COLLECT ->
                            Hatred = #st_hatred{key = Pkey, pid = Pid, hurt = 1, node = Node},
                            drop:mon_drop(Minfo, [Hatred], 1, #attacker{key = Pkey, sign = ?SIGN_PLAYER});
                        Minfo#mon.kind == ?MON_KIND_MANOR_PARTY_TABLE ->
                            manor_war_party:party_collect(Minfo, Pkey, Pid, Nickname);
                        Minfo#mon.kind == ?MON_KIND_CROSS_BATTLEFIELD_BOX ->
                            cross_battlefield:collect_box(Minfo, Pkey);
                        Minfo#mon.kind == ?MON_KIND_PARTY ->
                            party_proc:get_server_pid() ! {party_eat, Pkey, Pid, Minfo#mon.party_key};
                        Minfo#mon.kind == ?MON_KIND_CROSS_WAR_KING_GOLD ->
                            cross_war_battle:collect(Pkey);
                        true ->
                            IsKindomGuard = kindom_guard:is_kindom_guard_dun(Minfo#mon.scene),
                            IsCrossBoss = scene:is_cross_boss_scene(Minfo#mon.scene),
                            IsCrossWar = scene:is_cross_war_scene(Minfo#mon.scene),
                            IsDunMarry = scene:is_dun_marry_scene(Minfo#mon.scene),
                            if
                                IsKindomGuard ->
                                    Hatred = #st_hatred{key = Pkey, pid = Pid, hurt = 1, node = Node},
                                    drop:mon_drop(Minfo, [Hatred], 1, #attacker{key = Pkey, sign = ?SIGN_PLAYER});
                                IsCrossBoss ->
                                    Hatred = #st_hatred{key = Pkey, pid = Pid, hurt = 1, node = Node},
                                    drop:mon_drop(Minfo, [Hatred], 1, #attacker{key = Pkey, sign = ?SIGN_PLAYER});
                                IsCrossWar ->
                                    Hatred = #st_hatred{key = Pkey, pid = Pid, hurt = 1, node = Node},
                                    drop:mon_drop(Minfo, [Hatred], 1, #attacker{key = Pkey, sign = ?SIGN_PLAYER});
                                IsDunMarry ->
                                    dungeon_marry:collect_mon(Minfo);
                                true ->
                                    ok
                            end
                    end,
                    ClAuth =
                        case lists:keyfind(Pkey, 1, Minfo#mon.cl_auth) of
                            false -> Minfo#mon.cl_auth;
                            {_, _} ->
                                lists:keyreplace(Pkey, 1, Minfo#mon.cl_auth, {Pkey, 1})
                        end,
                    EatKeys = ?IF_ELSE(Minfo#mon.kind =/= ?MON_KIND_PARTY, State#mon_act.eat_keys, [Pkey | State#mon_act.eat_keys]),
                    if
                        Minfo#mon.collect_count + 1 >= Minfo#mon.collect_num ->
                            mon_util:hide_mon(Minfo),
                            NewMinfo = Minfo#mon{hp = 0, collect_count = 0, cl_auth = ClAuth},
                            %%副本采集
                            dungeon:collect_mon(Minfo),
                            cross_dungeon:collect_mon(Minfo, []),
                            State#mon_act{state = die, minfo = NewMinfo, clist = [], eat_keys = EatKeys};
                        true ->
                            NewClist = lists:keydelete(Pkey, 1, Clist),
                            NewMinfo = Minfo#mon{collect_count = Minfo#mon.collect_count + 1, cl_auth = ClAuth},
                            mon_agent:update(NewMinfo),
                            mon_util:refresh_collect_times(NewMinfo),
                            State#mon_act{minfo = NewMinfo, clist = NewClist, eat_keys = EatKeys}
                    end;
                false ->
                    NewClist = [{Pkey, Pid, Time, ReqTimes + 1} | lists:keydelete(Pkey, 1, Clist)],
                    State#mon_act{clist = NewClist}
            end
    end.

%%同步共享怪物进程
sync_mon_pid(ShareList) ->
    F = fun(Pid) ->
        case is_pid(Pid) of
            true -> Pid ! {change_attr, [{share_list, ShareList}]};
            false -> skip
        end
        end,
    lists:foreach(F, ShareList).

%%同步共享怪物血量
sync_mon_hp(Mon) ->
    F = fun(Pid) ->
        case Mon#mon.pid =/= Pid of
            true ->
                Pid ! {change_attr, [{hp, Mon#mon.hp}]};
            false -> skip
        end
        end,
    lists:foreach(F, Mon#mon.share_list).


%%获取攻击目标坐标
get_att_obj_xy(CurX, CurY, Att, SceneId, Copy) ->
    case Att of
        [Key, _Pid, ?SIGN_PLAYER] ->
            case scene_agent:get_scene_player(SceneId, Copy, Key) of
                [] -> {0, 0};
                ScenePlayer ->
                    {ScenePlayer#scene_player.x, ScenePlayer#scene_player.y}
            end;
        [_Key, Pid, ?SIGN_MON] ->
            %%需避免call自己是情况
            case Pid == self() of
                true ->
                    {CurX, CurY};
                false ->
                    case monster:get_mon(Pid) of
                        [] -> {0, 0};
                        Mon ->
                            {Mon#mon.x, Mon#mon.y}
                    end
            end;
        _ ->
            {0, 0}
    end.

%%怪物死亡处理
mon_die(Mon, Attacker, Klist, TotalHurt) ->
    %%副本
    dungeon:kill_mon(Mon),
    %%跨服副本
    cross_dungeon:kill_mon(Mon, Klist),
    %%巅峰塔
    cross_battlefield:kill_mon(Mon, Attacker#attacker.key),
    %%跨服1vn机器人死亡
    cross_1vn_play:kill_mon(Mon, Attacker#attacker.key),
    %%消消乐
    cross_eliminate_play:mon_die(Mon, Attacker#attacker.key),
    %%跨服竞技
    cross_elite:shadow_die(Mon),
    %%领地战
    manor_war:check_kill_boss(Mon, Attacker, Klist),
    %%王者守卫
    kindom_guard:kill_mon_noitce(Mon, Attacker#attacker.name),
    %%世界首领
    field_boss:kill_elite_mon(Mon, Klist, Attacker#attacker.key),
    %% 节日首领
    act_festive_boss:kill_boss(Mon, Klist, Attacker),
    %%乱斗战场
    cross_scuffle:kill_mon(Mon, Attacker#attacker.key),
    %%乱斗精英
    cross_scuffle_elite:kill_mon(Mon, Attacker#attacker.key),
    %%跨服boss
    cross_boss:kill_boss(Mon, Attacker, Klist, TotalHurt),
    %%精英boss
    elite_boss:kill_boss(Mon, Attacker, Klist, TotalHurt),
    %%怪物掉落
    drop:mon_drop(Mon, Klist, TotalHurt, Attacker),
    %%跨服深渊
    cross_dark_bribe:kill_mon(Mon, Attacker, Klist, TotalHurt),
    %%攻城战
    cross_war_battle:kill_mon(Mon, Attacker, Klist, TotalHurt),
    %%跨服试炼
    cross_dungeon_guard_util:kill_mon_noitce(Mon, Attacker#attacker.name),
    %%仙盟神兽
    guild_boss:kill_boss(Mon, Attacker, Klist, TotalHurt),
    %%宝宝击杀怪物
%%    baby_util:kill_mon(Mon, Attacker),
    %%仙装
%%    xian_upgrade:kill_mon(Mon, Attacker),
    ok.
