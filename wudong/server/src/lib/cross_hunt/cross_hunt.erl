%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 二月 2016 16:49
%%%-------------------------------------------------------------------
-module(cross_hunt).
-author("hxming").

-include("cross_hunt.hrl").
-include("scene.hrl").
-include("common.hrl").
-include("team.hrl").
%% API
-compile(export_all).

%%检查状态
check_state(Node, Sid, Now) ->
    ?CAST(cross_hunt_proc:get_server_pid(), {check_state, Node, Sid, Now}),
    ok.

%%检查进入
check_enter(Mb) ->
    ?CAST(cross_hunt_proc:get_server_pid(), {check_enter, Mb}),
    ok.

%%检查退出
check_quit(Pkey) ->
    ?CAST(cross_hunt_proc:get_server_pid(), {check_quit, Pkey}),
    ok.

%%打包玩家信息
make_mb(Player) ->
    #cross_hunt_mb{
        node = node(),
        pkey = Player#player.key,
        nickname = Player#player.nickname,
        lv = Player#player.lv,
        career = Player#player.career,
        pid = Player#player.pid,
        sid = Player#player.sid,
        gkey = Player#player.guild#st_guild.guild_key,
        is_online = 1,
        target = cross_hunt_target:get_target()
    }.

%%玩家离线
logout(Player) ->
    cross_hunt_target:logout(),
    case scene:is_hunt_scene(Player#player.scene) of
        false -> skip;
        true ->
            cross_area:apply(cross_hunt, check_quit, [Player#player.key])
    end.

%%查看目标
check_boss(Node, Pkey, Sid) ->
    ?CAST(cross_hunt_proc:get_server_pid(), {check_boss, Node, Pkey, Sid}),
    ok.

%%查看线路信息
check_copy(Node, Copy, Gkey, Sid) ->
    ?CAST(cross_hunt_proc:get_server_pid(), {check_copy, Node, Copy, Gkey, Sid}),
    ok.

%%切换线路
change_copy(Node, Pkey, Pid, Copy) ->
    ?CAST(cross_hunt_proc:get_server_pid(), {change_copy, Node, Pkey, Pid, Copy}),
    ok.

%%设置怪物刷新
set_mon_refresh(Now, WorldLv) ->
    F = fun(Id) ->
        Base = data_cross_hunt_mon:get(Id),
        Ref = erlang:send_after(Base#base_cross_hunt.refresh * 1000, self(), {refresh, Id}),
        Mid = mon_util:match_boss(Base#base_cross_hunt.mon_list, WorldLv),
        NewBase = Base#base_cross_hunt{mid = Mid, create_time = Now + Base#base_cross_hunt.refresh, ref = Ref, m_pid_dict = dict:new(), boss_state = ?CROSS_HUNT_BOSS_ST_UNCREATE},
        HuntTarget = #base_hunt_target{goods_id = Base#base_cross_hunt.goods_id, mid = Mid},
        ets:insert(?ETS_CROSS_HUNT_MON, HuntTarget),
        sync_hunt_target(HuntTarget),
        NewBase
        end,
    lists:map(F, data_cross_hunt_mon:ids()).

sync_hunt_target(HuntTarget) ->
    F = fun(Node) ->
        center:apply(Node, cross_hunt, base_hunt_target, [HuntTarget])
        end,
    lists:foreach(F, center:get_nodes()).

base_hunt_target(Record) ->
    ets:insert(?ETS_CROSS_HUNT_MON, Record).

%%获取boss状态
get_boss_state(MonList) ->
    case [Base || Base <- MonList, Base#base_cross_hunt.type == ?CROSS_HUNT_MON_TYPE_BOSS] of
        [] -> {?CROSS_HUNT_BOSS_ST_NO, 0};
        [Base | _] ->
            Now = util:unixtime(),
            {Base#base_cross_hunt.boss_state, max(0, Base#base_cross_hunt.create_time - Now)}
    end.

%%刷新怪物
refresh_mon(Base, CopyList, Pdict) when Base#base_cross_hunt.type == ?CROSS_HUNT_MON_TYPE_BOSS ->
    {X, Y} = hd(tuple_to_list(Base#base_cross_hunt.pos_list)),
    F = fun(Copy) ->
        mon_agent:create_mon([Base#base_cross_hunt.mid, ?SCENE_ID_HUNT, X, Y, Copy, 1, [{return_id_pid, true}]])
        end,
    KeyPidList = lists:map(F, CopyList),
    monster:sync_mon_pid([Pid || {_, Pid} <- KeyPidList]),
    Now = util:unixtime(),
    spawn(fun() -> refresh_boss_damage([], Pdict, ?CROSS_HUNT_BOSS_ST_CREATE) end),
    Base#base_cross_hunt{create_time = Now + Base#base_cross_hunt.refresh, boss_key_pid = KeyPidList, boss_state = ?CROSS_HUNT_BOSS_ST_CREATE};

refresh_mon(Base, CopyList, _Pdict) ->
    F = fun(Pos, Dict) ->
        {X, Y} = Pos,
        case dict:is_key(Pos, Dict) of
            false ->
                F1 = fun(Copy) ->
                    Pid = mon_agent:create_mon([Base#base_cross_hunt.mid, ?SCENE_ID_HUNT, X, Y, Copy, 1, [{return_pid, true}]]),
                    {Copy, Pid}
                     end,
                PidList = lists:map(F1, CopyList),
                dict:store(Pos, PidList, Dict);
            true ->
                OldPidList = dict:fetch(Pos, Dict),
                F2 = fun(Copy) ->
                    case lists:keyfind(Copy, 1, OldPidList) of
                        false ->
                            Pid = mon_agent:create_mon([Base#base_cross_hunt.mid, ?SCENE_ID_HUNT, X, Y, Copy, 1, [{return_pid, true}]]),
                            {Copy, Pid};
                        {_, Pid} ->
                            case misc:is_process_alive(Pid) of
                                false ->
                                    NewPid = mon_agent:create_mon([Base#base_cross_hunt.mid, ?SCENE_ID_HUNT, X, Y, Copy, 1, [{return_pid, true}]]),
                                    {Copy, NewPid};
                                true ->
                                    {Copy, Pid}
                            end
                    end
                     end,
                PidList = lists:map(F2, CopyList),
                dict:store(Pos, PidList, Dict)
        end
        end,
    PidDict = lists:foldl(F, Base#base_cross_hunt.m_pid_dict, tuple_to_list(Base#base_cross_hunt.pos_list)),
    Now = util:unixtime(),
    Ref = erlang:send_after(Base#base_cross_hunt.refresh * 1000, self(), {refresh, Base#base_cross_hunt.id}),
    Base#base_cross_hunt{create_time = Now + Base#base_cross_hunt.refresh, ref = Ref, m_pid_dict = PidDict, boss_state = ?CROSS_HUNT_BOSS_ST_CREATE}.


%%检查是否需要创建BOSS
copy_boss(MonList, Copy) ->
    case [Base || Base <- MonList, Base#base_cross_hunt.boss_state == ?CROSS_HUNT_BOSS_ST_CREATE, Base#base_cross_hunt.type == ?CROSS_HUNT_MON_TYPE_BOSS] of
        [] -> MonList;
        [Boss] ->
            case Boss#base_cross_hunt.boss_key_pid of
                [] -> MonList;
                [{Key, _Pid} | _] ->
                    case mon_agent:get_mon(?SCENE_ID_HUNT, 0, Key) of
                        [] -> MonList;
                        Mon ->
                            {NewKey, NewPid} = mon_agent:create_mon([Mon#mon.mid, ?SCENE_ID_HUNT, Mon#mon.x, Mon#mon.y, Copy, 1, [{hp, Mon#mon.hp}, {return_id_pid, true}]]),
                            ShareList = [Pid || {_, Pid} <- Boss#base_cross_hunt.boss_key_pid],
                            monster:sync_mon_pid([NewPid | ShareList]),
                            KeyPidList = [{NewKey, NewPid} | Boss#base_cross_hunt.boss_key_pid],
                            NewBoss = Boss#base_cross_hunt{boss_key_pid = KeyPidList},
                            lists:keyreplace(Boss#base_cross_hunt.id, #base_cross_hunt.id, MonList, NewBoss)
                    end
            end
    end.


%%活动结束,清理场景
clean(CopyList, Dict) ->
    clean_mon(CopyList),
    cross_hunt_target:target_ret_to_client(Dict),
    util:sleep(5000),
    scene_cross:send_out_cross(?SCENE_TYPE_HUNT),
    ok.

%%清怪
clean_mon(CopyList) ->
    F = fun(Copy) ->
        [monster:stop_broadcast(MonPid) || MonPid <- mon_agent:get_scene_mon_pids(?SCENE_ID_HUNT, Copy)],
        scene_agent:clean_scene_area(?SCENE_ID_HUNT, Copy)
        end,
    lists:foreach(F, CopyList).

%%击杀怪物,获得掉落
mon_drop_goods(Mon, Pkey) ->
    if Mon#mon.kind == ?MON_KIND_HUNT_MON orelse Mon#mon.kind == ?MON_KIND_HUNT_COLLECT ->
            catch ?CAST(cross_hunt_proc:get_server_pid(), {check_mon_die, Mon#mon.mid, Pkey}),
        ok;
        true -> skip
    end.


%%玩家被击杀
role_die(Pkey, AttKey, Sign) ->
    if Sign == ?SIGN_PLAYER ->
        cross_area:apply(cross_hunt, check_role_die, [Pkey, AttKey]);
        true -> skip
    end.

%%检查死亡
check_role_die(Pkey, AttKey) ->
    ?CAST(cross_hunt_proc:get_server_pid(), {check_role_die, Pkey, AttKey}),
    ok.

%%共享
check_share(Pkey, GoodsId) ->
    ?CAST(cross_hunt_proc:get_server_pid(), {check_share, Pkey, GoodsId}),
    ok.

%%boss伤害信息
boss_damage(Pkey, DamageList) ->
    {MyDamage, MyRank} =
        case lists:keyfind(Pkey, #ch_boss_damage.pkey, DamageList) of
            false ->
                {0, 0};
            BossDamage ->
                {BossDamage#ch_boss_damage.damage, BossDamage#ch_boss_damage.rank}
        end,
    TopThree = top_three(DamageList),
    {MyDamage, MyRank, TopThree}.

top_three(DamageList) ->
    F = fun(Damage) ->
        [Damage#ch_boss_damage.nickname, Damage#ch_boss_damage.damage, Damage#ch_boss_damage.rank, Damage#ch_boss_damage.gkey]
        end,
    lists:map(F, lists:sublist(DamageList, 3)).

refresh_boss_damage(DamageList, PDict, BossState) ->
    TopThree = top_three(DamageList),
    F = fun({_, P}) ->
        if P#cross_hunt_mb.is_online == 1 ->
            {MyDamage, MyRank} =
                case lists:keyfind(P#cross_hunt_mb.pkey, #ch_boss_damage.pkey, DamageList) of
                    false ->
                        {0, 0};
                    BossDamage ->
                        {BossDamage#ch_boss_damage.damage, BossDamage#ch_boss_damage.rank}
                end,
            {ok, Bin} = pt_620:write(62005, {BossState, 0, MyDamage, MyRank, TopThree}),
            server_send:send_to_sid(P#cross_hunt_mb.node, P#cross_hunt_mb.sid, Bin);
%%                catch center:apply(P#cross_hunt_mb.node, server_send, send_to_sid, [P#cross_hunt_mb.sid, Bin]);
            true -> skip
        end
        end,
    lists:foreach(F, dict:to_list(PDict)),
    ok.

%%更新boss伤害列表
update_cross_hunt_boss_klist(Mon, KList, Attacker) ->
    if Mon#mon.boss == ?BOSS_TYPE_HUNT ->
        case scene:is_hunt_scene(Mon#mon.scene) of
            false -> KList;
            true ->
                if Mon#mon.hp =< 0 ->
                    ?CAST(cross_hunt_proc:get_server_pid(), {update_boss_damage, Mon, Attacker, 1, KList}),
                    [];
                    true ->
                        Now = util:unixtime(),
                        Key = update_CROSS_HUNT_boss_klist,
                        case get(Key) of
                            undefined ->
                                put(Key, Now),
                                ?CAST(cross_hunt_proc:get_server_pid(), {update_boss_damage, Mon, Attacker, 0, KList}),
                                [];
                            Time ->
                                case Now - Time >= 3 of
                                    true ->
                                        put(Key, Now),
                                        ?CAST(cross_hunt_proc:get_server_pid(), {update_boss_damage, Mon, Attacker, 0, KList}),
                                        [];
                                    false -> KList
                                end
                        end
                end
        end;
        true -> KList
    end.

boss_mail(Pkey, GoodsList) ->
    {Title, Content} = t_mail:mail_content(26),
    mail:sys_send_mail([Pkey], Title, Content, GoodsList).