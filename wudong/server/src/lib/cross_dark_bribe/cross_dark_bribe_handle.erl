%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 七月 2017 11:37
%%%-------------------------------------------------------------------
-module(cross_dark_bribe_handle).
-include("common.hrl").
-include("server.hrl").
-include("cross_dark_bribe.hrl").
-include("scene.hrl").

%% API
-export([handle_call/3, handle_cast/2, handle_info/2]).


%% API
handle_call({check_enter_scene, SceneId, Lv}, _From, #cross_dark_bribe_state{scene_open_lv = LvList} = State) ->
    Ret =
        if State#cross_dark_bribe_state.open_state == 0 -> 7;
            true ->
                case lists:keyfind(SceneId, 1, LvList) of
                    {_, MinLv, _MaxLv} when MinLv =< Lv -> 1;
                    _ -> 6
                end
        end,
    {reply, Ret, State};

%%获取服务器占领值
handle_call({get_sn_t_val, Sn}, _From, State) ->
    Reply =
        case dict:is_key(Sn, State#cross_dark_bribe_state.server_dict) of
            false -> 0;
            true ->
                Server = dict:fetch(Sn, State#cross_dark_bribe_state.server_dict),
                Server#server_info.t_val
        end,
    {reply, {ok, Reply}, State};

%% 获取个人可进入的最高级场景
handle_call({get_max_enter_scene, Lv}, _From, #cross_dark_bribe_state{scene_open_lv = LvList} = State) ->
    Sids = [SceneId || {SceneId, MinLv, MaxLv} <- LvList, Lv >= MinLv, Lv =< MaxLv],
    case Sids of
        [SId | _] -> ok;
        _ ->
            SortList = lists:keysort(3, LvList),
            SId =
                case lists:reverse(SortList) of
                    [{SceneId, _MinLv1, MaxLv1} | _] when Lv > MaxLv1 ->
                        SceneId; %%兼容最大等级的玩家
                    _ ->
                        0
                end
    end,
    {reply, SId, State};


%% 领取物品奖励
handle_call({check_award_task_ids, [Sn, GetTaskIds, TaskId]}, _From, State) ->
    Ret = cross_dark_bribe:check_award_task_ids(Sn, GetTaskIds, TaskId, State),
    {reply, Ret, State};



handle_call(_Msg, _From, State) ->
    {reply, ok, State}.


%% 获取面板信息
handle_cast({get_panel_info, [Sid, Key, Sn, TaskList, GetTaskIds]}, State) ->
    NewState = cross_dark_bribe:get_panel_info(Sid, Key, TaskList, GetTaskIds, Sn, State),
    {noreply, NewState};


%% 获取全服排行
handle_cast({get_server_rank, Sid, Sn}, State) ->
    cross_dark_bribe:get_server_rank(Sid, Sn, State),
    {noreply, State};

%% 获取全服排行
handle_cast({get_person_rank, Key, Sid}, State) ->
    cross_dark_bribe:get_person_rank(Sid, Key, State),
    {noreply, State};


handle_cast({get_scene_lv, Sid}, #cross_dark_bribe_state{scene_open_lv = LvList} = State) ->
    SendLvList =
        if State#cross_dark_bribe_state.open_state == 0 -> [];
            true ->
                [[SceneId, MinLv, MaxLv] || {SceneId, MinLv, MaxLv} <- LvList]
        end,
    {ok, Bin} = pt_403:write(40304, {SendLvList}),
    server_send:send_to_sid(Sid, Bin),
    {noreply, State};


%%击杀服务器其他玩家
handle_cast({kill_other_server, _AttKey, AttSn, _DieSn, KillPid, SceneId}, #cross_dark_bribe_state{server_dict = SDict} = State) ->
    NewState =
        case dict:find(AttSn, SDict) of
            {ok, #server_info{task_list = TaskList, p_list = PList, t_val = TVal} = ServerInfo} ->
                TaskList1 = update_value(?TASK_SUB_TYPE_KILL_PLAYER, 1, TaskList),
                TaskList2 = update_value(?TASK_SUBTYPE_TAKE_VALUE, ?KILL_PLAYER_ADD_VAL, TaskList1),
                NewPList = [_AttKey | lists:delete(_AttKey, PList)],
                NewTVal = TVal + ?KILL_PLAYER_ADD_VAL,
                NewServerInfo = ServerInfo#server_info{task_list = TaskList2, p_list = NewPList, t_val = NewTVal, time = util:unixtime(), is_change = 1},
                cross_dark_bribe:refresh_buff_sn(AttSn, TVal, NewTVal, SceneId),
                ?CAST(KillPid, {cross_dark_bribe_kill_person, ?KILL_PLAYER_ADD_VAL}),
                NewDict = dict:store(AttSn, NewServerInfo, SDict),
                State#cross_dark_bribe_state{server_dict = NewDict};
            _ ->
                ?WARNING("kill_other_server == not find server ========== ~w", [AttSn]),
                State
        end,
    {noreply, NewState};


%%击杀怪物
handle_cast({kill_mon, _Key, Sn, KillPid, SceneId}, #cross_dark_bribe_state{server_dict = SDict} = State) ->
%%    ?PRINT("kill mon ======================="),
    NewState =
        case dict:find(Sn, SDict) of
            {ok, #server_info{task_list = TaskList, p_list = PList, t_val = TVal} = ServerInfo} ->
                TaskList1 = update_value(?TASK_SUB_TYPE_KILL_MON, 1, TaskList),
                TaskList2 = update_value(?TASK_SUBTYPE_TAKE_VALUE, ?KILL_MON_ADD_VAL, TaskList1),
                NewPList = [_Key | lists:delete(_Key, PList)],
                NewTVal = TVal + ?KILL_MON_ADD_VAL,
                NewServerInfo = ServerInfo#server_info{task_list = TaskList2, p_list = NewPList, t_val = NewTVal, time = util:unixtime(), is_change = 1},
                cross_dark_bribe:refresh_buff_sn(Sn, TVal, NewTVal, SceneId),
                ?CAST(KillPid, {cross_dark_bribe_kill_mon, SceneId, ?TASK_SUB_TYPE_P_KILL_MON}),
                NewDict = dict:store(Sn, NewServerInfo, SDict),
                State#cross_dark_bribe_state{server_dict = NewDict};
            _ ->
                ?WARNING("kill_mon == not find server ========== ~w", [Sn]),
                State
        end,
    {noreply, NewState};


%% 获取面板推送信息
handle_cast({get_cross_dark_scene_info, [Key, SN, Sid, TaskList, SerTList, S_Val]}, State) ->
    cross_dark_bribe:get_cross_dark_scene_info(Sid, Key, SN, TaskList, SerTList, S_Val, State),
    {noreply, State};


handle_cast(_msg, State) ->
    {noreply, State}.


%%检测是否有新服务器加入
handle_info({check_new_server, Sn, SnName, Plv}, State) ->
    case dict:is_key(Sn, State#cross_dark_bribe_state.server_dict) of
        true ->
            {noreply, State};
        false ->
            ServerInfo = cross_dark_bribe_init:init_server(Sn, SnName, Plv),
            Dict = dict:store(Sn, ServerInfo, State#cross_dark_bribe_state.server_dict),
            MaxLv = cross_dark_bribe_init:calc_max_lv(Dict),
            EnterLvList =
                if MaxLv == State#cross_dark_bribe_state.max_lv ->
                    State#cross_dark_bribe_state.scene_open_lv;
                    true ->
                        cross_dark_bribe_init:refresh_mon_attribute(MaxLv)
                end,
            {noreply, State#cross_dark_bribe_state{server_dict = Dict, sn_list = [Sn | State#cross_dark_bribe_state.sn_list], scene_open_lv = EnterLvList}}
    end;

%% gm 刷新怪物属性
handle_info(refresh_mon_attribute, #cross_dark_bribe_state{server_dict = Dict} = State) ->
    MaxLv = cross_dark_bribe_init:calc_max_lv(Dict),
    EnterLvList = cross_dark_bribe_init:refresh_mon_attribute(MaxLv),
    {noreply, State#cross_dark_bribe_state{scene_open_lv = EnterLvList}};


handle_info({reset, _NowTime}, State) ->
    misc:cancel_timer(refresh_task),
    Time = ?IF_ELSE(config:is_debug(), 30, 121),
    Ref = erlang:send_after(Time * 1000, self(), refresh_task),
    put(refresh_task, Ref),
    case config:is_center_node() of
        false ->
            ok;
        true ->
            scene_cross:send_out_cross(?SCENE_TYPE_CROSS_DARK_BLIBE),
            db:execute("truncate cross_dark_blibe"),
            cross_dark_bribe:clean_cache()
    end,
    {noreply, State#cross_dark_bribe_state{sn_list = [], server_dict = dict:new(), open_state = 0}};



handle_info(refresh_task, State) ->
    ?DEBUG("refresh_task ~n"),
    misc:cancel_timer(refresh_task),
    Sids = ets:match(?ETS_ONLINE, #ets_online{pid = '$1', _ = '_'}),
    [Pid ! refresh_task_dark || [Pid] <- Sids],
    {noreply, State#cross_dark_bribe_state{open_state = 1}};

handle_info(timer_db, State) ->
    misc:cancel_timer(timer_db),
    Ref = erlang:send_after(30 * 1000, self(), timer_db),
    put(timer_db, Ref),
    F = fun(_Sn, ServerInfo) ->
        if ServerInfo#server_info.is_change == 1 ->
            cross_dark_bribe_init:db_update(ServerInfo),
            ServerInfo#server_info{is_change = 0};
            true -> ServerInfo
        end
        end,
    Dict = dict:map(F, State#cross_dark_bribe_state.server_dict),
    {noreply, State#cross_dark_bribe_state{server_dict = Dict}};

handle_info(_msg, State) ->
    {noreply, State}.


update_value(Key, Val, List) ->
    case lists:keytake(Key, 1, List) of
        false ->
            check_update_tips(0, Val),
            [{Key, Val} | List];
        {value, {_, OldVal}, T} ->
            check_update_tips(OldVal, OldVal + Val),
            [{Key, OldVal + Val} | T]
    end.


%% @doc 显示是否要提示红圈
check_update_tips(OldVal, NewVal) ->
    IsUpdate =
        lists:any(fun(TaskId) ->
            check_update_tips2(TaskId, OldVal, NewVal)
                  end, data_cross_dark_task:type_ids(?TASK_SERVER)),
    case IsUpdate of
        true ->
            F = fun(Node) ->
                center:apply(Node, cross_dark_bribe, update_tips, [])
                end,
            lists:foreach(F, center:get_nodes());
        _ ->
            ok
    end.


%%
check_update_tips2(TaskId, OldNum, NewNum) ->
    #config_darak_bribe_task{tar = TarNum, next_id = NextId} = data_cross_dark_task:get(TaskId),
    case OldNum < TarNum andalso NewNum >= TarNum of
        true -> true;
        false ->
            if NextId =< 0 -> false;
                true ->
                    check_update_tips2(NextId, OldNum, NewNum)
            end
    end.




