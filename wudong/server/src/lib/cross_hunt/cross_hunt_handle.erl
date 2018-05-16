%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 六月 2016 17:31
%%%-------------------------------------------------------------------
-module(cross_hunt_handle).

-author("hxming").

-include("common.hrl").
-include("cross_hunt.hrl").
-include("scene.hrl").
-include("battle.hrl").

%% API
-export([handle_call/3, handle_cast/2, handle_info/2]).

handle_call(_Msg, _From, State) ->
    {reply, ok, State}.

%%查询活动图标状态
handle_cast({check_state, Node, Sid, Now}, State) ->
    if State#st_cross_hunt.open_state == ?CROSS_HUNT_STATE_CLOSE -> skip;
        true ->
            {ok, Bin} = pt_620:write(62001, {State#st_cross_hunt.open_state, max(0, State#st_cross_hunt.time - Now)}),
            server_send:send_to_sid(Node,Sid,Bin)
%%            center:apply(Node, server_send, send_to_sid, [Sid, Bin])
    end,
    {noreply, State};

%%进入
handle_cast({check_enter, Mb}, State) ->
    {Ret, NewState} =
        if State#st_cross_hunt.open_state /= ?CROSS_HUNT_STATE_START -> {4, State};
            true ->
                {Copy, CopyList, PDict, NewMonList} = rand_copy(Mb, State#st_cross_hunt.copy_list, State#st_cross_hunt.p_dict, State#st_cross_hunt.mon_list),
                State1 = State#st_cross_hunt{copy_list = CopyList, p_dict = PDict, mon_list = NewMonList},
                server_send:send_node_pid(Mb#cross_hunt_mb.node, Mb#cross_hunt_mb.pid, {enter_cross_hunt, Copy}),
                {1, State1}
        end,
    {ok, Bin} = pt_620:write(62002, {Ret}),
    server_send:send_to_sid(Mb#cross_hunt_mb.node,Mb#cross_hunt_mb.sid,Bin),
%%    center:apply(Mb#cross_hunt_mb.node, server_send, send_to_sid, [Mb#cross_hunt_mb.sid, Bin]),
    {noreply, NewState};


%%玩家退出/离线
handle_cast({check_quit, Pkey}, State) ->
    NewState =
        case dict:is_key(Pkey, State#st_cross_hunt.p_dict) of
            false ->
                State;
            true ->
                PDict = dict:erase(Pkey, State#st_cross_hunt.p_dict),
                DamageList =
                    case lists:keytake(Pkey, #ch_boss_damage.pkey, State#st_cross_hunt.boss_damage_list) of
                        false ->
                            State#st_cross_hunt.boss_damage_list;
                        {value, Damage, L} ->
                            [Damage#ch_boss_damage{pid = 0} | L]
                    end,
                State#st_cross_hunt{p_dict = PDict, boss_damage_list = DamageList}
        end,
    {noreply, NewState};


%%获取场景线路数据
handle_cast({check_copy, Node, Copy, Gkey, Sid}, State) ->
    F = fun(CopyCheck) ->
        Filter = dict:filter(fun(_, P) ->
            P#cross_hunt_mb.copy == Copy andalso P#cross_hunt_mb.is_online == 1 end, State#st_cross_hunt.p_dict),
        GFilter = dict:filter(fun(_, P) ->
            P#cross_hunt_mb.gkey /= 0 andalso P#cross_hunt_mb.gkey == Gkey end, Filter),
        [CopyCheck, dict:size(Filter), data_cross_hunt_scene_count:limit_num(), dict:size(GFilter)]
        end,
    Data = lists:map(F, lists:sort(State#st_cross_hunt.copy_list)),
    {ok, Bin} = pt_620:write(62006, {Copy, Data}),
    server_send:send_to_sid(Node,Sid,Bin),
%%    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, State};

%%检查boss信息
handle_cast({check_boss, Node, Pkey, Sid}, State) ->
    Data =
        case cross_hunt:get_boss_state(State#st_cross_hunt.mon_list) of
            {?CROSS_HUNT_BOSS_ST_NO, Time} ->
                {?CROSS_HUNT_BOSS_ST_NO, Time, 0, 0, []};
            {?CROSS_HUNT_BOSS_ST_UNCREATE, Time} ->
                {?CROSS_HUNT_BOSS_ST_UNCREATE, Time, 0, 0, []};
            {BossState, Time} ->
                {MyDamage, MyRank, TopThree} =
                    cross_hunt:boss_damage(Pkey, State#st_cross_hunt.boss_damage_list),
                {BossState, Time, MyDamage, MyRank, TopThree}
        end,
    {ok, Bin} = pt_620:write(62005, Data),
    server_send:send_to_sid(Node,Sid,Bin),
%%    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, State};

%%切换线路
handle_cast({change_copy, Node, Pkey, Pid, Copy}, State) ->
    Filter = dict:filter(fun(_, P) ->
        P#cross_hunt_mb.copy == Copy andalso P#cross_hunt_mb.is_online == 1 end, State#st_cross_hunt.p_dict),
    Limit = data_cross_hunt_scene_count:limit_num(),
    {Ret, NewState} =
        case dict:size(Filter) < Limit of
            true ->
                case dict:is_key(Pkey, State#st_cross_hunt.p_dict) of
                    false ->
                        {1, State};
                    true ->
                        P = dict:fetch(Pkey, State#st_cross_hunt.p_dict),
                        NewP = P#cross_hunt_mb{copy = Copy},
                        PDict = dict:store(Pkey, NewP, State#st_cross_hunt.p_dict),
                        server_send:send_node_pid(Node, Pid, {enter_cross_hunt, Copy}),
                        {1, State#st_cross_hunt{p_dict = PDict}}
                end;
            false ->
                {7, State}
        end,
    {ok, Bin} = pt_620:write(62007, {Ret}),
    center:apply(Node, server_send, send_to_pid, [Pid, Bin]),
    {noreply, NewState};


%%boss伤害更新
handle_cast({update_boss_damage, Mon, Attacker, IsDie, KList}, State) ->
    DamageList = update_boss_damage(KList, State#st_cross_hunt.boss_damage_list, State#st_cross_hunt.p_dict),
    BossState = ?IF_ELSE(IsDie == 1, ?CROSS_HUNT_BOSS_ST_DIE, ?CROSS_HUNT_BOSS_ST_CREATE),
    spawn(fun() -> cross_hunt:refresh_boss_damage(DamageList, State#st_cross_hunt.p_dict, BossState) end),
    MonList =
        if BossState == ?CROSS_HUNT_BOSS_ST_DIE ->
            drop:hunt_boss_drop(Mon, DamageList, Attacker, State#st_cross_hunt.copy_list),
            F1 = fun(Base) ->
                if Base#base_cross_hunt.type == ?CROSS_HUNT_MON_TYPE_BOSS ->
                    Base#base_cross_hunt{boss_state = BossState};
                    true -> Base
                end
                 end,
            lists:map(F1, State#st_cross_hunt.mon_list);
            true ->
                State#st_cross_hunt.mon_list
        end,
    {noreply, State#st_cross_hunt{boss_damage_list = DamageList, mon_list = MonList}};


%%击杀怪物,获得掉落
handle_cast({check_mon_die, Mid, Pkey}, State) ->
    NewState =
        case lists:keyfind(Mid, #base_cross_hunt.mid, State#st_cross_hunt.mon_list) of
            false ->
                State;
            Base ->
                case dict:is_key(Pkey, State#st_cross_hunt.p_dict) of
                    false ->
                        State;
                    true ->
                        Mb = dict:fetch(Pkey, State#st_cross_hunt.p_dict),
                        NewMb = cross_hunt_target:check_mon_die(Mb, Base#base_cross_hunt.goods_id),
                        center:apply(Mb#cross_hunt_mb.node, cross_hunt_target, check_team_share, [Pkey, Base#base_cross_hunt.goods_id]),
                        State#st_cross_hunt{p_dict = dict:store(NewMb#cross_hunt_mb.pkey, NewMb, State#st_cross_hunt.p_dict)}
                end
        end,
    {noreply, NewState};

%%队伍共享
handle_cast({check_share, Pkey, GoodsId}, State) ->
    NewState =
        case dict:is_key(Pkey, State#st_cross_hunt.p_dict) of
            false ->
                State;
            true ->
                Mb = dict:fetch(Pkey, State#st_cross_hunt.p_dict),
                NewMb = cross_hunt_target:check_mon_die(Mb, GoodsId),
                State#st_cross_hunt{p_dict = dict:store(NewMb#cross_hunt_mb.pkey, NewMb, State#st_cross_hunt.p_dict)}
        end,
    {noreply, NewState};

%%玩家被击杀
handle_cast({check_role_die, Pkey, AttKey}, State) ->
    Dict = cross_hunt_target:check_role_die(State#st_cross_hunt.p_dict, Pkey, AttKey),
    {noreply, State#st_cross_hunt{p_dict = Dict}};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info({reset, Now}, State) ->
    util:cancel_ref([State#st_cross_hunt.ref]),
    NewState = cross_hunt_proc:set_timer(State, Now),
    {noreply, NewState};

%%准备
handle_info({ready, ReadyTime, LastTime}, State) when State#st_cross_hunt.open_state == ?CROSS_HUNT_STATE_CLOSE ->
    ?DEBUG("hunt ready ~p~n", [ReadyTime]),
    util:cancel_ref([State#st_cross_hunt.ref]),
    Now = util:unixtime(),
    {ok, Bin} = pt_620:write(62001, {?CROSS_HUNT_STATE_READY, ReadyTime}),
    F = fun(Node) ->
        center:apply(Node, server_send, send_to_all, [Bin])
%%         center:apply(Node, notice_sys, add_notice, [hunt_ready, []])
        end,
    lists:foreach(F, center:get_nodes()),
    Ref = erlang:send_after(ReadyTime * 1000, self(), {start, LastTime}),
    NewState = State#st_cross_hunt{open_state = ?CROSS_HUNT_STATE_READY, time = Now + ReadyTime, ref = Ref},
    {noreply, NewState};

%%开始
handle_info({start, LastTime}, State) when State#st_cross_hunt.open_state /= ?CROSS_HUNT_STATE_START ->
    util:cancel_ref([State#st_cross_hunt.ref]),
    Now = util:unixtime(),
    {ok, Bin} = pt_620:write(62001, {?CROSS_HUNT_STATE_START, LastTime}),
    F = fun(Node) ->
        center:apply(Node, server_send, send_to_all, [Bin])
%%         center:apply(Node, notice_sys, add_notice, [hunt_start, []])
        end,
    lists:foreach(F, center:get_nodes()),
    Ref = erlang:send_after(LastTime * 1000, self(), close),
    WorldLv = center:world_lv(),
    MonList = cross_hunt:set_mon_refresh(Now, WorldLv),
    NewState = State#st_cross_hunt{
        open_state = ?CROSS_HUNT_STATE_START,
        time = Now + LastTime,
        ref = Ref,
        round = 0,
        world_lv = WorldLv,
        mon_list = MonList,
        p_dict = dict:new(),
        boss_damage_list = [],
        copy_list = [0]
    },
    ?DEBUG("cross hunt start ~n"),
    {noreply, NewState};

%%关闭
handle_info(close, State) ->
    ?DEBUG("cross hunt close ~n"),
    util:cancel_ref([State#st_cross_hunt.ref]),
    Now = util:unixtime(),
    {ok, Bin} = pt_620:write(62001, {?CROSS_HUNT_STATE_CLOSE, 0}),
    F = fun(Node) ->
        center:apply(Node, server_send, send_to_all, [Bin])
%%         center:apply(Node, notice_sys, add_notice, [hunt_close, []])
        end,
    lists:foreach(F, center:get_nodes()),

    State1 = State#st_cross_hunt{ref = [], round = 0, mon_list = [], p_dict = dict:new(), boss_damage_list = [], copy_list = []},
    NewState = cross_hunt_proc:set_timer(State1#st_cross_hunt{}, Now),
    spawn(fun() -> cross_hunt:clean(State#st_cross_hunt.copy_list, State#st_cross_hunt.p_dict) end),
    {noreply, NewState};

%%刷新怪物
handle_info({refresh, Id}, State) ->
    case lists:keyfind(Id, #base_cross_hunt.id, State#st_cross_hunt.mon_list) of
        false ->
            {noreply, State};
        Base ->
            NewBase = cross_hunt:refresh_mon(Base, State#st_cross_hunt.copy_list, State#st_cross_hunt.p_dict),
            MonList = lists:keyreplace(Id, #base_cross_hunt.id, State#st_cross_hunt.mon_list, NewBase),
            {noreply, State#st_cross_hunt{mon_list = MonList}}
    end;

handle_info(_msg, State) ->
    ?DEBUG("msg udef ~p~n", [_msg]),
    {noreply, State}.

update_boss_damage(Klist, DamageList, PDict) ->
    F = fun(Hatred, L) ->
        case lists:keyfind(Hatred#st_hatred.key, #ch_boss_damage.pkey, L) of
            false ->
                case dict:is_key(Hatred#st_hatred.key, PDict) of
                    false -> L;
                    true ->
                        P = dict:fetch(Hatred#st_hatred.key, PDict),
                        Damage = #ch_boss_damage{
                            node = P#cross_hunt_mb.node,
                            pid = P#cross_hunt_mb.pid,
                            pkey = Hatred#st_hatred.key,
                            nickname = P#cross_hunt_mb.nickname,
                            lv = P#cross_hunt_mb.lv,
                            career = P#cross_hunt_mb.career,
                            damage = Hatred#st_hatred.hurt,
                            gkey = P#cross_hunt_mb.gkey
                        },
                        [Damage | L]
                end;
            Damage ->
                NewDamage = Damage#ch_boss_damage{damage = Damage#ch_boss_damage.damage + Hatred#st_hatred.hurt},
                lists:keyreplace(Hatred#st_hatred.key, #ch_boss_damage.pkey, L, NewDamage)
        end
        end,
    DamageList1 = lists:foldl(F, DamageList, Klist),
    DamageList2 = lists:keysort(#ch_boss_damage.damage, DamageList1),
    F1 = fun(Damage, {L, Rank}) ->
        {[Damage#ch_boss_damage{rank = Rank} | L], Rank - 1}
         end,
    {DamageList3, _} = lists:foldl(F1, {[], length(DamageList2)}, DamageList2),
    DamageList3.


%%随机分配玩家线路
rand_copy(Mb, CopyList, Pdict, MonList) ->
    {Copy, NewCopyList, NewMonList} = copy(CopyList, Pdict, MonList),
    Dict = dict:store(Mb#cross_hunt_mb.pkey, Mb#cross_hunt_mb{copy = Copy}, Pdict),
    {Copy, NewCopyList, Dict, NewMonList}.

copy(CopyList, Pdict, MonList) ->
    F = fun({_Pkey, HPlayer}, L) ->
        if HPlayer#cross_hunt_mb.is_online == 0 ->
            L;
            true ->
                case lists:keyfind(HPlayer#cross_hunt_mb.copy, 1, L) of
                    false ->
                        [{HPlayer#cross_hunt_mb.copy, 1} | L];
                    {_, Count} ->
                        lists:keyreplace(HPlayer#cross_hunt_mb.copy, 1, L, {HPlayer#cross_hunt_mb.copy, Count + 1})
                end
        end
        end,
    CountList = lists:foldl(F, [{Copy, 0} || Copy <- CopyList], dict:to_list(Pdict)),
    case lists:keysort(2, CountList) of
        [] -> {0, CopyList, MonList};
        [{Copy, Count} | _] ->
            Limit = data_cross_hunt_scene_count:open_num(),
            if Count >= Limit ->
                %%线路满人了,开新的线路
                NewCopy = length(CopyList),
                NewMonList = cross_hunt:copy_boss(MonList, NewCopy),
                {NewCopy, [NewCopy | CopyList], NewMonList};
                true ->
                    {Copy, CopyList, MonList}
            end

    end.