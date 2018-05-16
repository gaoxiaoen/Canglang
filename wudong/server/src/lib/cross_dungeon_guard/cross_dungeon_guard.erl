%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%   跨服试炼副本处理
%%% @end
%%% Created : 30. 十一月 2016 9:46
%%%-------------------------------------------------------------------
-module(cross_dungeon_guard).
-author("hxming").

-include("common.hrl").
-include("server.hrl").
-include("dungeon.hrl").
-include("scene.hrl").
-include("cross_dungeon_guard.hrl").
-include("battle.hrl").

-behaviour(gen_server).

%% API
-export([
    start/3,
    kill_mon/2,
    collect_mon/2,
    logout/2,
    quit/2,
    back/4,
    check_target/3,
    add_qinmidu/1,
    refresh_target/1
]).

%% gen_server callbacks
-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).

-export([
    calc_kill_list/1
]).

-define(SERVER, ?MODULE).

-define(CLOSE_TIME, 15).
%%%===================================================================
%%% API
%%%===================================================================
%% playerlist [#dungeon_mb{}]
%% now 当前时间
%% dunid 副本id
%% Extra
start(Room, Now, SceneId) ->
    {ok, Pid} = gen_server:start(?MODULE, [Room, Now, SceneId], []),
    Pid.

%%副本杀怪
kill_mon(Mon, _KList) ->
    case dungeon_util:is_dungeon_guard_cross(Mon#mon.scene) of
        true ->
            Mon#mon.copy ! {kill_mon, Mon#mon.mid, Mon#mon.shadow_key, [{scene, Mon#mon.scene}, {wave, Mon#mon.wave}, {xy, {Mon#mon.x, Mon#mon.y}}]};
        false -> skip
    end.

%%副本采集
collect_mon(Mon, KList) ->
    case dungeon_util:is_dungeon_guard_cross(Mon#mon.scene) of
        true ->
            Mon#mon.copy ! {kill_mon, Mon#mon.mid, KList};
        false -> skip
    end.


%%玩家下线
logout(Pkey, Copy) ->
    catch Copy ! {logout, Pkey}.

back(Pkey, Pid, Sid, Copy) ->
    catch Copy ! {back, Pkey, Pid, Sid}.

quit(Pkey, Copy) ->
    catch Copy ! {quit, Pkey}.

%%副本目标
check_target(Node, Sid, Copy) ->
    catch Copy ! {check_target, Node, Sid}.

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

init([Room, Now, SceneId]) ->
    scene_init:priv_create_scene(Room#ets_cross_dun_guard_room.dun_id, self()),
    DunId = Room#ets_cross_dun_guard_room.dun_id,
    Dungeon = data_dungeon:get(DunId),
    %副本结束定时器
    Ref = erlang:send_after(Dungeon#dungeon.time * 1000, self(), dungeon_finish),
    Round = 1,
%%     MonList = Dungeon#dungeon.mon,
    MonList = [],
    MaxRound = length(MonList),
    {NeedKill, KillList} = create_mon(Dungeon#dungeon.type, DunId, Round, MonList, 0),
    DunCross = #dun_cross_guard{key = Room#ets_cross_dun_guard_room.key, password = Room#ets_cross_dun_guard_room.password, is_fast = Room#ets_cross_dun_guard_room.is_fast, buff_id = Room#ets_cross_dun_guard_room.buff_id},
    RoundRef = erlang:send_after(10 * 1000, self(), next_round),
    DamageList = [#st_hatred{sn = Mb#dungeon_mb.sn, key = Mb#dungeon_mb.pkey, nickname = util:make_sure_list(Mb#dungeon_mb.nickname)} || Mb <- Room#ets_cross_dun_guard_room.mb_list],
    StDungeon = #st_dungeon{
        type = Dungeon#dungeon.type,
        lv = Dungeon#dungeon.lv,
        round = Round,
        max_round = MaxRound,
        dungeon_id = DunId,
        time = Dungeon#dungeon.time,
        begin_time = Now,
        end_time = Now + Dungeon#dungeon.time,
        close_timer = Ref,
        player_list = Room#ets_cross_dun_guard_room.mb_list,
        need_kill_num = NeedKill,
        kill_list = KillList,
        mon = MonList,
        next_round_timer = RoundRef,
        round_time = Now,
        dun_cross_guard = DunCross,
        damage_list = DamageList
    },
    NewStDungeon1 = cross_dungeon_guard_util:start_init(StDungeon, SceneId, DunId, 0),
    erlang:send_after(2000, self(), notice),
    ?PRINT("DUNGEON ~p INIT FINISH!~n", [DunId]),
    {ok, NewStDungeon1}.


handle_call(_Request, _From, State) ->
    {reply, ok, State}.


handle_cast(_Request, State) ->
    {noreply, State}.

handle_info(Request, State) ->
    case catch info(Request, State) of
        {stop, normal, NewState} ->
            {stop, normal, NewState};
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR(" handle_info ~p/ ~p~n", [Request, Reason]),
            {noreply, State}
    end.

terminate(_Reason, State) ->
    [monster:stop_broadcast(MonPid) || MonPid <- mon_agent:priv_get_scene_mon_pids(State#st_dungeon.dungeon_id, self())],
    scene_init:priv_stop_scene(State#st_dungeon.dungeon_id, self()),
%%    scene_agent:clean_scene_area(State#st_dungeon.dungeon_id, self()),
    F = fun(Mb) ->
        if Mb#dungeon_mb.node == none -> ok;
            Mb#dungeon_mb.pid == none ->
                center:apply(Mb#dungeon_mb.node, dungeon_record, erase, [Mb#dungeon_mb.pkey]);
            true ->
                ok
        end
    end,
    lists:foreach(F, State#st_dungeon.player_list),
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
%%击杀怪物
info({kill_mon, Mid, _ShadowKey, Extra}, State) ->
    NewState = dungeon_kill:cross_guard_kill(State, Mid, Extra),
    refresh_target(NewState),
    {noreply, NewState};

info(notice, State) ->
    {ok, Bin} = pt_651:write(65125, {1, 10}),
    F = fun(Mb) ->
        if
            Mb#dungeon_mb.node == nonde -> skip;
            true ->
                case misc:is_process_alive(Mb#dungeon_mb.pid) of
                    true -> server_send:send_to_pid(Mb#dungeon_mb.pid, Bin);
                    false -> skip
                end
        end
    end,
    lists:foreach(F, State#st_dungeon.player_list),
%%     refresh_target(NewState),
    {noreply, State};

%%刷新下一轮
info(next_round, State) ->
    Round = State#st_dungeon.round + 1,
    util:cancel_ref([State#st_dungeon.next_round_timer, State#st_dungeon.dun_cross_guard#dun_cross_guard.mon_notice_ref]),
    Dungeon = data_dungeon:get(State#st_dungeon.dungeon_id),
    CrossGuardDun = State#st_dungeon.dun_cross_guard,
    Floor = CrossGuardDun#dun_cross_guard.cur_floor + 1,
    MaxFloor = data_dungeon_cross_guard_floor:get_max_floor(State#st_dungeon.dungeon_id),
%%     ?DO_IF(Floor == 1, kindom_guard_proc:get_act_pid() ! buff_notice_before_fight),
    if
        Floor > MaxFloor ->
            {noreply, State#st_dungeon{next_round_timer = 0}};
        true ->
            BaseGuard = data_dungeon_cross_guard_floor:get(State#st_dungeon.dungeon_id, Floor),
            #base_cross_guard_dun{
                mon_list = RoundMonList0
            } = BaseGuard,
            RoundMonList = util:to_list(RoundMonList0),
            Args = ?IF_ELSE(Dungeon#dungeon.type == ?DUNGEON_TYPE_CROSS_GUARD, [{type, ?ATTACK_TENDENCY_MON}, {group, 1}, {wave, Floor}], []),
            cross_dungeon_guard_util:mon_refresh_notice(State#st_dungeon.dungeon_id, self(), State#st_dungeon.dun_cross_guard#dun_cross_guard.cur_floor + 1, 0),
            Copy = self(),
            F = fun({Mid, X, Y}) ->
                timer:sleep(30),
                _R = mon_agent:create_mon_cast([Mid, State#st_dungeon.dungeon_id, X, Y, Copy, 1, Args])
            end,
            spawn(fun() -> lists:foreach(F, RoundMonList) end),
            KillList = dungeon:calc_kill_list(RoundMonList),
            StDun = State#st_dungeon{
                round = Round,
                kill_list = State#st_dungeon.kill_list ++ [{Floor, KillList}]
            },
            self() ! {dungeon_target, 0},
            {noreply, StDun}
    end;


%%刷怪通知
info({cross_guard_mon_notice_ref, Scene}, State) ->
    ?DEBUG("State#st_dungeon.dun_cross_guard#dun_cross_guard.cur_floor ~p~n", [State#st_dungeon.dun_cross_guard#dun_cross_guard.cur_floor]),
    cross_dungeon_guard_util:mon_refresh_notice(Scene, self(), State#st_dungeon.dun_cross_guard#dun_cross_guard.cur_floor + 1, 0),
    {noreply, State};

%%跨服试炼副本活动结束
info({cross_guard_finish, Scene, _CrossGuardState}, State) ->
    ?DEBUG("cross_guard_finish ~n"),
    util:cancel_ref([State#st_dungeon.close_timer, State#st_dungeon.dun_cross_guard#dun_cross_guard.mon_notice_ref, State#st_dungeon.next_round_timer]),
    cross_dungeon_guard_util:mon_refresh_notice(?SCENE_ID_KINDOM_GUARD_ID, self(), State#st_dungeon.dun_cross_guard#dun_cross_guard.cur_floor, 0),
%%清除攻击怪
    MonList = mon_agent:get_scene_mon(Scene, self()),
    [Mon#mon.pid ! clear_broadcast || Mon <- MonList],
    erlang:send_after(1 * 1000, self(), dungeon_finish),
    {noreply, State#st_dungeon{is_final = 1}};

%%副本完成
info(dungeon_finish, State) ->
    util:cancel_ref([State#st_dungeon.close_timer]),
    [monster:stop_broadcast(Pid) || Pid <- mon_agent:get_scene_mon_pids(State#st_dungeon.dungeon_id, self())],
    cross_dungeon_guard_proc:get_server_pid() ! {del_in_pro_room, State#st_dungeon.dun_cross_guard#dun_cross_guard.key},
    if State#st_dungeon.is_pass == ?DUNGEON_PASS andalso State#st_dungeon.is_reward == 0 ->
        %%发放奖励
        reward(State),
        %% 增加亲密度
        erlang:send_after(?CLOSE_TIME * 1000, self(), dungeon_close),
        {noreply, State#st_dungeon{is_reward = 1}};
        true ->
            reward(State),
            erlang:send_after(?CLOSE_TIME * 1000, self(), dungeon_close),
            {noreply, State}
    end;

%%副本关闭
info(dungeon_close, State) ->
    send_out(State),
    {stop, normal, State};

%%玩家掉线
info({logout, Pkey}, State) ->
    MbList =
        case lists:keytake(Pkey, #dungeon_mb.pkey, State#st_dungeon.player_list) of
            false ->
                State#st_dungeon.player_list;
            {value, Mb, T} ->
                [Mb#dungeon_mb{pid = none, sid = none} | T]
        end,
    NewState = State#st_dungeon{player_list = MbList},
    {noreply, NewState};

info({quit, Pkey}, State) ->
    IsPass = State#st_dungeon.is_final,

    MbList =
        case lists:keytake(Pkey, #dungeon_mb.pkey, State#st_dungeon.player_list) of
            false ->
                State#st_dungeon.player_list;
            {value, Mb, T} ->
                IsExtraPt = State#st_dungeon.dun_cross_guard#dun_cross_guard.buff_id > 0,
                RoomKey = State#st_dungeon.dun_cross_guard#dun_cross_guard.key,
                Password = State#st_dungeon.dun_cross_guard#dun_cross_guard.password,
                FastOpen = State#st_dungeon.dun_cross_guard#dun_cross_guard.is_fast,
                AutoReady = ?IF_ELSE(Mb#dungeon_mb.is_ready == 1, 1, 0),
                if
                    IsPass /= 1 ->
                        Msg = {dun_cross_guard_ret, State#st_dungeon.is_pass, State#st_dungeon.dungeon_id, RoomKey, Password, FastOpen, AutoReady, IsExtraPt, State#st_dungeon.dun_cross_guard#dun_cross_guard.cur_floor, State#st_dungeon.dun_cross_guard#dun_cross_guard.box_count, State#st_dungeon.goods_list},
                        ?DO_IF(Mb#dungeon_mb.pid /= none, server_send:send_node_pid(Mb#dungeon_mb.node, Mb#dungeon_mb.pid, Msg));
                    true -> skip
                end,

                T
        end,
    NewState = State#st_dungeon{player_list = MbList},
    {noreply, NewState};


%%玩家重连
info({back, Pkey, Pid, Sid}, State) ->
    MbList =
        case lists:keytake(Pkey, #dungeon_mb.pkey, State#st_dungeon.player_list) of
            false ->
                State#st_dungeon.player_list;
            {value, Mb, T} ->
                ?DO_IF(State#st_dungeon.dun_cross_guard#dun_cross_guard.buff_id > 0,
                    catch server_send:send_node_pid(Mb#dungeon_mb.node, Pid, {buff, State#st_dungeon.dun_cross_guard#dun_cross_guard.buff_id})),
                [Mb#dungeon_mb{pid = Pid, sid = Sid} | T]
        end,
    NewState = State#st_dungeon{player_list = MbList},
    {noreply, NewState};

%%查看目标
info({check_target, Node, Sid}, State) ->
    Bin = pack_target(State),
    server_send:send_to_sid(Node, Sid, Bin),
%%    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, State};

info(_Msg, State) ->
    {noreply, State}.


%% 副本创建怪物
create_mon(_DunType, DunId, Round, MonList, IsBc) ->
    MonInfo = lists:keyfind(Round, 1, MonList),
    case MonInfo == false of
        true ->
            {0, []};
        false ->
            {_Round, RoundMonList} = MonInfo,
            F = fun({Mid, X, Y}) ->
                mon_agent:create_mon_cast([Mid, DunId, X, Y, self(), IsBc, [{group, 1}]])
            end,
            lists:foreach(F, RoundMonList),
            KillList = calc_kill_list(RoundMonList),
            {length(RoundMonList), KillList}
    end.

%%统计详细击杀
calc_kill_list(MonList) ->
    F = fun({Mid, _, _}, List) ->
        case lists:keyfind(Mid, 1, List) of
            false ->
                [{Mid, 1, 0} | List];
            {_, Need, Cur} ->
                lists:keyreplace(Mid, 1, List, {Mid, Need + 1, Cur})
        end
    end,
    lists:foldl(F, [], MonList).

%%奖励发放
reward(State) ->
    IsExtraPt = State#st_dungeon.dun_cross_guard#dun_cross_guard.buff_id > 0,
    F = fun(Mb) ->
        if Mb#dungeon_mb.node == none -> ok;
            true ->
                RoomKey = State#st_dungeon.dun_cross_guard#dun_cross_guard.key,
                Password = State#st_dungeon.dun_cross_guard#dun_cross_guard.password,
                FastOpen = State#st_dungeon.dun_cross_guard#dun_cross_guard.is_fast,
                AutoReady = ?IF_ELSE(Mb#dungeon_mb.is_ready == 1, 1, 0),
                Msg = {dun_cross_guard_ret, State#st_dungeon.is_pass, State#st_dungeon.dungeon_id, RoomKey, Password, FastOpen, AutoReady, IsExtraPt, State#st_dungeon.dun_cross_guard#dun_cross_guard.cur_floor, State#st_dungeon.dun_cross_guard#dun_cross_guard.box_count, State#st_dungeon.goods_list},
                ?DO_IF(Mb#dungeon_mb.pid /= none, server_send:send_node_pid(Mb#dungeon_mb.node, Mb#dungeon_mb.pid, Msg)),
                ok
        end
    end,
    lists:foreach(F, State#st_dungeon.player_list),
    ok.

add_qinmidu(State) ->
    ?DEBUG("add qinmidu ~n"),
    add_qinmidu_help(State#st_dungeon.player_list),
    ok.
add_qinmidu_help([]) -> ok;
add_qinmidu_help([H | PlayerList]) ->
    if H#dungeon_mb.node == none -> ok;
        true ->
            PlayerKeyList = [X#dungeon_mb.pkey || X <- PlayerList, X#dungeon_mb.pid /= none, X#dungeon_mb.type == 0, X#dungeon_mb.sn == H#dungeon_mb.sn],
            ?DO_IF(H#dungeon_mb.pid /= none, server_send:send_node_pid(H#dungeon_mb.node, H#dungeon_mb.pid, {cross_dungeon_guard_add_qinmidu, PlayerKeyList})),
            add_qinmidu_help(PlayerList)
    end,
    ok.

send_out(State) ->
    F = fun(Mb) ->
        if Mb#dungeon_mb.node == none -> ok;
            Mb#dungeon_mb.pid == none -> ok;
            true ->
                Msg = {quit_cross_dungeon_guard_scene, State#st_dungeon.dungeon_id, State#st_dungeon.dun_cross_guard#dun_cross_guard.buff_id},
                server_send:send_node_pid(Mb#dungeon_mb.node, Mb#dungeon_mb.pid, Msg),
                ok
        end
    end,
    lists:foreach(F, State#st_dungeon.player_list),
    ok.

refresh_target(State) ->
    Bin = pack_target(State),
    F = fun(Mb) ->
        if Mb#dungeon_mb.node /= none andalso Mb#dungeon_mb.pid /= none andalso Mb#dungeon_mb.type == 0 ->
            server_send:send_to_sid(Mb#dungeon_mb.node, Mb#dungeon_mb.sid, Bin);
%%            center:apply(Mb#dungeon_mb.node, server_send, send_to_sid, [Mb#dungeon_mb.sid, Bin]);
            true -> ok
        end
    end,
    lists:foreach(F, State#st_dungeon.player_list).

pack_target(State) ->
    LeftTime = max(0, State#st_dungeon.end_time - util:unixtime()),
    DamageList = lists:keysort(#st_hatred.hurt, State#st_dungeon.damage_list),
    F = fun(Hatred) ->
        [Hatred#st_hatred.sn, Hatred#st_hatred.key, Hatred#st_hatred.nickname, util:make_sure_list(Hatred#st_hatred.hurt)] end,
    DamageList1 = lists:map(F, lists:reverse(DamageList)),
    ?DEBUG("State#st_dungeon.dun_cross_guard#dun_cross_guard.box_count ~p~n",[State#st_dungeon.dun_cross_guard#dun_cross_guard.box_count]),
    {ok, Bin} = pt_651:write(65121, {LeftTime, State#st_dungeon.dun_cross_guard#dun_cross_guard.box_count, State#st_dungeon.dun_cross_guard#dun_cross_guard.cur_floor, DamageList1}),
    Bin.
