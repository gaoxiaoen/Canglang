%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%     乱斗处理
%%% @end
%%% Created : 01. 六月 2017 14:33
%%%-------------------------------------------------------------------
-module(cross_scuffle_play).
-author("hxming").


-behaviour(gen_server).

-include("cross_scuffle.hrl").
-include("scene.hrl").
-include("common.hrl").
-include("notice.hrl").
-include("achieve.hrl").

%% gen_server callbacks
-export([
    init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3
]).

-record(state, {
    mb_list = [],
    mon_list = [],%%[{id,keylist}]
    buff_list = [],
    is_finish = 0,
    last_score = {0, 0},
    ref = 0,
    time = 0
}).


-record(mon_buff, {
    key = 0,
    mid = 0,
    pid = none,
    x = 0,
    y = 0,
    group = 0
}).
-define(SERVER, ?MODULE).

-define(TRAP_TIME, 20).
-define(SHOT_TIME, 15).

-define(TRAP_BUFF_ID, 56719).
-define(SCUFFLE_SCORE_LIM, 1000).

%% API
-export([start/2, stop/1, back/3, change_career/3]).

%%创建房间
start(RedMbList, BlueMbList) ->
    gen_server:start(?MODULE, [RedMbList, BlueMbList], []).

%%停止
stop(Pid) ->
    case is_pid(Pid) of
        false -> skip;
        true ->
            Pid ! close
    end.

back(Pkey, Pid, Copy) ->
    Copy ! {back, Pkey, Pid}.


change_career(Pkey, Copy, Career) ->
    Copy ! {change_career, Pkey, Career}.

