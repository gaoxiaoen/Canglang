%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 场景消息处理模块
%%% @end
%%% Created : 14. 七月 2015 下午3:06
%%%-------------------------------------------------------------------
-module(scene_agent_info).
-author("fancy").

-include("scene.hrl").
-include("common.hrl").
-include("skill.hrl").
-include("battle.hrl").
%% API
-export([handle/2]).

-export([upgrade_skill_cd/2, upgrade_buff_list/2]).

%% 移动
handle({move, [Pkey, X, Y, Type, Now]}, State) ->
    case scene_agent:dict_get_player(Pkey) of
        [] ->
            skip;
        ScenePlayer ->
            #scene_player{
                sid = Sid,
                key = Key,
                pid = Pid,
                copy = Copy,
                scene = SceneId,
                x = X0,
                y = Y0,
                move_time = LastMoveTime
            } = ScenePlayer,
            MoveTime = mon_agent:move_active_mon_ai(SceneId, Copy, X, Y, Key, Pid, Now, LastMoveTime),
            ScenePlayer2 = ScenePlayer#scene_player{x = X, y = Y, is_transport = 0, move_time = MoveTime},
            {ok, Bin} = pt_120:write(12001, {Pkey, X, Y, Type}),
            case scene:is_broadcast_scene(SceneId) of
                true ->
                    scene_agent:priv_send_to_scene(Copy, Bin);
