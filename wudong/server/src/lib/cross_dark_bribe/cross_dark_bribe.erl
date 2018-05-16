%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. 七月 2017 10:07
%%%-------------------------------------------------------------------
-module(cross_dark_bribe).
-author("lzx").
-include("common.hrl").
-include("server.hrl").
-include("battle.hrl").
-include("scene.hrl").
-include("cross_dark_bribe.hrl").
-include("skill.hrl").
-include("task.hrl").
-include("tips.hrl").
-include("achieve.hrl").

-define(PERSON_RANK_CACHE, person_rank_cache).
-define(CROSS_DARK_CONTINE_KILL, cross_dark_contine_kill).


%% API
-export([
    init/1,
    kill_player/2,
    kill_mon/4,
    check_finish_task/4,
    check_award_task_ids/4,
    get_panel_info/6,
    get_server_rank/3,
    get_person_rank/3,
    get_cross_dark_scene_info/7,
    clean_cache/0,
    cls_get_rank/2,
    cross_dark_bribe_kill_person/2,
    cross_dark_bribe_kill_mon/3,
    get_award/2,
    get_sn_t_val/1,
    refresh_buff_enter/2,
    get_max_enter_scene/1,
    del_buff_quit/1,
    refresh_buff_sn/4,
    trigger_person_task/1,
    get_task_list/1,
    midnight_refresh/2,
    timer_update/0,
    check_get_award_state/1,
    logout/0,
    update_tips/0,
    gm_refresh_mon_attribute/0
]).


-export([do_kf_rank/1
]).

