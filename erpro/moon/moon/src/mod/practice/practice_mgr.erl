%% --------------------------------------------------------------------
%% 试练管理进程
%% @author abu
%%          wpf(wprehard@qq.com 2012/11/15)
%% @end
%% --------------------------------------------------------------------
-module(practice_mgr).
-behaviour(gen_fsm).

%% export functions
-export([
        start_link/0
        ,start_practice/0
        ,stop_practice/0
        ,settle/0
        ,get_hall/0
        ,start_combat/2
        ,center_combat_over_result/4
        ,combat_info/1
        ,get_status/1
        ,get_champion/0
        ,get_last_rank/2
        ,get_acc_reward/2
        ,get_enter_count/1
        ,check_enter_count/2
        ,get_map/0
        ,role_enter/1
        ,update_map_role/2
        ,add_maps/1
        ,leave_combat/2
        ,is_wave_over_point/1
        ,next_wave/4
    ]).

%% debug functions
-export([debug/1]).

%% gen_fsm callbacks
-export([init/1, handle_event/3,handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).

%% state functions
-export([state_idel/2, state_start/2, state_stop/2]).

%% test functions
-export([do_save/2, do_load/0]).

%% macro
-define(practice_start_time, {16, 30, 0}).
-define(practice_notice_time, {16, 15, 0}).
-define(reward_mail_title, ?L(<<"无尽试练奖励结算">>)).
-define(reward_mail_content, ?L(<<"~s\n获得了：~w经验，~w绑定金币。">>)).
%% 活动时间
-ifdef(debug).
-define(campaign_start_time, util:datetime_to_seconds({{2013, 2, 21}, {8, 0, 0}})).
-define(campaign_end_time, util:datetime_to_seconds({{2013, 4, 8}, {23, 59, 59}})).
-else.
-define(campaign_start_time, util:datetime_to_seconds({{2013, 4, 3},{0,0,0}})).
-define(campaign_end_time, util:datetime_to_seconds({{2013, 4, 7},{23,59,59}})).
-endif.
%% 试炼时间已取消，现全天开放
-define(time_interval_start, 1800).
-define(time_interval_stop, 5400).
-define(time_interval_idel, 1).

%% include
-include("common.hrl").
-include("practice.hrl").
-include("combat.hrl").
-include("pos.hrl").
-include("hall.hrl").
-include("role.hrl").
-include("mail.hrl").

%% --------------------------------------------------------------------
%% API functions
%% --------------------------------------------------------------------

%% @spec role_enter(Role) -> {ok, NewRole} | {false, Msg}
%% @doc 玩家进入无尽试炼跨服准备地图
role_enter(Role = #role{cross_srv_id = <<"center">>, pos = #pos{map_base_id = 36002}}) ->
    %% 已经在跨服准备区
    case center:call(practice_mgr, get_hall, []) of
        {ok, HallId} ->
            hall:enter(HallId, Role);
        {false, Msg} ->
            {false, Msg};
        _ -> {false, ?L(<<"网络不稳定，无法进入跨服无尽试炼大厅">>)}
    end;
role_enter(#role{cross_srv_id = <<"center">>}) ->
    {false, ?L(<<"您的状态异常，暂时无法参加无尽试炼">>)};
role_enter(Role) ->
    case center:call(practice_mgr, get_hall, []) of
        {ok, HallId} ->
            case center:call(practice_mgr, get_map, []) of
                {ok, MapId} ->
                    {Xx, Yy} = util:rand_list([{1140, 1050}, {1140, 1410}, {1800, 990}, {1800, 1410}, {1500, 1230}]),
                    {X, Y} = {Xx + util:rand(-200, 200), Yy + util:rand(-200, 200)},
                    case map:role_enter(MapId, X, Y, Role#role{cross_srv_id = <<"center">>}) of
                        {ok, NewRole} ->
                            center:cast(practice_mgr, update_map_role, [add, MapId]),
                            case hall:enter(HallId, NewRole) of
                                {ok, NewRole1} -> {ok, NewRole1};
                                _ -> {ok, NewRole}
                            end;
                        {false, Reason} ->
                            {false, Reason}
                    end;
                {false, Msg} -> {false, Msg};
                _E ->
                    ?DEBUG("_E:~w", [_E]),
                    {false, ?L(<<"无尽试炼准备区地图创建中，请稍后再参加">>)}
            end;
        {false, Msg} ->
            {false, Msg};
        _ -> {false, local}
    end.

%% @spec update_map_role(Type, MapId) -> any()
%%% Type = add | delete
%% 更新准备区人数
update_map_role(Type, MapId) ->
    info({update_map_role, Type, MapId}).

%% @spec add_maps(N) -> any()
%% N = integer()
%% 增加准备区
add_maps(N) ->
    info({add_maps, N}).

%% @spec check_enter_count(Type, Data) -> ok | {ok, PidList} | {false, Msg}
%% Type = self | all
%% Data = RolePractice | RoleIdList::list()
%% @doc 检查进入次数
check_enter_count(self, RolePractice) ->
    case do_get_count(RolePractice) of
        C when C >= ?practice_count ->
            {false, ?L(<<"您的次数已满，无法发起试练">>)};
        _ ->
            ok
    end;
check_enter_count(all, RoleIds) when is_list(RoleIds) ->
    do_check_enter_count(RoleIds, []).
do_check_enter_count([], Back) ->
    {ok, Back};
do_check_enter_count([H | T], Back) ->
    case role_api:c_lookup(by_id, H, [#role.practice, #role.pid, #role.name]) of
        {ok, _, [Rprac, Rpid, Name]} ->
            case do_get_count(Rprac) of
                C when C >= ?practice_count ->
                    {false, util:fbin(?L(<<"~s的次数已满，无法发起试练">>), [Name])};
                _ ->
                    do_check_enter_count(T, [Rpid | Back])
            end;
        _ ->
            {false, ?L(<<"无法发起试练">>)}
    end.

%% @spec start_link() -> {ok,Pid} | ignore | {error,Error}
%% Starts the server
start_link() ->
    gen_fsm:start_link({local, ?MODULE}, ?MODULE, [], []).

%% start_practice()
%% 开启试练
start_practice() ->
    info_state({start}).

%% start_combat(RoomNo, Rids)
%% RoomNo = integer()
%% Rids = [rid(), ...]
%% 试练开打
start_combat(RoomNo, Rids) ->
    info_state({start_combat, RoomNo, Rids}).

%% @spec center_combat_over_result(PracticeRole, Score, Maxround, PracticeRoles) -> any()
%% 通知节点服战斗结束
center_combat_over_result(PracticeRole, Score, Maxround, PracticeRoles) ->
    info_state({center_combat_over_result, PracticeRole, Score, Maxround, PracticeRoles}).

%% stop_practice()
%% 关闭试练
stop_practice() ->
    info_state({stop}).

%% @spec settle()
%% 结算
settle() ->
    info_state({settle}).

%% get_hall() -> {ok, HallId} | {false, Reason}
%% 进入试练大厅
get_hall() ->
    case call({get_hall}) of
        {ok, Hid, _Hpid} ->
            {ok, Hid};
        {false, Reason} ->
            {false, Reason};
        _ ->
            {false, ?L(<<"试练还没有开启">>)}
    end.

%% combat_info(Msg) ->
%% Msg = term()
%% 战斗消息
combat_info(Msg) ->
    ?MODULE ! Msg.

%% @spec get_status(Pid) 
%% Pid = pid()
%% 获取试练当前状态
get_status(Rpid) ->
    info({get_status, Rpid}).

%% @spec get_champion()
%% 获取冠军队伍
get_champion() ->
    call({get_champion}).

%% @spec get_last_rank(PageSize, PageNo) ->
%% PageSize = PageNo = integer()
%% 获取排名
get_last_rank(PageSize, PageNo) when PageSize > 0 andalso PageNo >= 0 ->
    call({get_last_rank, PageSize, PageNo});
get_last_rank(_, _) ->
    {false, <<>>}.

%% @spec get_acc_reward(Lev, KilledNpcId) -> {Exp, BindCoin}
%% Lev = Exp = BindCoin = integer()
%% KilledNpcId = [integer(), ...]
%% 获取累积奖励
get_acc_reward(Lev, KilledNpcId) ->
    Score = do_calc_score(KilledNpcId),
    Exp = do_reward_exp(Score, Lev),
    BindCoin = do_reward_bindcoin(Score),
    {Exp, BindCoin}.

%% @spec get_enter_count(#role{}) -> integer()
%% 已试练的次数
get_enter_count(#role{practice = RolePrac}) ->
    do_get_count(RolePrac).

%% @spec get_map() -> {ok, MapId::integer()} | ...
%% 获取无尽试炼准备区地图
get_map() ->
    call(get_map).

%% @spec leave_combat(Rid, CombatPid)
%% Rid = rid()
%% CombatPid = pid()
%% 退出试练战斗
leave_combat(Rid, CombatPid) ->
    case node(CombatPid) =:= node() of
        true ->
            info({leave_combat, Rid, CombatPid});
        false ->
            center:cast(practice_mgr, leave_combat, [Rid, CombatPid])
    end.

%% 打印高度信息
debug(Type) ->
    info({debug, Type}).

%% @spec is_wave_over_point(integer()) -> fasle | true 
%% 是不是需要检测跳跃的波数
is_wave_over_point(WaveNo) -> lists:member(WaveNo, [3, 6, 9, 12, 15, 18, 21, 24]).

%% @spec next_wave(BegRound, Round, WaveNo, NpcBaseIds) -> {Newwaveno, Newnpcbaseids, OveredNpcIds}
%% 计算跳跃下一波怪物
next_wave(BegRound, Round, WaveNo, [NpcBaseId|T]) ->
    Diff = Round - BegRound,
    {NextWave, MaxDiff} = over_wave_diff(WaveNo - 1),
    case Diff =< MaxDiff of
        true ->
            case calc_over_wave(WaveNo, NextWave, [NpcBaseId|T], []) of
                {0, [], []} ->
                    {WaveNo, [NpcBaseId|T], []};
                {NewWaveNo, NewNpcBaseIds, OveredNpcIds} ->
                    {NewWaveNo, NewNpcBaseIds, OveredNpcIds}
            end;
        false ->
            {WaveNo, [NpcBaseId|T], []}
    end;
next_wave(_BegRound, _Round, WaveNo, NpcBaseIds) ->
    {WaveNo, NpcBaseIds, []}.

%% --------------------------------------------------------------------
%% API functions
%% --------------------------------------------------------------------


%% --------------------------------------------------------------------
%% gen_fsm callback functions
%% --------------------------------------------------------------------

%% Func: init/1
%% Returns: {ok, StateName, StateData}          |
%%          {ok, StateName, StateData, Timeout} |
%%          ignore                              |
%%          {stop, StopReason}
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    process_flag(trap_exit, true),
    ?INFO("[~w] 启动完成", [?MODULE]),
    %% {LastCham, LastRanks} = do_load(),
    %% do_prepare_notice(),
    %% {ok, state_idel, #practice{state_change_time = util:unixtime(), time_interval = get_next_practice_time(), last_champion = LastCham, last_ranks = LastRanks}, get_next_practice_time() * 1000}.
    {ok, state_idel, #practice{state_change_time = util:unixtime(), time_interval = get_next_practice_time()}, get_next_practice_time() * 1000}.

%% Func: StateName/2
%% Returns: {next_state, NextStateName, NextStateData}          |
%%          {next_state, NextStateName, NextStateData, Timeout} |
%%          {stop, Reason, NewStateData}

%% 空闲状态
state_idel(timeout, State) ->
    do_start(State);
state_idel({start}, State) ->
    do_start(State);
state_idel(_Event, State) ->
    ?INFO("~w 状态下收到消息 ~w", [state_idel, _Event]),
    continue(state_idel, State).

%% 进行中的状态
%% 开始战斗
state_start({start_combat, RoomNo, Hroles = [#hall_role{id = Lrid} | _]}, State = #practice{combats = Combats, hall_id = HallId}) ->
    case check_enter_count(all, [Rid || #hall_role{id = Rid} <- Hroles]) of
        {ok, Pids} ->
            add_enter_count(Pids),
            Wave = get_practice_wave(Hroles),
            AtkList = to_fighter(Hroles),
            CombatRoles = lists:map(fun to_practice_role/1, Hroles),
            NewCombats = case combat:start(?combat_type_practice, self(), AtkList, practice_data:all(), [{start_wave_no, Wave}, {room_master, Lrid}]) of
                {ok, CombatPid} ->
                    Pcombat = #practice_combat{combat_pid = CombatPid, roles = CombatRoles, room_no = RoomNo},
                    [Pcombat | Combats];
                _ ->
                    ?ERR("发起战斗失败: ~w", [Hroles]),
                    hall:room_end_combat(HallId, RoomNo),
                    Combats
            end,
            continue(state_start, State#practice{combats = NewCombats});
        {false, Reason} ->
            hall:room_end_combat(HallId, RoomNo),
            send_role_combat_notice([Rpid || #hall_role{pid = Rpid} <- Hroles, is_pid(Rpid)], Reason),
            continue(state_start, State)
    end;

%% 中央服传回的节点服处理(奖励、成就等)
state_start({center_combat_over_result, PracticeRole = #practice_role{id = RoleId}, Score, MaxRound, PracticeRoles}, State) ->
    trigger_celebrity(PracticeRoles, MaxRound),
    campaign_listener:handle(practice, [PracticeRole], MaxRound),  %% 后台活动
    campaign_task:listener(RoleId, practice, 1),
    spawn(fun() -> reward(Score, MaxRound, [PracticeRole]) end),
    continue(state_start, State);
state_start({center_combat_over_result, _, _Score, _MaxRound}, State) ->
    continue(state_start, State);

%% 结束试练
state_start({stop}, State) ->
    NewState = do_stop(State),
    continue(state_stop, NewState);
state_start(timeout, State) ->
    ?DEBUG("timeout state_start"),
    NewState = do_stop(State),
    continue(state_stop, NewState);
state_start(_Event, State) ->
    ?INFO("~w 状态下收到消息 ~w", [state_start, _Event]),
    continue(state_start, State).

%% 结束状态
state_stop(timeout, State = #practice{ranks = Ranks, combats = Combats}) ->
    ?INFO("试练结算"),
    [CombatPid ! stop || #practice_combat{combat_pid = CombatPid} <- Combats, is_pid(CombatPid)],
    NewRanks = mark_rank(Ranks),
    Champion = case NewRanks of
        [H | _] ->
            do_handle_champion(H);
        _ ->
            false
    end,
    do_save(Champion, NewRanks),
    NewState = State#practice{combats = [], ranks = [], last_ranks = NewRanks, last_champion = Champion},
    continue(state_idel, NewState#practice{hall_id = 0, hall_pid = 0, state_change_time = util:unixtime(), time_interval = get_next_practice_time()});

%% 结算
state_stop({settle}, State) ->
    continue(state_stop, State#practice{time_interval = 1});

state_stop({start_combat, _RoomNo, _Hroles}, State) ->
    ?DEBUG("结束后收到发起战斗的操作"),
    continue(state_stop, State);
state_stop(_Event, State) ->
    ?INFO("~w 状态下收到消息 ~w", [state_stop, _Event]),
    continue(state_stop, State).

%% Func: handle_event/3
%% Returns: {next_state, NextStateName, NextStateData}          |
%%          {next_state, NextStateName, NextStateData, Timeout} |
%%          {stop, Reason, NewStateData}

%% 获取试练状态
handle_event({get_status, Rpid}, StateName, State) ->
    Status = case StateName of
        state_start ->
            1;
        _ ->
            0
    end,
    Time = get_timeout(Status, State),
    practice_rpc:push(16601, Rpid, {Status, Time}),
    continue(StateName, State);

%% 退出试练战斗
handle_event({leave_combat, Rid, CombatPid}, StateName, State = #practice{combats = Combats}) ->
    case lists:keyfind(CombatPid, #practice_combat.combat_pid, Combats) of
        #practice_combat{roles = [#practice_role{id = Lrid} | _]} when is_pid(CombatPid) andalso Lrid =:= Rid ->
            CombatPid ! stop;
        _ ->
            ok
    end,
    continue(StateName, State);

%% 更新地图人数
handle_event({update_map_role, Type, MapId}, StateName, State) ->
    Maps = case get(maps) of
        L when is_list(L) -> L;
        _ -> []
    end,
    NewMaps = case lists:keyfind(MapId, 1, Maps) of
        false -> Maps;
        {MapId, MapPid, N} when Type =:= add ->
            lists:keyreplace(MapId, 1, Maps, {MapId, MapPid, N + 1});
        {MapId, MapPid, N} when Type =:= delete ->
            lists:keyreplace(MapId, 1, Maps, {MapId, MapPid, N - 1});
        _ -> Maps
    end,
    put(maps, NewMaps),
    ?DEBUG("更新后的地图：~w", [NewMaps]),
    continue(StateName, State);

%% 增加地图
handle_event({add_maps, N}, StateName, State) when N =< 0 ->
    ?ERR("参数错误"),
    continue(StateName, State);
handle_event({add_maps, N}, StateName, State = #practice{map_id = MapId, map_pid = MapPid}) ->
    Maps = case get(maps) of
        L when is_list(L) -> L;
        _ -> []
    end,
    NewMaps = case is_pid(MapPid) andalso MapId > 0 of
        true ->
            do_create_map(N, [{MapId, MapPid, 200} | Maps]);
        false ->
            do_create_map(N, Maps)
    end,
    put(maps, NewMaps),
    ?INFO("增加地图后的MAPS:~w", [NewMaps]),
    continue(StateName, State#practice{map_id = 0, map_pid = 0});
handle_event({add_maps, _N}, StateName, State) ->
    continue(StateName, State);

handle_event({debug, test_data}, state_start, State = #practice{ranks = Ranks}) ->
    continue(state_start, State#practice{ranks = Ranks ++ Ranks});
handle_event({debug, combats}, StateName, State = #practice{combats = Combats}) ->
    ?INFO("practice combat: ~w", [Combats]),
    continue(StateName, State);
handle_event({debug, _Type}, StateName, State) ->
    ?DEBUG("practice_mgr: ~w, state_name = ~w", [State, StateName]),
    continue(StateName, State);

handle_event(_Event, StateName, State) ->
    continue(StateName, State).

%% Func: handle_sync_event/4
%% Returns: {next_state, NextStateName, NextStateData}            |
%%          {next_state, NextStateName, NextStateData, Timeout}   |
%%          {reply, Reply, NextStateName, NextStateData}          |
%%          {reply, Reply, NextStateName, NextStateData, Timeout} |
%%          {stop, Reason, NewStateData}                          |
%%          {stop, Reason, Reply, NewStateData}
handle_sync_event({get_hall}, _From, state_start, State = #practice{hall_id = HallId, hall_pid = HallPid}) ->
    Reply = {ok, HallId, HallPid},
    sync_continue(Reply, state_start, State);
handle_sync_event({get_hall}, _From, state_stop, State) ->
    Reply = {false, ?L(<<"无尽试练每天16：30-17：00开启，有大量金币与经验奖励，请准时参加哦！">>)},
    sync_continue(Reply, state_stop, State);
handle_sync_event({get_hall}, _From, StateName, State) ->
    Reply = {false, ?L(<<"无尽试练每天16：30-17：00开启，有大量金币与经验奖励，请准时参加哦！">>)},
    sync_continue(Reply, StateName, State);

%% 获取试练冠军
handle_sync_event({get_champion}, _From, StateName, State = #practice{last_champion = Lcham}) ->
    Reply = {ok, Lcham},
    sync_continue(Reply, StateName, State);

%% 获取排名
handle_sync_event({get_last_rank, PageSize, PageNo}, _From, StateName, State = #practice{last_ranks = Lranks}) ->
    TotalPage = util:ceil(length(Lranks) / PageSize),
    SubList = case PageNo + 1 > TotalPage of
        true ->
            [];
        false ->
            lists:sublist(Lranks, PageNo * PageSize + 1, PageSize)
    end,
    Reply = {ok, TotalPage, SubList},
    sync_continue(Reply, StateName, State);

%% 获取地图
handle_sync_event(get_map, _From, StateName, State = #practice{}) ->
    Reply = case check_in(get(maps)) of
        {MapId, _MapPid, _N} ->
            ?DEBUG("获取地图：~w", [MapId]),
            {ok, MapId};
        _E ->
            ?ERR("无尽试炼准备区不够：~w", [_E]),
            {false, ?L(<<"无尽试炼准备区人数过多，请稍候再进入">>)}
    end,
    sync_continue(Reply, StateName, State);
    
handle_sync_event(_Event, _From, StateName, State) ->
    Reply = ok,
    sync_continue(Reply, StateName, State).

%% Func: handle_info/3
%% Returns: {next_state, NextStateName, NextStateData}          |
%%          {next_state, NextStateName, NextStateData, Timeout} |
%%          {stop, Reason, NewStateData}

%% 同步地图人数
handle_info(sync_map_role, StateName = state_start, State) ->
    NewMaps = case get(maps) of
        Maps when is_list(Maps) ->
            lists:map(
                fun({MapId, MapPid, _N}) ->
                        Num = case catch map:role_list(MapPid) of
                            L when is_list(L) -> length(L);
                            _ -> 100 %% 默认有100人
                        end,
                        {MapId, MapPid, Num}
                end, Maps);
        _ -> []
    end,
    put(maps, NewMaps),
    erlang:send_after(3200*1000, self(), sync_map_role),
    ?INFO("试炼准备区MAPS:~w", [NewMaps]),
    continue(StateName, State);

%% 发公告
handle_info({send_notice, Num}, StateName = state_idel, State) ->
    Msg = util:fbin(?L(<<"无尽试练即将在~w分钟后开始，有大量金币与经验奖励，请各位仙友做好准备！">>), [(Num -1) * 2 + 1]),
    notice:send(54, Msg),
    case (Num - 1) > 0 of
        true ->
            erlang:send_after(2 * 60 * 1000, self(), {send_notice, Num - 1});
        false ->
            ok
    end,
    continue(StateName, State);

handle_info({send_notice_board}, StateName = state_idel, State) ->
    role_group:pack_cast(world, 16601, {2, 60 * 10}),
    continue(StateName, State);

handle_info({send_notice_end}, StateName = state_start, State) ->
    notice:send(54, ?L(<<"无尽试练即将在5分钟后结束，还没有参加的仙友请抓紧时间哦！">>)), 
    continue(StateName, State);

handle_info({send_notice_start}, StateName = state_start, State) ->
    notice:send(54, ?L(<<"无尽试练已经开启，有大量金币与经验奖励，请各位仙友前往参加！{open, 29, 我要参加, #00ff00}">>)), 
    continue(StateName, State);

%% 战斗结果
%% 节点服
handle_info({combat_over_result, CombatResult}, StateName, State = #practice{is_center = ?false, combats = Combats, ranks = _Ranks, hall_id = HallId})
when StateName =:= state_start orelse StateName =:= state_stop ->
    ?DEBUG("combat_over_result: ~w", [CombatResult]),
    {MaxRound, Score} = case lists:keyfind(kill_npc, 1, CombatResult) of
        {_, NpcIds} ->
            Mr = get_top_round(NpcIds),
            S = do_calc_score(NpcIds),
            {Mr, S};
        _ ->
            {1, 1}
    end,
    _CombatRound = case lists:keyfind(round, 1, CombatResult) of
        {_, Round} ->
            Round;
        _ ->
            256
    end,
    {NewCombats, Combat} = case lists:keyfind(combat_pid, 1, CombatResult) of
        {_, CombatPid} ->
            {lists:keydelete(CombatPid, #practice_combat.combat_pid, Combats), lists:keyfind(CombatPid, #practice_combat.combat_pid, Combats)};
        _ ->
            {Combats, false}
    end,
    NewState = case Combat of
        #practice_combat{room_no = RoomNo, roles = Roles} ->
            rank_celebrity:listener(practice_wave, Roles, MaxRound), %% 名人榜 
            campaign_listener:handle(practice, Roles, MaxRound),  %% 后台活动
            [campaign_task:listener(RoleId, practice, MaxRound) || #practice_role{id = RoleId} <- Roles],
            hall:room_end_combat(HallId, RoomNo, false),
            spawn(fun() -> reward(Score, MaxRound, Roles) end),
            spawn(fun() -> [check_leave_hall(R, MaxRound) || R <- Roles] end),
            %% NewCombat = Combat#practice_combat{score = Score, combat_pid = 0, round = CombatRound, wave = MaxRound},
            %% NewRanks = do_rank(NewCombat, Ranks),
            %% State#practice{ranks = NewRanks, combats = NewCombats};
            State#practice{combats = NewCombats};
        _ ->
            State
    end,
    continue(state_start, NewState);
%% 跨服试炼进程处理战斗结束
handle_info({combat_over_result, CombatResult}, StateName, State = #practice{is_center = ?true, combats = Combats, hall_id = HallId})
when StateName =:= state_start orelse StateName =:= state_stop ->
    ?DEBUG("center combat_over_result: ~w", [CombatResult]),
    {MaxRound, Score} = case lists:keyfind(kill_npc, 1, CombatResult) of
        {_, NpcIds} ->
            Mr = get_top_round(NpcIds),
            S = do_calc_score(NpcIds),
            ?DEBUG("NpcIds:~w, Mr:~w, S:~w", [NpcIds, Mr, S]),
            {Mr, S};
        _ ->
            {1, 1}
    end,
    {NewCombats, Combat} = case lists:keyfind(combat_pid, 1, CombatResult) of
        {_, CombatPid} ->
            {lists:keydelete(CombatPid, #practice_combat.combat_pid, Combats), lists:keyfind(CombatPid, #practice_combat.combat_pid, Combats)};
        _ ->
            {Combats, false}
    end,
    NewState = case Combat of
        #practice_combat{room_no = RoomNo, roles = Roles} ->
            lists:foreach(fun(PracticeRole = #practice_role{id = {_Rid, SrvId}}) ->
                        c_mirror_group:cast(node, SrvId, practice_mgr, center_combat_over_result, [PracticeRole, Score, MaxRound, Roles]);
                    (_) -> ignore
                end, Roles), %% 通知节点服进程处理奖励、榜或成就
            hall:room_end_combat(HallId, RoomNo, false),
            spawn(fun() -> [check_leave_hall(R, MaxRound) || R <- Roles] end),
            State#practice{combats = NewCombats};
        _ ->
            State
    end,
    continue(state_start, NewState);

handle_info(_Info, StateName, State) ->
    ?DEBUG("收到无效消息: ~w", [_Info]),
    continue(StateName, State).

%% Func: terminate/3
%% Purpose: Shutdown the fsm
%% Returns: any
terminate(_Reason, _StateName, _StatData) ->
    ok.

%% Func: code_change/4
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState, NewStateData}
code_change(_OldVsn, StateName, StateData, _Extra) ->
    {ok, StateName, StateData}.

%%--------------------------------------------------------------------
%%% Internal functions
%%--------------------------------------------------------------------

%% 异步调用
info(Msg) ->
    gen_fsm:send_all_state_event(?MODULE, Msg).

%% 同步调用
call(Msg) ->
    gen_fsm:sync_send_all_state_event(?MODULE, Msg).

%% 异步事件调用
info_state(Msg) ->
    gen_fsm:send_event(?MODULE, Msg).

%% 同步单状态调用
%call_state(Msg) ->
%    gen_fsm:sync_send_event(?MODULE, Msg).

%% 用于状态机的持续执行
continue(state_start, State) ->
    {next_state, state_start, State, infinity};
continue(StateName, State = #practice{state_change_time = ChangeTime, time_interval = TimeInterval}) ->
    Now = util:unixtime(),
    Timeout = case ChangeTime + TimeInterval - Now of
        T1 when T1 > 0 ->
            T1 * 1000;
        _ ->
            1
    end,
    {next_state, StateName, State, Timeout}.

sync_continue(Reply, state_start, State) ->
    {reply, Reply, state_start, State, infinity};
sync_continue(Reply, StateName, State = #practice{state_change_time = ChangeTime, time_interval = TimeInterval}) ->
    Now = util:unixtime(),
    Timeout = case ChangeTime + TimeInterval - Now of
        T1 when T1 > 0 ->
            T1 * 1000;
        _ ->
            1
    end,
    {reply, Reply, StateName, State, Timeout}.

%% 添加新的准备区地图，增加相关映射关系
create_map(#practice{is_center = ?true}) ->
    do_create_map(20, []);
create_map(_State) ->
    [].

do_create_map(0, Maps) ->
    Maps;
do_create_map(N, Maps) when N > 0 ->
    case map_mgr:create(36002) of
        {ok, MapPid, MapId} ->
            do_create_map(N - 1, [{MapId, MapPid, 0} | Maps]);
        _ ->
            ?ERR("新建跨服准备区地图失败"),
            do_create_map(N - 1, Maps)
    end.

%% 查询一个能进入地图出来
-ifdef(debug).
check_in([{_MapId, _MapPid, Cnt} | T]) when Cnt >= 2 ->
    check_in(T);
check_in([H = {_MapId, _MapPid, _Cnt} | _]) ->
    H;
check_in(_) -> error.
-else.
check_in([{_MapId, _MapPid, Cnt} | T]) when Cnt > 150 ->
    check_in(T);
check_in([H = {_MapId, _MapPid, _Cnt} | _]) ->
    H;
check_in(_) -> error.
-endif.

%% 转化为战斗角色
to_fighter(Rids) ->
    to_fighter(Rids, []).
to_fighter([], Back) ->
    Back;
to_fighter([#hall_role{id = Rid} | T], Back) ->
    case role_api:c_lookup(by_id, Rid, to_fighter) of
        {ok, _, Fighter} ->
            to_fighter(T, [Fighter | Back]);
        _ ->
            to_fighter(T, Back)
    end.

%% 转换为试练角色 
to_practice_role(#hall_role{id = Rid, pid = Pid, name = Name, career = Career, lev = Lev, guild_name = Gname, sex = Sex, vip_type = VipType}) ->
    #practice_role{id = Rid, pid = Pid, name = Name, career = Career, lev = Lev, guild_name = Gname, sex = Sex, vip_type = VipType}.

%% 根据战斗结果计算得分
do_calc_score(NpcIds) ->
    do_calc_score(NpcIds, 0).

do_calc_score([], Back) ->
    Back;
do_calc_score([H | T], Back) ->
    case practice_data:get(H) of
        #practice_round_data{score = Score} ->
            do_calc_score(T, Back + Score);
        _ ->
            do_calc_score(T, Back)
    end.

%% 排名
%% do_rank(Combat, Ranks) ->
%%     do_rank(Combat, lists:reverse(Ranks), []).
%% do_rank(Combat, [], Back) ->
%%     top30([Combat | Back]);
%% do_rank(Combat, Ranks = [H | T], Back) ->
%%     case compare(Combat, H) of
%%         true ->
%%             do_rank(Combat, T, [H | Back]);
%%         false ->
%%             top30(lists:reverse([Combat | Ranks]) ++ Back)
%%     end.
%% 
%% compare(#practice_combat{score = Score1, round = Round1}, #practice_combat{score = Score2, round = Round2}) ->
%%     case {Score1 - Score2, Round1 - Round2} of
%%         {0, R1} ->
%%             R1 < 0;
%%         {S2, _R2} when S2 > 0 ->
%%             true;
%%         _ ->
%%             false
%%     end;
%% compare(_, _) ->
%%     false.
%% 
%% top30(L) ->
%%     lists:sublist(L, 1, 30).

%% 开启试练
do_start(State) ->
    %% role_group:pack_cast(world, 16601, {1, ?time_interval_start}),
    %% erlang:send_after(25 * 60 * 1000, self(), {send_notice_end}),
    %% erlang:send_after(5 * 1000, self(), {send_notice_start}),
    Result = case center:is_cross_center() of
        true ->
            erlang:send_after(3400*1000, self(), sync_map_role),
            case hall_mgr:create(hall_data:get_hall(13)) of
                {ok, HallId, HallPid} ->
                    State1 = State#practice{is_center = ?true, hall_id = HallId, hall_pid = HallPid},
                    Maps = create_map(State1),
                    put(maps, Maps),
                    {ok, State1};
                _ ->
                    ?ERR("启动试练大厅失败"),
                    error
            end;
        false ->
            case hall_mgr:create(hall_data:get_hall(1)) of
                {ok, HallId, HallPid} ->
                    {ok, State#practice{is_center = ?false, hall_id = HallId, hall_pid = HallPid}};
                _ ->
                    ?ERR("启动试练大厅失败"),
                    error
            end
    end,
    case Result of
        {ok, S} ->
            NewState = S#practice{state_change_time = util:unixtime(), time_interval = ?time_interval_start},
            ?INFO("启动试练成功"),
            continue(state_start, NewState);
        _ ->
            NewState = State#practice{state_change_time = util:unixtime(), time_interval = ?time_interval_idel},
            continue(state_idel, NewState)
    end.

%% 关闭试练
do_stop(State = #practice{hall_pid = HallPid, combats = Combats}) ->
    ?INFO("关闭试练成功"),
    [CombatPid ! stop || #practice_combat{combat_pid = CombatPid} <- Combats, is_pid(CombatPid)],
    hall:stop(HallPid),
    Maps = case get(maps) of
        L when is_list(L) -> L;
        _ -> []
    end,
    [map:stop(MapPid) || {_, MapPid, _} <- Maps],
    %% role_group:pack_cast(world, 16601, {0, 0}),
    %% do_prepare_notice(),
    TimeInterval = case length(Combats) =:= 0 of
        true ->
            1;
        false ->
            ?time_interval_stop
    end,
    State#practice{state_change_time = util:unixtime(), time_interval = TimeInterval, hall_id = 0, hall_pid = 0}.

%% 保存数据
do_save(Champion, Ranks) ->
    InsertSql = "insert into sys_practice(champion, ranks, ctime) values(~s, ~s, ~s)",
    UpdateSql = "update sys_practice set champion = ~s, ranks = ~s, ctime = ~s",
    SelectSql = "select ctime from sys_practice",
    case db:get_row(SelectSql) of
        {ok, _} ->
            db:execute(UpdateSql, [util:term_to_bitstring(Champion), util:term_to_bitstring(Ranks), util:unixtime()]);
        _ ->
            db:execute(InsertSql, [util:term_to_bitstring(Champion), util:term_to_bitstring(Ranks), util:unixtime()])
    end.

%% 获取数据
do_load() ->
    SelectSql = "select champion, ranks, ctime from sys_practice",
    case db:get_row(SelectSql) of
        {ok, [Champion, Ranks, _Ctime]} ->
            {to_term(Champion, false), to_term(Ranks, [])};
        _ ->
            {false, []}
    end.

%% 将数据库存储的数据转换为term
to_term(Data, Def) ->
    case util:bitstring_to_term(Data) of
        {ok, R} ->
            R;
        _ ->
            Def
    end.

%% 获取当前状态的Timeout
get_timeout(1, #practice{state_change_time = StartTime, time_interval = Interval}) ->
    Now = util:unixtime(),
    StartTime + Interval - Now;
get_timeout(_, _) ->
    0.

%% 处理冠军
do_handle_champion(Champion = #practice_combat{roles = Proles}) ->
    NewHroles = lists:map(fun get_looks/1, Proles),
    Champion#practice_combat{roles = NewHroles};
do_handle_champion(Data) ->
    Data.

%% 获取用户外观
get_looks(Hrole = #practice_role{id = Rid}) ->
    case role_api:lookup(by_id, Rid, [#role.looks]) of
        {ok, _, [Looks]} ->
            Hrole#practice_role{looks = Looks};
        _ ->
            case role_data:fetch_role(by_id, Rid) of
                {ok, Role} ->
                    #role{looks = Looks} = setting:dress_login_init(Role),
                    Hrole#practice_role{looks = Looks};
                _ ->
                    Hrole
            end
    end.
 
%% 对排名进行编码
mark_rank(Ranks) ->
    mark_rank(Ranks, 1, []).

mark_rank([], _, Back) ->
    lists:reverse(Back);
mark_rank([H | T], Index, Back) ->
    mark_rank(T, Index + 1, [H#practice_combat{rank = Index} | Back]).

%% 更新玩家的试练次数
add_enter_count(Pids) when is_list(Pids) ->
    [role:apply(async, Pid, {fun add_enter_count/1, []}) || Pid <- Pids, is_pid(Pid)];
add_enter_count(Role = #role{practice = RolePractice}) ->
    NewRolePractice = do_add_count(RolePractice),
    NewRole2 = role_listener:special_event(Role#role{practice = NewRolePractice}, {1053, finish}), %% 任务
    NewRole = role_listener:special_event(NewRole2, {30007, 1}), %%活跃度
    {ok, NewRole}.

%% 增加试练的次数
do_add_count(RolePractice) ->
    case lists:keyfind(count, 1, RolePractice) of
        false ->
            lists:append(RolePractice, [{count, 1, util:unixtime()}]);
        _ ->
            Count = do_get_count(RolePractice) + 1,
            lists:keyreplace(count, 1, RolePractice, {count, Count, util:unixtime()})
    end.

%% 获取试练次数
do_get_count(RolePractice) ->
    case lists:keyfind(count, 1, RolePractice) of
        false ->
            0;
        {_, Count, Last} ->
            case Last >= util:unixtime({today, util:unixtime()}) of
                true ->
                    Count;
                false ->
                    0
            end
    end.

%% 发送提示
send_role_combat_notice(Pids, Msg) when is_list(Pids) ->
    lists:foreach(fun (Pid) -> send_role_combat_notice(Pid, Msg) end, Pids);
send_role_combat_notice(Pid, Msg) when is_pid(Pid) ->
    role:pack_send(Pid, 10931, {55, Msg, []}).
    
%% 奖励
reward(Score, MaxRound, Proles) when is_list(Proles) ->
    cast_wave_notice(MaxRound, Proles),
    lists:foreach(fun(Prole) -> reward(Score, MaxRound, Prole) end, Proles);
reward(Score, MaxRound, Prole = #practice_role{id = Rid, lev = Lev}) ->
    Msg = do_reward_msg(MaxRound),
    Exp = do_reward_exp(Score, Lev),
    BindCoin = do_reward_bindcoin(Score),
    Item = do_reward_item(MaxRound),
    cast_item_notice(Item, MaxRound, Prole),
    %%Item = do_reward_item(100),
    do_reward_push([Rid], MaxRound, BindCoin, Exp),
    case Score =:= 0 of
        true ->
            ok;
        false ->
            mail:send_system(Rid, {?reward_mail_title, util:fbin(?reward_mail_content, [Msg, Exp, BindCoin]), [{?mail_exp, Exp}, {?mail_coin_bind, BindCoin}], Item})
    end.

do_reward_msg(Mr) when Mr =< 6 ->
    util:fbin(?L(<<"很遗憾，您只击退了~w波妖魔，实力还亟需提高哦！">>), [Mr]);
do_reward_msg(Mr) when Mr =< 12 ->
    util:fbin(?L(<<"经过一番苦战，您成功击退了~w波妖魔，修为已属上乘之流！">>), [Mr]);
do_reward_msg(Mr) when Mr =< 18 ->
    util:fbin(?L(<<"经过一番激烈的试炼，您成功击退了~w波妖魔，修为真是震古烁今！">>), [Mr]);
do_reward_msg(Mr) when Mr =< 24 ->
    util:fbin(?L(<<"经过一番生死大战，您竟然击退了~w波妖魔，俨然已达仙人之境！">>), [Mr]);
do_reward_msg(Mr) ->
    util:fbin(?L(<<"经过一番生死大战，您竟然击退了~w波妖魔，您已经天下无敌了！">>), [Mr]).

do_reward_exp(Score, Lev) ->
    util:ceil(math:pow(Lev, 0.8)/20*math:pow(Score, 0.5) * 10000).

do_reward_bindcoin(Score) ->
    util:ceil(math:pow(Score, 0.8) * 1400).

do_reward_item(Round) ->
    do_reward_campaign(Round)
    ++ do_reward_item(10 * Round / 3, 25021, 1)
    ++ do_reward_item(10 * Round / 3, 33088, 1)
    ++ do_reward_item(min(20, Round * 10 / 3), 23015, 1)
    ++ do_reward_item(min(30,max(0,(Round-4)*5)), 23016, 1)
    ++ do_reward_item(min(35,max(0,(Round-8)*5)), 23017, 1)
    ++ do_reward_item(min(27,max(0,(Round-13)*5)), 23018, 1)
    ++ do_reward_item(min(10,max(0,(Round-18)*5)), 23019, 1).

do_reward_item(Prob, ItemId, Bind) when Prob >= 1000 ->
    do_reward_item(Prob - 1000, ItemId, Bind) ++ [{ItemId, Bind, 1}];

do_reward_item(Prob, ItemId, Bind) when Prob > 0 ->
    case util:rand(1, 1000) of
        N when is_integer(N) andalso N < Prob ->
            [{ItemId, Bind, 1}];
        _ ->
            []
    end;
do_reward_item(_Prob, _ItemId, _) ->
    [].

rand(L) ->
    T = lists:sum([X || {_, X} <- L]),
    rand(L, util:rand(1, T)).
rand([{Id, V} | T], Prob) ->
    case Prob =< V of
        true -> {Id, V};
        false -> rand(T, Prob - V)
    end.

%% 活动奖励
do_reward_campaign(Round) when Round >= 1 ->
    Now = util:unixtime(),
    %% 汤圆
    L = [{33129, 1, 1}, {33130, 1, 1}, {33131, 1, 1}, {33132, 1, 1}, {33133, 1, 1}, {33134, 1, 1}, {33135, 1, 1}],
    RandL = [{33129, 15}, {33130, 15}, {33131, 15}, {33132, 15}, {33133, 13}, {33134, 13}, {33135, 14}],
    case Now >= ?campaign_start_time andalso Now =< ?campaign_end_time of
        %% true when Round >= 8 ->
        %%     I1 = {Id1, _} = rand(RandL),
        %%     L1 = lists:delete(I1, RandL),
        %%     I2 = {Id2, _} = rand(L1),
        %%     _I3 = {Id3, _} = rand(lists:delete(I2, L1)),
        %%     [lists:keyfind(Id1, 1, L), lists:keyfind(Id2, 1, L), lists:keyfind(Id3, 1, L)];
        %% true when Round >= 5 ->
        %%     I1 = {Id1, _} = rand(RandL),
        %%     L1 = lists:delete(I1, RandL),
        %%     _I2 = {Id2, _} = rand(L1),
        %%     [lists:keyfind(Id1, 1, L), lists:keyfind(Id2, 1, L)];
        %% true ->
        %%     {Id1, _} = rand(RandL),
        %%     [lists:keyfind(Id1, 1, L)];
        true when Round >= 7 ->
             I1 = {Id1, _} = rand(RandL),
             L1 = lists:delete(I1, RandL),
             _I2 = {Id2, _} = rand(L1),
             [lists:keyfind(Id1, 1, L), lists:keyfind(Id2, 1, L)];
        true when Round >= 4 ->
            {Id1, _} = rand(RandL),
            [lists:keyfind(Id1, 1, L)];
            %% do_reward_item(8 * (Round - 3), 33129, 0) 
            %% ++ do_reward_item(8 * (Round - 3), 33130, 0) 
            %% ++ do_reward_item(8 * (Round - 3), 33131, 0) 
            %% ++ do_reward_item(8 * (Round - 3), 33132, 0)
            %% ++ do_reward_item(8 * (Round - 3), 33133, 0)
            %% ++ do_reward_item(8 * (Round - 3), 33134, 0)
            %% ++ do_reward_item(8 * (Round - 3), 33135, 0);
            %% do_reward_item(1000, 33182, 1);  %% 烟花
        _ ->
            []
    end;
do_reward_campaign(_) ->
    [].

%% 推送结算面板
do_reward_push([], _, _, _) ->
    ok;
do_reward_push([H | T], Mr, BindCoin, Exp) ->
    case role_api:lookup(by_id, H, [#role.pid]) of
        {ok, _, [Rpid]} ->
            role:pack_send(Rpid, 16611, {Mr, BindCoin, Exp});
        _ ->
            ok
    end,
    do_reward_push(T, Mr, BindCoin, Exp).

%% 根据玩家级别确定从哪一波怪开始
get_practice_wave(_Roles) ->
    1.
 
%% 根据怪物获知击败的最大波数
get_top_round(NpcIds) ->
    get_top_round(NpcIds, 1).

get_top_round([], Round) ->
    Round;
get_top_round([H | T], Round) ->
    case practice_data:get(H) of
        #practice_round_data{round = R} when R > Round ->
            get_top_round(T, R);
        _ ->
            get_top_round(T, Round)
    end.

%% 获取下一场试练的时间
get_next_practice_time() ->
    %% Time = util:datetime_to_seconds({date(), ?practice_start_time}) - util:unixtime(),
    %% TimeLeft = case Time >= 0 of 
    %%     true ->
    %%         Time;
    %%     false ->
    %%         Time + 86400
    %% end,
    %% ?DEBUG("下一场试练时间: ~w", [TimeLeft]),
    %% TimeLeft.
    ?time_interval_idel.

%% 公告
cast_item_notice(Items, MaxRound, Prole) ->
    cast_item_notice(Items, MaxRound, Prole, <<>>).

cast_item_notice([], MaxRound, #practice_role{id = {RoleId, SrvId}, name = Name}, Back) ->
    case Back =:= <<>> of
        true ->
            ok;
        false ->
            notice:send(53, util:fbin(?L(<<"~s在无尽试练中击败了~w波妖魔，英勇无比，居然幸运地获得了~s">>), [notice:role_to_msg({RoleId, SrvId, Name}), MaxRound, Back])),
            ok
    end;
cast_item_notice([{ItemId, Bind, Q} | T], MaxRound, Prole, Back) ->
    case ItemId =:= 33087 orelse ItemId =:= 33088 orelse ItemId =:= 25021 orelse ItemId =:= 23018 orelse ItemId =:= 23019 of
        true ->
            cast_item_notice(T, MaxRound, Prole, util:fbin(<<"~s, ~s">>, [Back, notice:item_to_msg({ItemId, Bind, Q})]));
        _ ->
            cast_item_notice(T, MaxRound, Prole, Back)
    end;
cast_item_notice([_ | T], MaxRound, Prole, Back) ->
    cast_item_notice(T, MaxRound, Prole, Back).

%% 公告波数
cast_wave_notice(MaxRound, Proles) when MaxRound >= 13 ->
    Rnames = lists:foldl(fun(#practice_role{id = {RoleId, SrvId}, name = Name}, Back) -> 
                            case Back of
                                <<>> ->
                                    notice:role_to_msg({RoleId, SrvId, Name});
                                _ ->
                                    util:fbin("~s, ~s", [Back, notice:role_to_msg({RoleId, SrvId, Name})]) 
                            end
                end, <<>>, Proles),
    notice:send(53, util:fbin(?L(<<"~s修为通天，居然在【{str, 无尽试练, #ffff00}】中击退了~w波妖魔，实在令人钦佩！">>), [Rnames, MaxRound])),
    ok;
cast_wave_notice(_, _) ->
    ok.

%% 判断是否踢出大厅
check_leave_hall(#practice_role{pid = RolePid}, MaxRound) when is_pid(RolePid) ->
    role:apply(async, RolePid, {fun apply_check_leave/2, [MaxRound]}),
    role:apply(async, RolePid, {fun apply_check_leave_map/1, []}); %% 检查离开地图
check_leave_hall(#practice_role{id = Rid}, MaxRound) ->
    case role_api:c_lookup(by_id, Rid, [#role.pid]) of
        {ok, _, [Rpid]} ->
            role:apply(async, Rpid, {fun apply_check_leave/2, [MaxRound]}),
            role:apply(async, Rpid, {fun apply_check_leave_map/1, []}); %% 检查离开地图
        _ ->
            ok
    end.

apply_check_leave(Role = #role{event = ?event_hall, hall = #role_hall{id = HallId, pid = HallPid}}, MaxRound) ->
    NewRole = role_listener:special_event(Role, {20029, MaxRound}), %% 无尽试练 N:第N波
    case get_enter_count(NewRole) of
        E when is_integer(E) andalso E >= ?practice_count ->
            hall:leave_room(HallId, NewRole),
            hall:leave(HallPid, NewRole);
        _ -> ok
    end,
    {ok, NewRole};
apply_check_leave(_Role, _MaxRound) ->
    {ok}.

apply_check_leave_map(Role = #role{cross_srv_id = <<"center">>, pos = #pos{map = OldMapId, map_base_id = MapBaseId}})
when MapBaseId =:= 36002 ->
    case get_enter_count(Role) of
        E when is_integer(E) andalso E >= ?practice_count ->
            {ok, MapId, X, Y} = {ok, 10003, 6420, 6300},
            case map:role_enter(MapId, X, Y, Role#role{cross_srv_id = <<>>}) of
                {ok, NewRole} ->
                    center:cast(practice_mgr, update_map_role, [delete, OldMapId]),
                    {ok, NewRole};
                {false, _Reason} ->
                    {ok}
            end;
        _ -> {ok}
    end;
apply_check_leave_map(_Role) -> {ok}.

%% 跨服试炼触发名人榜
trigger_celebrity(Roles, MaxRound) ->
    case is_same_srv(Roles) of
        true ->
            rank_celebrity:listener(practice_wave, Roles, MaxRound);
        _ -> ok
    end,
    {ok}.

%% 判断副本内角色是否同服
is_same_srv([]) -> true;
is_same_srv([#practice_role{id = {_Rid, SrvId}} | T]) ->
    case role_api:is_local_role(SrvId) of
        true -> is_same_srv(T);
        false -> false
    end;
is_same_srv(_) -> false.

%% 跳波找跳向的波数
calc_over_wave(WaveNo, NextWave, NpcBaseIds, OveredNpcIds) when WaveNo >= NextWave ->
    {WaveNo, NpcBaseIds, OveredNpcIds};
calc_over_wave(WaveNo, NextWave, [NpcId | T], OveredNpcIds) ->
    calc_over_wave(WaveNo + 1, NextWave, T, [NpcId | OveredNpcIds]);
calc_over_wave(_WaveNo, _NextWave, _T, _OveredNpcIds) ->
    {0, [], []}.

over_wave_diff(3) -> {7, 3};
over_wave_diff(6) -> {10, 3};
over_wave_diff(9) -> {13, 3};
over_wave_diff(12) -> {16, 5};
over_wave_diff(15) -> {19, 6};
over_wave_diff(18) -> {22, 7};
over_wave_diff(21) -> {25, 8};
over_wave_diff(24) -> {28, 8}.

%% 准备好一下一场的公告
%% do_prepare_notice() ->
%%     PracTime = get_next_practice_time(),
%%     TimeLeft = PracTime - (5 * 60),
%%     TimeLeft2 = PracTime - (10 * 60),
%%     ?DEBUG("公告时间：~w", [TimeLeft]),
%%     case TimeLeft > 0 of
%%         true ->
%%             erlang:send_after(TimeLeft * 1000, self(), {send_notice, 3});
%%         false ->
%%             ok
%%     end,
%%     case TimeLeft2 > 0 of
%%         true ->
%%             erlang:send_after(TimeLeft2 * 1000, self(), {send_notice_board});
%%         false ->
%%             ok
%%     end.

