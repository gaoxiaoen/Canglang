%% --------------------------------------------------------------------
%% 至尊管理进程
%% @author shawn 
%% @end
%% --------------------------------------------------------------------
-module(cross_king_mgr).
-behaviour(gen_fsm).

%% export functions
-export([
        start_link/0
        ,role_enter/1
        ,apply_enter_map/2
        ,apply_leave_map/1
        ,info/1
        ,call/1
        ,role_leave/1
        ,do_enter_match/2
        ,update_cache/1
        ,login/1
        ,logout/1
        ,get_king_role/1
        ,broadcast_srv/2
        ,get_pet_status/2
        ,save_pet_status/3
        %% ----------
        ,m/1
        ,info_list/2
    ]).

%% gen_fsm callbacks
-export([init/1, handle_event/3,handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).

%%      idel         空闲
%%      notice       活动通知 
%%      prepare      报名阶段
%%      match_pre    比赛早期(可进战场)
%%      matching     比赛阶段
%%      expire       进入战区过期

%% state functions
-export(
    [
        idel/2         %% 空闲状态
       ,notice/2       %% 公告状态
       ,prepare/2      %% 准备期
       ,match_pre/2    %% 
       ,matching/2
       ,expire/2
   ]
).

-record(state, {
        pre_list = []      %% 准备区列表[#cross_king_pre{}]
        ,zone_list = []   %% [#cross_king_zone{}]
        ,ts = 0             %% 进入某状态的时刻
        ,timeout = 0        %% 超时时间
        ,end_time = 0       %% 整个活动结束时间
    }
).

-include("common.hrl").
-include("role.hrl").
-include("attr.hrl").
-include("cross_king.hrl").
-include("pos.hrl").
-include("looks.hrl").

%% @doc 启动竞技场服务进程
start_link()->
    gen_fsm:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 发送消息
info(Msg) ->
    gen_fsm:send_all_state_event(?MODULE, Msg).

%% 打印消息
info_list(Seq, Label) ->
    gen_fsm:sync_send_all_state_event(?MODULE, {info_list, Seq, Label}).

%% 发送消息
call(Msg) ->
    gen_fsm:sync_send_all_state_event(?MODULE, Msg).

m(Event) ->
    gen_fsm:send_event(?MODULE, Event).

%% 获取某个参战角色宠物状态
get_pet_status(RoleId, PetId) ->
    case get_king_role(RoleId) of
        undefined -> undefined;
        #cross_king_role{group = 0} -> undefined;
        #cross_king_role{group = 1, pet_status = PetStatus} ->
            case lists:keyfind(PetId, 1, PetStatus) of
                false -> undefined;
                {PetId, {Hp, Mp}} -> {Hp, Mp};
                _ -> undefined
            end;
        _ -> undefined
    end.

%% 保存角色某个宠物状态
save_pet_status({Rid, SrvId}, PetId, {Hp, Mp}) ->
    case get_king_role({Rid, SrvId}) of
        undefined ->
            skip;
        #cross_king_role{group = 0} ->
            skip;
        K = #cross_king_role{group = 1, pet_status = PetStatus} ->
            NewPetStatus = case lists:keyfind(PetId, 1, PetStatus) of
                false -> [{PetId, {Hp, Mp}} | PetStatus];
                _ -> lists:keyreplace(PetId, 1, PetStatus, {PetId, {Hp, Mp}})
            end,
            NewK = K#cross_king_role{pet_status = NewPetStatus},
            update_cache(NewK);
        _ ->
            skip
    end.

%% @spec role_enter(RoleId, Pid, FightCapacity) -> any()
%% Role = #role{}
%% FightLev = integer()
role_enter(KingRole) ->
    gen_fsm:send_all_state_event(?MODULE, {role_enter, KingRole}).

%% @spec role_leave(Role) -> {ok, NewRole} | {false, Reason}
%% @doc 退出战区
role_leave(#role{id = Id, event = ?event_cross_king_match, event_pid = EventPid}) ->
    case is_pid(EventPid) andalso util:is_process_alive(EventPid) of
        false ->
            {false, ?L(<<"至尊王者赛已经关闭">>)};
        true ->
            case cross_king:exit_match(EventPid, Id) of
                {false, Reason} -> {false, Reason};
                _Any -> ok
            end
    end;
role_leave(#role{id = Id, event = ?event_cross_king_prepare})->
    case cross_king_api:call_center({exit_prepare, Id}) of
        ok -> ok;
        {false, Reason} -> {false, Reason};
        _ -> ok 
    end;
role_leave(_Role) -> {false, <<"">>}.

%% 登陆
login(Role = #role{id = {RoleId, SrvId}, name = _Name, event = ?event_cross_king_prepare, pos = Pos, pid = Pid}) ->
    case cross_king_api:call_center({login, prepare, RoleId, SrvId, Pid}) of
        {ok, _Time} ->
            Role;
        _Any ->
            {MapId, X, Y} = util:rand_list(?cross_king_exit),
            NewX = util:rand(X - 20, X + 20),
            NewY = util:rand(Y - 20, Y + 20),
            Role#role{pos = Pos#pos{map = MapId, x = NewX, y = NewY}, event = ?event_no, cross_srv_id = <<>>}
    end;
login(Role = #role{name = _Name, id = {RoleId, SrvId}, pid = Pid, event = ?event_cross_king_match, pos = Pos, looks = Looks}) ->
    {MapId, X, Y} = util:rand_list(?cross_king_exit),
    NewX = util:rand(X - 20, X + 20),
    NewY = util:rand(Y - 20, Y + 20),
    case cross_king_api:call_center({login, match, RoleId, SrvId, Pid}) of
        {ok, KingRole = #cross_king_role{zone_pid = ZonePid}} ->
            case is_pid(ZonePid) of
                true ->
                    NewLooks = update_looks(Looks, KingRole), 
                    Role#role{event_pid = ZonePid, looks = NewLooks};
                false -> 
                    Role#role{pos = Pos#pos{map = MapId, x = NewX, y = NewY}, event = ?event_no, cross_srv_id = <<>>}
            end;
        false -> 
            Role#role{pos = Pos#pos{map = MapId, x = NewX, y = NewY}, event = ?event_no, cross_srv_id = <<>>};
        _Any -> 
            Role#role{pos = Pos#pos{map = MapId, x = NewX, y = NewY}, event = ?event_no, cross_srv_id = <<>>}
    end;
login(Role) ->
    Role.

%% 下线
logout(_Role = #role{id = {RoleId, SrvId}, event = ?event_cross_king_prepare}) ->
    cross_king_api:inform_center({logout, RoleId, SrvId});
logout(_Role = #role{id = {RoleId, SrvId}, event = ?event_cross_king_match}) ->
    cross_king_api:inform_center({logout, RoleId, SrvId});
logout(_Role) ->
    ok.

update_looks(Looks, #cross_king_role{group = Group, death = Death}) ->
    GroupLooks = case Group of
        1 ->
            case lists:keyfind(?LOOKS_TYPE_KING, 1, Looks) of
                false ->
                    [{?LOOKS_TYPE_KING, 0, ?LOOKS_VAL_KING_GFS} | Looks];
                _ ->
                    lists:keyreplace(?LOOKS_TYPE_KING, 1, Looks, {?LOOKS_TYPE_KING, 0, ?LOOKS_VAL_KING_GFS})
            end;
        _ ->
            case lists:keyfind(?LOOKS_TYPE_KING, 1, Looks) of
                false ->
                    [{?LOOKS_TYPE_KING, 0, ?LOOKS_VAL_KING_DS} | Looks];
                _ ->
                    lists:keyreplace(?LOOKS_TYPE_KING, 1, Looks, {?LOOKS_TYPE_KING, 0, ?LOOKS_VAL_KING_DS})
            end
    end,
    DeathLooks = case Death of
        3 when Group =:= 1 ->
            case lists:keyfind(?LOOKS_TYPE_ALPHA, 1, GroupLooks) of
                false ->
                    [{?LOOKS_TYPE_ALPHA, 0, ?LOOKS_VAL_ALPHA_ARENA} | GroupLooks];
                _ ->
                    lists:keyreplace(?LOOKS_TYPE_ALPHA, 1, GroupLooks, {?LOOKS_TYPE_ALPHA, 0, ?LOOKS_VAL_ALPHA_ARENA})
            end;
        5 when Group =:= 0 ->
            case lists:keyfind(?LOOKS_TYPE_ALPHA, 1, GroupLooks) of
                false ->
                    [{?LOOKS_TYPE_ALPHA, 0, ?LOOKS_VAL_ALPHA_ARENA} | GroupLooks];
                _ ->
                    lists:keyreplace(?LOOKS_TYPE_ALPHA, 1, GroupLooks, {?LOOKS_TYPE_ALPHA, 0, ?LOOKS_VAL_ALPHA_ARENA})
            end;
        _ -> GroupLooks
    end,
    DeathLooks.

%% ------------------------------------
%% 状态机内部逻辑
%% ------------------------------------

%% 初始化
init([])->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    process_flag(trap_exit, true),
    IdelTime = get_idel_time(),
    ets:new(ets_cross_king_roles, [named_table, public, set, {keypos, #cross_king_role.id}]),
    State = #state{},
    cross_king_rank:start_link(),
    ?INFO("[~w] 启动完成...", [?MODULE]),
    {ok, idel, State#state{ts = erlang:now(), timeout = IdelTime}, IdelTime}.

%% 报名阶段才接受报名
handle_event({role_enter, KingRole = #cross_king_role{pid = Pid}}, prepare, State = #state{pre_list = MapList}) ->
    case get_enter_map(MapList) of
        {ok, M = #cross_king_pre{map_id = MapId}} ->
            role:apply(async, Pid, {cross_king_mgr, apply_enter_map, [MapId]}),
            add_pre_roles(KingRole, M),
            NewMapList = add_pre_count(MapId, MapList),
            continue(prepare, State#state{pre_list = NewMapList});
        _ -> %% 新建准备区地图
            M = #cross_king_pre{map_id = MapId} = new_mapping(),
            ?INFO("准备区不足,新增准备区"),
            role:apply(async, Pid, {cross_king_mgr, apply_enter_map, [MapId]}),
            add_pre_roles(KingRole, M),
            NewMap = M#cross_king_pre{role_size = 1}, 
            NewMapList = MapList ++ [NewMap],
            continue(prepare, State#state{pre_list = NewMapList})
    end;
handle_event({role_enter, #cross_king_role{pid = Pid}}, StateName, State) when StateName =:= notice ->
    role:pack_send(Pid, 17001, {?false, ?L(<<"至尊王者活动即将开始，在准备时间结束后可以报名参加活动">>)}),
    continue(StateName, State);
handle_event({role_enter, #cross_king_role{pid = Pid}}, idel, State) ->
    role:pack_send(Pid, 17001, {?false, ?L(<<"至尊王者活动还未开启">>)}),
    continue(idel, State);
handle_event({role_enter, #cross_king_role{pid = Pid}}, StateName, State) ->
    role:pack_send(Pid, 17001, {?false, ?L(<<"至尊王者活动正在进行中, 无法进入">>)}),
    continue(StateName, State);

%% 其他消息
handle_event({fail_enter, RoleId}, StateName, State) ->
    ets:delete(ets_cross_king_roles, RoleId),
    continue(StateName, State);

%% 角色下线
handle_event({logout, Rid, SrvId}, StateName, State) ->
    case get_king_role({Rid, SrvId}) of
        KingRole = #cross_king_role{status = ?cross_king_role_status_prepare} ->
            NewKingRole = KingRole#cross_king_role{status = ?cross_king_role_status_logout},
            update_cache(NewKingRole),
            continue(StateName, State);
        KingRole = #cross_king_role{status = ?cross_king_role_status_match, zone_pid = ZonePid} ->
            catch cross_king:logout(ZonePid, Rid, SrvId),
            NewKingRole = KingRole#cross_king_role{status = ?cross_king_role_status_logout},
            update_cache(NewKingRole),
            continue(StateName, State);
        _ ->
            continue(StateName, State)
    end;

%% 容错函数
handle_event(_Event, StateName, State) ->
    continue(StateName, State).

%% 获取状态
handle_sync_event(get_status, _From, StateName, State = #state{ts = Ts, end_time = EndTime}) ->
    Fun = fun(idel) -> {0, 0};
        (notice) -> {1, Ts};
        (prepare) -> {2, Ts};
        (_) -> {3, EndTime - util:unixtime()}
    end,
    Reply = {ok, Fun(StateName)},
    continue(StateName, Reply, State);

%% 打印信息
handle_sync_event({info_list, Seq, Label}, _From, StateName, State = #state{zone_list = ZoneList}) ->
    Reply = case lists:keyfind(Seq, #cross_king_zone.id, ZoneList) of
        false ->
            {false, ?L(<<"不存在该战区">>)};
        #cross_king_zone{pid = Pid} ->
            cross_king:info_list(Pid, Label)
    end,
    continue(StateName, Reply, State);

%% 获取角色信息
handle_sync_event({get_role_info, Id}, _From, StateName, State) ->
    case get_king_role(Id) of
        undefined ->
            continue(StateName, false, State);
        #cross_king_role{status = ?cross_king_role_status_prepare} ->
            continue(StateName, {0, 0, 0, 0}, State);
        #cross_king_role{zone_id = ZoneId, group = 1, kill = Kill, death = Death} ->
            continue(StateName, {ZoneId, 1, Kill, 3 - Death}, State);
        #cross_king_role{zone_id = ZoneId, group = 0, dmg = Dmg, death = Death} ->
            continue(StateName, {ZoneId, 0, Dmg, 7 - Death}, State);
        _ ->
            continue(StateName, {0, 0, 0, 0}, State)
    end;

%% 登录
handle_sync_event({login, prepare, RoleId, SrvId, Pid}, _From, prepare, State = #state{ts = Ts}) ->
    case get_king_role({RoleId, SrvId}) of
        undefined ->
            continue(prepare, false, State);
        KingRole = #cross_king_role{} ->
            Time = round(util:time_left(300 * 1000, Ts)/ 1000),
            NewKingRole = KingRole#cross_king_role{status = ?cross_king_role_status_prepare, pid = Pid},
            update_cache(NewKingRole),
            continue(prepare, {ok, Time}, State)
    end;
handle_sync_event({login, match, RoleId, SrvId, Pid}, _From, match_pre, State) ->
    case get_king_role({RoleId, SrvId}) of
        _KingRole = #cross_king_role{zone_pid = ZonePid} when is_pid(ZonePid) ->
            case util:is_process_alive(ZonePid) of
                true ->
                    case catch cross_king:login(ZonePid, RoleId, SrvId, Pid) of
                        {ok, KingRole2} ->
                            continue(match_pre, {ok, KingRole2}, State);
                        _ ->
                            continue(match_pre, false, State)
                    end;
                false ->
                    continue(match_pre, false, State)
            end;
        _ ->
            continue(match_pre, false, State)
    end;

%% 角色离开准备区
handle_sync_event({exit_prepare, RoleId}, _From, StateName, State = #state{pre_list = MapList}) ->
    case get_king_role(RoleId) of
        undefined ->
            continue(StateName, {false, ?L(<<"你并不在准备区里面">>)}, State);
        #cross_king_role{pid = Pid, pre_map_id = MapId} ->
            role:apply(async, Pid, {cross_king_mgr, apply_leave_map, []}),
            del_pre_roles(RoleId),
            NewMapList = del_pre_count(MapId, MapList),
            continue(StateName, ok, State#state{pre_list = NewMapList})
    end;

handle_sync_event(_Event, _From, StateName, State) ->
    Reply = ok,
    continue(StateName, Reply, State).

%% 处理地图进程正常退出
handle_info({'EXIT', Pid, normal}, StateName, State) ->
    case delete_zone_online(Pid, State) of
        {false, _Reason} ->
%%          ?DEBUG("[竞技场]接收到竞技场进程退出信息有误:~w", [_Reason]),
            continue(StateName, State);
        {#cross_king_zone{id = _ZoneId}, NewState} ->
            ?DEBUG("[至尊王者~w号场]已经正常退出", [_ZoneId]),
            continue(StateName, NewState)
    end;

handle_info(_Info, StateName, State) ->
    continue(StateName, State).

terminate(_Reason, _StateName, _State) ->
    ok.

code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.

%%----------------------------------------------------
%% 状态处理
%%----------------------------------------------------

%% 开始报名 
idel(timeout, State) ->
    ?INFO("进入通知阶段"),
    broadcast(notice, erlang:now()),
    cross_king_rank:clean_rank(),
    EndTime = util:unixtime() + 1920,
    {next_state, notice, State#state{ts = erlang:now(), timeout = 180 * 1000, end_time = EndTime}, 180 * 1000};
idel(_Any, State) ->
    continue(idel, State).

%% 通知
notice(timeout, State) ->
    ?INFO("[至尊王者]报名阶段"),
    case create_map(prepare, State) of
        {false, Reason} ->
            ?ERR("创建至尊王者准备区地图失败:~s", [Reason]),
            {stop, normal, State};
        NewState ->
            broadcast(prepare, erlang:now()),
            {next_state, prepare, NewState#state{ts = erlang:now(), timeout = 300 * 1000}, 300 * 1000}
    end;
notice(_Any, State) ->
    continue(notice, State).

%% 准备期结束,进入战场
prepare(timeout, State = #state{end_time = EndTime}) ->
    ?INFO("[至尊王者]比赛前期分配正式区"),
    broadcast(match_pre, EndTime),
    case startup_branch(State) of
        {ok, NewState} ->
            role_enter_match(),
            {next_state, match_pre, NewState#state{ts = erlang:now(), timeout = 15 * 1000}, 15 * 1000};
        {false, Reason} ->
            ?INFO("启动至尊王者正式区失败[Reason:~w]", [Reason]),
            {next_state, expire, State#state{ts = erlang:now(), timeout = 30 * 1000}, 30 * 1000} %% 时间设置
    end;
prepare(_Any, State) ->
    continue(prepare, State).

%% 关闭准备区
match_pre(timeout, State = #state{pre_list = PreList}) ->
    ?INFO("[至尊王者]比赛中，不可进入战场"),
    role_enter_match(),
    close_all_pre(PreList),
    {next_state, matching, State#state{ts = erlang:now(), timeout = 1500 * 1000}, 1500 * 1000}; %% 时间设置
match_pre(_Any, State) ->
    continue(match_pre, State).

%% 比赛结束
matching(timeout, State = #state{zone_list = ZoneList}) ->
    ?INFO("[至尊王者]比赛结束,结算"),
    stop_all_zone(ZoneList),
    {next_state, expire, State#state{ts = erlang:now(), timeout = 15 * 1000}, 15 * 1000}; %% 时间设置
matching(_Any, State) ->
    continue(matching, State).

%% 结束所有战区 
expire(timeout, State = #state{pre_list = PreList}) ->
    ?INFO("[至尊王者]比赛结束, 关闭所有正式区"),
    close_all_pre(PreList),
    IdelTime = get_idel_time(),
    broadcast(expire, 0),
    ets:delete_all_objects(ets_cross_king_roles),
    %% 存储最终榜单
    cross_king_rank:save_rank(),
    {next_state, idel, State#state{ts = erlang:now(), pre_list = [], zone_list = [], timeout = IdelTime}, IdelTime}; %% 时间临时设置
expire(_Any, State) ->
    continue(expire, State).

%% ----------------------------------
%% 私有函数
%% ----------------------------------
%% 活动通知
broadcast(StateName, Ts) ->
    c_mirror_group:cast(all, cross_king_mgr, broadcast_srv, [StateName, Ts]).

broadcast_srv(StateName, Ts) ->
    case sys_env:get(srv_open_time) of
        T when is_integer(T) ->
            Openday = util:unixtime({today, T}),
            case Openday + 6 * 86400 < util:unixtime() of
                true ->
                    do_broadcast(StateName, Ts);
                false -> ignore
            end;
        _ ->
            do_broadcast(StateName, Ts)
    end.

do_broadcast(notice, Ts) ->
    sys_env:set(cross_king_status, {1, Ts}),
    role_group:pack_cast(world, 17000, {1, 180}),
    notice:send(54, ?L(<<"王者无敌，至尊降临！至尊王者赛即将开始，请诸位飞仙同道开始准备并及时参加！">>));
do_broadcast(prepare, Ts) ->
    sys_env:set(cross_king_status, {2, Ts}),
    role_group:pack_cast(world, 17000, {2, 300}),
    notice:send(54, ?L(<<"至尊王者赛正式开始，各位飞仙同道可以报名进入准备区，等待王者降临！{open,40,我要参加,#00ff24}">>));
do_broadcast(match_pre, EndTime) ->
    sys_env:set(cross_king_status, {3, EndTime}),
    role_group:pack_cast(world, 17000, {3, 1500});
do_broadcast(expire, _) ->
    sys_env:set(cross_king_status, {0, 0}),
    role_group:pack_cast(world, 17000, {0, 0});
do_broadcast(_, _) -> ok.

%% 某战区关闭了
delete_zone_online(Pid, State = #state{zone_list = ZoneList}) ->
    case lists:keyfind(Pid, #cross_king_zone.pid, ZoneList) of
        false ->
            {false, ?L(<<"未记录到该至尊王者正式区的信息">>)};
        Zone ->
            {Zone, State#state{zone_list = lists:keydelete(Pid, #cross_king_zone.pid, ZoneList)}}
    end.

%% 获取间隔天数
get_day(6) -> 4;
get_day(7) -> 3;
get_day(1) -> 2;
get_day(2) -> 1;
get_day(3) -> 0.

%% 获取离下一次开启时间
get_idel_time() ->
    Day = calendar:day_of_the_week(date()),
    Today = util:unixtime(today),
    Now = util:unixtime(),
    StartCd = 15 * 3600 - 180,
    TimeLeft = if
        %% 周四或周五 15:00 -> 15:30
        Day =:= 4 ->
            T1 = Today + StartCd,
            if
                Now < T1 -> T1 - Now;
                Now =:= T1 -> 1;
                true -> (util:unixtime({tomorrow, Now}) - Now) + StartCd
            end;
        Day =:= 5 ->
            T1 = Today + StartCd,
            if
                Now < T1 -> T1 - Now;
                Now =:= T1 -> 1;
                true -> (util:unixtime({tomorrow, Now}) - Now) + 5*86400 + StartCd
            end;
        true ->
            util:unixtime({tomorrow, Now}) - Now + get_day(Day)*86400 + StartCd
    end,
    M = util:floor(TimeLeft / 60),
    S = TimeLeft - M * 60,
    ?INFO("离下一次开始还有~w分~w秒", [M, S]),
    TimeLeft * 1000.

role_enter_match() ->
    AllRole = ets:tab2list(ets_cross_king_roles), 
    async_enter_match(AllRole).

async_enter_match([]) -> ok;
async_enter_match([KingRole = #cross_king_role{pid = Pid, status = ?cross_king_role_status_prepare} | T]) ->
    role:apply(async, Pid, {cross_king_mgr, do_enter_match, [KingRole]}),
    async_enter_match(T);
async_enter_match([_ | T]) ->
    async_enter_match(T).

do_enter_match(Role = #role{name = _Name, looks = Looks}, KingRole = #cross_king_role{group = Group, zone_pid = ZonePid}) ->
    case cross_king:enter_match(ZonePid, KingRole) of
        {ok, MapId} ->
            L = case Group of
                0 -> [{1500,1620}, {2280,1170}, {1500,840}]; %% 求道者 
                _ -> [{1260, 1260}, {1500, 1140}, {1680, 1260}] %% 王者点 
            end,
            {X, Y} = util:rand_list(L),
            NewX = util:rand(X - 5, X + 5),
            NewY = util:rand(Y - 5, Y + 5),
            GroupLooks = update_looks(Looks, KingRole),
            case map:role_enter(MapId, NewX, NewY, Role#role{cross_srv_id = <<"center">>, event = ?event_cross_king_match, event_pid = ZonePid, looks = GroupLooks}) of
                {ok, NewRole} ->
                    ?DEBUG("~s成功进入正式区",[_Name]),
                    NewRole1 = role_listener:special_event(NewRole, {30028, 1}), %%至尊皇者
                    campaign_listener:handle(king, NewRole1, 1),
                    {ok, NewRole1};
                {false, _Why} ->
                    cross_king:fail_enter_match(ZonePid, KingRole),
                    ?ERR("~s进入正式区失败,原因:~w",[_Name, _Why]),
                    {ok}
            end;
        _Why ->
            ?ERR("~s进入正式区失败,原因:~w",[_Name, _Why]),
            {ok}
    end.

startup_branch(State) ->
    AllKingRole = ets:tab2list(ets_cross_king_roles),
    AllKingNum = length(AllKingRole),
    case AllKingNum > 0 of
        true ->
            QsortKingRole = qsort(AllKingRole),
%%          G = erlang:round(AllKingNum * 50/ 100),
            G = util:ceil(AllKingNum * 14.2857143 / 100),
            GfsNum = case G rem 3 of %% 高富帅的数量
                0 -> G;
                1 -> G + 2;
                2 -> G + 1
            end,
            RoomNum = util:ceil(GfsNum div 3),
            DsNum = AllKingNum - GfsNum,
            {GetGfsRole, GetDsRole} = reset_role_flag(QsortKingRole, GfsNum, [], []),
            NewGfsRole = lists:reverse(GetGfsRole),
            NewDsRole = lists:reverse(GetDsRole),
            RoomDsList = calc_ds_room(lists:seq(1, RoomNum), RoomNum, DsNum), 
            ?INFO("至尊王者共有~w人参加,其中王者:~w人,求道者:~w人, 房间共有~w个", [AllKingNum, GfsNum, DsNum, RoomNum]),  
            NewState = set_room(State, RoomDsList, NewGfsRole, NewDsRole),
            {ok, NewState};
        false ->
            {false, ?L(<<"人数为0">>)}
    end.

stop_all_zone([]) -> {ok};
stop_all_zone([#cross_king_zone{id = _Id, pid = Pid} | T]) ->
    ?DEBUG("关闭战区:~w",[_Id]),
    Pid ! time_stop,
    stop_all_zone(T).

%% 关闭所有准备区地图
close_all_pre([]) -> ok;
close_all_pre([#cross_king_pre{map_id = MapId} | T]) ->
    ?DEBUG("关闭准备区:~w",[MapId]),
    map_mgr:stop(MapId),
    close_all_pre(T).

calc_ds_room(RoomSeq, RoomNum, DsNum) ->
    AveNum = DsNum div RoomNum,
    RemNum = DsNum rem RoomNum,
    calc_ds_room(RoomSeq, AveNum, RemNum, []).
calc_ds_room([], _AveNum, _RemNum, RoomList) -> lists:reverse(RoomList);
calc_ds_room([Seq | T], AveNum, 0, RoomList) ->
    calc_ds_room(T, AveNum, 0, [{Seq, AveNum} | RoomList]);
calc_ds_room([Seq | T], AveNum, RemNum, RoomList) ->
    calc_ds_room(T, AveNum, RemNum - 1, [{Seq, AveNum + 1} | RoomList]).
    

set_room(State, [], _, _) -> State; 
set_room(State = #state{zone_list = ZoneList}, [{Seq, RoomDsNum} | T], GfsRole, DsRole) ->
    {LastGfs, GetGfs} = get_role(GfsRole, 3),
    {LastDs, GetDs} = get_role(DsRole, RoomDsNum),
    case cross_king:start_link(Seq) of 
        {ok, Pid} ->
            set_role(GetGfs, {Seq, Pid}),
            set_role(GetDs, {Seq, Pid}),
            set_room(State#state{zone_list = [#cross_king_zone{id = Seq, pid = Pid} | ZoneList]}, T, LastGfs, LastDs);
        _Err ->
            ?ERR("至尊王者~w战区启动失败,Reason:~w",[Seq, _Err]),
            set_room(State, T, LastGfs, LastDs)
    end.

set_role([], _) -> ok;
set_role([K | T], {RoomNum, RoomPid}) ->
    NewK = K#cross_king_role{zone_id = RoomNum, zone_pid = RoomPid},
    ets:insert(ets_cross_king_roles, NewK),
    set_role(T, {RoomNum, RoomPid}).

reset_role_flag([], _, GfsRole, DsRole) -> {GfsRole, DsRole};
reset_role_flag([KingRole | T], 0, GfsRole, DsRole) ->
    NewKingRole = KingRole#cross_king_role{group = 0},
    ets:insert(ets_cross_king_roles, NewKingRole),
    reset_role_flag(T, 0, GfsRole, [NewKingRole | DsRole]);
reset_role_flag([KingRole | T], Num, GfsRole, DsRole) when Num > 0 ->
    NewKingRole = KingRole#cross_king_role{group = 1},
    ets:insert(ets_cross_king_roles, NewKingRole),
    reset_role_flag(T, Num - 1, [NewKingRole | GfsRole], DsRole).

%% 从列表里面取出Num名角色,不够也返回
get_role(Role, Num) ->
    get_role(Role, Num, []).
get_role([], _, GetRole) -> {[], GetRole};
get_role(Role, 0, GetRole) -> {Role, GetRole};
get_role([K | T], Num, GetRole) ->
    get_role(T, Num - 1, [K | GetRole]).

%% 按战斗力快速排序
qsort([]) -> [];
qsort([KingRole = #cross_king_role{fight_capacity = Fight} | T]) ->
    qsort([KR || KR = #cross_king_role{fight_capacity = KRFight} <- T, KRFight > Fight])
    ++ [KingRole] ++
    qsort([KR || KR = #cross_king_role{fight_capacity = KRFight} <- T, KRFight =< Fight]).

create_map(prepare, State) ->
    create_map(prepare, State, 200).

create_map(prepare, State = #state{pre_list = PreList}, Num) when Num =< 0 -> 
    ?INFO("创建准备区完成,共创建了~w个准备区",[length(PreList)]),
    State;
create_map(prepare, State = #state{pre_list = PreList}, Num) ->
    NewPrelist = do_create_map(prepare, PreList),
    create_map(prepare, State#state{pre_list = NewPrelist}, Num - 1).

do_create_map(prepare, PreList) ->
    case map_mgr:create(36011) of
        {false, Reason} ->
            ?ERR("创建至尊王者地图失败[MapBaseId:~w]:~s", [36011, Reason]),
            PreList;
        {ok, MapPid, MapId} ->
            CrossPre = #cross_king_pre{map_id = MapId, map_pid = MapPid},
            [CrossPre | PreList]
    end.

%% 添加新的准备区地图，增加相关映射关系
new_mapping() ->
    case map_mgr:create(36011) of
        {ok, MapPid, MapId} ->
            #cross_king_pre{map_id = MapId, map_pid = MapPid};
        _ ->
            ?ERR("新建跨服准备区地图失败"),
            #cross_king_pre{}
    end.

%% 更新准备区玩家数量
add_pre_count(MapId, MappingList) ->
    case lists:keyfind(MapId, #cross_king_pre.map_id, MappingList) of
        false -> MappingList;
        M = #cross_king_pre{role_size = Cnt} ->
            lists:keyreplace(MapId, #cross_king_pre.map_id, MappingList, M#cross_king_pre{role_size = Cnt+1})
    end.
del_pre_count(MapId, MappingList) ->
    case lists:keyfind(MapId, #cross_king_pre.map_id, MappingList) of
        false -> MappingList;
        M = #cross_king_pre{role_size = Cnt} ->
            lists:keyreplace(MapId, #cross_king_pre.map_id, MappingList, M#cross_king_pre{role_size = Cnt-1})
    end.

%% 更新准备区的玩家角色列表
add_pre_roles(KingRole, #cross_king_pre{map_id = MapId, map_pid = MapPid}) ->
    add_pre_roles(KingRole, MapId, MapPid).
add_pre_roles(KingRole, MapId, MapPid) ->
    NewKingRole = KingRole#cross_king_role{pre_map_id = MapId, pre_map_pid = MapPid},
    ets:insert(ets_cross_king_roles, NewKingRole).
del_pre_roles(RoleId) ->
    ets:delete(ets_cross_king_roles, RoleId).

update_cache(KingRole) when is_record(KingRole, cross_king_role) ->
    ets:insert(ets_cross_king_roles, KingRole);
update_cache(_) -> skip.

%% 获取角色
get_king_role(RoleId) ->
    case ets:lookup(ets_cross_king_roles, RoleId) of
        [KingRole] -> KingRole;
        _ -> undefined
    end.

get_enter_map([]) -> false;
get_enter_map([H = #cross_king_pre{role_size = RoleSize} | _T]) when RoleSize < 60 -> {ok, H};
get_enter_map([_ | T]) -> get_enter_map(T).

%% 异步回调：进出地图
apply_enter_map(Role = #role{id = RoleId}, MapId) ->
    {X1, Y1} = util:rand_list([{1140, 1500}, {1980, 1500}, {1560, 1290}, {1560, 1710}]),
    {X, Y} = {X1 + util:rand(-80, 80), Y1 + util:rand(-80, 80)},
    case map:role_enter(MapId, X, Y, Role#role{cross_srv_id = <<"center">>, event = ?event_cross_king_prepare}) of
        {ok, NewRole} -> {ok, NewRole};
        _E ->
            ?ERR("进入跨服至尊王者准备区地图失败：~w", [_E]),
            cross_king_api:inform_center({fail_enter, RoleId}),
            {ok}
    end.
apply_leave_map(Role = #role{cross_srv_id = <<"center">>}) ->
    Rand = util:rand(-100, 100),
    X = util:rand_list([1620, 1380]) + Rand,
    Y = util:rand_list([3540, 3720]) + Rand,
    case map:role_enter(10003, X, Y, Role#role{cross_srv_id = <<>>, event = ?event_no}) of
        {ok, NewRole} -> {ok, NewRole};
        _E ->
            ?ERR("退出跨服准备区地图失败：~w", [_E]),
            {ok}
    end;
apply_leave_map(_Role) ->
    ?ERR("至尊王者挑战赛, 玩家异步离开准备区地图异常[NAME:~s, SRV:~s]", [_Role#role.name, _Role#role.cross_srv_id]),
    {ok}.

%%----------------------------------------------------
%% 辅助函数
%%----------------------------------------------------
continue(StateName, State = #state{ts = Ts, timeout = Timeout}) ->
    {next_state, StateName, State, util:time_left(Timeout, Ts)}.

continue(StateName, Reply, State = #state{ts = Ts, timeout = Timeout}) ->
    {reply, Reply, StateName, State, util:time_left(Timeout, Ts)}.