%% 玩家数据
init(Player) ->
    MidNight = util:unixdate(),
    case player_util:is_new_role(Player) of
        true ->
            lib_dict:put(?PROC_STATUS_CROSS_DARK_BRIBE, #player_info{id = Player#player.key, nick_name = Player#player.nickname, time = util:unixtime()});
        false ->
            PlayerDark = init_data(Player#player.key, Player#player.nickname, MidNight),
            lib_dict:put(?PROC_STATUS_CROSS_DARK_BRIBE, PlayerDark)
    end,
    Player.

midnight_refresh(Player, Now) ->
    DarkPlayer = lib_dict:get(?PROC_STATUS_CROSS_DARK_BRIBE),
    spawn(fun() ->
        SleepTime = util:random(10,20),
        util:sleep(SleepTime*1000),
        send_un_get_award_by_mail(DarkPlayer)
        end),
    lib_dict:put(?PROC_STATUS_CROSS_DARK_BRIBE, #player_info{id = Player#player.key, nick_name = Player#player.nickname, time = Now, is_change = 1}),
    ok.



timer_update() ->
    DarkBribe = lib_dict:get(?PROC_STATUS_CROSS_DARK_BRIBE),
    if DarkBribe#player_info.is_change == 1 ->
        update_player_dark_bribe(DarkBribe),
        lib_dict:put(?PROC_STATUS_CROSS_DARK_BRIBE, DarkBribe#player_info{is_change = 0});
        true ->
            ok
    end.

logout() ->
    DarkBribe = lib_dict:get(?PROC_STATUS_CROSS_DARK_BRIBE),
    if DarkBribe#player_info.is_change == 1 ->
        update_player_dark_bribe(DarkBribe);
        true ->
            ok
    end.

%% 通知红圈
update_tips() ->
    Sids = ets:match(?ETS_ONLINE, #ets_online{pid = '$1', _ = '_'}),
    [Pid ! refresh_darak_task_tisp || [Pid] <- Sids].


%% 检查今日是否有领取
check_un_get_task(TaskList) ->
    case not task_dark:in_finish() andalso TaskList == [] of
        true ->
            case task:get_task_by_type(?TASK_TYPE_DARK) of
                [#task{} | _] -> true;
                _ ->
                    false
            end;
        _ ->
            false
    end.

%% 检测个人任务是否有未领取的奖励
check_un_get_local(TaskList) ->
    lists:any(fun({_, TaskId, CurNum}) ->
        #config_darak_bribe_task{tar = TarNum} = data_cross_dark_task:get(TaskId),
        CurNum >= TarNum
              end, TaskList).

%% @doc 红圈检查
check_get_award_state(Player) ->
    OpenLv = data_menu_open:get(52),
    Res =
        if Player#player.lv < OpenLv -> 0;
            true ->
                DarkBribe = lib_dict:get(?PROC_STATUS_CROSS_DARK_BRIBE),
                #player_info{get_task_ids = GetTaskIds, task_list = TaskList} = DarkBribe,

                case check_un_get_task(TaskList) of
                    true -> 1;
                    _ ->
                        case check_un_get_local(TaskList) of
                            true -> 1;
                            _ ->
                                case check_un_get_kf_task(Player, GetTaskIds) of
                                    true -> 1;
                                    _ ->
                                        0
                                end
                        end
                end
        end,
    ?PRINT("State ~w", [Res]),
    Res.


check_un_get_kf_task(Player, GetTaskIds) ->
    InitList = data_cross_dark_task:type_ids(?TASK_SERVER),
    Pid = cross_dark_bribe_proc:get_server_pid(),
    Result =
        try check_server_task_award_state(InitList, Player, GetTaskIds, Pid)
        catch _:Msg -> Msg
        end,
    Result.


check_server_task_award_state([], _Player, _GetTaskList, _Pid) -> false;
check_server_task_award_state([H | T], Player, GetTaskIds, Pid) ->
    NewT =
        case lists:member(H, GetTaskIds) of
            true ->
                #config_darak_bribe_task{next_id = NextId} = data_cross_dark_task:get(H),
                case NextId /= 0 of
                    true -> lists:reverse([NextId | T]);
                    _ -> T
                end;
            _ ->
                case ?CALL(Pid, {check_award_task_ids, [Player#player.sn_cur, GetTaskIds, H]}) of
                    ok -> throw(true);
                    _ -> false
                end,
                T
        end,
    check_server_task_award_state(NewT, Player, GetTaskIds, Pid).


init_data(Pkey, Nickname, _MidNight) ->
    NowTime = util:unixtime(),
    Sql = io_lib:format("SELECT kill_p_num,kill_m_num,t_val,get_task_ids,task_list,time FROM `cross_dark_blibe_player` where player_id = ~p", [Pkey]),
    case db:get_row(Sql) of
        [KillP, KillM, Tval, GetTaskId, TaskList, GetTime] ->
            DarkInfo = #player_info{id = Pkey, nick_name = Nickname, kill_m_num = KillM,
                kill_p_num = KillP, t_val = Tval, get_task_ids = util:bitstring_to_term(GetTaskId),
                task_list = util:bitstring_to_term(TaskList), time = GetTime
            },
            case util:is_same_date(GetTime, _MidNight) of
                true -> DarkInfo;
                _ ->
                    send_un_get_award_by_mail(DarkInfo),
                    #player_info{id = Pkey, nick_name = Nickname, time = NowTime, is_change = 1}

            end;
        _R ->
            #player_info{id = Pkey, nick_name = Nickname, time = NowTime}
    end.


%% 凌晨未领取奖励发送
send_un_get_award_by_mail(#player_info{get_task_ids = GetIds, task_list = TaskList, id = Pkey}) ->
    lists:foreach(fun(TaskType) ->
        case lists:keyfind(TaskType, 1, TaskList) of
            {_, TaskId, CurNum} ->
                #config_darak_bribe_task{tar = TarNum, award_list = GoodsList} = data_cross_dark_task:get(TaskId),
                case CurNum >= TarNum andalso not lists:member(TaskId, GetIds) of
                    true ->
                        {Title, Content} = t_mail:mail_content(113),
                        mail:sys_send_mail([Pkey], Title, Content, GoodsList);
                    false ->
                        ok
                end;
            _ ->
                ok
        end
                  end,
        [?TASK_SUB_TYPE_P_KILL_MON, ?TASK_SUB_TYPE_P_KILL_PLAYER]).




kill_player(Player, #attacker{sn = Sn, key = Key, pid = Pid, sign = Sign}) ->
    put(?CROSS_DARK_CONTINE_KILL, 0), %%被杀了
    case Sign =/= ?SIGN_MON andalso Sn /= Player#player.sn_cur of
        true ->
            DarkPid = cross_dark_bribe_proc:get_server_pid(),
            ?CAST(DarkPid, {kill_other_server, Key, Sn, Player#player.sn_cur, Pid, Player#player.scene});
        _ ->
            skip
    end.


kill_mon(Mon, #attacker{sn = Sn, key = Key, pid = Pid}, _, _) ->
    case scene:is_cross_dark_blibe(Mon#mon.scene) of
        true ->
            DarkPid = cross_dark_bribe_proc:get_server_pid(),
            ?CAST(DarkPid, {kill_mon, Key, Sn, Pid, Mon#mon.scene});
        _ ->
            ok
    end.

check_finish_task(TaskType, TaskId, NowVal, TaskList) ->
    #config_darak_bribe_task{tar = MaxVal, next_id = NextId} = data_cross_dark_task:get(TaskId),
    NewTaskId = ?IF_ELSE(NowVal >= MaxVal andalso NextId /= 0, NextId, TaskId),
    lists:keyreplace(TaskType, 1, TaskList, {TaskType, NewTaskId, NowVal}).


%% 获取面板信息
get_panel_info(Sid, _Key, PlayerTaskList, GetTaskIds, Sn, #cross_dark_bribe_state{server_dict = SDict} = State) ->
    case dict:find(Sn, SDict) of
        {ok, #server_info{t_val = MyTval, task_list = ServerTaskList}} ->
            PlayerTask2 =
                if State#cross_dark_bribe_state.open_state == 0 -> [];
                    true ->
                        pack_player_task_list(GetTaskIds, PlayerTaskList)
                end,
            STaskList =
                if State#cross_dark_bribe_state.open_state == 0 -> [];
                    true ->
                        pack_server_task_list(GetTaskIds, ServerTaskList)
                end,
            SortList = lists:sublist(sort_server_info(SDict), 5),
            ServerList =
                lists:map(fun(#server_info{id = _ServerId, t_val = Tval}) ->
                    ServerName = center:get_sn_name_by_sn(_ServerId),
                    [ServerName, Tval]
                          end, SortList),
            Bid = data_cross_dark_buff:get_id(MyTval),
            ?PRINT("40301 ========= ======~w ~w ~w ~w ~w", [PlayerTask2, STaskList, 0, ServerList, MyTval]),
            {ok, Bin} = pt_403:write(40301, {PlayerTask2, STaskList, Bid, ServerList, MyTval}),
            server_send:send_to_sid(Sid, Bin),
            State;
        _ ->
            {ok, Bin} = pt_403:write(40301, {[], [], 0, [], 0}),
            server_send:send_to_sid(Sid, Bin),
            ?WARNING("find not server ~w ~w ===", [_Key, Sn]),
            State
    end.


%%服务器领取任务的数据
pack_player_task_list(GetTaskIds, TaskList) ->
%%    ?DEBUG("GetTaskIds ~p tasek ~p~n", [GetTaskIds, TaskList]),
    lists:map(
        fun({_TaskType, TaskId, CurNum}) ->
            case lists:member(TaskId, data_task_dark:task_ids()) of
                true ->
                    [TaskId, 0, 0];
                false ->
                    case lists:member(TaskId, GetTaskIds) of
                        true -> [TaskId, CurNum, 2];
                        false ->
                            #config_darak_bribe_task{tar = TarNum} = data_cross_dark_task:get(TaskId),
                            ?IF_ELSE(TarNum > CurNum, [TaskId, CurNum, 0], [TaskId, CurNum, 1])
                    end
            end
        end, TaskList).
pack_server_task_list(GetTaskIds, TaskList) ->
    F = fun(FirstTaskId) ->
        TaskId = fetch_task(FirstTaskId, GetTaskIds),
        case lists:member(TaskId, data_task_dark:task_ids()) of
            true ->
                [TaskId, 0, 0];
            false ->
                #config_darak_bribe_task{tar = TarNum, sub_type = SubType} = data_cross_dark_task:get(TaskId),
                case lists:keyfind(SubType, 1, TaskList) of
                    false -> [TaskId, 0, 0];
                    {_, CurNum} ->
                        case lists:member(TaskId, GetTaskIds) of
                            true -> [TaskId, CurNum, 2];
                            false ->

                                ?IF_ELSE(TarNum > CurNum, [TaskId, CurNum, 0], [TaskId, CurNum, 1])
                        end
                end
        end
        end,
    lists:map(F, data_cross_dark_task:type_ids(?TASK_SERVER)).

fetch_task(TaskId, GetTaskIds) ->
    case lists:member(TaskId, GetTaskIds) of
        false -> TaskId;
        true ->
            #config_darak_bribe_task{next_id = NextId} = data_cross_dark_task:get(TaskId),
            if NextId == 0 -> TaskId;
                true ->
                    fetch_task(NextId, GetTaskIds)
            end
    end.



sort_server_info(NewDict) ->
    DictList = util:dict_to_list(NewDict),
    SortList =
        lists:sort(fun(#server_info{t_val = Tval1, time = Time1}, #server_info{t_val = Tval2, time = Time2}) ->
            {Tval1, Time2} > {Tval2, Time1}
                   end, DictList),
    {RankList, _Acc} =
        lists:mapfoldl(fun(ServerInfo, RankId) ->
            {ServerInfo#server_info{rank = RankId}, RankId + 1}
                       end, 1, SortList),
    RankList.


%% 获取服务器排名
get_server_rank(Sid, Sn, #cross_dark_bribe_state{server_dict = SDict}) ->
    SortList = sort_server_info(SDict),
    SendList = [[RankId, SName, length(PList), Tval] || #server_info{rank = RankId, s_n = SName, p_list = PList, t_val = Tval} <- SortList],
    case lists:keyfind(Sn, #server_info.s_n, SortList) of
        #server_info{rank = MyRank} -> ok;
        _ ->
            MyRank = 0
    end,
    {ok, Bin} = pt_403:write(40303, {SendList, MyRank}),
    server_send:send_to_sid(Sid, Bin).


%% 获取个人排名
%% TODO 设置缓存
get_person_rank(Sid, _Key, _State) ->
    PRankList =
        case cache:get(?PERSON_RANK_CACHE) of
            [] ->
                RankList = do_kf_rank(_State#cross_dark_bribe_state.sn_list),
                cache:set(?PERSON_RANK_CACHE, RankList, 120),
                RankList;
            List -> List
        end,
    case lists:keyfind(_Key, #player_info.id, PRankList) of
        #player_info{rank = MyRank} -> ok;
        _ -> MyRank = 0
    end,
    PackRankList =
        lists:map(fun(#player_info{id = _PlayerId, rank = Rank, nick_name = NickName,
            t_val = Tval, kill_p_num = KillPNum, kill_m_num = _KillMNum, sn = Sn}) ->
            ServerName = center:get_sn_name_by_sn(Sn),
            [Rank, NickName, ServerName, KillPNum, _KillMNum, Tval]
                  end, PRankList),
    {ok, Bin} = pt_403:write(40302, {PackRankList, MyRank}),
    server_send:send_to_sid(Sid, Bin).

clean_cache() ->
    cache:erase(?PERSON_RANK_CACHE).

%% 获取服务器场景信息
get_cross_dark_scene_info(Sid, _Key, Sn, MyTaskList, SerTaskList, S_Val, #cross_dark_bribe_state{server_dict = SDict}) ->
    case dict:find(Sn, SDict) of
        {ok, #server_info{t_val = STval, task_list = TaskList}} ->
            Bid = data_cross_dark_buff:get_id(STval),
            PlayerTask2 = pack_player_task_list(SerTaskList, MyTaskList),
            STaskList = pack_server_task_list(SerTaskList, TaskList),
            {ok, Bin} = pt_403:write(40308, {PlayerTask2, STaskList, Bid, S_Val, STval}),
            server_send:send_to_sid(Sid, Bin);
        _ ->
            ?WARNING(" snlist ~p no server info in cross_dark bribe ~w", [dict:fetch_keys(SDict), Sn])
    end.


%% 获取跨服数据
do_kf_rank(SnList) ->
    MidNight = util:unixdate(),
    F = fun(Sn, AccIn) ->
        case center:get_node_by_sn(Sn) of
            false -> AccIn;
            Node ->
                try
                    case rpc:call(Node, ?MODULE, cls_get_rank, [Sn, MidNight]) of
                        [#player_info{} | _] = RankList when is_list(RankList) ->
                            RankList ++ AccIn;
                        _ -> AccIn
                    end
                catch
                    _:_ ->
                        ?WARNING("rpc get rank fail,node:~s", [Node]),
                        AccIn
                end
        end
        end,
    L = lists:foldl(F, [], SnList),
    L2 = lists:sort(fun(#player_info{t_val = Consume1, time = Time1}, #player_info{t_val = Consume2, time = Time2}) ->
        {Consume1, -Time1} >= {Consume2, -Time2}
                    end, L),
    {L3, _} = lists:mapfoldl(fun(PlayerInfo, RankId) ->
        {PlayerInfo#player_info{rank = RankId}, RankId + 1}
                             end, 1, L2),
    lists:sublist(L3, 50).



cls_get_rank(Sn, MidNight) ->
    Len = 50, %% 排名前50
    Sql1 = io_lib:format("SELECT player_id,nick_name,kill_p_num,kill_m_num,t_val,time FROM `cross_dark_blibe_player` where time > ~p and t_val>0 order by t_val desc limit ~p", [MidNight, Len]),
    L = db:get_all(Sql1),
    lists:map(fun([PlayerId, NickName, KillPNum, KillMNum, TVal, Time]) ->
        #player_info{id = PlayerId, sn = Sn, nick_name = NickName, kill_p_num = KillPNum, kill_m_num = KillMNum, t_val = TVal, time = Time}
              end, L).


%%杀了人了
cross_dark_bribe_kill_person(_Player, AddVal) ->
    Time = util:unixtime(),
    TaskType = ?TASK_SUB_TYPE_P_KILL_PLAYER,
    CrossInfo = #player_info{t_val = TVal, kill_p_num = KillPNum, task_list = TaskList} = lib_dict:get(?PROC_STATUS_CROSS_DARK_BRIBE),
    KillTotal = case get(?CROSS_DARK_CONTINE_KILL) of
                    undefined -> 0;
                    KP -> KP
                end,
    NewTotal = KillTotal + 1,
    put(?CROSS_DARK_CONTINE_KILL, NewTotal),
    case NewTotal div 10 /= KillTotal div 10 of
        true ->
            ServerName = config:get_server_name(),
            notice_sys:add_notice(cross_dark_bribe_kill_num, [ServerName, _Player#player.nickname, NewTotal]);
        _ ->
            skip
    end,
    case lists:keyfind(TaskType, 1, TaskList) of
        {_, TaskId, CurNum} ->
            #config_darak_bribe_task{tar = MaxVal} = data_cross_dark_task:get(TaskId),
            NowNum = min(CurNum + 1, MaxVal),

            NewTaskList = lists:keyreplace(TaskType, 1, TaskList, {TaskType, TaskId, NowNum}),
            NweInfo = CrossInfo#player_info{
                t_val = TVal + AddVal, kill_p_num = KillPNum + 1, task_list = NewTaskList,
                nick_name = _Player#player.nickname,
                time = Time,
                is_change = 1
            },
            lib_dict:put(?PROC_STATUS_CROSS_DARK_BRIBE, NweInfo),
            if CurNum < MaxVal andalso NowNum >= MaxVal ->
                act_hi_fan_tian:trigger_finish_api(_Player, 13, 1),
                activity:get_notice(_Player, [141], true);
                true -> ok
            end,
            ok;
        _ ->
            NweInfo = CrossInfo#player_info{t_val = TVal + AddVal, kill_p_num = KillPNum + 1, nick_name = _Player#player.nickname, time = Time, is_change = 1},
            lib_dict:put(?PROC_STATUS_CROSS_DARK_BRIBE, NweInfo),
            ok
    end,
    send_t_val_tv(NweInfo, CrossInfo),
    achieve:trigger_achieve(_Player, ?ACHIEVE_TYPE_3, ?ACHIEVE_SUBTYPE_3024, 0, 1),
    ok.


%%%% 发送连续击杀传闻
%%send_player_kill_num_tv(SerName,NickName,NewTotal) ->
%%    F = fun(Node) ->
%%        center:apply(Node, notice_sys, add_notice, [cross_dark_bribe_kill_num, [SerName, NickName, NewTotal]])
%%        end,
%%    lists:foreach(F, center:get_nodes()).


%% 发送服务器占领值
send_t_val_tv(#player_info{t_val = Tval, nick_name = NickName}, #player_info{t_val = OldTval}) ->
    ServerName = config:get_server_name(),
%%    IsSend = true,
    IsSend = if Tval >= ?SEND_TV_INIT_VAL andalso OldTval < ?SEND_TV_INIT_VAL -> true;
                 OldTval > ?SEND_TV_INIT_VAL ->
                     Div1 = (Tval - ?SEND_TV_INIT_VAL) div ?SEND_TV_INIT_ADD_VAL,
                     Div2 = (OldTval - ?SEND_TV_INIT_VAL) div ?SEND_TV_INIT_ADD_VAL,
                     Div1 /= Div2;
                 true -> false
             end,
    case IsSend of
        true ->
            notice_sys:add_notice(cross_dark_bribe_t_val, [ServerName, NickName, Tval]);
        _ ->
            ok
    end.


%%杀怪了
cross_dark_bribe_kill_mon(_Player, SceneId, AddVal) ->
    Time = util:unixtime(),
    #config_darak_bribe_scene_lv{t_ids = Tids} = data_cross_dark_scene_lv:get(SceneId),
    TaskType = ?TASK_SUB_TYPE_P_KILL_MON,
    CrossInfo = #player_info{t_val = TVal, kill_m_num = KillMNum, task_list = TaskList} = lib_dict:get(?PROC_STATUS_CROSS_DARK_BRIBE),
    case lists:keyfind(TaskType, 1, TaskList) of
        {_, TaskId, CurNum} ->
            [StarId, EndId] = Tids,
            case lists:member(TaskId, lists:seq(StarId, EndId)) of
                true ->
                    #config_darak_bribe_task{tar = MaxVal} = data_cross_dark_task:get(TaskId),
                    NowNum = min(CurNum + 1, MaxVal),
                    NewTaskList = lists:keyreplace(TaskType, 1, TaskList, {TaskType, TaskId, NowNum}),
                    NweInfo = CrossInfo#player_info{
                        t_val = TVal + AddVal, kill_m_num = KillMNum + 1, task_list = NewTaskList,
                        time = Time,
                        is_change = 1
                    },
                    lib_dict:put(?PROC_STATUS_CROSS_DARK_BRIBE, NweInfo),
                    if CurNum < MaxVal andalso NowNum >= MaxVal ->
                        act_hi_fan_tian:trigger_finish_api(_Player, 13, 1),
                        activity:get_notice(_Player, [141], true);
                        true -> ok
                    end,
                    ok;
                _ ->
                    NweInfo = CrossInfo#player_info{t_val = TVal + AddVal, kill_m_num = KillMNum + 1, time = Time, is_change = 1},
                    lib_dict:put(?PROC_STATUS_CROSS_DARK_BRIBE, NweInfo)
            end;
        _ ->
            NweInfo = CrossInfo#player_info{t_val = TVal + AddVal, kill_m_num = KillMNum + 1, time = Time, is_change = 1},
            lib_dict:put(?PROC_STATUS_CROSS_DARK_BRIBE, NweInfo)
    end,
    send_t_val_tv(NweInfo, CrossInfo),
    achieve:trigger_achieve(_Player, ?ACHIEVE_TYPE_3, ?ACHIEVE_SUBTYPE_3023, 0, 1),
    ok.


%%
update_player_dark_bribe(#player_info{id = PlayerId, t_val = TVal, kill_p_num = KillPNum,
    kill_m_num = KillMNum, nick_name = NickName, time = Time, get_task_ids = GetTaskList, task_list = TaskList}) ->
    Sql = io_lib:format("replace into cross_dark_blibe_player set player_id = ~p,nick_name = '~s',kill_p_num = ~p,kill_m_num = ~p,t_val = ~p,get_task_ids = '~s',task_list = '~s',time = ~p",
        [PlayerId, NickName, KillPNum, KillMNum, TVal, util:term_to_bitstring(GetTaskList), util:term_to_bitstring(TaskList), Time]),
    db:execute(Sql).


%% 获取能进入的最高等级场景
get_max_enter_scene(Lv) ->
    ?CALL(cross_dark_bribe_proc:get_server_pid(), {get_max_enter_scene, Lv}).


%%获取服务器占领值
get_sn_t_val(Sn) ->
    ?CALL(cross_dark_bribe_proc:get_server_pid(), {get_sn_t_val, Sn}).


%% 获取奖励
get_award(Player, TaskId) ->
    case data_cross_dark_task:get(TaskId) of
        #config_darak_bribe_task{type = Type} when Type == ?TASK_SERVER -> %%跨服任务领取
            get_kf_task_award(Player, TaskId);
        #config_darak_bribe_task{type = Type} when Type == ?TASK_PLAYER -> %%个人任务
            get_local_task_award(Player, TaskId);
        _ ->
            {13, Player}
    end.


%% 获取奖励
check_award_task_ids(SN, GetTaskIds, TaskId, #cross_dark_bribe_state{server_dict = SDict}) ->
    try
        case dict:find(SN, SDict) of
            {ok, #server_info{task_list = TaskList}} ->
                #config_darak_bribe_task{tar = TarNum, sub_type = Subtype} = data_cross_dark_task:get(TaskId),
                case lists:member(TaskId, GetTaskIds) of
                    true -> {fail, 12};
                    false ->
                        case lists:keyfind(Subtype, 1, TaskList) of
                            false -> {fail, 10};
                            {_, CurNum} ->
                                if CurNum >= TarNum -> ok;
                                    true -> {fail, 11}
                                end
                        end
                end;
            _ ->
                throw({fail, 9})
        end
    catch _:Msg -> Msg
    end.

get_kf_task_award(Player, TaskId) ->
    Pid = cross_dark_bribe_proc:get_server_pid(),
    DarkBribe = lib_dict:get(?PROC_STATUS_CROSS_DARK_BRIBE),
    #player_info{get_task_ids = GetTaskIds} = DarkBribe,
    case ?CALL(Pid, {check_award_task_ids, [Player#player.sn_cur, GetTaskIds, TaskId]}) of
        ok ->
            #config_darak_bribe_task{award_list = AwardList} = data_cross_dark_task:get(TaskId),
            GiveGoodsList = goods:make_give_goods_list(673, AwardList),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
            Res = 1,
            NewDark = DarkBribe#player_info{get_task_ids = [TaskId | GetTaskIds], is_change = 1},
            lib_dict:put(?PROC_STATUS_CROSS_DARK_BRIBE, NewDark),
            ok;
        {fail, Res} -> NewPlayer = Player;
        _R ->
            ?WARNING("40305 ================ err ~w", [_R]),
            Res = 0, NewPlayer = Player
    end,
    {Res, NewPlayer}.


%% 获取本地任务奖励 12,15,
get_local_task_award(Player, TaskId) ->
    PlayerDark = lib_dict:get(?PROC_STATUS_CROSS_DARK_BRIBE),
    #player_info{get_task_ids = GetTaskList, task_list = TaskList} = PlayerDark,
    #config_darak_bribe_task{tar = TarNum, sub_type = SubType, next_id = NextId} = data_cross_dark_task:get(TaskId),
    case lists:member(TaskId, GetTaskList) of
        true ->
            {12, Player};
        _ ->
            case lists:keyfind(TaskId, 2, TaskList) of
                {_, TaskId, CurNum} when CurNum >= TarNum ->
                    #config_darak_bribe_task{award_list = AwardList} = data_cross_dark_task:get(TaskId),
                    GiveGoodsList2 = goods:make_give_goods_list(673, AwardList),
                    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList2),
                    NextList = ?IF_ELSE(NextId /= 0, {SubType, NextId, 0}, {SubType, TaskId, CurNum}),
                    ?DO_IF(NextId == 0, achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_3, ?ACHIEVE_SUBTYPE_3025, 0, 1)),
                    NewTaskList = lists:keyreplace(SubType, 1, TaskList, NextList),
                    NewDark = PlayerDark#player_info{task_list = NewTaskList, get_task_ids = [TaskId | GetTaskList], is_change = 1},
                    lib_dict:put(?PROC_STATUS_CROSS_DARK_BRIBE, NewDark),
                    {1, NewPlayer};
                _ ->
                    {13, Player}
            end
    end.


%%进入场景获取buff
refresh_buff_enter(Player, OldScene) ->
    case scene:is_cross_dark_blibe(OldScene) of
        true -> Player;
        false ->
            case get_sn_t_val(Player#player.sn_cur) of
                {ok, T_val} ->
                    case data_cross_dark_buff:get(T_val) of
                        [] -> Player;
                        BuffList ->
                            buff:add_buff_list_to_player(Player, BuffList, 1)
                    end;
                _ -> Player
            end
    end.


%%退出场景,清除buff
del_buff_quit(Player) ->
    F = fun(SkillBuff) ->
        case data_buff:get(SkillBuff#skillbuff.buffid) of
            [] -> [SkillBuff#skillbuff.buffid];
            Buff ->
                if Buff#buff.eff_scene == [] -> [];
                    true ->
                        SceneType = scene:get_scene_type(Player#player.scene),
                        case lists:member(SceneType, Buff#buff.eff_scene) of
                            false -> [];
                            true -> [SkillBuff#skillbuff.buffid]
                        end
                end
        end
        end,
    BuffList = lists:flatmap(F, Player#player.buff_list),
    buff:del_buff_list(Player, BuffList, 1).


%%占领值变更,刷新buff
refresh_buff_sn(Sn, OldTval, NewTval, KillScene) ->
    OldBuffList = data_cross_dark_buff:get(OldTval),
    NewBuffList = data_cross_dark_buff:get(NewTval),
    case NewBuffList == OldBuffList of
        true -> ok;
        false ->
            SerName = center:get_sn_name_by_sn(Sn),
            notice_sys:add_notice(cross_dark_bribe_buff, [SerName, NewTval, KillScene]),
            F = fun(SceneId) ->
                L = scene_agent:get_scene_player(SceneId),
                [server_send:send_node_pid(ScenePlayer#scene_player.node, ScenePlayer#scene_player.pid, {refresh_dark_buff, OldBuffList, NewBuffList})
                    || ScenePlayer <- L, ScenePlayer#scene_player.sn_cur == Sn]
                end,
            lists:foreach(F, data_cross_dark_scene_lv:ids())
    end.


%% 触发领取个人任务
trigger_person_task(#player{scene = SceneId} = Player) ->
    case data_cross_dark_scene_lv:get(SceneId) of
        #config_darak_bribe_scene_lv{t_ids = Tids} ->
            PlayerDark = lib_dict:get(?PROC_STATUS_CROSS_DARK_BRIBE),
            InitTask = lists:map(fun(Id) ->
                #config_darak_bribe_task{sub_type = SubType} = data_cross_dark_task:get(Id),
                {SubType, Id, 0}
                                 end, Tids),
            NewPlayerDark = PlayerDark#player_info{task_list = InitTask, is_change = 1},
%%            update_player_dark_bribe(NewPlayerDark),
            lib_dict:put(?PROC_STATUS_CROSS_DARK_BRIBE, NewPlayerDark),
            activity:get_notice(Player, [141], true);
        _ ->
            ?WARNING("not trigger_person_task player_id:~w in scene:~w", [Player#player.key, SceneId]),
            skip
    end.


%% 今日任务
get_task_list(TaskLit) ->
    case TaskLit of %%任务为空
        [] ->
            case task_dark:in_finish() of
                false ->
                    case task:get_task_by_type(?TASK_TYPE_DARK) of
                        [#task{taskid = TaskId} | _] ->
                            [{1, TaskId, 0}];
                        _ ->
                            TaskLit
                    end;
                _ ->
                    TaskLit
            end;
        _ ->
            TaskLit
    end.


%% gm 刷新
gm_refresh_mon_attribute() ->
    Pid = cross_dark_bribe_proc:get_server_pid(),
    Pid ! refresh_mon_attribute.