init([RedMbList, BlueMbList]) ->
%%    ?DEBUG("init scuffle play ~p~n", [self()]),
    scene_init:priv_create_scene(?SCENE_ID_CROSS_SCUFFLE, self()),
    RedList = lists:map(fun(Mb) ->
        Mb#scuffle_mb{group = ?CROSS_SCUFFLE_GROUP_RED, s_career = cross_scuffle:get_s_career()} end, RedMbList),
    BlueList = lists:map(fun(Mb) ->
        Mb#scuffle_mb{group = ?CROSS_SCUFFLE_GROUP_BLUE, s_career = cross_scuffle:get_s_career()} end, BlueMbList),
    Ref = erlang:send_after(100, self(), ready),

    {ok, #state{mb_list = RedList ++ BlueList, ref = Ref}}.


handle_call(_Request, _From, State) ->
    {reply, ok, State}.


handle_cast(_Request, State) ->
    {noreply, State}.

handle_info(Request, State) ->
    case catch info(Request, State) of
        {stop, NewState} ->
            {stop, normal, NewState};
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("cross scuffle play handle_info ~p/~p~n", [Request, Reason]),
            {noreply, State}
    end.


terminate(_Reason, _State) ->
    misc:cancel_timer([_State#state.ref]),
    [monster:stop_broadcast(Aid) || Aid <- mon_agent:get_scene_mon_pids(?SCENE_ID_CROSS_SCUFFLE, self())],
    scene_init:priv_stop_scene(?SCENE_ID_CROSS_SCUFFLE, self()),
%%    F = fun(Mb) ->
%%        center:apply(Mb#scuffle_mb.node, cross_scuffle, erase_record, [Mb#scuffle_mb.pkey])
%%        end,
%%    lists:foreach(F, _State#state.mb_list),
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

info(ready, State) ->
    Timer = 5,
    util:cancel_ref([State#state.ref]),
    Ref = erlang:send_after(Timer * 1000, self(), fight),
    F = fun(Mb) ->
        [Mb#scuffle_mb.sn, Mb#scuffle_mb.pkey, Mb#scuffle_mb.nickname, Mb#scuffle_mb.career, Mb#scuffle_mb.sex, Mb#scuffle_mb.avatar, Mb#scuffle_mb.s_career, Mb#scuffle_mb.group]
        end,
    InfoList = lists:map(F, State#state.mb_list),
    {ok, Bin} = pt_584:write(58407, {Timer, InfoList}),
    F1 = fun(Mb1) ->
        if Mb1#scuffle_mb.pid /= none ->
            center:apply(Mb1#scuffle_mb.node, server_send, send_to_pid, [Mb1#scuffle_mb.pid, Bin]);
            true -> ok
        end
         end,
    lists:foreach(F1, State#state.mb_list),
    %%初始化怪物
    MonList = init_mon(),
    {noreply, State#state{ref = Ref, mon_list = MonList}};

%%通知玩家进入
info(fight, State) ->
    F = fun(Mb) ->
        if Mb#scuffle_mb.pid /= none ->
            server_send:send_node_pid(Mb#scuffle_mb.node, Mb#scuffle_mb.pid, {enter_cross_scuffle, self(), Mb#scuffle_mb.group, Mb#scuffle_mb.s_career});
            true -> ok
        end
        end,
    lists:foreach(F, State#state.mb_list),
    util:cancel_ref([State#state.ref]),
    Ref = erlang:send_after(?CROSS_SCUFFLE_PLAY_TIME * 1000, self(), timeout),
    Ref1 = erlang:send_after(?TRAP_TIME * 1000, self(), trap_timer),
    put(trap_timer, Ref1),
    {noreply, State#state{ref = Ref, time = util:unixtime() + ?CROSS_SCUFFLE_PLAY_TIME}};

%%统计信息
info({info, Pkey}, State) ->
    case lists:keyfind(Pkey, #scuffle_mb.pkey, State#state.mb_list) of
        false -> ok;
        Mb ->
            ScoreLim = data_cross_scuffle_score:get(-1),
            {RedScore, BlueScore} = acc_score(State#state.mb_list),
            LeftTime = max(0, State#state.time - util:unixtime()),
            {ok, Bin} = pt_584:write(58408, {LeftTime, RedScore, BlueScore, ScoreLim, Mb#scuffle_mb.group, Mb#scuffle_mb.score, Mb#scuffle_mb.acc_kill, Mb#scuffle_mb.acc_die}),
            center:apply(Mb#scuffle_mb.node, server_send, send_to_pid, [Mb#scuffle_mb.pid, Bin])
    end,
    {noreply, State};
info(refresh_info, State) when State#state.is_finish == 0 ->
    {RedScore, BlueScore} = acc_score(State#state.mb_list),
    LeftTime = max(0, State#state.time - util:unixtime()),
    ScoreLim = data_cross_scuffle_score:get(-1),
    F = fun(Mb) ->
        if Mb#scuffle_mb.pid /= none ->
            {ok, Bin} = pt_584:write(58408, {LeftTime, RedScore, BlueScore, ScoreLim, Mb#scuffle_mb.group, Mb#scuffle_mb.score, Mb#scuffle_mb.acc_kill, Mb#scuffle_mb.acc_die}),
            center:apply(Mb#scuffle_mb.node, server_send, send_to_pid, [Mb#scuffle_mb.pid, Bin]);
            true -> ok
        end
        end,
    lists:foreach(F, State#state.mb_list),
    ScoreLim = data_cross_scuffle_score:get(-1),
    ScoreSub = abs(RedScore - BlueScore),
    Ret =
        if RedScore >= ScoreLim ->
            final(?CROSS_SCUFFLE_GROUP_RED, State#state.mb_list, ScoreSub);
            BlueScore >= ScoreLim ->
                final(?CROSS_SCUFFLE_GROUP_BLUE, State#state.mb_list, ScoreSub);
            true ->
                skip
        end,
    IsFinish = ?IF_ELSE(Ret == ok, 1, 0),
    Self = self(),
    {OldRedScore, OldBlueScore} = State#state.last_score,
    spawn(fun() ->
        score_msg(OldRedScore, RedScore, 1, Self),
        score_msg(OldBlueScore, BlueScore, 2, Self)
          end),
    {noreply, State#state{is_finish = IsFinish, last_score = {RedScore, BlueScore}}};

%%挑战时间结束
info(timeout, State) when State#state.is_finish == 0 ->
    {RedScore, BlueScore} = acc_score(State#state.mb_list),
    ScoreSub = abs(RedScore - BlueScore),
    if RedScore > BlueScore ->
        final(?CROSS_SCUFFLE_GROUP_RED, State#state.mb_list, ScoreSub);
        BlueScore > RedScore ->
            final(?CROSS_SCUFFLE_GROUP_BLUE, State#state.mb_list, ScoreSub);
        true ->
            final(0, State#state.mb_list, ScoreSub)
    end,
    {noreply, State#state{is_finish = 1}};

info({acc_damage, Pkey, AccDamage}, State) when State#state.is_finish == 0 ->
    MbList =
        case lists:keytake(Pkey, #scuffle_mb.pkey, State#state.mb_list) of
            false -> State#state.mb_list;
            {value, Mb, L} ->
                [Mb#scuffle_mb{acc_damage = Mb#scuffle_mb.acc_damage + AccDamage, acc_damage_time = util:unixtime()} | L]
        end,
    {noreply, State#state{mb_list = MbList}};

%%玩家死亡
info({role_die, DieKey, AttackKey, AccDamage}, State) when State#state.is_finish == 0 ->
    MbList =
        case lists:keytake(DieKey, #scuffle_mb.pkey, State#state.mb_list) of
            false -> State#state.mb_list;
            {value, DieMb, T} ->
                case lists:keytake(AttackKey, #scuffle_mb.pkey, T) of
                    false -> State#state.mb_list;
                    {value, AttMb, T1} ->
                        Now = util:unixtime(),
                        NewDieMb = DieMb#scuffle_mb{
                            combo = 0,
                            acc_die = DieMb#scuffle_mb.acc_die + 1,
                            is_alive = false,
                            acc_damage = DieMb#scuffle_mb.acc_damage + AccDamage,
                            acc_damage_time = Now
                        },
                        Combo = AttMb#scuffle_mb.combo + 1,
                        Score = data_cross_scuffle_score:get(0) + data_cross_scuffle_score:get(Combo),
                        NewAttMb =
                            AttMb#scuffle_mb{
                                combo = Combo,
                                acc_combo = max(Combo, AttMb#scuffle_mb.acc_combo),
                                acc_kill = AttMb#scuffle_mb.acc_kill + 1,
                                score = AttMb#scuffle_mb.score + Score,
                                time = Now
                            },
                        Self = self(),
                        Self ! refresh_info,
                        L = [NewAttMb, NewDieMb] ++ T1,

                        if Combo > 0 ->
                            {ok, BinCombo} = pt_584:write(58415, {AttackKey, Combo}),
                            center:apply(AttMb#scuffle_mb.node, server_send, send_to_pid, [AttMb#scuffle_mb.pid, BinCombo]),
                            ?DO_IF(Combo == 6, server_send:send_node_pid(AttMb#scuffle_mb.node, AttMb#scuffle_mb.pid, {buff, ?SCUFFLE_COMBO_BUFF_ID})),
                            server_send:send_node_pid(AttMb#scuffle_mb.node, AttMb#scuffle_mb.pid, {achieve, ?ACHIEVE_TYPE_3, ?ACHIEVE_SUBTYPE_3026, 0, Combo}),
                            ok;
                            true -> ok
                        end,
                        case AttMb#scuffle_mb.s_career of
                            1 ->
                                server_send:send_node_pid(AttMb#scuffle_mb.node, AttMb#scuffle_mb.pid, {achieve, ?ACHIEVE_TYPE_3, ?ACHIEVE_SUBTYPE_3027, 0, 1});
                            2 ->
                                server_send:send_node_pid(AttMb#scuffle_mb.node, AttMb#scuffle_mb.pid, {achieve, ?ACHIEVE_TYPE_3, ?ACHIEVE_SUBTYPE_3028, 0, 1});
                            3 ->
                                server_send:send_node_pid(AttMb#scuffle_mb.node, AttMb#scuffle_mb.pid, {achieve, ?ACHIEVE_TYPE_3, ?ACHIEVE_SUBTYPE_3029, 0, 1});
                            4 ->
                                server_send:send_node_pid(AttMb#scuffle_mb.node, AttMb#scuffle_mb.pid, {achieve, ?ACHIEVE_TYPE_3, ?ACHIEVE_SUBTYPE_3030, 0, 1});
                            5 ->
                                server_send:send_node_pid(AttMb#scuffle_mb.node, AttMb#scuffle_mb.pid, {achieve, ?ACHIEVE_TYPE_3, ?ACHIEVE_SUBTYPE_3031, 0, 1});
                            6 ->
                                server_send:send_node_pid(AttMb#scuffle_mb.node, AttMb#scuffle_mb.pid, {achieve, ?ACHIEVE_TYPE_3, ?ACHIEVE_SUBTYPE_3032, 0, 1});
                            _ -> ok
                        end,
                        spawn(fun() ->
                            kill_msg(AttMb, DieMb, Self),
                            combo_msg(NewAttMb, Self),
                            end_combo_msg(DieMb, AttMb, Self),
                            all_die_msg(L, DieMb#scuffle_mb.group, Self)
                              end),
                        L
                end
        end,
    {noreply, State#state{mb_list = MbList}};

%%击杀怪物
info({mon_die, Mkey, AttKey}, State) when State#state.is_finish == 0 ->
    {MonList, BuffList} =
        case lists:keytake(Mkey, 1, State#state.mon_list) of
            false ->
                {State#state.mon_list, State#state.buff_list};
            {value, {_, Group}, T} ->
                BuffList1 =
                    case [Key || {Key, Group1} <- T, Group == Group1] of
                        [] ->
                            %%该组野怪清光,进入cd
                            set_mon_refresh_cd(Group),
                            create_buff(Group) ++ State#state.buff_list;
                        _ ->
                            State#state.buff_list
                    end,
                {T, BuffList1}
        end,
    MbList =
        case lists:keytake(AttKey, #scuffle_mb.pkey, State#state.mb_list) of
            false -> State#state.mb_list;
            {value, Mb, L} ->
                [Mb#scuffle_mb{acc_kill_mon = Mb#scuffle_mb.acc_kill_mon + 1, acc_kill_mon_time = util:unixtime()} | L]
        end,
    {noreply, State#state{mb_list = MbList, mon_list = MonList, buff_list = BuffList}};

%%刷新怪物
info({refresh_mon, Group}, State) when State#state.is_finish == 0 ->
    misc:cancel_timer({mon_cd, Group}),
    F = fun(Buff, L) ->
        %%清除buff怪物
        if Buff#mon_buff.group == Group ->
                catch monster:stop_broadcast(Buff#mon_buff.pid),
            L;
            true ->
                [Buff | L]
        end
        end,
    BuffList =
        lists:foldl(F, [], State#state.buff_list),

    MonList = create_mon_list(Group),
    {noreply, State#state{mon_list = State#state.mon_list ++ MonList, buff_list = BuffList}};

%%buff碰撞
info({crash_buff, Node, Pid, Sid, Mkey, CurX, CurY}, State) when State#state.is_finish == 0 ->
    BuffList =
        case lists:keytake(Mkey, #mon_buff.key, State#state.buff_list) of
            false ->
                mon_util:hide_mon(Mkey, Node, Sid),
                State#state.buff_list;
            {value, Buff, T} ->
                case abs(CurX - Buff#mon_buff.x) =< 2 andalso abs(CurY - Buff#mon_buff.y) =< 2 of
                    true ->
                            catch monster:stop_broadcast(Buff#mon_buff.pid),
                        case data_cross_scuffle_buff:get_buff(Buff#mon_buff.mid) of
                            [] -> ok;
                            BuffId ->
                                server_send:send_node_pid(Node, Pid, {buff, BuffId})
                        end,
                        T;
                    false ->
                        State#state.buff_list
                end
        end,
    {noreply, State#state{buff_list = BuffList}};

%%陷阱定时器
info(trap_timer, State) when State#state.is_finish == 0 ->
    misc:cancel_timer(trap_timer),
    Ref1 = erlang:send_after(?TRAP_TIME * 1000, self(), trap_timer),
    put(trap_timer, Ref1),
    PlayerList = scene_agent:get_copy_scene_player(?SCENE_ID_CROSS_SCUFFLE, self()),
    EffTime = 2,
    {ok, Bin} = pt_584:write(58410, {EffTime}),
    F = fun(ScenePlayer) ->
        if ScenePlayer#scene_player.hp > 0 ->
            center:apply(ScenePlayer#scene_player.node, server_send, send_to_pid, [ScenePlayer#scene_player.pid, Bin]),
            [{ScenePlayer#scene_player.x, ScenePlayer#scene_player.y}];
            true -> []
        end
        end,
    L = lists:flatmap(F, PlayerList),
    erlang:send_after(EffTime * 1000, self(), {trap_eff, L}),
    {noreply, State};

%%陷阱效果 58411
info({trap_eff, TrapList}, State) when State#state.is_finish == 0 ->
    PlayerList = scene_agent:get_copy_scene_player(?SCENE_ID_CROSS_SCUFFLE, self()),
    F = fun(ScenePlayer) ->
        F1 = fun({X, Y}) ->
            abs(ScenePlayer#scene_player.x - X) < 2 andalso abs(ScenePlayer#scene_player.y - Y) < 2
             end,
        case lists:any(F1, TrapList) of
            true ->
                server_send:send_node_pid(ScenePlayer#scene_player.node, ScenePlayer#scene_player.pid, {buff, ?TRAP_BUFF_ID});
            false -> skip
        end
        end,
    lists:foreach(F, PlayerList),
    {noreply, State};


%%重连
info({back, Pkey, Pid}, State) ->
    MbList =
        case lists:keytake(Pkey, #scuffle_mb.pkey, State#state.mb_list) of
            false ->
                State#state.mb_list;
            {value, Mb, T} ->
                [Mb#scuffle_mb{pid = Pid, is_alive = true} | T]
        end,
    {noreply, State#state{mb_list = MbList}};

%%玩家掉线
info({logout, Pkey}, State) ->
    MbList =
        case lists:keytake(Pkey, #scuffle_mb.pkey, State#state.mb_list) of
            false -> State#state.mb_list;
            {value, Mb, T} ->
                [Mb#scuffle_mb{pid = none, is_alive = false} | T]
        end,
    {noreply, State#state{mb_list = MbList}};

%%离开
info({quit, Pkey}, State) ->
    case lists:keytake(Pkey, #scuffle_mb.pkey, State#state.mb_list) of
        false ->
            {noreply, State};
        {value, Mb, T} ->
            case T of
                [] ->
                    {stop, State};
                _ ->
                    case [M || M <- T, M#scuffle_mb.group == Mb#scuffle_mb.group] of
                        [] ->
                            if State#state.is_finish == 0 ->
                                WinGroup = ?IF_ELSE(Mb#scuffle_mb.group == ?CROSS_SCUFFLE_GROUP_RED, ?CROSS_SCUFFLE_GROUP_BLUE, ?CROSS_SCUFFLE_GROUP_RED),
                                final(WinGroup, State#state.mb_list, 0),
                                {noreply, State#state{mb_list = T, is_finish = 1}};
                                true ->
                                    {noreply, State#state{mb_list = T}}
                            end;
                        _ ->
                            {noreply, State#state{mb_list = T}}
                    end
            end
    end;

info(close, State) when State#state.is_finish == 0 ->
    info(timeout, State);

info(stop, State) ->
    send_out(),
    {stop, State};


info({change_career, Pkey, Career}, State) ->
    MbList =
        case lists:keytake(Pkey, #scuffle_mb.pkey, State#state.mb_list) of
            false ->
                State#state.mb_list;
            {value, Mb, T} ->
                [Mb#scuffle_mb{s_career = Career, is_alive = true} | T]

        end,
    {noreply, State#state{mb_list = MbList}};

info(_Msg, State) ->
    {noreply, State}.


%%传出
send_out() ->
    PlayerList = scene_agent:get_copy_scene_player(?SCENE_ID_CROSS_SCUFFLE, self()),
    F1 = fun(ScenePlayer) ->
        server_send:send_node_pid(ScenePlayer#scene_player.node, ScenePlayer#scene_player.pid, quit_cross_scuffle)
         end,
    lists:foreach(F1, PlayerList).

%%初始化野怪
init_mon() ->
    F = fun(Group) ->
        create_mon_list(Group)
        end,
    lists:flatmap(F, data_cross_scuffle_mon:id_list()).

create_mon_list(Group) ->
    MonList = data_cross_scuffle_mon:get(Group),
    F = fun({Mid, X, Y}) ->
        Key = mon_agent:create_mon([Mid, ?SCENE_ID_CROSS_SCUFFLE, X, Y, self(), 1, []]),
        {Key, Group}
        end,
    lists:map(F, MonList).

set_mon_refresh_cd(Group) ->
    TimerKey = {mon_cd, Group},
    misc:cancel_timer(TimerKey),
    Cd = data_cross_scuffle_mon:get_cd(Group),
    Ref = erlang:send_after(Cd * 1000, self(), {refresh_mon, Group}),
    put(TimerKey, Ref),
    ok.

%%创建buff
create_buff(Group) ->
    case data_cross_scuffle_mon:get_buff_mon(Group) of
        [] -> [];
        [MonList, X, Y] ->
            BuffMid = util:list_rand_ratio(MonList),
            {Key, Pid} = mon_agent:create_mon([BuffMid, ?SCENE_ID_CROSS_SCUFFLE, X, Y, self(), 1, [{return_id_pid, true}]]),
            Buff = #mon_buff{key = Key, mid = BuffMid, pid = Pid, x = X, y = Y, group = Group},
            [Buff]
    end.


acc_score(MbList) ->
    F = fun(Mb, {RedScore, BlueScore}) ->
        if Mb#scuffle_mb.group == ?CROSS_SCUFFLE_GROUP_RED ->
            {RedScore + Mb#scuffle_mb.score, BlueScore};
            Mb#scuffle_mb.group == ?CROSS_SCUFFLE_GROUP_BLUE ->
                {RedScore, BlueScore + Mb#scuffle_mb.score};
            true -> {RedScore, BlueScore}
        end
        end,
    lists:foldl(F, {0, 0}, MbList).


%%结算
final(WinGroup, MbList, ScoreSub) ->
    erlang:send_after(?SHOT_TIME * 1000, self(), stop),
    ScoreList = score_rank(MbList),
    F = fun(Type) -> rank(Type, ScoreList) end,
    TopList = lists:flatmap(F, lists:seq(1, 3)),
    TopInfoList = pack_rank_list(TopList),
    F1 = fun(Mb) ->
        Ret = ?IF_ELSE(WinGroup == 0, 2, ?IF_ELSE(Mb#scuffle_mb.group == WinGroup, 1, 2)),
        GoodsList = get_reward(Mb, Ret, TopList),
        if Mb#scuffle_mb.pid /= none ->
            server_send:send_node_pid(Mb#scuffle_mb.node, Mb#scuffle_mb.pid, {scuffle_reward, format_good_list(GoodsList)}),
%%            center:apply(Mb#scuffle_mb.node, cross_scuffle, reward_msg, [Mb#scuffle_mb.pkey, format_good_list(GoodsList)]),
            {ok, Bin} = pt_584:write(58412, {Ret, Mb#scuffle_mb.acc_kill, Mb#scuffle_mb.acc_combo, Mb#scuffle_mb.acc_die,
                Mb#scuffle_mb.score, Mb#scuffle_mb.rank, TopInfoList, pack_goods_list(GoodsList)}),
            ?DO_IF(Ret == 1, server_send:send_node_pid(Mb#scuffle_mb.node, Mb#scuffle_mb.pid, {achieve, ?ACHIEVE_TYPE_3, ?ACHIEVE_SUBTYPE_3034, 0, 1})),
            ?DO_IF(Ret == 1 andalso ScoreSub >= 50, server_send:send_node_pid(Mb#scuffle_mb.node, Mb#scuffle_mb.pid, {achieve, ?ACHIEVE_TYPE_3, ?ACHIEVE_SUBTYPE_3033, 0, 1})),
            center:apply(Mb#scuffle_mb.node, server_send, send_to_pid, [Mb#scuffle_mb.pid, Bin]);
            true ->
                center:apply(Mb#scuffle_mb.node, cross_scuffle, erase_scuffle_record, [Mb#scuffle_mb.pkey]),
                ok
        end
         end,
    lists:foreach(F1, ScoreList),
    ?CAST(cross_scuffle_proc:get_server_pid(), {del_play, self()}),
    if WinGroup == 0 -> ok;
        true ->
            Self = self(),
            spawn(fun() -> final_msg(WinGroup, Self) end)
    end,
    ok.

get_reward(Mb, Ret, TopList) ->
    RetGoodsList = ?IF_ELSE(Mb#scuffle_mb.times >= ?DAILY_CROSS_SCUFFLE_TIMES_LIM, [], ret_goods(Ret)),
    ScoreGoodsList = ?IF_ELSE(Mb#scuffle_mb.times >= ?DAILY_CROSS_SCUFFLE_TIMES_LIM, [], score_goods(Mb#scuffle_mb.rank)),
    DropGoodsList = drop_goods(),
    MvpGoodsList = mvp_goods(Mb#scuffle_mb.pkey, TopList),
    RetGoodsList ++ ScoreGoodsList ++ DropGoodsList ++ MvpGoodsList.

%%胜负奖励
ret_goods(Ret) ->
    RetGoodsList =
        case Ret of
            0 ->
                tuple_to_list(data_cross_scuffle_reward:get(100));
            1 ->
                tuple_to_list(data_cross_scuffle_reward:get(101));
            _2 ->
                tuple_to_list(data_cross_scuffle_reward:get(102))
        end,
    [{Gid, Num, 1} || {Gid, Num} <- RetGoodsList].

%%积分排名奖励
score_goods(Rank) ->
    [{Gid, Num, 2} || {Gid, Num} <- tuple_to_list(data_cross_scuffle_reward:get(Rank))].

%%掉落奖励
drop_goods() ->
    case data_cross_scuffle_reward:get(0) of
        {} -> [];
        L ->
            GoodsList = tuple_to_list(L),
            RatioList = [{Gid, Ratio} || {Gid, _, Ratio} <- GoodsList],
            case util:list_rand_ratio(RatioList) of
                0 -> [];
                Gid ->
                    case lists:keyfind(Gid, 1, GoodsList) of
                        false -> [];
                        {_, Num, _} ->
                            [{Gid, Num, 2}]
                    end
            end
    end.

%%MVP奖励
mvp_goods(Pkey, TopList) ->
    F = fun({_, Mb}) -> Mb#scuffle_mb.pkey == Pkey end,
    case lists:any(F, TopList) of
        false -> [];
        true ->
            drop_goods()
    end.

format_good_list(GoodsList) ->
    [{GoodsId, Num} || {GoodsId, Num, _} <- GoodsList].

pack_goods_list(GoodsList) ->
    [tuple_to_list(Info) || Info <- GoodsList].

score_rank(MbList) ->
    F = fun(Mb1, Mb2) ->
        if Mb1#scuffle_mb.acc_kill > Mb2#scuffle_mb.acc_kill -> true;
            Mb1#scuffle_mb.acc_kill == Mb2#scuffle_mb.acc_kill andalso Mb1#scuffle_mb.time < Mb2#scuffle_mb.time ->
                true;
            true -> false
        end
        end,
    SortList = lists:sort(F, MbList),
    F1 =
        fun(Mb, {Rank, L}) ->
            {Rank + 1, L ++ [Mb#scuffle_mb{rank = Rank}]}
        end,
    {_, List} = lists:foldl(F1, {1, []}, SortList),
    List.

%% 杀人最多
rank(1, MbList) ->
    F = fun(Mb1, Mb2) ->
        if Mb1#scuffle_mb.acc_kill > Mb2#scuffle_mb.acc_kill -> true;
            Mb1#scuffle_mb.acc_kill == Mb2#scuffle_mb.acc_kill andalso Mb1#scuffle_mb.time < Mb2#scuffle_mb.time ->
                true;
            true -> false
        end
        end,
    case lists:sort(F, [M || M <- MbList, M#scuffle_mb.acc_kill > 0]) of
        [] -> [{1, #scuffle_mb{}}];
        [Mb | _] ->
            [{1, Mb}]
    end;
%%承受伤害最高
rank(2, MbList) ->
    F = fun(Mb1, Mb2) ->
        if Mb1#scuffle_mb.acc_damage > Mb2#scuffle_mb.acc_damage -> true;
            Mb1#scuffle_mb.acc_damage == Mb2#scuffle_mb.acc_damage andalso Mb1#scuffle_mb.acc_damage_time < Mb2#scuffle_mb.acc_damage_time ->
                true;
            true -> false
        end
        end,
    case lists:sort(F, [M || M <- MbList, M#scuffle_mb.acc_damage > 0]) of
        [] -> [{2, #scuffle_mb{}}];
        [Mb | _] ->
            [{2, Mb}]
    end;
%%杀怪最多
rank(3, MbList) ->
    F = fun(Mb1, Mb2) ->
        if Mb1#scuffle_mb.acc_kill_mon > Mb2#scuffle_mb.acc_kill_mon -> true;
            Mb1#scuffle_mb.acc_kill_mon == Mb2#scuffle_mb.acc_kill_mon andalso Mb1#scuffle_mb.acc_kill_mon_time < Mb2#scuffle_mb.acc_kill_mon_time ->
                true;
            true -> false
        end
        end,
    case lists:sort(F, [M || M <- MbList, M#scuffle_mb.acc_kill_mon > 0]) of
        [] -> [{3, #scuffle_mb{}}];
        [Mb | _] ->
            [{3, Mb}]
    end;
rank(_, _) -> [].

pack_rank_list(RankList) ->
    F = fun({Type, Mb}) ->
        case Type of
            1 ->
                [Type, Mb#scuffle_mb.sn, Mb#scuffle_mb.nickname, Mb#scuffle_mb.s_career, Mb#scuffle_mb.acc_kill];
            2 ->
                [Type, Mb#scuffle_mb.sn, Mb#scuffle_mb.nickname, Mb#scuffle_mb.s_career, Mb#scuffle_mb.acc_damage];
            3 ->
                [Type, Mb#scuffle_mb.sn, Mb#scuffle_mb.nickname, Mb#scuffle_mb.s_career, Mb#scuffle_mb.acc_kill_mon]
        end
        end,
    lists:map(F, RankList).
%%连杀公告
combo_msg(Mb, Copy) ->
    Notice =
        if Mb#scuffle_mb.acc_combo =< 1 -> [];
            Mb#scuffle_mb.acc_combo == 2 orelse Mb#scuffle_mb.acc_combo == 3 ->
                data_notice_sys:get(210);
            Mb#scuffle_mb.acc_combo == 4 orelse Mb#scuffle_mb.acc_combo == 5 ->
                data_notice_sys:get(211);
            true ->
                data_notice_sys:get(212)
        end,
    case Notice of
        [] ->
            ok;
        #base_notice{content = Content} ->
            Player = #player{key = Mb#scuffle_mb.pkey, nickname = Mb#scuffle_mb.nickname},
            CareerName = get_s_career_name(Mb#scuffle_mb.s_career),
            Msg = io_lib:format(Content, [t_tv:pn(Player), CareerName, Mb#scuffle_mb.acc_combo]),
            {ok, Bin} = pt_490:write(49013, {1, Msg}),
            server_send:send_to_scene(?SCENE_ID_CROSS_SCUFFLE, Copy, Bin),
            ok
    end.
%%连杀中止
end_combo_msg(DieMb, AttMb, Copy) ->
    Notice =
        if
            DieMb#scuffle_mb.acc_combo >= 2 andalso DieMb#scuffle_mb.acc_combo =< 3 ->
                data_notice_sys:get(213);
            DieMb#scuffle_mb.acc_combo >= 4 andalso DieMb#scuffle_mb.acc_combo =< 5 ->
                data_notice_sys:get(214);
            DieMb#scuffle_mb.acc_combo >= 6 ->
                data_notice_sys:get(215);
            true ->
                []
        end,
    case Notice of
        [] -> skip;
        #base_notice{content = Content} ->
            AttP = #player{key = AttMb#scuffle_mb.pkey, nickname = AttMb#scuffle_mb.nickname},
            AttCareerName = get_s_career_name(AttMb#scuffle_mb.s_career),
            DieP = #player{key = DieMb#scuffle_mb.pkey, nickname = DieMb#scuffle_mb.nickname},
            DieCareerName = get_s_career_name(DieMb#scuffle_mb.s_career),
            Msg = io_lib:format(Content, [t_tv:pn(AttP), AttCareerName, t_tv:pn(DieP), DieCareerName, DieMb#scuffle_mb.acc_combo]),
            {ok, Bin} = pt_490:write(49013, {1, Msg}),
            server_send:send_to_scene(?SCENE_ID_CROSS_SCUFFLE, Copy, Bin),
            ok
    end.

get_s_career_name(Career) ->
    case data_cross_scuffle_career:get(Career) of
        [] -> <<>>;
        Base -> Base#base_scuffle_career.name
    end.

%%团灭公告
all_die_msg(MbList, Group, Copy) ->
    case [Mb || Mb <- MbList, Mb#scuffle_mb.group == Group, Mb#scuffle_mb.is_alive == true] of
        [] ->
            #base_notice{content = Content} = data_notice_sys:get(216),
            Msg = io_lib:format(Content, [group_name(Group)]),
            {ok, Bin} = pt_490:write(49013, {1, Msg}),
            server_send:send_to_scene(?SCENE_ID_CROSS_SCUFFLE, Copy, Bin),
            ok;
        _ -> skip
    end.


group_name(Group) ->
    ?IF_ELSE(Group == 1, ?T("妖界"), ?T("玄门")).

%%最终结果公告
final_msg(Group, Copy) ->
    #base_notice{content = Content} = data_notice_sys:get(218),
    Msg = io_lib:format(Content, [group_name(Group)]),
    {ok, Bin} = pt_490:write(49013, {1, Msg}),
    server_send:send_to_scene(?SCENE_ID_CROSS_SCUFFLE, Copy, Bin),
%%    {ok, Bin} = pt_490:write(49001, {[[0, Msg, Show]]}),
%%    server_send:send_to_scene(?SCENE_ID_CROSS_SCUFFLE, Copy, Bin),
    ok.

score_msg(OldScore, NewScore, Group, Copy) ->
    if OldScore < 100 andalso NewScore >= 100 ->
        #base_notice{content = Content} = data_notice_sys:get(217),
        Msg = io_lib:format(Content, [group_name(Group), NewScore]),
        {ok, Bin} = pt_490:write(49013, {1, Msg}),
        server_send:send_to_scene(?SCENE_ID_CROSS_SCUFFLE, Copy, Bin),
%%        {ok, Bin} = pt_490:write(49001, {[[0, Msg, Show]]}),
%%        server_send:send_to_scene(?SCENE_ID_CROSS_SCUFFLE, Copy, Bin),
        ok;
        true ->
            ok
    end.

%%击杀公告
kill_msg(AttMb, DieMb, Copy) ->
    #base_notice{content = Content} = data_notice_sys:get(223),
    AttP = #player{key = AttMb#scuffle_mb.pkey, nickname = AttMb#scuffle_mb.nickname},
    AttCareerName = get_s_career_name(AttMb#scuffle_mb.s_career),
    DieP = #player{key = DieMb#scuffle_mb.pkey, nickname = DieMb#scuffle_mb.nickname},
    DieCareerName = get_s_career_name(DieMb#scuffle_mb.s_career),
    Msg = io_lib:format(Content, [AttMb#scuffle_mb.sn, t_tv:pn(AttP), AttCareerName, DieMb#scuffle_mb.sn, t_tv:pn(DieP), DieCareerName]),
    {ok, Bin} = pt_490:write(49013, {1, Msg}),
    server_send:send_to_scene(?SCENE_ID_CROSS_SCUFFLE, Copy, Bin),
    ok.