%%                    scene_agent:send_to_scene(SceneId, Copy, Bin);
                false ->
                    {ok, Bin1} = pt_120:write(12004, {[[ScenePlayer#scene_player.key, SceneId]]}),
                    {ok, Bin2} = pt_120:write(12003, {[scene_pack:trans12003(ScenePlayer2)]}),
                    scene_calc:move_broadcast(Copy, X, Y, X0, Y0, Bin, Bin1, Bin2, [Key, Sid])
            end,
            scene_agent:dict_put_player(ScenePlayer2)
    end,
    {noreply, State};

%% 复活
handle({revive, [Pkey, X, Y, Hp, Mp, Protect, ShowGoldenBody]}, State) ->
    case scene_agent:dict_get_player(Pkey) of
        [] -> skip;
        ScenePlayer ->
            BattleInfo = ScenePlayer#scene_player.battle_info,
            TimerMark = BattleInfo#batt_info.time_mark,
            TimerMark2 = TimerMark#time_mark{godt = Protect},
            scene_agent:dict_put_player(ScenePlayer#scene_player{x = X, y = Y, hp = Hp, mp = Mp, show_golden_body = ShowGoldenBody, sync_time = util:longunixtime(), battle_info = BattleInfo#batt_info{time_mark = TimerMark2}})
    end,
    {noreply, State};

%%请求场景信息
handle({request_scene_data, ScenePlayer}, State) ->
    handle({enter_scene, ScenePlayer}, State),
    handle({send_scene_info, ScenePlayer#scene_player.key, ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y}, State),
    {noreply, State};

%% 进入场景
handle({enter_scene, ScenePlayer}, State) ->
    {ok, Bin} = pt_120:write(12003, {[scene_pack:trans12003(ScenePlayer)]}),
    case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
        true ->
            scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
        false ->
            scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
    end,
    case scene_agent:dict_get_player(ScenePlayer#scene_player.key) of
        [] ->
            scene_copy_proc:enter_scene(ScenePlayer#scene_player.scene, ScenePlayer#scene_player.copy, ScenePlayer#scene_player.sn),
            scene_agent:dict_put_player(ScenePlayer);
        ScenePlayerOld ->  %%复活
            Hp = ScenePlayer#scene_player.hp,
            Mp = ScenePlayer#scene_player.mp,
            scene_agent:dict_put_player(ScenePlayerOld#scene_player{pid = ScenePlayer#scene_player.pid, sid = ScenePlayer#scene_player.sid, hp = Hp, mp = Mp})
    end,
    {noreply, State};

%% 离开场景
handle({leave, [Key, Copy, X, Y]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            ok;
        ScenePlayer ->
            {ok, Bin} = pt_120:write(12004, {[[Key, ScenePlayer#scene_player.scene]]}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(Copy, X, Y, Bin)
            end,
            scene_agent:dict_del_player(Key),
            erlang:erase({move_active, ScenePlayer#scene_player.key}),
            scene_copy_proc:leave_scene(ScenePlayer#scene_player.scene, ScenePlayer#scene_player.copy, ScenePlayer#scene_player.sn)
    end,
    {noreply, State};

%% 移除模型
handle({hide, [Key, Copy, X, Y]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            {ok, Bin} = pt_120:write(12004, {[[Key, ScenePlayer#scene_player.scene]]}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(Copy, X, Y, Bin)
            end
    end,
    {noreply, State};


%% 发送场景信息
handle({send_scene_info, Key, Copy, X, Y}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            [ScenePlayerList, SceneMonList] =
                case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                    true ->
                        [scene_agent:priv_get_scene_player(Copy), mon_agent:priv_get_scene_mon(Copy)];
                    false ->
                        [scene_agent:priv_get_scene_area_player(Copy, X, Y), mon_agent:priv_get_scene_area_mon(Copy, X, Y)]
                end,
%%             PrintF = fun(#scene_player{figure = Figure, battle_info = BattleInfo}) ->
%%                 ?DEBUG("Figure:~p BattleInfo:~p", [Figure, BattleInfo])
%%             end,
%%             lists:map(PrintF, ScenePlayerList),
%%            DoorList = scene_cross:door(ScenePlayer#scene_player.scene, ScenePlayer#scene_player.lv),
            DoorList = [],
            SceneNpc = scene_pack:pack_scene_npc(State#scene_state.sid, State#scene_state.npc, State#scene_state.manor_guild_name),
            ScenePlayerList2 = [SP || SP <- lists:keydelete(Key, #scene_player.key, ScenePlayerList), SP#scene_player.is_view /= 2],
            MonInfoList = scene_pack:pack_scene_mon_helper(SceneMonList),
            {ok, BinData} = pt_120:write(12002, {DoorList, MonInfoList, scene_pack:pack_scene_player_helper(ScenePlayerList2), SceneNpc}),
            server_send:send_to_sid(ScenePlayer#scene_player.node, ScenePlayer#scene_player.sid, BinData)
    end,
    {noreply, State};

%% 发送消息到场景
handle({send_to_scene, Copy, Bin}, State) ->
    scene_agent:priv_send_to_scene(Copy, Bin),
    {noreply, State};

handle({send_to_scene, Bin}, State) ->
    scene_agent:priv_send_to_scene(Bin),
    {noreply, State};

handle({send_to_area_scene, Copy, X, Y, Bin}, State) ->
    scene_agent:priv_send_to_local_arena(Copy, X, Y, Bin),
    {noreply, State};

handle({send_to_area_scene, Copy, X, Y, ABin, DBin}, State) ->
    scene_agent:priv_send_to_spec_arena(Copy, X, Y, ABin, DBin),
    {noreply, State};

handle({send_to_scene_group, Copy, Group, Bin}, State) ->
    scene_agent:priv_send_to_scene_group(Copy, Group, Bin),
    {noreply, State};

handle({get_player_scene_group, Node, Sid, Copy, Group}, State) ->
    MainList = cross_war:get_main_key(Node, Sid),
    PlayerList = scene_agent:priv_get_player_by_group(Copy, Group),
    F = fun(ScenePlayer) ->
        case lists:keyfind(ScenePlayer#scene_player.key, 1, MainList) of
            false -> Sign = 0;
            {_, Sign0} -> Sign = Sign0
        end,
        [
            ScenePlayer#scene_player.vip,
            ScenePlayer#scene_player.avatar,
            ScenePlayer#scene_player.fashion#fashion_figure.fashion_decoration_id,
            ScenePlayer#scene_player.sex,
            ScenePlayer#scene_player.nickname,
            ScenePlayer#scene_player.group,
            ScenePlayer#scene_player.key,
            Sign]
    end,
    Data = lists:map(F, PlayerList),
    {ok, Bin} = pt_110:write(11004, {Data}),
    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, State};

%% 战斗更新信息
handle({sync_scene_obj_list, Msg}, State) ->
    write_scene_obj(Msg),
    {noreply, State};

%% mana 法盾 定时器重置
handle({mana_reset, Key, Sign}, State) ->
    Longtime = util:longunixtime(),
    case Sign of
        ?SIGN_MON ->
            case mon_agent:dict_get_mon(Key) of
                [] ->
                    skip;
                Mon ->
                    mon_agent:dict_put_mon(Mon#mon{mana = 0, sync_time = Longtime})
            end;
        _ ->
            case scene_agent:dict_get_player(Key) of
                [] ->
                    skip;
                ScenePlayer ->
                    scene_agent:dict_put_player(ScenePlayer#scene_player{
                        mana = 0,
                        sync_time = Longtime
                    })
            end

    end,
    {noreply, State};

%% 血量变化
%% EffectKey 生成流血效果的key {skillid,effid}
%% Key 玩家或者怪物key
%% Sign 玩家或怪物标记
%% V 血量变化值  （小数为血量上限百分比)
%% N 剩余递减次数
handle({hp_change, EffKey, Key, Sign, V, N, Attacker}, State) ->
    Longtime = util:longunixtime(),
    case Sign of
        ?SIGN_MON ->
            case mon_agent:dict_get_mon(Key) of
                [] ->
                    skip;
                Mon ->
                    #mon{pid = Pid, copy = Copy, x = X, y = Y, hp = HP, hp_lim = HpLim, obj_ref = ObjRef, unbleed = UnBleed, time_mark = TimeMark, buff_list = BuffList, mana = Mana} = Mon,
                    if
                        HP > 0 ->

                            HP2 = ?IF_ELSE(is_float(V), trunc(HpLim * V), V),
                            if UnBleed > 0 andalso HP2 =< 0 -> skip;
                                true ->
                                    HP3 = ?IF_ELSE(HP + HP2 > HpLim, HpLim, HP + HP2),
                                    if HP3 =< 0 andalso Attacker#attacker.key /= 0 andalso Attacker#attacker.key /= Mon#mon.key ->
                                        [erlang:cancel_timer(Ref) || {_, Ref} <- ObjRef#obj_ref.ref_hp_list],
                                        NewMon = Mon#mon{hp = 0, obj_ref = ObjRef#obj_ref{ref_hp_list = []}, sync_time = Longtime},
                                        mon_agent:dict_put_mon(NewMon),
                                        %%广播
                                        ChangeType = ?IF_ELSE(HP3 >= HP, 1, 0),
                                        {ok, Bin} = pt_200:write(20004, {[[Sign, Key, ChangeType, abs(HP2), HP3]]}),
                                        scene_agent:priv_send_to_local_arena(Copy, X, Y, Bin),
                                        Msg = {battle_info_mon, {0, Mon#mon.mp, X, Y, 0, Mon#mon.speed, Longtime, TimeMark, BuffList, [], Mon#mon.t_att, Mon#mon.t_def, Mon#mon.mana, Mon#mon.mana_lim}, Attacker},
                                        Pid ! Msg,
                                        mon_util:hide_mon(Mon),
                                        ok;
                                        Mana > 0 ->
                                            Ref_hp_list =
                                                if
                                                    N > 1 ->
                                                        Ref = erlang:send_after(1000, self(), {hp_change, EffKey, Key, Sign, V, N - 1, Attacker}),
                                                        [{EffKey, Ref} | lists:keydelete(EffKey, 1, ObjRef#obj_ref.ref_hp_list)];
                                                    true ->
                                                        ObjRef#obj_ref.ref_hp_list

                                                end,
                                            NewMon = Mon#mon{obj_ref = ObjRef#obj_ref{ref_hp_list = Ref_hp_list}, sync_time = Longtime},
                                            mon_agent:dict_put_mon(NewMon),
                                            ok;
                                        true ->
                                            NewHP = max(1, HP3),
                                            Ref_hp_list =
                                                if
                                                    N > 1 ->
                                                        Ref = erlang:send_after(1000, self(), {hp_change, EffKey, Key, Sign, V, N - 1, Attacker}),
                                                        [{EffKey, Ref} | lists:keydelete(EffKey, 1, ObjRef#obj_ref.ref_hp_list)];
                                                    true ->
                                                        ObjRef#obj_ref.ref_hp_list

                                                end,
                                            NewMon = Mon#mon{hp = NewHP, obj_ref = ObjRef#obj_ref{ref_hp_list = Ref_hp_list}, sync_time = Longtime},
                                            mon_agent:dict_put_mon(NewMon),
                                            Pid ! {hp, NewHP, HP2},
                                            %%广播
                                            ChangeType = ?IF_ELSE(HP3 >= HP, 1, 0),
                                            {ok, Bin} = pt_200:write(20004, {[[Sign, Key, ChangeType, abs(HP2), NewHP]]}),
                                            scene_agent:priv_send_to_local_arena(Copy, X, Y, Bin)
                                    end
                            end;
                        true ->
                            skip
                    end
            end;
        _ ->
            case scene_agent:dict_get_player(Key) of
                [] ->
                    skip;
                ScenePlayer ->
                    #scene_player{node = Node, copy = Copy, scene = Scene, x = X, y = Y, pid = Pid, hp = HP, battle_info = BattleInfo, attribute = Attribute, scuffle_attribute = ScuffleAttribute, scuffle_elite_attribute = ScuffleEliteAttribute, mana = Mana} = ScenePlayer,
                    HpLim =
                        if
                            Scene == ?SCENE_ID_CROSS_SCUFFLE -> ScuffleAttribute#attribute.hp_lim;
                            Scene == ?SCENE_ID_CROSS_SCUFFLE_ELITE -> ScuffleEliteAttribute#attribute.hp_lim;
                            true -> Attribute#attribute.hp_lim
                        end,
                    ObjRef = BattleInfo#batt_info.obj_ref,
                    Now = Longtime div 1000,
                    if
                        HP > 0 andalso BattleInfo#batt_info.time_mark#time_mark.godt < Now ->
                            HP2 = ?IF_ELSE(is_float(V), trunc(HpLim * V), V),
                            HP3 = ?IF_ELSE(HP + HP2 > HpLim, HpLim, HP + HP2),
                            if HP3 =< 0 andalso Attacker#attacker.key /= 0 andalso Attacker#attacker.key /= ScenePlayer#scene_player.key ->
                                [erlang:cancel_timer(Ref) || {_, Ref} <- ObjRef#obj_ref.ref_hp_list],
                                NewBattleInfo = BattleInfo#batt_info{obj_ref = ObjRef#obj_ref{ref_hp_list = []}},
                                NewScenePlayer = ScenePlayer#scene_player{hp = 0, battle_info = NewBattleInfo, sync_time = Longtime},
                                scene_agent:dict_put_player(NewScenePlayer),
                                %%广播
                                ChangeType = ?IF_ELSE(HP3 >= HP, 1, 0),
                                {ok, Bin} = pt_200:write(20004, {[[Sign, Key, ChangeType, abs(HP2), HP3]]}),
                                scene_agent:priv_send_to_local_arena(Copy, X, Y, Bin),
                                Msg = {HP3, ScenePlayer#scene_player.mp, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, 0, Longtime, Attacker, HP2},
                                server_send:send_node_pid(Node, Pid, {battle_die, Msg});
                                Mana > 0 ->
                                    Ref_hp_list =
                                        if
                                            N > 1 ->
                                                Ref = erlang:send_after(1000, self(), {hp_change, EffKey, Key, Sign, V, N - 1, Attacker}),
                                                [{EffKey, Ref} | lists:keydelete(EffKey, 1, ObjRef#obj_ref.ref_hp_list)];
                                            true ->
                                                ObjRef#obj_ref.ref_hp_list
                                        end,
                                    NewBattleInfo = BattleInfo#batt_info{obj_ref = ObjRef#obj_ref{ref_hp_list = Ref_hp_list}},
                                    NewScenePlayer = ScenePlayer#scene_player{battle_info = NewBattleInfo, sync_time = Longtime},
                                    scene_agent:dict_put_player(NewScenePlayer),
                                    ok;
                                true ->
                                    Ref_hp_list =
                                        if
                                            N > 1 ->
                                                Ref = erlang:send_after(1000, self(), {hp_change, EffKey, Key, Sign, V, N - 1, Attacker}),
                                                [{EffKey, Ref} | lists:keydelete(EffKey, 1, ObjRef#obj_ref.ref_hp_list)];
                                            true ->
                                                ObjRef#obj_ref.ref_hp_list
                                        end,
                                    NewBattleInfo = BattleInfo#batt_info{obj_ref = ObjRef#obj_ref{ref_hp_list = Ref_hp_list}},
                                    NewHP = max(1, HP3),
                                    NewScenePlayer = ScenePlayer#scene_player{hp = NewHP, battle_info = NewBattleInfo, sync_time = Longtime},
                                    scene_agent:dict_put_player(NewScenePlayer),
                                    server_send:send_node_pid(Node, Pid, {hp, NewHP, HP2}),
                                    %%广播
                                    ChangeType = ?IF_ELSE(HP3 >= HP, 1, 0),
                                    {ok, Bin} = pt_200:write(20004, {[[Sign, Key, ChangeType, abs(HP2), NewHP]]}),
                                    scene_agent:priv_send_to_local_arena(Copy, X, Y, Bin)
                            end;
                        true ->
                            skip
                    end
            end

    end,
    {noreply, State};

%%区域范围血量变化  e.固定位置火烧;加血泉水
%% effkey  生成流血效果的key {skillid,effid}
%% Copy 副本
%% x绝对坐标
%% y绝对坐标
%% area 范围
%% v 数值
%% n 次数
%% 排除的key列表
%% 排除的分组
handle({area_hp_change, EffKey, Copy, X, Y, Area, V, N, ExceptKeys, Group, Attacker}, State) ->
    AllObj = scene_agent:priv_get_scene_obj_for_battle(Copy, X, Y, Area, ExceptKeys, Group),
    Now = util:unixtime(),
    Self = self(),
    F = fun(Obj) ->
        {Key, Sign, TimeMark} =
            if
                is_record(Obj, scene_player) ->
                    {Obj#scene_player.key, ?SIGN_PLAYER, Obj#scene_player.battle_info#batt_info.time_mark};
                is_record(Obj, mon) ->
                    {Obj#mon.key, ?SIGN_MON, Obj#mon.time_mark};
                true ->
                    {0, 0, 0}
            end,
        if
            Key /= 0 andalso Now > TimeMark#time_mark.godt ->
                Self ! {hp_change, EffKey, Key, Sign, V, 0, Attacker};
            true ->
                skip
        end
    end,
    lists:foreach(F, AllObj),
    ?DO_IF(N > 1, erlang:send_after(1000, Self, {area_hp_change, EffKey, Copy, X, Y, Area, V, N - 1, ExceptKeys, Group, Attacker})),
    {noreply, State};

%% 持续触发效果
handle({trigger_eff, Sign, Key, N, Effid, Target, Args}, State) ->
    Longtime = util:longunixtime(),
    case Sign of
        ?SIGN_MON ->
            case mon_agent:dict_get_mon(Key) of
                [] ->
                    skip;
                Mon ->
                    if
                        Mon#mon.hp > 0 ->
                            ObjRef = Mon#mon.obj_ref,
                            Ref = ?IF_ELSE(N > 1, erlang:send_after(1000, self(), {trigger_eff, Sign, Key, N - 1, Effid, Target, Args}), none),
                            BS = battle:init_data(Mon, util:longunixtime()),
                            effect:trigger_effect(BS, Effid, Target, Args),
                            mon_agent:dict_put_mon(Mon#mon{obj_ref = ObjRef#obj_ref{ref_effect = Ref}, sync_time = Longtime});
                        true ->
                            skip
                    end

            end;
        _ ->
            case scene_agent:dict_get_player(Key) of
                [] ->
                    skip;
                ScenePlayer ->
                    if
                        ScenePlayer#scene_player.hp > 0 ->
                            BattleInfo = ScenePlayer#scene_player.battle_info,
                            ObjRef = BattleInfo#batt_info.obj_ref,
                            Ref = ?IF_ELSE(N > 1, erlang:send_after(1000, self(), {trigger_eff, Sign, Key, N - 1, Effid, Target, Args}), none),
                            NewBattleInfo = BattleInfo#batt_info{obj_ref = ObjRef#obj_ref{ref_effect = Ref}},
                            BS = battle:init_data(ScenePlayer, util:longunixtime()),
                            effect:trigger_effect(BS, Effid, Target, Args),
                            scene_agent:dict_put_player(ScenePlayer#scene_player{battle_info = NewBattleInfo, sync_time = Longtime});
                        true ->
                            skip
                    end
            end

    end,
    {noreply, State};

%%更新仙盟信息
handle({guild, [Key, GKey, GName, Position]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{guild_key = GKey, guild_name = GName, guild_position = Position},
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_120:write(12011, {Key, GKey, GName, Position}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};

%%更新战队信息
handle({war_team, [Key, WtKey, WtName, Position]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{war_team_key = WtKey, war_team_name = WtName, war_team_position = Position},
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_120:write(12067, {Key, WtKey, WtName, Position}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};


%%更新队伍信息
handle({team, [Key, Tkey, Tpid, Leader]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{teamkey = Tkey, team = Tpid, team_leader = Leader},
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_120:write(12013, {Key, Tkey, Leader}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};


%%更新变身信息
handle({figure, [Key, Figure, Sid, PEvil]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            {ok, Bin} = pt_120:write(12025, {Key, Figure, PEvil#pevil.evil}),
            server_send:send_to_sid(Sid, Bin),
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{figure = Figure},
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_120:write(12025, {Key, Figure, PEvil#pevil.evil}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};


%%更新战场数据
handle({battlefield, [Key, Group, Combo, Score]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{combo = Combo, group = Group, bf_score = Score},
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_120:write(12032, {Key, Group, Score, Combo}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};


%%更新护送信息
handle({convoy, [Key, ConvoyState]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{convoy_state = ConvoyState},
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_120:write(12026, {Key, ConvoyState}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};

%%设置无敌保护
handle({protect, [Key, GodTime]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            BattleInfo = ScenePlayer#scene_player.battle_info,
            NewBattleInfo = BattleInfo#batt_info{time_mark = BattleInfo#batt_info.time_mark#time_mark{godt = GodTime}},
            NewScenePlayer = ScenePlayer#scene_player{battle_info = NewBattleInfo},
            scene_agent:dict_put_player(NewScenePlayer)
    end,
    {noreply, State};



handle({convoy_rob, [Key, Times]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{convoy_rob = Times},
            scene_agent:dict_put_player(NewScenePlayer)
    end,
    {noreply, State};


%%属性信息更新
handle({attribute, [Key, Attribute, ScuffleAttribute, ScuffleEliteAttribute]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            scene_agent:dict_put_player(ScenePlayer#scene_player{attribute = Attribute, scuffle_attribute = ScuffleAttribute, scuffle_elite_attribute = ScuffleEliteAttribute})
    end,
    {noreply, State};

%%更新速度
handle({speed, [Key, Speed]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{attribute = ScenePlayer#scene_player.attribute#attribute{speed = Speed}},
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_200:write(20006, {?SIGN_PLAYER, Key, Speed}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};

%%更新坐骑形象
handle({mount_id, [Key, MountId, Attribute]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{attribute = Attribute, mount_id = MountId},
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_120:write(12012, {Key, MountId}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};

%%更新翅膀形象
handle({wing_figure, [Key, WingId, Attribute]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{
                attribute = Attribute,
                wing_id = WingId},
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_120:write(12018, {Key, WingId}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};

%%更新翅膀形象
handle({baby_wing_figure, [Key, WingId, Attribute]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{
                attribute = Attribute,
                baby_wing_id = WingId},
            scene_agent:dict_put_player(NewScenePlayer),
            ?DEBUG("WingId ~p~n", [WingId]),
            {ok, Bin} = pt_120:write(12061, {Key, WingId}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};

%%更新装备形象与属性
handle({equip_figure, [Key, EquipInfo, Attribute]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{
                attribute = Attribute,
                equip_figure = EquipInfo},
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_120:write(12019, {Key, EquipInfo#equip_figure.weapon_id, EquipInfo#equip_figure.clothing_id}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};

%%更新时装形象与属性
handle({fashion_figure, [Key, Fashion, Attribute]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{
                attribute = Attribute,
                fashion = Fashion},
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_120:write(12020, {Key, Fashion#fashion_figure.fashion_cloth_id, Fashion#fashion_figure.fashion_head_id}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};

%%更新光武形象与属性
handle({light_weapon_figure, [Key, LightWeaponId, Attribute]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{
                attribute = Attribute,
                light_weapon_id = LightWeaponId},
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_120:write(12024, {Key, LightWeaponId}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};

%%妖灵形象
handle({pet_weapon_figure, [Key, PetWeaponId, Attribute]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{
                attribute = Attribute,
                pet_weapon_id = PetWeaponId},
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_120:write(12046, {Key, PetWeaponId}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};

%%skillbuff
handle({skillbuff, [Key, SkillBuffList]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            BattleInfo = ScenePlayer#scene_player.battle_info,
            scene_agent:dict_put_player(ScenePlayer#scene_player{battle_info = BattleInfo#batt_info{buff_list = SkillBuffList}})

    end,
    {noreply, State};

%%血量魔法同步
handle({hpmp, [Key, Hp, Mp]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            scene_agent:dict_put_player(ScenePlayer#scene_player{hp = Hp, mp = Mp})
    end,
    {noreply, State};

%%ex技能信息
handle({evil, [Key, Node, Sid, Sin, Figure, Evil]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            {ok, Bin} = pt_120:write(12025, {Key, Figure, Evil#pevil.evil}),
            server_send:send_to_sid(Node, Sid, Bin),
            skip;
        ScenePlayer ->
            scene_agent:dict_put_player(ScenePlayer#scene_player{sin = Sin, figure = Figure, evil = Evil}),
            {ok, Bin} = pt_120:write(12025, {Key, Figure, Evil#pevil.evil}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};

%%跟新宠物数据
handle({pet, [Key, TypeId, Star, Stage, Figure, Name, Skill, AttParam]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePet = ScenePlayer#scene_player.pet#scene_pet{
                type_id = TypeId,
                figure = Figure,
                star = Star,
                stage = Stage,
                name = Name,
                skill = Skill,
                att_param = AttParam
            },
            NewScenePlayer = ScenePlayer#scene_player{
                pet = NewScenePet
            },
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_120:write(12014, {Key, TypeId, Figure, Name}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};


%%跟新宝宝数据
handle({baby, [Key, TypeId, Step, Lv, Figure, Name, Skill]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewSceneBaby = ScenePlayer#scene_player.baby#scene_baby{
                type_id = TypeId,
                figure = Figure,
                name = Name,
                skill = Skill,
                step = Step,
                lv = Lv
            },
            NewScenePlayer = ScenePlayer#scene_player{
                baby = NewSceneBaby
            },
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_120:write(12060, {Key, TypeId, Figure, Name}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};


%%更新称号数据
handle({designation, [Key, DesList]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{
                design = DesList
            },
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_120:write(12028, {Key, DesList}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};


%%自动战斗,宠物,法器
handle({auto_battle, Sign, Akey, TargetList, SkillId, Type}, State) ->
%%     util:sleep(1000),
    case TargetList of
        [] -> ok;
        _ ->
            case Type of
                pet ->
                    battle_pet:battle(Sign, Akey, SkillId, [hd(TargetList)]);
                magic_weapon ->
                    battle_magic_weapon:battle(Sign, Akey, SkillId, TargetList);
                god_weapon ->
                    battle_god_weapon:battle(Sign, Akey, SkillId, TargetList);
                baby ->
                    battle_baby:battle(Sign, Akey, SkillId, TargetList);
                _ -> ok
            end
    end,
    {noreply, State};


%%获取怪物攻击对象
handle({mon_att_target, Mpid, _Mid, Mkey, Type, Copy, X, Y, TraceArea, Group, GuildKey, _ShadowKey}, State) ->
    %% ?DEBUG("TraceArea ~p~n",[TraceArea]),
    AtterSign = ?SIGN_MON,
    TargetList =
        case Type of
            ?ATTACK_TENDENCY_RANDOM ->
                case util:rand(?ATTACK_TENDENCY_MON, ?ATTACK_TENDENCY_PLAYER) of
                    ?ATTACK_TENDENCY_MON ->
                        mon_agent:priv_get_scene_mon_for_battle(Copy, X, Y, TraceArea, [Mkey], Group, AtterSign, _ShadowKey);
                    ?ATTACK_TENDENCY_PLAYER ->
                        scene_agent:priv_get_scene_player_for_battle(Copy, X, Y, TraceArea, [Mkey], Group)
                end;
            ?ATTACK_TENDENCY_MON ->
                mon_agent:priv_get_scene_mon_for_battle(Copy, X, Y, TraceArea, [Mkey], Group, AtterSign, _ShadowKey);
            ?ATTACK_TENDENCY_PLAYER ->
                scene_agent:priv_get_scene_player_for_battle(Copy, X, Y, TraceArea, [Mkey], Group);
            ?ATTACK_TENDENCY_PLAYER_2_MON ->
                case scene_agent:priv_get_scene_player_for_battle(Copy, X, Y, TraceArea, [Mkey], Group) of
                    [] ->
                        mon_agent:priv_get_scene_mon_for_battle(Copy, X, Y, TraceArea, [Mkey], Group, AtterSign, _ShadowKey);
                    TList1 ->
                        TList1
                end;
            ?ATTACK_TENDENCY_MONAR ->
                scene_agent:priv_get_scene_player_for_manor_boss(Copy, X, Y, TraceArea, [Mkey], GuildKey)
        end,
    case TargetList of
        [] ->
            skip;
        [Obj | _] ->
            if
                is_record(Obj, scene_player) ->
                    Mpid ! {attack, [Obj#scene_player.key, Obj#scene_player.pid, ?SIGN_PLAYER]};
                is_record(Obj, mon) ->
                    Mpid ! {attack, [Obj#mon.key, Obj#mon.pid, ?SIGN_MON]};
                true ->
                    skip
            end
    end,
    {noreply, State};
%% %%怪物嗅探
%% handle({sinffer, Mkey, Mpid, Copy, X, Y, TraceArea, _Group, GuildKey}, State) when GuildKey /= 0 ->
%%     case scene_agent:priv_get_scene_player_for_manor_boss(Copy, X, Y, TraceArea, [Mkey], GuildKey) of
%%         [] ->
%%             skip;
%%         [ScenePlayer | _] ->
%%             Mpid ! {attack, [ScenePlayer#scene_player.key, ScenePlayer#scene_player.pid, ?SIGN_PLAYER]}
%%     end,
%%     {noreply, State};
%% handle({sinffer, Mkey, Mpid, Copy, X, Y, TraceArea, Group, _GuildKey}, State) when Group == 0 ->
%%     case scene_agent:priv_get_scene_player_for_battle(Copy, X, Y, TraceArea, [Mkey], Group) of
%%         [] ->
%%             skip;
%%         [ScenePlayer | _] ->
%%             Mpid ! {attack, [ScenePlayer#scene_player.key, ScenePlayer#scene_player.pid, ?SIGN_PLAYER]}
%%     end,
%%     {noreply, State};
%%
%% handle({sinffer, Mkey, Mpid, Copy, X, Y, TraceArea, Group, _GuildKey}, State) when Group == -1 ->
%%     case mon_agent:priv_get_scene_mon_for_battle(Copy, X, Y, TraceArea, [Mkey], Group) of
%%         [] ->
%%             skip;
%%         [Mon | _] ->
%%             Mpid ! {attack, [Mon#mon.key, Mon#mon.pid, ?SIGN_MON]}
%%     end,
%%     {noreply, State};
%%
%% handle({sinffer, Mkey, Mpid, Copy, X, Y, TraceArea, Group, _GuildKey}, State) ->
%%     case scene_agent:priv_get_scene_obj_for_battle(Copy, X, Y, TraceArea, [Mkey, Group], Group) of
%%         [] ->
%%             skip;
%%         [Obj | _] ->
%%             if
%%                 is_record(Obj, scene_player) ->
%%                     Mpid ! {attack, [Obj#scene_player.key, Obj#scene_player.pid, ?SIGN_PLAYER]};
%%                 is_record(Obj, mon) ->
%%                     Mpid ! {attack, [Obj#mon.key, Obj#mon.pid, ?SIGN_MON]};
%%                 true ->
%%                     skip
%%             end
%%     end,
%%     {noreply, State};

%%更新采集标记
%%handle({collect_flag, [Key, Flag]}, State) ->
%%    case scene_agent:dict_get_player(Key) of
%%        [] ->
%%            skip;
%%        ScenePlayer ->
%%            NewScenePlayer = ScenePlayer#scene_player{collect_flag = Flag},
%%            scene_agent:dict_put_player(NewScenePlayer),
%%            {ok, Bin} = pt_120:write(12029, {Key, Flag}),
%%            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
%%                true ->
%%                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
%%                false ->
%%                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
%%            end
%%    end,
%%    {noreply, State};

%%更新VIP
handle({vip, [Key, VipLv, VipState]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{
                vip = VipLv
            },
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_120:write(12030, {Key, VipLv,VipState}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};

%%更新光环
handle({halo, [Key, HolaId]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{
                halo_id = HolaId
            },
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_120:write(12033, {Key, HolaId}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};

handle({scene_face, [Key, SceneFace]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{
                scene_face = SceneFace
            },
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_120:write(12034, {Key, SceneFace}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};

handle({change_name, [Key, NewName]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{
                nickname = NewName
            },
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_120:write(12035, {Key, NewName}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};

%%战场皇冠更新
handle({crown, [Key, Crown]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{crown = Crown},
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_120:write(12036, {Key, Crown}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};

%%双人共乘坐骑信息更新
handle({common_mount, Key, CommonRiding}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{commom_mount_pkey = CommonRiding#common_riding.common_pkey,
                main_mount_pkey = CommonRiding#common_riding.main_pkey,
                commom_mount_state = CommonRiding#common_riding.state},
            scene_agent:dict_put_player(NewScenePlayer),
%?PRINT("common_mount ~p ~p ~p ~n",[CommonRiding#common_riding.main_pkey,CommonRiding#common_riding.common_pkey,CommonRiding#common_riding.state]),
            {ok, Bin} = pt_120:write(12037, {CommonRiding#common_riding.main_pkey, CommonRiding#common_riding.common_pkey, CommonRiding#common_riding.state}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};

%%坐骑技能同步
handle({passive_skill, Key, SkillList}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{passive_skill = SkillList},
            scene_agent:dict_put_player(NewScenePlayer)
    end,
    {noreply, State};

%%法宝技能
handle({magic_weapon_skill, Key, SkillList}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{magic_weapon_skill = SkillList},
            scene_agent:dict_put_player(NewScenePlayer)
    end,
    {noreply, State};


%%法宝形象
handle({magic_weapon_id, Key, WeaponId, Attribute}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{magic_weapon_id = WeaponId, attribute = Attribute},
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_120:write(12040, {Key, WeaponId}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};

handle({god_weapon_id, Key, WeaponId, SkillId}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{god_weapon_id = WeaponId, god_weapon_skill = SkillId},
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_120:write(12041, {Key, WeaponId, SkillId}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};


handle({sword_pool_figure, Key, Figure}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{sword_pool_figure = Figure},
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_120:write(12039, {Key, Figure}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};

%%设置模式
handle({set_view, Key, IsView}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{is_view = IsView},
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_120:write(12043, {?SIGN_PLAYER, Key, IsView}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};

%%设置足迹
handle({footprint_id, Key, FootprintId}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{footprint_id = FootprintId},
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_120:write(12044, {Key, FootprintId}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};

%%罪恶更新
handle({pk_value, Key, StPk}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
%%            NewScenePlayer = ScenePlayer#scene_player{pk = ScenePlayer#scene_player{pk = StPk}},
            NewScenePlayer = ScenePlayer#scene_player{pk = StPk},
            #pk{
                pk = PkType,
                value = Value,
                kill_count = Kill,
                chivalry = Chivalry,
                protect_time = ProtectTime
            } = StPk,
            Now = util:unixtime(),
            LeaveTime = max(0, ProtectTime - Now),
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_120:write(12045, {Key, Value, Kill, Chivalry, PkType, LeaveTime}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};

%%等级更新
handle({lv_update, Key, Lv}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{lv = Lv},
            scene_agent:dict_put_player(NewScenePlayer)
    end,
    {noreply, State};

%%性别更新
handle({sex_update, Key, Sex}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{sex = Sex},
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_130:write(13029, {ScenePlayer#scene_player.key, Sex}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};

%%烟花广播
handle({marry_fireworks, Key, X, Y}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            {ok, Bin} = pt_120:write(12057, {X, Y}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};


%%钻石vip 更新
handle({d_vip, Key, DVipType}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{dvip_type = DVipType},
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_120:write(12064, {Key, DVipType}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};

%%更新分组
handle({group_update, Key, Group, Sid}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            %%切换场景 只发给自己
            {ok, Bin} = pt_120:write(12027, {Key, Group}),
            server_send:send_to_sid(Sid, Bin),
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{group = Group},
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_120:write(12027, {Key, Group}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};

handle({hot_well_update, Key, HotWell}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            {ok, Bin} = pt_120:write(12050, {Key, HotWell#phot_well.state, HotWell#phot_well.pkey}),
            server_send:send_to_key(Key, Bin),
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{hot_well = HotWell},
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_120:write(12050, {Key, HotWell#phot_well.state, HotWell#phot_well.pkey}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};

%%传送状态保护更新
handle({transport_update, Key, IsTransport}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{is_transport = IsTransport},
            scene_agent:dict_put_player(NewScenePlayer)
    end,
    {noreply, State};

%%灵猫形象
handle({cat_figure, [Key, CatId, Attribute]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{
                attribute = Attribute,
                cat_id = CatId},
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_120:write(12052, {Key, CatId}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};

%%法身形象
handle({golden_body_figure, [Key, GoldenBodyId, Attribute]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{
                attribute = Attribute,
                golden_body_id = GoldenBodyId},
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_120:write(12055, {Key, GoldenBodyId}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};

handle({update_marry, [Key, Marry]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{marry = Marry},
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_120:write(12053, {Key, Marry#marry.marry_type, Marry#marry.couple_name, Marry#marry.couple_sex, Marry#marry.couple_key}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};

handle({update_cruise, [Key, CruiseState]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            Marry = ScenePlayer#scene_player.marry,
            NewMarry = Marry#marry{cruise_state = CruiseState},
            NewScenePlayer = ScenePlayer#scene_player{marry = NewMarry},
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_120:write(12054, {Key, CruiseState}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};

handle({marry_ring_update, Key, RingLv}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{marry_ring_lv = RingLv},
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_120:write(12056, {Key, RingLv}),
            ?DEBUG("12056 12056~n"),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};

handle({update_career, [Key, Career]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{new_career = Career},
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_120:write(12063, {Key, Career}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};


handle({update_sit, [Key, SitState, ShowGoldenBody]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{sit_state = SitState, show_golden_body = ShowGoldenBody},
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_120:write(12059, {Key, SitState, ShowGoldenBody}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};


%%更新子女坐骑
handle({baby_mount_figure, [Key, MountId, Attribute]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{
                attribute = Attribute,
                baby_mount_id = MountId},
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_120:write(12065, {Key, MountId}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};

%%更新子女武器
handle({baby_weapon_figure, [Key, WeaponId, Attribute]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{
                attribute = Attribute,
                baby_weapon_id = WeaponId},
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_120:write(12066, {Key, WeaponId}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};

handle({update_skill_effect, [Key, SkillEffect]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{skill_effect = SkillEffect},
            scene_agent:dict_put_player(NewScenePlayer)
    end,
    {noreply, State};

handle({xian_stage_update, [Key, Stage]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{xian_stage = Stage},
            scene_agent:dict_put_player(NewScenePlayer)
    end,
    {noreply, State};

handle({xian_skill_update, [Key, StageSkill, PassiveSkillList]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{xian_skill = StageSkill, passive_skill = PassiveSkillList},
            scene_agent:dict_put_player(NewScenePlayer)
    end,
    {noreply, State};

handle({field_boss_times, [Key, Times]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{field_boss_times = Times},
            scene_agent:dict_put_player(NewScenePlayer)
    end,
    {noreply, State};

handle({jiandao_stage_update, [Key, Stage]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{jiandao_stage = Stage},
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_120:write(12069, {Key, Stage}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};

handle({wear_element_list, [Key, WearElementList]}, State) ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            NewScenePlayer = ScenePlayer#scene_player{wear_element_list = WearElementList},
            scene_agent:dict_put_player(NewScenePlayer),
            {ok, Bin} = pt_120:write(12070, {Key, util:list_tuple_to_list(WearElementList)}),
            case scene:is_broadcast_scene(ScenePlayer#scene_player.scene) of
                true ->
                    scene_agent:priv_send_to_scene(ScenePlayer#scene_player.copy, Bin);
                false ->
                    scene_agent:priv_send_to_local_arena(ScenePlayer#scene_player.copy, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, Bin)
            end
    end,
    {noreply, State};

handle(_Info, State) ->
    ?ERR("scene_agent_info nomatch ~p~n", [_Info]),
    {noreply, State}.



write_scene_obj([]) -> ok;
write_scene_obj([{battle_eff, Sign, Key, SkillCd, BuffList, AttackerKey} | L]) when Sign == ?SIGN_PLAYER ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            BattleInfo = ScenePlayer#scene_player.battle_info,
            NewSkillCd = upgrade_skill_cd(SkillCd, BattleInfo#batt_info.skill_cd),
            NewBuffList = upgrade_buff_list(BuffList, BattleInfo#batt_info.buff_list),
            {LockKey, _} = ScenePlayer#scene_player.att_lock,
            AttLock = ?IF_ELSE(AttackerKey == LockKey, {0, 0}, ScenePlayer#scene_player.att_lock),
            scene_agent:dict_put_player(ScenePlayer#scene_player{att_lock = AttLock, battle_info = BattleInfo#batt_info{skill_cd = NewSkillCd, buff_list = NewBuffList}})
    end,
    write_scene_obj(L);
write_scene_obj([{battle_eff, Sign, Key, SkillCd, BuffList, AttackerKey} | L]) when Sign == ?SIGN_MON ->
    case mon_agent:dict_get_mon(Key) of
        [] ->
            skip;
        Mon ->
            NewSkillCd = upgrade_skill_cd(SkillCd, Mon#mon.skill_cd),
            NewBuffList = upgrade_buff_list(BuffList, Mon#mon.buff_list),
            {LockKey, _} = Mon#mon.att_lock,
            AttLock = ?IF_ELSE(AttackerKey == LockKey, {0, 0}, Mon#mon.att_lock),
            mon_agent:dict_put_mon(Mon#mon{att_lock = AttLock, skill_cd = NewSkillCd, buff_list = NewBuffList})
    end,
    write_scene_obj(L);
write_scene_obj([{Sign, Key, Hp, Mp, ManaLim, Mana, Sin, X, Y, IsMove, LongTime, BuffList, SkillCd, ObjRef, TimeMark, TAtt, TDef, AttackerKey} | L]) when Sign == ?SIGN_PLAYER ->
    case scene_agent:dict_get_player(Key) of
        [] ->
            skip;
        ScenePlayer ->
            LongTime2 = util:longunixtime(),
            BattleInfo = ScenePlayer#scene_player.battle_info,
            NewSkillCd = upgrade_skill_cd(SkillCd, BattleInfo#batt_info.skill_cd),
            NewBuffList = upgrade_buff_list(BuffList, BattleInfo#batt_info.buff_list),
            {LockKey, _} = ScenePlayer#scene_player.att_lock,
            AttLock = ?IF_ELSE(AttackerKey == LockKey, {0, 0}, ScenePlayer#scene_player.att_lock),
            if
                ScenePlayer#scene_player.hp > 0 andalso (ScenePlayer#scene_player.sync_time < LongTime orelse Hp =< 0) ->
                    RefHpList =
                        if Hp == 0 ->
                            [erlang:cancel_timer(Ref) || {_, Ref} <- ObjRef#obj_ref.ref_hp_list],
                            [];
                            true ->
                                ObjRef#obj_ref.ref_hp_list
                        end,
                    NewObjRef = ObjRef#obj_ref{ref_hp_list = RefHpList},
                    {NewX, NewY} = ?IF_ELSE(IsMove /= 0, {X, Y}, {ScenePlayer#scene_player.x, ScenePlayer#scene_player.y}),
                    {NewTAtt, NewTDef} = ?IF_ELSE(Hp =< 0, {0, 0}, {TAtt, TDef}),
                    scene_agent:dict_put_player(ScenePlayer#scene_player{
                        att_lock = AttLock,
                        hp = Hp,
                        mp = Mp,
                        x = NewX,
                        y = NewY,
                        mana_lim = ManaLim,
                        mana = Mana,
                        sin = Sin,
                        sync_time = LongTime2,
                        battle_info = BattleInfo#batt_info{skill_cd = NewSkillCd, buff_list = NewBuffList, obj_ref = NewObjRef, time_mark = TimeMark},
                        t_att = NewTAtt,
                        t_def = NewTDef
                    });
                true ->
                    if IsMove /= 0 ->
                        scene_agent:dict_put_player(ScenePlayer#scene_player{
                            att_lock = AttLock,
                            x = X, y = Y, hp = Hp,
                            battle_info = BattleInfo#batt_info{skill_cd = NewSkillCd, buff_list = NewBuffList},
                            sync_time = LongTime2});
                        true ->
                            scene_agent:dict_put_player(ScenePlayer#scene_player{att_lock = AttLock, battle_info = BattleInfo#batt_info{skill_cd = NewSkillCd, buff_list = NewBuffList}})
                    end
            end
    end,
    write_scene_obj(L);
write_scene_obj([{_Sign, Key, Hp, Mp, ManaLim, Mana, _Sin, X, Y, IsMove, LongTime, BuffList, SkillCd, ObjRef, TimeMark, TAtt, TDef, AttackerKey} | L]) when _Sign == ?SIGN_MON ->
    case mon_agent:dict_get_mon(Key) of
        [] ->
            skip;
        Mon ->
            LongTime2 = util:longunixtime(),
            NewSkillCd = upgrade_skill_cd(SkillCd, Mon#mon.skill_cd),
            NewBuffList = upgrade_buff_list(BuffList, Mon#mon.buff_list),
            {LockKey, _} = Mon#mon.att_lock,
            AttLock = ?IF_ELSE(AttackerKey == LockKey, {0, 0}, Mon#mon.att_lock),
            if
                Mon#mon.sync_time < LongTime orelse Hp =< 0 ->
                    RefHpList =
                        if Hp == 0 ->
                            [erlang:cancel_timer(Ref) || {_, Ref} <- ObjRef#obj_ref.ref_hp_list],
                            [];
                            true ->
                                ObjRef#obj_ref.ref_hp_list
                        end,
                    NewObjRef = ObjRef#obj_ref{ref_hp_list = RefHpList},
                    {NewX, NewY} = ?IF_ELSE(IsMove /= 0, {X, Y}, {Mon#mon.x, Mon#mon.y}),
                    {NewTAtt, NewTDef} = ?IF_ELSE(Hp =< 0, {0, 0}, {TAtt, TDef}),
                    mon_agent:dict_put_mon(Mon#mon{
                        att_lock = AttLock,
                        hp = Hp,
                        mp = Mp,
                        mana_lim = ManaLim,
                        mana = Mana,
                        x = NewX,
                        y = NewY,
                        sync_time = LongTime2,
                        obj_ref = NewObjRef,
                        time_mark = TimeMark,
                        skill_cd = NewSkillCd,
                        buff_list = NewBuffList,
                        t_att = NewTAtt,
                        t_def = NewTDef
                    });
                true ->
                    if IsMove /= 0 ->
                        mon_agent:dict_put_mon(Mon#mon{att_lock = AttLock, x = X, y = Y, hp = Hp, sync_time = LongTime2, skill_cd = NewSkillCd, buff_list = NewBuffList});
                        true ->
                            mon_agent:dict_put_mon(Mon#mon{att_lock = AttLock, x = X, y = Y, hp = Hp, skill_cd = NewSkillCd, buff_list = NewBuffList})
                    end
            end
    end,
    write_scene_obj(L);
write_scene_obj([Args | L]) ->
    ?ERR("write_scene_obj no match ~p~n", [Args]),
    write_scene_obj(L).

upgrade_skill_cd(NewSkillCd, OldSkillCd) ->

    F = fun({Sid, SidTime}, L) ->
        case lists:keytake(Sid, 1, L) of
            false -> [{Sid, SidTime} | L];
            {value, {_, OldTime}, T} ->
                [{Sid, max(OldTime, SidTime)} | T]
        end
    end,
    lists:foldl(F, OldSkillCd, NewSkillCd).

upgrade_buff_list(BuffList, OldBuffList) ->
    F = fun(Buff, L) ->
        case lists:keytake(Buff#skillbuff.buffid, #skillbuff.buffid, L) of
            false -> [Buff | L];
            {value, _Old, T} ->
                [Buff | T]
        end
    end,
    lists:foldl(F, OldBuffList, BuffList).