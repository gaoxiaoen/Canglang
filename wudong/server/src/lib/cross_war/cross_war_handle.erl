%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. 八月 2017 11:19
%%%-------------------------------------------------------------------
-module(cross_war_handle).
-author("li").
-include("common.hrl").
-include("server.hrl").
-include("cross_war.hrl").
-include("scene.hrl").

%% API
-export([
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    gm/0
]).

gm() ->
    cross_war_proc:get_server_pid() ! close.

handle_call(get_door_list, _From, State) ->
    {reply, State#sys_cross_war.kill_king_door_list, State};

handle_call(get_main_key, _From, State) ->
    #sys_cross_war{
        king_info = KingInfo,
        last_king_info = LastKingInfo
    } = State,
    #cross_war_king{g_key = KingGkey, pkey = KingPkey} = KingInfo,
    #cross_war_king{g_key = LastKingGkey, pkey = LastKingPkey} = LastKingInfo,
    L1 =
        case cross_war_util:get_by_g_key(KingGkey) of
            #cross_war_guild{sign = Sign} -> [{KingPkey, Sign}];
            _ -> []
        end,
    L2 =
        case cross_war_util:get_by_g_key(LastKingGkey) of
            #cross_war_guild{sign = LastKingSign} ->
                if
                    KingGkey == LastKingGkey -> [];
                    true ->
                        [{LastKingPkey, LastKingSign}]
                end;
            _ -> []
        end,
    {reply, L1 ++ L2, State};

