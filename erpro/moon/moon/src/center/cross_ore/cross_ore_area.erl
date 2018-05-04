%%----------------------------------------------------
%% 跨服仙府抢矿分区进程
%% @author wpf(wprehard@qq.com)
%% @end
%%----------------------------------------------------
-module(cross_ore_area).
-behaviour(gen_server).
-export([
        start_link/1
        ,bind_map/2
        ,init_ore_room/3
        ,preview_award/2
        ,reap/1
        ,get_room_id/1
        %% -------------
        ,adm_set_timer/2
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("ore.hrl").
-include("role.hrl").

-define(DEF_AWARD_TIME, 3600). %% 资源收获时间CD，单位：秒

%% --------------------------------------------------------------------
%% API functions
%% --------------------------------------------------------------------

%% Sec = integer() 秒
%% 手动设置定时器
adm_set_timer(Pid, Sec) when is_pid(Pid) ->
    Pid ! {adm_set_timer, Sec}.

%% @spec preview_award(Roles, L) -> list()
%% 根据角色ID列表预览奖励
preview_award([], L) -> L;
preview_award([{Rid, SrvId, _} | T], L) ->
    case ets:lookup(ets_ore_role_info, {Rid, SrvId}) of
        [#ore_role_info{award = AL}] ->
            preview_award(T, add_award(AL, L));
        _ -> preview_award(T, L)
    end.

%% @spec get_room_id(AreaPid) -> list()
%% 获取分区仙府列表
get_room_id(AreaPid) ->
    gen_server:call(AreaPid, get_room_id).

%% @spec reap(RoleId) -> ok | {false, Msg}
%% 收割资源
reap(#ore_role_info{award = []}) ->
    {false, ?L(<<"您的仙府资源已收割完，请等待昆仑仙境灵气再次降临您的仙府">>)};
reap(OreRI = #ore_role_info{role_id = {Rid, SrvId}, pid = RolePid, name = Name, award = AwardList, room_id = RoomId}) ->
    case ets:lookup(ets_ore_room_list, RoomId) of
        [] ->
            {false, ?L(<<"仙府不存在">>)};
        [OreRoom = #ore_room{log3 = Log3}] ->
            c_mirror_group:cast(node, SrvId, cross_ore, mail_reap_award, [{Rid, SrvId, Name}, AwardList, self_gain]),
            NewOreRI = OreRI#ore_role_info{award = [], award_time = new_award_time()},
            ets:insert(ets_ore_role_info, NewOreRI),
            Log = pack_log(reap_ore, AwardList, none, none),
            NewOR = OreRoom#ore_room{log3 = add_log(Log, Log3)},
            ets:insert(ets_ore_room_list, NewOR),
            case is_pid(RolePid) of
                true ->
                    ?DEBUG("ROlePid:~w", [RolePid]),
                    role:pack_send(RolePid, 17802, cross_ore_mgr:get_ore_room(NewOreRI, NewOR));
                false -> skip
            end,
            ?DEBUG("OreRoom:~w", [OreRoom]),
            ok
    end.

%% @spec bind_map(AreaPid, MapId) -> any();
%% bind the area with a map id
bind_map(AreaPid, MapId) ->
    AreaPid ! {bind_map, MapId}.

%% @spec init_area_timer(AreaPid, FirstId, LastId) ->
%% 初始资源产出的定时器
init_ore_room(AreaPid, NextId, LastId) ->
    AreaPid ! {init_ore_room, NextId, LastId}.

%% @spec start_link(AreaId) -> {ok,Pid} | ignore | {error,Error}
%% Starts the server
start_link(AreaId) ->
    gen_server:start_link(?MODULE, [AreaId], []).

%% --------------------------------------------------------------------
%% gen_server callback functions
%% --------------------------------------------------------------------

%% Func: init/1
%% Result: {ok, StateName, StateData}          |
%%          {ok, StateName, StateData, Timeout} |
%%          ignore                              |
%%          {stop, StopReason}
init([AreaId]) ->
    State = #cross_ore_area{id = AreaId},
    {ok, State}.

%% Func: handle_call/3
%% Result: {reply,Reply,NewState}
%%   | {reply,Reply,NewState,Timeout}
%%   | {reply,Reply,NewState,hibernate}
%%   | {noreply,NewState} | {noreply,NewState,Timeout}
%%   | {noreply,NewState,hibernate}
%%   | {stop,Reason,Reply,NewState} | {stop,Reason,NewState}

handle_call(get_room_id, _From, State = #cross_ore_area{rooms = IdList}) ->
    {reply, IdList, State};

handle_call(_Request, _From, State) ->
    {noreply, State}.

%% Func: handle_cast/2
%% Result: {noreply,NewState} | {noreply,NewState,Timeout}
%%   | {noreply,NewState,hibernate}
%%   | {stop,Reason,NewState}

handle_cast(_Msg, State) ->
    {noreply, State}.

%% Func: handle_info/2
%% Result: {noreply,NewState} | {noreply,NewState,Timeout}
%%   | {noreply,NewState,hibernate}
%%   | {stop,Reason,NewState}

%% stop
handle_info(stop, State) ->
    {stop, normal, State};

%% bind_map
handle_info({bind_map, MapId}, State = #cross_ore_area{}) ->
    {noreply, State#cross_ore_area{map_id = MapId}};

%% reset timer

%% 初始化定时器
%% 仙府ID，递增规则
handle_info({init_ore_room, NextId, LastId}, State) ->
    State1 = do_init_ore_room(State, NextId, LastId),
    NewState = State1#cross_ore_area{rooms = lists:seq(NextId, LastId)},
    {noreply, NewState};

%% 资源产出
handle_info({ore, RoomId}, State) ->
    case ets:lookup(ets_ore_room_list, RoomId) of
        [] ->
            ?DEBUG("分区~w，资源产出时未找到原来的仙府ID:~w", [State, RoomId]),
            ignore;
        [#ore_room{flag = 0}] ->
            ignore;
        [OreRoom = #ore_room{roles = Roles, lev = RoomLev, log2 = Log2}] ->
            AwardList = output_ore(RoomLev, Roles),
            ?DEBUG("仙府~w产出资源：~w", [RoomId, AwardList]),
            Log = pack_log(output_ore, AwardList, none, none),
            NewOR = OreRoom#ore_room{log2 = add_log(Log, Log2)},
            ets:insert(ets_ore_room_list, NewOR)
    end,
    {noreply, update_award_timer(State, RoomId)}; %% 更新定时器

%% combat over
%% RoleList = [{Rid, SrvId, Name, RolePid} | ...]
handle_info({rob_ore, RoomId, ComRoleList, win}, State = #cross_ore_area{}) ->
    %% 打劫成功
    RoleList = [{Rid, SrvId, Name} || {Rid, SrvId, Name, _Pid} <- ComRoleList],
    ?DEBUG("打劫成功：~w", [RoomId]),
    case ets:lookup(ets_ore_room_list, RoomId) of
        [] ->
            ?ERR("战斗结束处理未找到仙府ID:~w, ~w", [RoomId, RoleList]),
            ignore;
        [OreRoom = #ore_room{flag = 0}] ->
            ets:insert(ets_ore_room_list, OreRoom#ore_room{combat_pid = 0}),
            ok;
        [OreRoom = #ore_room{flag = 1, roles = OreRoleList, log4 = Log4}] ->
            AwardList = handle_rob(RoleList, OreRoleList),
            Log = pack_log(rob_ore, {win, AwardList}, OreRoom, RoleList),
            NewOR = OreRoom#ore_room{combat_pid = 0, log4 = add_log(Log, Log4)},
            ets:insert(ets_ore_room_list, NewOR),
            spawn(fun() -> rob_success(OreRoleList) end),
            ok
    end,
    spawn(fun() -> load_role_cache(RoleList) end),
    {noreply, State};
handle_info({rob_ore, RoomId, ComRoleList, lose}, State = #cross_ore_area{}) ->
    %% 打劫失败
    RoleList = [{Rid, SrvId, Name} || {Rid, SrvId, Name, _Pid} <- ComRoleList],
    ?DEBUG("打劫失败：~w", [RoomId]),
    case ets:lookup(ets_ore_room_list, RoomId) of
        [] ->
            ?ERR("战斗结束处理未找到仙府ID:~w, ~w", [RoomId, RoleList]),
            ignore;
        [OreRoom = #ore_room{flag = 0}] ->
            ets:insert(ets_ore_room_list, OreRoom#ore_room{combat_pid = 0}),
            ok;
        [OreRoom = #ore_room{flag = 1, log4 = Log4}] ->
            Log = pack_log(rob_ore, {lose, []}, OreRoom, RoleList),
            NewOR = OreRoom#ore_room{combat_pid = 0, log4 = add_log(Log, Log4)},
            ets:insert(ets_ore_room_list, NewOR),
            rob_failed(ComRoleList),
            ok
    end,
    spawn(fun() -> load_role_cache(RoleList) end),
    {noreply, State};

%% ComRoleList = [{Rid, SrvId, Name, RolePid} | ...]
handle_info({capture_ore, RoomId, ComRoleList, win}, State) ->
    %% 占领成功
    ?DEBUG("占领成功：~w", [RoomId]),
    RoleList = [{Rid, SrvId, Name} || {Rid, SrvId, Name, _Pid} <- ComRoleList],
    case ets:lookup(ets_ore_room_list, RoomId) of
        [] ->
            ?ERR("战斗结束处理未找到仙府ID:~w, ~w", [RoomId, ComRoleList]),
            {noreply, State};
        [OreRoom = #ore_room{flag = 0}] ->
            handle_capture_roles(RoleList, OreRoom), %% 占领者设置仙府ID
            Log = pack_log(capture_ore, win, OreRoom, RoleList),%% 添加第一条日志
            NewOR = OreRoom#ore_room{flag = 1, combat_pid = 0, robed_cnt = 0, roles = RoleList, log1 = add_log(Log, []), log2 = [], log3 = [], log4 = []},
            ets:insert(ets_ore_room_list, NewOR),
            ?DEBUG("NEWOR:~w", [NewOR]),
            spawn(fun() -> load_role_cache(RoleList) end),
            {noreply, update_award_timer(State, RoomId)};
        [OreRoom = #ore_room{id = RoomId, flag = 1, roles = OreRoleList}] ->
            handle_captured_roles(RoleList, OreRoleList), %% 被占领者清除仙府ID，返回资源
            handle_capture_roles(RoleList, OreRoom), %% 占领者设置仙府ID
            Log = pack_log(capture_ore, win, OreRoom, RoleList),%% 添加第一条日志
            NewOR = OreRoom#ore_room{combat_pid = 0, robed_cnt = 0, roles = RoleList, log1 = add_log(Log, []), log2 = [], log3 = [], log4 = []},
            ets:insert(ets_ore_room_list, NewOR),
            ?DEBUG("NEWOR:~w", [NewOR]),
            spawn(fun() -> load_role_cache(RoleList) end),
            {noreply, update_award_timer(State, RoomId)}
    end;
handle_info({capture_ore, RoomId, ComRoleList, lose}, State) ->
    %% 占领失败
    ?DEBUG("占领失败:~w", [RoomId]),
    RoleList = [{Rid, SrvId, Name} || {Rid, SrvId, Name, _Pid} <- ComRoleList],
    case ets:lookup(ets_ore_room_list, RoomId) of
        [] ->
            ?ERR("战斗结束处理未找到仙府ID:~w, ~w", [RoomId, RoleList]),
            ignore;
        [OreRoom = #ore_room{flag = 0}] ->
            ets:insert(ets_ore_room_list, OreRoom#ore_room{combat_pid = 0}),
            ok;
        [OreRoom = #ore_room{flag = 1}] ->
            %% TODO: 失败通知
            NewOR = OreRoom#ore_room{combat_pid = 0},
            ets:insert(ets_ore_room_list, NewOR),
            ok
    end,
    {noreply, State};

handle_info(_Info, State) ->
    {noreply, State}.

%% Func: terminate/3
%% Purpose: Shutdown the server
%% Result: any
terminate(normal, _) ->
    ?INFO("跨服仙府分区进程结束:normal"),
    ok;
terminate(_Reason, _State = #cross_ore_area{id = AreaId, rooms = IdList}) ->
    ?INFO("跨服仙府分区进程结束:~w", [_Reason]),
    [Begin | T] = lists:sort(IdList),
    [End | T] = lists:reverse(lists:sort(IdList)),
    case Begin < End of
        true ->
            cross_ore_mgr:info({restart_area, {AreaId, Begin, End}});
        false ->
            ?ERR("跨服仙府分区~w奔溃，检测到仙府ID列表有异常，停止重启", [AreaId])
    end,
    ok.

%% Func: code_change/4
%% Purpose: Convert process state when code is changed
%% Result: {ok, NewState, NewStateData}
code_change(_OldVsn, StateData, _Extra) ->
    {ok, StateData}.

%% ----------------------------------------------------------
%% private functions
%% ----------------------------------------------------------

%% 加载玩家角色的战斗信息
load_role_cache([]) -> ok;
load_role_cache([{Rid, SrvId, Name} | T]) ->
    NewRM = case ets:lookup(ets_ore_role_misc, {Rid, SrvId}) of
        [OreRM = #ore_role_misc{}] -> OreRM;
        _ -> #ore_role_misc{role_id = {Rid, SrvId}, name = Name}
    end,
    case c_proxy:role_lookup(by_id, {Rid, SrvId}, [#role.sex, #role.career, #role.lev, #role.hp_max, #role.mp_max, #role.attr, #role.eqm, #role.skill, #role.pet, #role.demon, #role.looks, #role.ascend]) of
        {ok, _, Data} ->
            ets:insert(ets_ore_role_misc, NewRM#ore_role_misc{combat_cache = list_to_tuple(Data)});
        _ -> ets:insert(ets_ore_role_misc, NewRM)
    end,
    load_role_cache(T);
load_role_cache({RoleId, Name, Sex, Career, Lev, HpMax, MpMax, Attr, Eqm, Skill, PetBag, RoleDemon, Looks, Ascend}) ->
    NewRM = case ets:lookup(ets_ore_role_misc, RoleId) of
        [OreRM = #ore_role_misc{}] -> OreRM;
        _ -> #ore_role_misc{role_id = RoleId, name = Name}
    end,
    ets:insert(ets_ore_role_misc, NewRM#ore_role_misc{combat_cache = {Sex, Career, Lev, HpMax, MpMax, Attr, Eqm, Skill, PetBag, RoleDemon, Looks, Ascend}}),
    ok.

%% 获取打劫资源
rob_award([], AL1, AL2) -> {AL1, AL2};
rob_award([{BaseId, IsBind, Num} | T], AL1, AL2) ->
    X = util:floor(Num * 0.1),
    case X > 0 of
        true ->
            rob_award(T, [{BaseId, IsBind, Num - X} | AL1], [{BaseId, IsBind, X} | AL2]);
        false ->
            rob_award(T, [{BaseId, IsBind, Num} | AL1], AL2)
    end.

%% 合并资源
add_award([], L) -> L;
add_award([{BaseId, Bind, Num} | T], L) ->
    case lists:keyfind(BaseId, 1, L) of
        {BaseId, Bind, OldNum} ->
            add_award(T, lists:keyreplace(BaseId, 1, L, {BaseId, Bind, OldNum+Num}));
        _ ->
            add_award(T, [{BaseId, Bind, Num} | L])
    end.

%% 分配资源
split_award(L, 1) ->
    [L];
split_award(L, 2) ->
    [
        [{BaseId, Bind, (Num div 2)} || {BaseId, Bind, Num} <- L]
        ,[{BaseId, Bind, Num-(Num div 2)} || {BaseId, Bind, Num} <- L]
    ];
split_award(L, 3) ->
    [ 
        [{BaseId, Bind, (Num div 3)} || {BaseId, Bind, Num} <- L]
        ,[{BaseId, Bind, (Num div 3)} || {BaseId, Bind, Num} <- L]
        ,[{BaseId, Bind, Num-2*(Num div 3)} || {BaseId, Bind, Num} <- L]
    ];
split_award(_, _) ->
    [].

collect_award(L) ->
    collect_award(L, []).
collect_award([], L) -> L;
collect_award([{Rid, SrvId, _} | T], L) ->
    case ets:lookup(ets_ore_role_info, {Rid, SrvId}) of
        [RoleInfo = #ore_role_info{award = AL}] ->
            {NewAL, AddList} = rob_award(AL, [], []),
            ets:insert(ets_ore_role_info, RoleInfo#ore_role_info{award = NewAL}),
            collect_award(T, add_award(AddList, L));
        _ -> collect_award(T, L)
    end.

send_award([], _OreRoleList, _AL) -> ok;
send_award([{Rid, SrvId, Name} | T], OreRoleList, AL) ->
    A = util:rand_list(AL),
    c_mirror_group:cast(node, SrvId, cross_ore, mail_rob_award, [{Rid, SrvId, Name}, OreRoleList, A]),
    send_award(T, OreRoleList, AL -- [A]);
send_award([_ | T], OreRoleList, AL) ->
    send_award(T, OreRoleList, AL).

%% 处理打劫
handle_rob(RoleList, OreRoleList) ->
    L = collect_award(OreRoleList),
    SendList = split_award(L, length(RoleList)),
    send_award(RoleList, OreRoleList, SendList),
    L.

%% 打劫失败返回给打劫者提示
rob_failed([]) -> ok;
rob_failed([{_Rid, _SrvId, _Name, Pid} | T]) ->
    case is_pid(Pid) of
        true ->
            role:pack_send(Pid, 17810, {?false, ?L(<<"很遗憾，打劫失败，看来打劫也不是那么好打的啊。">>)});
        _ -> ?ERR("跨服仙府检测到角色PID异常:~w", [Pid])
    end,
    rob_failed(T).
%% 打劫成功通知主人
rob_success([]) -> ok;
rob_success([{Rid, SrvId, Name, _Pid} | T]) ->
    c_mirror_group:cast(node, SrvId, mail_mgr, deliver, [{Rid, SrvId, Name}, {?L(<<"仙府争夺">>), ?L(<<"您的仙府被打劫了，府中资源被无情掠夺，可前去仙府记事查看记录">>), [], []}]),
    rob_success(T);
rob_success([{Rid, SrvId, Name} | T]) ->
    c_mirror_group:cast(node, SrvId, mail_mgr, deliver, [{Rid, SrvId, Name}, {?L(<<"仙府争夺">>), ?L(<<"您的仙府被打劫了，府中资源被无情掠夺，可前去仙府记事查看记录">>), [], []}]),
    rob_success(T).

%% 处理被占领
handle_captured_roles(_RoleList, []) -> ok;
handle_captured_roles(RoleList, [{Rid, SrvId, Name} | T]) ->
    case ets:lookup(ets_ore_role_info, {Rid, SrvId}) of
        [] -> handle_captured_roles(RoleList, T);
        [RoleInfo = #ore_role_info{award = AwardList}] ->
            %% 被占领角色邮件返回资源
            ets:insert(ets_ore_role_info, RoleInfo#ore_role_info{room_id = 0, award = [], award_time = 0}),
            c_mirror_group:cast(node, SrvId, cross_ore, mail_capture_award, [{Rid, SrvId, Name}, {win, RoleList}, AwardList]),
            handle_captured_roles(RoleList, T)
    end.
%% 处理占领方
handle_capture_roles([], _OreRoom) -> ok;
handle_capture_roles([{Rid, SrvId, _Name} | T], OreRoom = #ore_room{id = RoomId}) ->
    case ets:lookup(ets_ore_role_info, {Rid, SrvId}) of
        [] ->
            handle_capture_roles(T, OreRoom);
        [RoleInfo = #ore_role_info{}] ->
            ets:insert(ets_ore_role_info, RoleInfo#ore_role_info{room_id = RoomId, award_time = new_award_time()}),
            handle_capture_roles(T, OreRoom)
    end.

%% 产出资源，一式三份
output_ore(RoomLev, Roles) ->
    Add = cross_ore_data:get_award(RoomLev),
    output_ore(Add, Roles, []).
output_ore(_Add, [], L) -> L;
output_ore(Add, [{Rid, SrvId, _Name} | T], L) ->
    case ets:lookup(ets_ore_role_info, {Rid, SrvId}) of
        [] ->
            ?ERR("资源产出时未找到原来的仙府ID对应的玩家信息"),
            output_ore(Add, T, L);
        [RI = #ore_role_info{award = OldAward}] ->
            NewRI = RI#ore_role_info{award = add_award(Add, OldAward), award_time = new_award_time()},
            ets:insert(ets_ore_role_info, NewRI),
            output_ore(Add, T, add_award(Add, L))
    end.

%% 产出资源 时间
new_award_time() ->
    util:unixtime() + ?DEF_AWARD_TIME.

%% 更新定时器，产出资源
update_award_timer(State, []) -> State;
update_award_timer(State, [RoomId | T]) ->
    NewState = update_award_timer(State, RoomId),
    update_award_timer(NewState, T);
update_award_timer(State = #cross_ore_area{timers = TimerList}, RoomId) ->
    Ref = erlang:send_after(?DEF_AWARD_TIME*1000, self(), {ore, RoomId}),
    case lists:keyfind(RoomId, 1, TimerList) of
        false -> State#cross_ore_area{timers = [{RoomId, Ref} | TimerList]};
        {RoomId, OldRef} ->
            erlang:cancel_timer(OldRef),
            State#cross_ore_area{timers = lists:keyreplace(RoomId, 1, TimerList, {RoomId, Ref})}
    end.

%% 分区建立后初始当前地图里仙府资源产出定时器
do_init_ore_room(State, NextId, LastId) when NextId > LastId ->
    State;
do_init_ore_room(State, NextId, LastId) ->
    NewState = update_award_timer(State, NextId),
    do_init_ore_room(NewState, NextId + 1, LastId).

%% 组装日志
%% Reault = 1 | 0
%% Roles = {Rid, SrvId, Name}
%% Items = {Id, Bind, Num}
%% Time = time()
%% 打劫
pack_log(rob_ore, {win, AwardList}, _OreRoom, RoleList) ->
    {1, RoleList, AwardList, util:unixtime()};
pack_log(rob_ore, {lose, _}, _OreRoom, RoleList) ->
    {2, RoleList, [], util:unixtime()};
pack_log(rob_ore, _, _, _) ->
    {0, [], [], 0};
%% 占领
pack_log(capture_ore, win, #ore_room{name = RoomName, lev = RoomLev}, _) ->
    {RoomName, RoomLev, util:unixtime()};
pack_log(capture_ore, win, _, _) ->
    {<<>>, 0, util:unixtime()};
pack_log(capture_ore, lose, _, RoleList) ->
    {4, RoleList, [], util:unixtime()};
%% 资源产出
pack_log(output_ore, AwardList, _, _) when is_list(AwardList) ->
    {AwardList, util:unixtime()};
pack_log(output_ore, _, _, _) ->
    {[], util:unixtime()};
%% 资源收割
pack_log(reap_ore, AwardList, _, _) when is_list(AwardList) ->
    {AwardList, util:unixtime()};
pack_log(reap_ore, _, _, _) ->
    {[], util:unixtime()}.

%% 增加日志
add_log(Log, []) -> [Log];
add_log(Log, [L1]) -> [Log, L1];
add_log(Log, [L1, L2]) -> [Log, L1, L2];
add_log(Log, [L1, L2, L3]) -> [Log, L1, L2, L3];
add_log(Log, [L1, L2, L3, L4]) -> [Log, L1, L2, L3, L4];
add_log(Log, [L1, L2, L3, L4, _L5]) -> [Log, L1, L2, L3, L4];
add_log(Log, _) -> [Log].