handle_call(get_acc_win, _From, State) ->
    {reply, State#sys_cross_war.king_info#cross_war_king.acc_win, State};

handle_call(get_king_pkey_gkey, _From, State) ->
    {reply, {State#sys_cross_war.king_info#cross_war_king.pkey, State#sys_cross_war.king_info#cross_war_king.g_key}, State};

handle_call(get_king_guild_key, _From, State) ->
    {reply, State#sys_cross_war.king_info#cross_war_king.g_key, State};

handle_call(get_king_pkey, _From, State) ->
    {reply, State#sys_cross_war.king_info#cross_war_king.pkey, State};

handle_call(get_all_guild_key_list, _From, State) ->
    List = cross_war:get_cross_war_guild_call(State),
    {reply, List, State};

handle_call({get_revice_center_call, Player}, _From, State) ->
    {X, Y} = cross_war:get_revice_center_call(State, Player),
    {reply, {X, Y}, State};

handle_call(get_act_open_state, _From, State) ->
    {reply, State#sys_cross_war.open_state, State};

handle_call(get_act_open_state_and_time, _From, State) ->
    {reply, {State#sys_cross_war.open_state, State#sys_cross_war.time}, State};

handle_call(_msg, _From, State) ->
    ?DEBUG("udef call msg ~p~n", [_msg]),
    {reply, ok, State}.

handle_cast({get_act_43099_actid_143, Node, Sid}, State) ->
    spawn(fun() -> timer:sleep(2000), cross_war:get_act_43099_actid_143_cast(State, Node, Sid) end),
    {noreply, State};

handle_cast({get_act_43099_actid_149, Key, StGuild, Node, Sid, IsRecvReward, IsMemberReward}, State) ->
    spawn(fun() -> timer:sleep(2000), cross_war:get_act_43099_actid_149_cast(State, Key, StGuild, Node, Sid, IsRecvReward, IsMemberReward) end),
    {noreply, State};

handle_cast({gm_center_king, Player}, State) ->
    NewState = cross_war_gm:gm_center_king_cast(State, Player),
    {noreply, NewState};

handle_cast({get_act_state, Node, GuildKey, Pkey, Sid, IsRecvMember, IsRecvKing, IsOrz}, State) ->
    cross_war:get_act_state_cast(State, Node, GuildKey, Pkey, Sid, IsRecvMember, IsRecvKing, IsOrz),
    {noreply, State};

handle_cast({get_act_info, Player, PlayerCouple, GuildMainShadow, GuildMainCoupleShadow, PlayerCon}, State) ->
    cross_war:get_act_info_cast(State, Player),
    cross_war:update_war_cast(State, Player, PlayerCouple, GuildMainShadow, GuildMainCoupleShadow, PlayerCon),
    {noreply, State};

handle_cast({get_guild_contrib_rank, GuildKey, Node, Sid, Type}, State) ->
    cross_war_rank:get_guild_contrib_rank_cast(GuildKey, Node, Sid, Type),
    {noreply, State};

handle_cast({get_member_contrib_rank, PKey, Node, Sid, Type}, State) ->
    cross_war_rank:get_member_contrib_rank_cast(PKey, Node, Sid, Type),
    {noreply, State};


handle_cast({get_guild_score_rank, Gkey, Node, Sid, Type}, State) ->
    cross_war_rank:get_guild_score_rank_cast(State, Gkey, Node, Sid, Type),
    {noreply, State};

handle_cast({get_member_score_rank, Pkey, Node, Sid, Type}, State) ->
    cross_war_rank:get_member_score_rank_cast(State, Pkey, Node, Sid, Type),
    {noreply, State};

handle_cast({get_cross_war_info,Player}, State) ->
    cross_war:get_cross_war_info_cast(State, Player),
    {noreply, State};

handle_cast({enter_cross_war, Player, PlayerCouple}, State) ->
    case cross_war:enter_cross_war_cast(State, Player) of
        {fail, NewState} ->
            {noreply, NewState};
        {true, NewState} ->
            cross_war:update_war_cast(Player, PlayerCouple),
            cross_war:get_now_war_info_cast(NewState, Player#player.node, Player#player.key, Player#player.sid),
            {noreply, NewState}
    end;

handle_cast({update_couple_info, Player, PlayerCouple}, State) ->
    case cross_war_util:get_by_pkey(Player#player.key) of
        [] ->
            skip;
        _ ->
            case cross_war_util:get_by_g_key(Player#player.guild#st_guild.guild_key) of
                [] -> skip;
                _ ->
                    cross_war:update_war_cast(Player, PlayerCouple)
            end
    end,
    {noreply, State};

handle_cast({change_sign, Player, Type}, State) ->
    cross_war:change_sign_cast(State, Player, Type),
    {noreply, State};

handle_cast({get_now_war_info, Node, Pkey, Sid}, State) ->
    cross_war:get_now_war_info_cast(State, Node, Pkey, Sid),
    {noreply, State};

handle_cast({kill_mon, Mon, Attacker, Klist}, State) ->
    NewState = cross_war_battle:kill_mon_cast(State,  Mon, Attacker, Klist),
    {noreply, NewState};

handle_cast({kill_player, Player, Attacker}, State) ->
    NewState = cross_war_battle:kill_player_cast(State, Player, Attacker),
    {noreply, NewState};

handle_cast({collect, Pkey}, State) ->
    NewState = cross_war_battle:collect_cast(State, Pkey),
    {noreply, NewState};

handle_cast({create_crown, X, Y}, State) ->
    {MonKey, MonPid} = mon_agent:create_mon([?CROSS_WAR_MON_ID_KING_GOLD, ?SCENE_ID_CROSS_WAR, X, Y, 0, 1, [{return_id_pid, true}]]),
    self() ! update_score_data,
    NewMap = cross_war_map:update_king_gold(State#sys_cross_war.map, X, Y, 0),
    {noreply, State#sys_cross_war{king_gold = {0,0}, map = NewMap, mon_list = [{MonKey, MonPid, #mon{}} | State#sys_cross_war.mon_list]}};

handle_cast({get_now_king_x_y, XX, YY, Node, Sid}, State) ->
    spawn(fun() -> cross_war:get_now_king_x_y_cast(State, XX, YY, Node, Sid) end),
    {noreply, State};

handle_cast({put_down_king_gold, Player}, State) ->
    NewState = cross_war:put_down_king_gold_cast(State, Player),
    {noreply, NewState};

handle_cast({update_cross_mon_hp, Mon}, State) ->
    NewState = cross_war:update_cross_mon_hp_cast(State, Mon),
    {noreply, NewState};

handle_cast(repair_king, State) ->
    NewState = cross_war_repair:repair_king_center_cast(State),
    {noreply, NewState};

handle_cast(gm_update_king, State) ->
    spawn(fun() -> timer:sleep(4000), cross_war_repair:update_king(State) end),
    {noreply, State};

handle_cast({get_war_map, Node, Sid}, State) ->
    spawn(fun() -> cross_war_map:get_war_map_cast(State, Node, Sid) end),
    {noreply, State};

handle_cast(_msg, State) ->
    ?DEBUG("udef cast msg ~p~n", [_msg]),
    {noreply, State}.

%%准备
handle_info({ready, ReadyTime, LastTime}, State)  ->
    ?DEBUG("cross war ready ~p~n", [ReadyTime]),
    util:cancel_ref([State#sys_cross_war.ref]),
    Now = util:unixtime(),
    Ref = erlang:send_after(ReadyTime * 1000, self(), {start, LastTime}),
    NewState = State#sys_cross_war{open_state = ?CROSS_WAR_STATE_READY, time = Now + ReadyTime, ref = Ref},
    spawn(fun() -> cross_war_util:sys_notice(cross_war_ready) end),
    spawn(fun() -> timer:sleep(1000), cross_war_util:sys_notice_43099() end),
    spawn(fun() -> timer:sleep(5000), cross_war_init:init_mon_lv() end),
    {noreply, NewState};

%%开始
handle_info({start, LastTime}, OldState) when OldState#sys_cross_war.open_state /= ?CROSS_WAR_STATE_START ->
    State = %% 做数据清除
        OldState#sys_cross_war{
            mon_list = [],
            king_gold = {0, 0},
            win_sign = 0, %% 上局赢方
            kill_war_door_list = [], %% 攻破城门玩家 [#cross_war_log{}] 入库
            kill_king_door_list = [], %% 攻破王城门玩家 [#cross_war_log{}] 入库
            kill_banner_time = 0, %% 攻破旗帜时间
            kill_banner_sign = 0, %% 攻破旗帜方
            def_guild_list = [], %% 防御方公会列表 [#cross_war_guild{}]
            att_guild_list = [], %% 攻击方公会列表 [#cross_war_guild{}]
            def_player_list = [], %% 防御方玩家列表 [Pkey]
            att_player_list = [], %% 攻击方玩家列表 [Pkey]
            collect_num = 0
        },
    util:cancel_ref([State#sys_cross_war.ref]),
    Ref = erlang:send_after(LastTime * 1000, self(), close),
    MonList = cross_war_init:init_mon(),
    NewState = cross_war:get_guild_data(State),
    NewSysWarMap = cross_war_map:init_map(#cross_war_map{}, MonList),
    spawn(fun() -> cross_war:notice_all_client(NewState) end),
    spawn(fun() -> cross_war_util:sys_notice(cross_war_start) end),
    spawn(fun() -> cross_war:sys_back_center(NewState) end),
    spawn(fun() -> timer:sleep(1000), cross_war_util:sys_notice_43099() end),
    {noreply, NewState#sys_cross_war{open_state = ?CROSS_WAR_STATE_START, ref = Ref, map = NewSysWarMap, mon_list = MonList, time = util:unixtime()+LastTime}};

%%关闭
handle_info(close, State) ->
    ?DEBUG("#########close", []),
    util:cancel_ref([State#sys_cross_war.ref]),
    erlang:send_after(6000, self(), clean),
    spawn(fun() -> timer:sleep(30000), cross_war:notice_client_quit() end),
    NewState = cross_war:sys_end_cacl(State), %% 结算奖励
    spawn(fun() -> cross_war:to_client_result(NewState) end),
    spawn(fun() -> cross_war:to_client_reward(NewState) end),
    spawn(fun() -> timer:sleep(1000), cross_war_util:sys_notice_43099() end),
    spawn(fun() -> timer:sleep(4000), cross_war_repair:update_king(NewState) end),
    {noreply, NewState#sys_cross_war{open_state = ?CROSS_WAR_STATE_CLOSE, time = 0}};

%%每日晚上重新定制时间规则
handle_info(sys_midnight_refresh, State) ->
    ?DEBUG("##########sys_midnight_refresh", []),
    util:cancel_ref([State#sys_cross_war.ref]),
    %%%%%%%%%%%%%%明天处理数据重置问题
    NState = cross_war:sys_midnight_refresh_cast(State),
    NewState = cross_war_proc:set_timer(NState, util:unixtime()),
    {noreply, NewState};

handle_info(gm_sys_midnight_refresh, State) ->
    ?DEBUG("gm_sys_midnight_refresh", []),
    util:cancel_ref([State#sys_cross_war.ref]),
    NState = cross_war_gm:gm_sys_midnight_refresh_cast(State),
    NewState = cross_war_proc:set_timer(NState, util:unixtime()),
    {noreply, NewState};

handle_info(gm_ready_center, State) ->
    ?DEBUG("gm_ready_center", []),
    Now = util:unixtime(),
    Ref = erlang:send_after(?CROSS_WAR_READY_TIME * 1000, self(), {start, ?ONE_HOUR_SECONDS div 2}),
    NewState = State#sys_cross_war{open_state = ?CROSS_WAR_STATE_READY, time = Now + ?CROSS_WAR_READY_TIME, ref = Ref},
    spawn(fun() -> cross_war_util:sys_notice(cross_war_ready) end),
    spawn(fun() -> timer:sleep(1000), cross_war_util:sys_notice_43099() end),
    spawn(fun() -> timer:sleep(5000), cross_war_init:init_mon_lv() end),
    {noreply, NewState};

handle_info(gm_start, State) when State#sys_cross_war.open_state /= ?CROSS_WAR_STATE_START ->
    ?DEBUG("cross_war gm_start", []),
    util:cancel_ref([State#sys_cross_war.ref]),
    Ref = erlang:send_after(1500, self(), {start, 1800}),
    NewState = State#sys_cross_war{open_state = ?CROSS_WAR_STATE_READY, ref = Ref, time = util:unixtime() + 1800},
    spawn(fun() -> timer:sleep(1000), cross_war_util:sys_notice_43099() end),
    spawn(fun() -> timer:sleep(50), cross_war_init:init_mon_lv() end),
    {noreply, NewState};

%%清除数据--譬如踢人
handle_info(clean, State) ->
%%     scene_agent:clean_scene_area(?SCENE_ID_CROSS_WAR, 0),
    BossPidList = State#sys_cross_war.mon_list,
    F = fun({_Key, MonPid, _Mon}) ->
        case misc:is_process_alive(MonPid) of
            true -> %% 关闭当前还存活的怪物进程
                monster:stop_broadcast(MonPid);
            false ->
                skip
        end
    end,
    lists:map(F, BossPidList),
    NewState =
        State#sys_cross_war{
            mon_list = []
        },
    {noreply, NewState};

%%更新积分数据操作
handle_info(update_score_data, State) ->
    util:cancel_ref([State#sys_cross_war.update_score_ref]),
    UpdateScoreRef = erlang:send_after(?CROSS_WAR_UPDATE_SCORE*1000, self(), update_score_data),
    NewMap = cross_war_map:update_king_gold_x_y(State#sys_cross_war.map),
    NewState = State#sys_cross_war{map = NewMap},
    spawn(fun() -> cross_war:notice_client_update_score(NewState) end),
    {noreply, NewState#sys_cross_war{update_score_ref = UpdateScoreRef}};

%%清除数据操作
handle_info(clean_node_data, State) ->
    util:cancel_ref([State#sys_cross_war.clean_ref]),
    cross_war_util:clean_node_data(),
    CleanRef = erlang:send_after(?CROSS_WAR_CLEAN_TIME*1000, self(), clean_node_data),
    {noreply, State#sys_cross_war{clean_ref = CleanRef}};

handle_info(add_exp_data, State) ->
    util:cancel_ref([State#sys_cross_war.add_exp_ref]),
    if
        State#sys_cross_war.open_state == ?CROSS_WAR_STATE_START ->
            spawn(fun() -> cross_war_util:add_exp_data(State) end);
        true ->
            skip
    end,
    AddExpRef = erlang:send_after(?CROSS_WAR_ADDEXP_TIME*1000, self(), add_exp_data),
    {noreply, State#sys_cross_war{add_exp_ref = AddExpRef}};

handle_info(_msg, State) ->
    ?DEBUG("udef info msg ~p~n", [_msg]),
    {noreply, State}.


