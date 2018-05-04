%% --------------------------------------------------------------------
%% 跨服仙府抢矿管理进程
%% @author wpf (wprehard@qq.com)
%% @end
%% --------------------------------------------------------------------
-module(cross_ore_mgr).
-behaviour(gen_fsm).

%% export functions
-export([
        start_link/0
        ,info/1
        ,get_status/0
        ,get_areas/0
        ,get_ore_room/1
        ,get_ore_room/2
        ,get_room_list/1
        ,get_log/1
        ,role_enter/4
        ,role_enter/3
        ,role_leave/4
        ,call_animal/2
        ,preview_upgrade_animal/2
        ,upgrade_animal/2
        ,reap/1
        ,rob_ore/4
        ,capture_ore/4
        ,combat_over/3
        ,abandon_room/1
        ,broadcast_srv/1
        ,role_login/4
        ,role_logout/2
        %% 回调函数
        ,apply_enter_map/2
        ,apply_leave_map/1
        ,sync_leave_map/1
    ]).
%% debug functions
-export([debug/1]).
%% adm functions
-export([gm_status/0]).
%% gen_fsm callbacks
-export([init/1, handle_event/3,handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).
%% state functions
-export([idel/2, prepare/2, active/2, stop/2]).

%% include
-include("common.hrl").
-include("role.hrl").
-include("ore.hrl").
-include("map.hrl").
-include("pos.hrl").
-include("combat.hrl").
-include("pet.hrl").

%% macro
-define(DEF_PREPARE_INTERVAL_TIME,  60).       %% 活动准备时间(秒)
-define(DEF_STOP_INTERVAL_TIME,     60).      %% 活动结束后等待时间(秒)
%% 状态值
-define(cross_ore_status_idel, 0).      %% 空闲
-define(cross_ore_status_prepare, 1).   %% 活动准备
-define(cross_ore_status_active, 2).    %% 活动开始
-define(cross_ore_status_stop, 3).      %% 活动结束

%% --------------------------------------------------------------------
%% API functions
%% --------------------------------------------------------------------

%% @spec get_status() -> {ok, {Status, Time}}
get_status() ->
    gen_fsm:sync_send_all_state_event(?MODULE, get_status).

%% @spec get_areas() -> {ok, Areas}
get_areas() ->
    AreaList = gen_fsm:sync_send_all_state_event(?MODULE, get_areas),
    [{Id, Cnt} || #ore_area{id = Id, cnt = Cnt} <- AreaList].

%% @spec get_ore_room(Id) -> none | term()
%% Id = {Rid, SrvId} | RoomId
get_ore_room(RoleId = {_, _}) ->
    case ets:lookup(ets_ore_role_info, RoleId) of
        [] -> no_role;
        [#ore_role_info{room_id = 0}] -> none_roleroom;
        [RoleInfo = #ore_role_info{room_id = RoomId, award = Award, award_time = T}] ->
            {L1, L2} = get_all_animal([RoleInfo]), 
            case ets:lookup(ets_ore_room_list, RoomId) of
                [] -> none_room;
                [#ore_room{name = Name, lev = Lev, roles = Roles}] ->
                    case T > util:unixtime() of
                        true ->
                            {RoomId, Name, Lev, Roles, Award, T-util:unixtime(), L1 ++ L2};
                        false -> 
                            {RoomId, Name, Lev, Roles, Award, 0, L1 ++ L2}
                    end
            end
    end;
get_ore_room(RoomId) ->
    case ets:lookup(ets_ore_room_list, RoomId) of
        [] -> none;
        [#ore_room{name = Name, lev = Lev, combat_pid = 0, flag = Flag, roles = Roles}] ->
            {L1, L2} = get_all_animal(Roles), 
            {RoomId, Name, Lev, Flag, 0, Roles, cross_ore_area:preview_award(Roles, []), get_most_nb_animal(L1, L2)};
        [#ore_room{name = Name, lev = Lev, flag = Flag, roles = Roles}] ->
            {L1, L2} = get_all_animal(Roles), 
            %% 战斗中
            {RoomId, Name, Lev, Flag, 1, Roles, cross_ore_area:preview_award(Roles, []), get_most_nb_animal(L1, L2)}
    end.

get_ore_room(RoleInfo = #ore_role_info{room_id = RoomId, award = Award, award_time = T}, #ore_room{name = Name, lev = Lev, roles = Roles}) ->
    {L1, L2} = get_all_animal([RoleInfo]), 
    case T > util:unixtime() of
        true ->
            {RoomId, Name, Lev, Roles, Award, T-util:unixtime(), L1 ++ L2};
        false -> 
            {RoomId, Name, Lev, Roles, Award, 0, L1 ++ L2}
    end.

get_rooms([], L) -> lists:reverse(L);
get_rooms([RoomId | T], L) ->
    case ets:lookup(ets_ore_room_list, RoomId) of
        [#ore_room{id = Id, name = Name, lev = Lev, flag = Flag}] ->
            get_rooms(T, [{Id, Name, Lev, Flag} | L]);
        _ -> get_rooms(T, L)
    end.

get_room_list(MapId) ->
    case gen_fsm:sync_send_all_state_event(?MODULE, {get_room_id, MapId}) of
        {ok, Pid} ->
            IdList = cross_ore_area:get_room_id(Pid),
            ?DEBUG("IDLIST:~w", [IdList]),
            get_rooms(lists:sort(IdList), []);
        _ -> []
    end.

%% @spec get_log(RoleId) -> {list(), list(), list(), list()}
get_log(RoleId) ->
    case ets:lookup(ets_ore_role_info, RoleId) of
        [] -> none;
        [#ore_role_info{room_id = 0}] -> none;
        [#ore_role_info{room_id = RoomId}] ->
            case ets:lookup(ets_ore_room_list, RoomId) of
                [] -> {[], [], [], []};
                [#ore_room{log1 = Log1, log2 = Log2, log3 = Log3, log4 = Log4}] ->
                    {Log1, Log2, Log3, Log4}
            end
    end.

%% @spec check_can_capture(RoleIds) -> ok | {false, Msg}
%% RoleIds = [{Rid, SrvId} | ...]
%% @doc 检查角色是否还可以占领仙府
check_can_capture([]) -> ok;
check_can_capture([RoleId | T]) ->
    case ets:lookup(ets_ore_role_info, RoleId) of
        [#ore_role_info{name = Name, room_id = RoomId}] when RoomId =/= 0 ->
            {false, util:fbin(?L(<<"~s 已占领仙府，无法争夺其他仙府">>), [Name])};
        _ -> check_can_capture(T)
    end.

%% @spec check_can_rob(RoleIds) -> ok | {false, Msg}
%% RoleIds = [{Rid, SrvId} | ...]
%% @doc 检查角色是否还可以打劫仙府
check_can_rob([]) -> ok;
check_can_rob([RoleId | T]) ->
    case ets:lookup(ets_ore_role_misc, RoleId) of
        [#ore_role_misc{name = Name, rob_cnt = RobCnt}] when RobCnt > 10 ->
            {false, util:fbin(?L(<<"~s 今天已经打劫10次了，无法再打劫仙府">>), [Name])};
        _ -> check_can_rob(T)
    end.

%% @spec check_has_self(IdLsit, Roles) -> true | false
%% IdList = [{Rid, Srv} | ...]
%% Roles = [{Rid, SrvId, Name} | ...]
check_has_self(_, []) -> false;
check_has_self([], _RoleList) -> false;
check_has_self([{Rid, SrvId} | T], RoleList) ->
    case do_check_has_self({Rid, SrvId}, RoleList) of
        true -> true;
        false -> check_has_self(T, RoleList)
    end.
do_check_has_self(_, []) ->
    false;
do_check_has_self({Rid, SrvId}, [{Rid, SrvId, _} | _T]) ->
    true;
do_check_has_self({Rid, SrvId}, [_ | T]) ->
    do_check_has_self({Rid, SrvId}, T).

%% @spec rob_ore(RoleId, RolePid, RoleIdList, RoomId) -> any()
%% @doc 打劫(任意三人组队)
rob_ore(RoleId, RolePid, RoleIdList, RoomId) ->
    case ets:lookup(ets_ore_role_misc, RoleId) of
        [#ore_role_misc{rob_cnt = RobCnt}] when RobCnt >= 10 ->
            role:pack_send(RolePid, 17810, {?false, ?L(<<"您今天已经打劫10次了，避免过于操劳，您还是休息下吧。">>)});
        [#ore_role_misc{last_rob = RoomId, last_time = LastTime}] ->
            case util:unixtime() > LastTime + ?ROB_CD of
                false ->
                    role:pack_send(RolePid, 17810, {?false, ?L(<<"您刚刚打劫过这个仙府，请先放过人家吧。">>)});
                true ->
                    case check_can_rob(RoleIdList) of
                        {false, Msg} ->
                            role:pack_send(RolePid, 17810, {?false, Msg});
                        ok ->
                            gen_fsm:send_all_state_event(?MODULE, {rob_ore, RoleId, RolePid, RoleIdList, RoomId})
                    end
            end;
        _ ->
            case check_can_rob(RoleIdList) of
                {false, Msg} ->
                    role:pack_send(RolePid, 17810, {?false, Msg});
                ok ->
                    gen_fsm:send_all_state_event(?MODULE, {rob_ore, RoleId, RolePid, RoleIdList, RoomId})
            end
    end.

%% @spec capture_ore(RoleId, RolePid, RoleIdList, RoomId) -> any()
%% RoleIdList = [{Rid, SrvId} | ...]
%% @doc 打劫(任意三人组队)
capture_ore(RoleId, RolePid, RoleIdList, RoomId) ->
    case ets:lookup(ets_ore_role_info, RoleId) of
        [#ore_role_info{room_id = Id}] when Id =/= 0 ->
            role:pack_send(RolePid, 17811, {?false, ?L(<<"您已占领仙府，无法争夺其他仙府">>)});
        _ ->
            case check_can_capture(RoleIdList) of
                {false, Msg} ->
                    role:pack_send(RolePid, 17811, {?false, Msg});
                ok ->
                    gen_fsm:send_all_state_event(?MODULE, {capture_ore, RoleId, RolePid, RoleIdList, RoomId})
            end
    end.

%% @spec combat_over(Referees, Winner, Loser) -> any()
%% @doc 战斗结束
combat_over(Data = [{Type, _AreaPid, _RoomId, _RoomLev, _RoleIdList}], [], Loser) when Type =:= rob_ore orelse Type =:= capture_ore ->
    ?ERR("跨服仙府战斗结束，胜利方列表为空:~w~n~w", [Data, Loser]),
    ignore;
combat_over([{Type, AreaPid, RoomId, _RoomLev, [H | _]}], Winner, Loser) when Type =:= rob_ore orelse Type =:= capture_ore ->
    TmpWinner1 = [{Rid, SrvId} || #fighter{rid = Rid, srv_id = SrvId, type = ?fighter_type_role} <- Winner],
    TmpWinner2 = [{Rid, SrvId, Name, Pid} || #fighter{rid = Rid, srv_id = SrvId, name = Name, pid = Pid, type = ?fighter_type_role, is_clone = ?false} <- Winner],
    TmpLoser = [{Rid, SrvId, Name, Pid} || #fighter{rid = Rid, srv_id = SrvId, name = Name, pid = Pid, type = ?fighter_type_role} <- Loser],
    case lists:member(H, TmpWinner1) of
        true -> %% 打劫&占领 成功
            AreaPid ! {Type, RoomId, TmpWinner2, win};
        false when TmpWinner2 =/= [] -> %%打劫&占领方队长未进入战斗，但打劫&占领方赢得战斗了
            AreaPid ! {Type, RoomId, TmpWinner2, win};
        false -> %% 打劫&占领方，输了
            AreaPid ! {Type, RoomId, TmpLoser, lose}
    end;
combat_over(_, _, _) ->
    ignore.

%% @spec abandon_room(RoleId) -> ok | {false, Msg}
%% 放弃仙府
abandon_room(RoleId) ->
    gen_fsm:sync_send_all_state_event(?MODULE, {abandon_room, RoleId}).

%% @spec call_animal(Roleid, AnimalId) -> {false, Msg} | ok
call_animal(RoleId, AnimalId) ->
    gen_fsm:sync_send_all_state_event(?MODULE, {call_animal, RoleId, AnimalId}).

%% @spec preview_upgrade_animal(Roleid, AnimalId) -> {false, Msg} | {ok, NewLev}
preview_upgrade_animal(RoleId, AnimalId) ->
    gen_fsm:sync_send_all_state_event(?MODULE, {preview_upgrade_animal, RoleId, AnimalId}).

%% @spec upgrade_animal(Roleid, AnimalId) -> {false, Msg} | ok
upgrade_animal(RoleId, AnimalId) ->
    gen_fsm:sync_send_all_state_event(?MODULE, {upgrade_animal, RoleId, AnimalId}).

%% @spec reap(RoleId) -> {false, Msg} | ok
reap(RoleId) ->
    gen_fsm:sync_send_all_state_event(?MODULE, {reap, RoleId}).

%% @spec role_enter(RoleId, RolePid, AreaId) -> any()
role_enter(RoleId, RoleName, RolePid, AreaId) ->
    gen_fsm:send_all_state_event(?MODULE, {role_enter, RoleId, RoleName, RolePid, AreaId}).

%% @spec role_enter(EnterRoles, AreaId) -> any()
%% EnterRoles = [{RoleId, RoleName, RolePid} | ...]
role_enter(RolePid, EnterRoles, AreaId) ->
    gen_fsm:send_all_state_event(?MODULE, {role_enter, RolePid, EnterRoles, AreaId}).

%% @spec role_leave(RoleId, RolePid, MapId) -> any()
role_leave(RoleId, RoleName, RolePid, MapId) ->
    gen_fsm:send_all_state_event(?MODULE, {role_leave, RoleId, RoleName, RolePid, MapId}).

%% @spec role_login(RoleId, RoleName, RolePid, MapId) -> any()
role_login(RoleId, RoleName, RolePid, MapId) ->
    gen_fsm:send_all_state_event(?MODULE, {role_login, RoleId, RoleName, RolePid, MapId}).

%% @spec role_logout(RoleId, RolePid, MapId) -> any()
role_logout(RoleId, MapId) ->
    gen_fsm:send_all_state_event(?MODULE, {role_logout, RoleId, MapId}).

%% @spec info(Msg) -> any()
%% Msg = term()
info(Msg) ->
    gen_fsm:send_all_state_event(?MODULE, Msg).

%% @spec start_link() -> {ok,Pid} | ignore | {error,Error}
%% Starts the server
start_link() ->
    gen_fsm:start_link({local, ?MODULE}, ?MODULE, [], []).

%% gm命令 - 活动状态
gm_status() ->
    gen_fsm:send_event(?MODULE, timeout).

%% 打印信息
debug(Type) ->
    info({debug, Type}).

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
    init_table(),
    %% load_data(), %% 重载仙府神兽等数据
    dets:open_file(dets_cross_ore_cache, [{file, "../var/cross_ore_cache.dets"}, {keypos, 1}, {type, set}]),
    State = #cross_ore_state{next_room_id = 1, next_area_id = 1},
    case get_next_act_time() of
        now ->
            load_cache(), %% 活动期间重启或启动，重载一次缓存数据
            CdSec = 1,
            NewState = State#cross_ore_state{ts = util:unixtime(), t_cd = CdSec},
            ?INFO("[~w] 启动完成:~w", [?MODULE, CdSec]),
            {ok, idel, NewState, CdSec * 1000};
        CdSec ->
            load_cache(), %% 重载活动缓存数据(主要是玩家神兽)
            NewState = State#cross_ore_state{ts = util:unixtime(), t_cd = CdSec},
            ?INFO("[~w] 启动完成:~w", [?MODULE, CdSec]),
            {ok, idel, NewState, CdSec * 1000}
    end.

%% Func: handle_event/3
%% Returns: {next_state, NextStateName, NextStateData}          |
%%          {next_state, NextStateName, NextStateData, Timeout} |
%%          {stop, Reason, NewStateData}

%% 增加分区信息
handle_event({add_area, Num}, active, State) ->
    NewState = add_area(State, Num),
    continue(active, NewState);
handle_event({add_area, _Num}, StateName, State) ->
    ?INFO("不在活动active时间段内，无法增加分区"),
    continue(StateName, State);

%% 分区奔溃
handle_event({restart_area, {AreaId, BeginRoomId, EndRoomId}}, StateName, State) ->
    NewState = restart_area(State, {AreaId, BeginRoomId, EndRoomId}),
    ?INFO("成功重启分区:~w", [AreaId]),
    continue(StateName, NewState);

handle_event({role_enter, RoleId, RoleName, RolePid, AreaId}, active, State = #cross_ore_state{areas = AreaList}) ->
    case lists:keyfind(AreaId, #ore_area.id, AreaList) of
        false -> %% 分区不存在
            role:pack_send(RolePid, 17804, {?false, ?L(<<"当前网络异常，暂时无法操作">>)}),
            continue(active, State);
        #ore_area{cnt = Cnt} when Cnt >= ?ORE_AREA_ROLE_MAX ->
            role:pack_send(RolePid, 17804, {?false, ?L(<<"当前仙府分区人数已满">>)}),
            continue(active, State);
        OreArea = #ore_area{map_id = MapId, cnt = Cnt} ->
            role:apply(async, RolePid, {cross_ore_mgr, apply_enter_map, [MapId]}),
            NewAL = lists:keyreplace(AreaId, #ore_area.id, AreaList, OreArea#ore_area{cnt = Cnt + 1}),
            update_role_info(RoleId, RoleName, RolePid),
            update_role_misc(RoleId, RoleName),
            continue(active, State#cross_ore_state{areas = NewAL})
    end;
handle_event({role_enter, _, _, RolePid, _}, prepare, State) ->
    role:pack_send(RolePid, 17804, {?false, ?L(<<"跨服仙府争夺战即将开始，在准备时间结束后可以参加">>)}),
    continue(prepare, State);
handle_event({role_enter, _, _, RolePid, _}, StateName, State) ->
    role:pack_send(RolePid, 17804, {?false, ?L(<<"跨服仙府争夺战每周一0点至周三24点开启，18000以上战力玩家可报名参加">>)}),
    continue(StateName, State);

%% 带队进入
handle_event({role_enter, RolePid, EnterRoles, AreaId}, active, State = #cross_ore_state{areas = AreaList}) ->
    Num = length(EnterRoles),
    case lists:keyfind(AreaId, #ore_area.id, AreaList) of
        false -> %% 分区不存在
            role:pack_send(RolePid, 17804, {?false, ?L(<<"当前网络异常，暂时无法操作">>)}),
            continue(active, State);
        #ore_area{cnt = Cnt} when (Cnt + Num) >= ?ORE_AREA_ROLE_MAX ->
            role:pack_send(RolePid, 17804, {?false, ?L(<<"当前仙府分区人数已满额，请重新选择分区进入">>)}),
            continue(active, State);
        OreArea = #ore_area{map_id = MapId, cnt = Cnt} ->
            %% 随机点
            X = 2160 + util:rand(-720, 720),
            Y = 2400 + util:rand(-1350, 1350),
            [role:apply(async, Pid, {cross_ore_mgr, apply_enter_map, [{MapId, X, Y}]}) || {_, _, Pid} <- EnterRoles],
            [update_role_info(Id, Name, Pid) || {Id, Name, Pid} <- EnterRoles],
            [update_role_misc(Id, Name) || {Id, Name, _Pid} <- EnterRoles],
            NewAL = lists:keyreplace(AreaId, #ore_area.id, AreaList, OreArea#ore_area{cnt = Cnt + Num}),
            continue(active, State#cross_ore_state{areas = NewAL})
    end;
handle_event({role_enter, RolePid, _, _}, prepare, State) ->
    role:pack_send(RolePid, 17804, {?false, ?L(<<"跨服仙府争夺战即将开始，在准备时间结束后可以参加">>)}),
    continue(prepare, State);
handle_event({role_enter, RolePid, _, _}, StateName, State) ->
    role:pack_send(RolePid, 17804, {?false, ?L(<<"跨服仙府争夺战每周一0点至周三24点开启，18000以上战力玩家可报名参加">>)}),
    continue(StateName, State);

handle_event({enter_failed, MapId}, StateName, State = #cross_ore_state{areas = AreaList}) ->
    case lists:keyfind(MapId, #ore_area.map_id, AreaList) of
        false ->
            continue(StateName, State);
        OreArea = #ore_area{map_id = MapId, cnt = Cnt} ->
            NewAL = lists:keyreplace(MapId, #ore_area.map_id, AreaList, OreArea#ore_area{cnt = Cnt - 1}),
            continue(StateName, State#cross_ore_state{areas = NewAL})
    end;

handle_event({role_leave, RoleId, RoleName, RolePid, MapId}, StateName, State = #cross_ore_state{areas = AreaList}) ->
    case lists:keyfind(MapId, #ore_area.map_id, AreaList) of
        false ->
            continue(StateName, State);
        OreArea = #ore_area{map_id = MapId, cnt = Cnt} ->
            role:apply(async, RolePid, {cross_ore_mgr, apply_leave_map, []}),
            NewOreArea = OreArea#ore_area{cnt = Cnt - 1},
            NewAL = lists:keyreplace(MapId, #ore_area.map_id, AreaList, NewOreArea),
            update_role_info(RoleId, RoleName, 0),
            continue(StateName, State#cross_ore_state{areas = NewAL})
    end;

handle_event({role_login, RoleId, RoleName, RolePid, MapId}, StateName, State = #cross_ore_state{areas = AreaList}) ->
    case lists:keyfind(MapId, #ore_area.map_id, AreaList) of
        false ->
            continue(StateName, State);
        OreArea = #ore_area{cnt = Cnt} ->
            NewOreArea = OreArea#ore_area{cnt = Cnt + 1},
            NewAL = lists:keyreplace(MapId, #ore_area.map_id, AreaList, NewOreArea),
            update_role_info(RoleId, RoleName, RolePid),
            continue(StateName, State#cross_ore_state{areas = NewAL})
    end;

handle_event({role_logout, RoleId, MapId}, StateName, State = #cross_ore_state{areas = AreaList}) ->
    case lists:keyfind(MapId, #ore_area.map_id, AreaList) of
        false ->
            continue(StateName, State);
        OreArea = #ore_area{cnt = Cnt} ->
            NewOreArea = OreArea#ore_area{cnt = Cnt - 1},
            NewAL = lists:keyreplace(MapId, #ore_area.map_id, AreaList, NewOreArea),
            update_role_info(RoleId, <<>>, 0),
            continue(StateName, State#cross_ore_state{areas = NewAL})
    end;

%% rob
handle_event({rob_ore, RoleId, RolePid, RoleIdList, RoomId}, active, State) ->
    ?DEBUG("ROOMID:~w", [RoomId]),
    case ets:lookup(ets_ore_room_list, RoomId) of
        [] ->
            role:pack_send(RolePid, 17810, {?false, ?L(<<"仙府不存在">>)});
        [#ore_room{flag = 0}] ->
            role:pack_send(RolePid, 17810, {?false, ?L(<<"这个仙府还未有主人，无法打劫">>)});
        [#ore_room{combat_pid = CombatPid}] when is_pid(CombatPid) ->
            role:pack_send(RolePid, 17810, {?false, ?L(<<"这个仙府的人家正在忙，等人家忙完了再上吧。">>)});
        [#ore_room{robed_cnt = RobedCnt}] when RobedCnt >= 10 ->
            role:pack_send(RolePid, 17810, {?false, ?L(<<"这间仙府看来被人光顾很多次了，估计没什么东西了，就不打劫它好了。">>)});
        [OreRoom = #ore_room{id = RoomId, roles = Roles, lev = RoomLev, area_pid = AreaPid, robed_cnt = RobedCnt}] ->
            case check_has_self([RoleId | RoleIdList], Roles) of
                true ->
                    role:pack_send(RolePid, 17810, {?false, ?L(<<"不能打劫队友的仙府">>)});
                false ->
                    spawn(fun() ->
                                AtkList = to_fighter([RolePid | RoleIdList]),
                                DfdList = convert_fighter_clone(OreRoom),
                                case combat:start(?combat_type_c_ore, [{rob_ore, AreaPid, RoomId, RoomLev, [RoleId | RoleIdList]}], AtkList, DfdList) of
                                    {ok, CombatPid} ->
                                        NewOR = OreRoom#ore_room{combat_pid = CombatPid, robed_cnt = RobedCnt + 1},
                                        ets:insert(ets_ore_room_list, NewOR), %% 更新仙府战斗信息
                                        add_rob_cnt([RoleId | RoleIdList], RoomId),
                                        ok;
                                    _ ->
                                        role:pack_send(RolePid, 17810, {?false, ?L(<<"战斗发起失败">>)})
                                end
                        end)
            end
    end,
    continue(active, State);

%% capture
handle_event({capture_ore, RoleId, RolePid, RoleIdList, RoomId}, active, State) ->
    ?DEBUG("ROOMID:~w", [RoomId]),
    case ets:lookup(ets_ore_room_list, RoomId) of
        [] ->
            role:pack_send(RolePid, 17811, {?false, ?L(<<"仙府不存在">>)});
        [#ore_room{combat_pid = CombatPid}] when is_pid(CombatPid) ->
            role:pack_send(RolePid, 17811, {?false, ?L(<<"这个仙府的人家正在忙，等人家忙完了再上吧。">>)});
        [OreRoom = #ore_room{id = RoomId, lev = RoomLev, roles = Roles, area_pid = AreaPid}] ->
            case check_has_self([RoleId | RoleIdList], Roles) of
                true ->
                    role:pack_send(RolePid, 17810, {?false, ?L(<<"不能争夺队友的仙府">>)});
                false ->
                    spawn(fun() ->
                                AtkList = to_fighter([RolePid | RoleIdList]),
                                DfdList = convert_fighter_clone(OreRoom),
                                case combat:start(?combat_type_c_ore, [{capture_ore, AreaPid, RoomId, RoomLev, [RoleId | RoleIdList]}], AtkList, DfdList) of
                                    {ok, CombatPid} ->
                                        NewOR = OreRoom#ore_room{combat_pid = CombatPid},
                                        ets:insert(ets_ore_room_list, NewOR), %% 更新仙府战斗信息
                                        ok;
                                    _ ->
                                        role:pack_send(RolePid, 17811, {?false, ?L(<<"战斗发起失败">>)})
                                end
                        end)
            end
    end,
    continue(active, State);

handle_event(_Event, StateName, State) ->
    ?DEBUG("跨服仙府抢矿管理进程在~w状态下，收到异常消息~w, State:~w", [StateName, _Event, State]),
    continue(StateName, State).

%% Func: handle_sync_event/4
%% Returns: {next_state, NextStateName, NextStateData}            |
%%          {next_state, NextStateName, NextStateData, Timeout}   |
%%          {reply, Reply, NextStateName, NextStateData}          |
%%          {reply, Reply, NextStateName, NextStateData, Timeout} |
%%          {stop, Reason, NewStateData}                          |
%%          {stop, Reason, Reply, NewStateData}

handle_sync_event(get_status, _From, StateName, State = #cross_ore_state{ts = Ts, t_cd = Tcd}) ->
    Fun = fun(idel) -> {?cross_ore_status_idel, Ts + Tcd - util:unixtime()};
        (prepare) -> {?cross_ore_status_prepare, Ts + Tcd - util:unixtime()};
        (active) -> {?cross_ore_status_active, Ts + Tcd - util:unixtime()};
        (stop) -> {?cross_ore_status_idel, 0}
    end,
    Reply = {ok, Fun(StateName)},
    continue(Reply, StateName, State);

handle_sync_event(get_areas, _From, StateName, State = #cross_ore_state{areas = AreaList}) ->
    continue(AreaList, StateName, State);

handle_sync_event({get_room_id, MapId}, _From, StateName, State = #cross_ore_state{areas = AreaList}) ->
    Reply = case lists:keyfind(MapId, #ore_area.map_id, AreaList) of
        false -> false;
        #ore_area{pid = Pid} -> {ok, Pid}
    end,
    continue(Reply, StateName, State);

handle_sync_event({call_animal, RoleId, AnimalId}, _From, active, State) ->
    Reply = case ets:lookup(ets_ore_role_info, RoleId) of
        [] ->
            {false, ?L(<<"您还木有占领一座仙府，无法驯养神兽">>)};
        [OreRI] ->
            do_call_animal(OreRI, AnimalId)
    end,
    ?DEBUG("REPLY:~w", [Reply]),
    continue(Reply, active, State);

handle_sync_event({preview_upgrade_animal, RoleId, AnimalId}, _From, active, State) ->
    Reply = case ets:lookup(ets_ore_role_info, RoleId) of
        [] ->
            {false, ?L(<<"您还木有占领一座仙府，无法驯养神兽">>)};
        [OreRI] ->
            do_preview_upgrade_animal(OreRI, AnimalId)
    end,
    ?DEBUG("REPLY:~w", [Reply]),
    continue(Reply, active, State);

handle_sync_event({upgrade_animal, RoleId, AnimalId}, _From, active, State) ->
    Reply = case ets:lookup(ets_ore_role_info, RoleId) of
        [] ->
            {false, ?L(<<"您还木有占领一座仙府，无法驯养神兽">>)};
        [OreRI] ->
            do_upgrade_animal(OreRI, AnimalId)
    end,
    ?DEBUG("REPLY:~w", [Reply]),
    continue(Reply, active, State);

handle_sync_event({reap, RoleId}, _From, active, State) ->
    Reply = case ets:lookup(ets_ore_role_info, RoleId) of
        [] ->
            {false, ?L(<<"您还木有占领一座仙府，无法驯养神兽">>)};
        [OreRI] ->
            cross_ore_area:reap(OreRI)
    end,
    ?DEBUG("REPLY:~w", [Reply]),
    continue(Reply, active, State);

handle_sync_event({abandon_room, RoleId = {Rid, SrvId}}, _From, active, State) ->
    Reply = case ets:lookup(ets_ore_role_info, RoleId) of
        [] ->
            {false, ?L(<<"您还木有占领一座仙府">>)};
        [OreRI = #ore_role_info{name = Name, room_id = RoomId, award = AwardList}] ->
            case check_and_handle_room_abandon(RoomId, RoleId) of
                {false, Msg} -> {false, Msg};
                ok ->
                    ets:insert(ets_ore_role_info, OreRI#ore_role_info{room_id = 0, award = [], award_time = 0}),
                    case AwardList =:= [] of
                        true -> ignore;
                        false ->
                            c_mirror_group:cast(node, SrvId, cross_ore, mail_reap_award, [{Rid, SrvId, Name}, AwardList, abandon])
                    end,
                    ok
            end
    end,
    continue(Reply, active, State);

handle_sync_event(_, _, prepare, State) ->
    Reply = {false, ?L(<<"昆仑仙府时空通道还未开启，请耐心等待准备时间结束">>)},
    continue(Reply, prepare, State);
    
handle_sync_event(_Event, _From, StateName, State) ->
    Reply = ok,
    continue(Reply, StateName, State).

%% Func: handle_info/3
%% Returns: {next_state, NextStateName, NextStateData}          |
%%          {next_state, NextStateName, NextStateData, Timeout} |
%%          {stop, Reason, NewStateData}

%% 每天清0打劫次数和被打劫次数
handle_info(clean_cnt, active, State) ->
    set_clean_timer(),
    L1 = ets:tab2list(ets_ore_room_list),
    L2 = ets:tab2list(ets_ore_role_misc),
    clean_cnt(L1),
    clean_cnt(L2),
    continue(active, State);
handle_info(clean_cnt, StateName, State) ->
    continue(StateName, State);

handle_info(save_cache, active, State) ->
    spawn(fun() -> save_cache() end),
    erlang:send_after(1000*3600, self(), save_cache),
    continue(active, State);
handle_info(save_cache, StateName, State) ->
    ?INFO("[~w]状态收到缓存数据定时消息", [StateName]),
    continue(StateName, State);

handle_info(_Info, StateName, State) ->
    ?DEBUG("收到无效消息: ~w", [_Info]),
    continue(StateName, State).

%% Func: terminate/3
%% Purpose: Shutdown the fsm
%% Returns: any
terminate(_Reason, active, #cross_ore_state{areas = AreaList, next_room_id = _NextRoomId, next_area_id = _NextAreaId}) ->
    save_cache(),
    kick_out(),
    destory_map(AreaList), %% 关闭各地图
    destory_area(AreaList), %% 关闭各个分区
    %% 不返回资源，等待重启服务器
    ?INFO("跨服仙府争夺战活动期间关机，信息完成保存"),
    dets:close(dets_cross_ore_cache),
    ok;
terminate(_Reason, _StateName, _StatData) ->
    save_data(),
    ?INFO("跨服仙府争夺战活动正常关机，持久化dets数据"),
    dets:close(dets_cross_ore_cache),
    ok.

%% Func: code_change/4
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState, NewStateData}
code_change(_OldVsn, StateName, StateData, _Extra) ->
    {ok, StateName, StateData}.

%% ---------------------------------------------------
%% StateName Function
%% ---------------------------------------------------

%% Func: StateName/2
%% Returns: {next_state, NextStateName, NextStateData}          |
%%          {next_state, NextStateName, NextStateData, Timeout} |
%%          {stop, Reason, NewStateData}

idel(timeout, State) ->
    ?INFO("跨服仙府挑战进入准备阶段"),
    NewState = init_area(State),
    ?INFO("分区完成:~w", [length(NewState#cross_ore_state.areas)]),
    broadcast(prepare),
    set_clean_timer(),
    continue(prepare, NewState#cross_ore_state{ts = util:unixtime(), t_cd = ?DEF_PREPARE_INTERVAL_TIME});
%% 空闲状态
idel(_Event, State) ->
    ?INFO("~w 状态下收到消息 ~w", [state_idel, _Event]),
    continue(idel, State).

prepare(timeout, State) ->
    broadcast(active),
    Sec = get_end_act_time(),
    erlang:send_after(1000*3600, self(), save_cache),
    ?INFO("跨服仙府挑战进入开始阶段:~w", [Sec]),
    continue(active, State#cross_ore_state{ts = util:unixtime(), t_cd = Sec});
%% 准备状态
prepare(_Event, State) ->
    ?INFO("~w 状态下收到消息 ~w", [state_prepare, _Event]),
    continue(prepare, State).

active(timeout, State = #cross_ore_state{areas = AreaList}) ->
    ?INFO("跨服仙府挑战进入结束阶段"),
    broadcast(stop),
    spawn(fun() ->
                kick_out(),
                destory_map(AreaList), %% 关闭各地图
                kill_combat(),
                ok
        end),
    continue(stop, State#cross_ore_state{ts = util:unixtime(), t_cd = ?DEF_STOP_INTERVAL_TIME});
%% 活动状态
active(_Event, State) ->
    continue(active, State).

%% 结束状态
stop(timeout, #cross_ore_state{areas = AreaList}) ->
    ?INFO("跨服仙府挑战进入关闭阶段，下个阶段剩余时间：~w", [get_next_act_time()]),
    destory_area(AreaList), %% 关闭各个分区
    reap_all_ore(), %% 返回各个玩家未收获的资源，并清空资源，保留神兽
    ets:delete_all_objects(ets_ore_room_list),
    %% ets:delete_all_objects(ets_ore_role_misc),
    %% ets:delete_all_objects(ets_ore_role_info), %% 保留神兽，不能清除
    save_data(),
    case get_next_act_time() of
        now ->
            continue(idel, #cross_ore_state{ts = util:unixtime(), t_cd = 1});
        CdSec ->
            continue(idel, #cross_ore_state{ts = util:unixtime(), t_cd = CdSec})
    end;
stop(_Event, State) ->
    ?INFO("~w 状态下收到消息 ~w", [stop, _Event]),
    continue(stop, State).

%%--------------------------------------------------------------------
%%% Internal functions
%%--------------------------------------------------------------------

%%% 同步调用
%call(Msg) ->
%    gen_fsm:sync_send_all_state_event(?MODULE, Msg).
%
%%% 异步事件调用
%info_state(Msg) ->
%    gen_fsm:send_event(?MODULE, Msg).

%% 同步单状态调用
%call_state(Msg) ->
%    gen_fsm:sync_send_event(?MODULE, Msg).

%% 状态机的持续执行
continue(StateName, State = #cross_ore_state{ts = Ts, t_cd = Tcd}) ->
    Now = util:unixtime(),
    Timeout = case Ts + Tcd - Now of
        T1 when T1 > 0 ->
            T1 * 1000;
        _ ->
            100
    end,
    {next_state, StateName, State, Timeout}.
continue(Reply, StateName, State = #cross_ore_state{ts = Ts, t_cd = Tcd}) ->
    Now = util:unixtime(),
    Timeout = case Ts + Tcd - Now of
        T1 when T1 > 0 ->
            T1 * 1000;
        _ ->
            1
    end,
    {reply, Reply, StateName, State, Timeout}.

%% ----------------------------------------------------------
%% private functions
%% ----------------------------------------------------------
%% 获取当天本地时间的星期天数
get_day_of_week() ->
    {Date, _} = calendar:local_time(),
    calendar:day_of_the_week(Date).
%% 获取下次活动时间间隔，秒/now
get_next_act_time() ->
    Day = get_day_of_week(),
    Now = util:unixtime(),
    %% 周一至周三 0:00-24:00
    if
        Day =:= 1 orelse Day =:= 2 ->
            now;
         Day =:= 3 ->
             %% 如果周三23点后启动，则直接下周开启活动
             case (util:unixtime({tomorrow, Now}) - Now) > 3600 of
                 true ->
                     now;
                 false ->
                     (util:unixtime({tomorrow, Now}) - Now) + (7 - Day)*86400
             end;
        true ->
            (util:unixtime({tomorrow, Now}) - Now) + (7 - Day)*86400
    end.
%% 获取活动结束时间间隔，秒
get_end_act_time() ->
    Day = get_day_of_week(),
    Now = util:unixtime(),
    %% 周一至周三 0:00-24:00
    if
        Day =:= 1 orelse Day =:= 2 orelse Day =:= 3 ->
            (util:unixtime({tomorrow, Now}) - Now) + (3 - Day)*86400;
        true ->
            (util:unixtime({tomorrow, Now}) - Now) + (7 - Day)*86400 + 86400*3
    end.

%% 初始化数据ETS表
init_table() ->
    ets:new(ets_ore_room_list, [public, named_table, set, {keypos, #ore_room.id}]),
    ets:new(ets_ore_role_info, [public, named_table, set, {keypos, #ore_role_info.role_id}]),
    ets:new(ets_ore_role_misc, [public, named_table, set, {keypos, #ore_role_misc.role_id}]),
    ok.

%% 加载活动间关机的缓存数据
load_cache() ->
    case dets:first(dets_cross_ore_cache) of
        '$end_of_table' -> ?INFO("加载跨服仙府争夺战数据，无数据正常");
        _ ->
            dets:traverse(dets_cross_ore_cache, 
                fun({DataType, DataList}) when is_list(DataList) ->
                        do_load_cache(DataType, DataList),
                        continue;
                    (_Data) ->
                        ?INFO("中央服跨服仙府保存数据信息有错:~w", [_Data]),
                        continue
                end
            ),
            dets:delete_all_objects(dets_cross_ore_cache),
            ?INFO("加载跨服仙府争夺战数据，上次跨服仙府活动时间内关机")
    end.
do_load_cache(_DataType, []) -> ok;
do_load_cache(DataType, DataList = [_ | _])
when DataType =:= ets_ore_room_list 
orelse DataType =:= ets_ore_role_info
orelse DataType =:= ets_ore_role_misc ->
    lists:foreach(fun(Data = #ore_role_misc{combat_cache = CombatCache}) ->
                ets:insert(DataType, Data#ore_role_misc{combat_cache = ver_parse(CombatCache)});
            (Data) ->
                ets:insert(DataType, Data)
        end, DataList);
do_load_cache(_, _) -> ignore.

%% 版本更新
ver_parse({Sex, Career, Lev, HpMax, MpMax, Attr, Eqm, Skill, PetBag, RoleDemon, Looks}) ->
    ver_parse({Sex, Career, Lev, HpMax, MpMax, Attr, Eqm, Skill, PetBag, RoleDemon, Looks, ascend:init()});
ver_parse({Sex, Career, Lev, HpMax, MpMax, Attr, Eqm, Skill, PetBag, RoleDemon, Looks, RoleAscend}) ->
    NewEqm = case item_parse:parse_eqm(Eqm) of
        {false, _Reason} -> [];
        NewE -> NewE
    end,
    NewSkill = skill:ver_parse_2(Skill),
    NewPetBag = case pet_parse:do(PetBag) of
        {false, _} -> #pet_bag{};
        {ok, NewPB} -> NewPB
    end,
    NewRoleDemon = demon:ver_parse(RoleDemon),
    NewAscend = ascend:ver_parse(RoleAscend),
    NewAttr = role_attr:ver_parse(Attr),
    {Sex, Career, Lev, HpMax, MpMax, NewAttr, NewEqm, NewSkill, NewPetBag, NewRoleDemon, Looks, NewAscend};
ver_parse(Data) ->
    ?DEBUG("跨服仙府数据转换遇到异常：~w", [Data]),
    Data.

%% %% 正常加载仙府神兽等数据
%% load_data() ->
%%     dets:open_file(dets_cross_ore_data, [{file, "../var/cross_ore_data.dets"}, {keypos, #ore_role_info.role_id}, {type, set}]),
%%     case dets:first(dets_cross_ore_data) of
%%         '$end_of_table' -> ?INFO("加载跨服仙府争夺战数据，无数据正常");
%%         _ ->
%%             dets:traverse(dets_cross_ore_data, 
%%                 fun(RoleInfo) when is_record(RoleInfo, ore_role_info) ->
%%                         ets:insert(ets_ore_role_info, RoleInfo),
%%                         continue;
%%                     (_Data) ->
%%                         ?INFO("中央服跨服仙府保存数据信息有错:~w", [_Data]),
%%                         continue
%%                 end
%%             ),
%%             ?INFO("加载跨服仙府争夺战数据，上次跨服仙府活动时间内关机")
%%     end.
%% %% 保存数据
%% save_data([]) -> ok;
%% save_data([RI = #ore_role_info{} | T]) ->
%%     dets:insert(dets_cross_ore_data, reset_role_info(RI)),
%%     save_data(T);
%% save_data([_H | T]) ->
%%     ?ERR("跨服仙府争夺战保存玩家神兽数据出错:~w", [_H]),
%%     save_data(T).
%%
%% %% 活动结束重置玩家仙府信息
%% reset_role_info([]) -> ok;
%% reset_role_info([RI | T]) ->
%%     ets:insert(eta_ore_role_info, RI#ore_role_info{award = [], award_time = 0, room_id = 0}),
%%     reset_role_info(T);
%% reset_role_info(RI = #ore_role_info{award = [], award_time = 0, room_id = 0}) ->
%%     RI#ore_role_info{award = [], award_time = 0, room_id = 0}.

%% 缓存
save_cache() ->
    RoomList = ets:tab2list(ets_ore_room_list),
    RoleInfoList = ets:tab2list(ets_ore_role_info),
    RoleMiscList = ets:tab2list(ets_ore_role_misc),
    dets:insert(dets_cross_ore_cache, {ets_ore_room_list, RoomList}),
    dets:insert(dets_cross_ore_cache, {ets_ore_role_info, RoleInfoList}),
    dets:insert(dets_cross_ore_cache, {ets_ore_role_misc, RoleMiscList}),
    ?INFO("跨服仙府缓存数据:~w,~w,~w", [length(RoomList), length(RoleInfoList), length(RoleMiscList)]),
    ok.

%% 持久化部分数据（玩家神兽等级）
save_data() ->
    dets:delete(dets_cross_ore_cache, ets_ore_room_list),
    dets:delete(dets_cross_ore_cache, ets_ore_role_info),
    %% dets:delete(dets_cross_ore_cache, ets_ore_role_misc),
    L = ets:tab2list(ets_ore_role_info),
    Data = lists:map(
        fun(#ore_role_info{role_id = RoleId, name = Name, npc_1 = Npc1, npc_2 = Npc2}) ->
                D = #ore_role_info{role_id = RoleId, name = Name, npc_1 = Npc1, npc_2 = Npc2},
                ets:insert(ets_ore_role_info, D),
                D; %% 下个活动时间继续保留
            (Rinfo) -> Rinfo
        end, L),
    dets:insert(dets_cross_ore_cache, {ets_ore_role_info, Data}),
    ok.

%% 结束所有战斗
kill_combat() ->
    L = ets:tab2list(ets_ore_room_list),
    lists:foreach(fun(#ore_room{combat_pid = Pid}) ->
                case is_pid(Pid) of
                    true ->
                        Pid ! stop;
                    false -> ignore
                end
        end, L).

%% 返回所有资源
reap_all_ore() ->
    L = ets:tab2list(ets_ore_role_info),
    lists:foreach(
        fun(#ore_role_info{pid = RolePid, award = []}) ->
                case is_pid(RolePid) of
                    true ->
                        role:pack_send(RolePid, 17817, {?true, ?L(<<"活动结束，您的仙府资源已提前收割完毕">>)});
                    false -> ignore
                end;
            (#ore_role_info{role_id = {Rid, SrvId}, pid = RolePid, name = Name, award = AwardList}) ->
                c_mirror_group:cast(node, SrvId, cross_ore, mail_reap_award, [{Rid, SrvId, Name}, AwardList, sys_gain]),
                case is_pid(RolePid) of
                    true ->
                        role:pack_send(RolePid, 17817, {?true, ?L(<<"活动结束，您还未收获的资源即将通过邮件发送，请耐心等待接收">>)});
                    false -> ignore
                end
        end, L).

%% 活动开始初始化分区进程
init_area(State = #cross_ore_state{next_area_id = NextAreaId}) when NextAreaId > ?ORE_AREA_MAX ->
    State;
init_area(State = #cross_ore_state{areas = AreaList, next_room_id = NextRoomId, next_area_id = NextAreaId}) ->
    case cross_ore_area:start_link(NextAreaId) of
        {ok, AreaPid} ->
            ?DEBUG("分区进程建立:~w", [NextAreaId]),
            OreArea = #ore_area{map_id = MapId} = new_map(NextAreaId, AreaPid),
            cross_ore_area:bind_map(AreaPid, MapId), %% 通知分区进程绑定地图
            NewNextId = create_elems(OreArea, NextRoomId, cross_ore_data:get_elems(), []),
            cross_ore_area:init_ore_room(AreaPid, NextRoomId, NewNextId-1),
            init_area(State#cross_ore_state{areas = [OreArea | AreaList], next_room_id = NewNextId, next_area_id = NextAreaId + 1});
        _ ->
            ?ERR("初始化分区进程出错"),
            State
    end.

%% 增加分区
add_area(State, Num) when Num =< 0 ->
    State;
add_area(State = #cross_ore_state{areas = AreaList, next_room_id = NextRoomId, next_area_id = NextAreaId}, Num) ->
    NewState = case cross_ore_area:start_link(NextAreaId) of
        {ok, AreaPid} ->
            OreArea = #ore_area{map_id = MapId} = new_map(NextAreaId, AreaPid),
            cross_ore_area:bind_map(AreaPid, MapId), %% 通知分区进程绑定地图
            NewNextId = create_elems(OreArea, NextRoomId, cross_ore_data:get_elems(), []),
            cross_ore_area:init_ore_room(AreaPid, NextRoomId, NewNextId-1),
            ?INFO("成功增加分区~w，下个仙府ID：~w", [NextAreaId, NewNextId]),
            State#cross_ore_state{areas = [OreArea | AreaList], next_room_id = NewNextId, next_area_id = NextAreaId + 1};
        _ ->
            ?ERR("初始化分区进程出错"),
            State
    end,
    add_area(NewState, Num-1).

%% 重启分区
%% 注意仙府元素ID的处理，不能自增了
restart_area(State = #cross_ore_state{areas = AreaList, next_room_id = _NextRoomId}, {AreaId, BeginRoomId, EndRoomId}) ->
    case lists:keyfind(AreaId, #ore_area.id, AreaList) of
        false ->
            ?ERR("跨服仙府重启分区~w，未找到分区信息", [AreaId]),
            State;
        #ore_area{map_pid = OldMapPid} ->
            map:stop(OldMapPid), %% 关闭原地图
            case cross_ore_area:start_link(AreaId) of
                {ok, AreaPid} ->
                    OreArea = #ore_area{map_id = MapId} = new_map(AreaId, AreaPid),
                    cross_ore_area:bind_map(AreaPid, MapId),
                    NewId = create_elems(OreArea, BeginRoomId, cross_ore_data:get_elems(), []),
                    case (NewId - 1) =:= EndRoomId of
                        true -> %% 说明
                            ?ERR("跨服仙府重启分区前后，仙府元素数量正常");
                        false ->
                            ?ERR("跨服仙府重启分区前后，仙府元素数量异常：~w", [NewId, EndRoomId])
                    end,
                    cross_ore_area:init_ore_room(AreaPid, BeginRoomId, EndRoomId),
                    NewAreaList = lists:keyreplace(AreaId, #ore_area.id, AreaList, OreArea),
                    State#cross_ore_state{areas = NewAreaList};
                _ ->
                    State
            end
    end.

%% 生成新地图
new_map(AreaId, AreaPid) ->
    case map_mgr:create(40002) of
        {ok, MapPid, MapId} ->
            create_cloud(MapId, 50),
            #ore_area{id = AreaId, pid = AreaPid, map_id = MapId, map_pid = MapPid};
        _ ->
            #ore_area{id = AreaId, pid = AreaPid}
    end.

%% 创建云
create_cloud(_MapId, 0) -> ok;
create_cloud(MapId, Num) ->
    BaseId = util:rand_list([60446, 60447, 60448]),
    X = util:rand(-1800, 1800) + 1920,
    Y = util:rand(-660, 660) + 690,
    case map_data_elem:get(BaseId) of
        Elem = #map_elem{} ->
            map:elem_enter(MapId, Elem#map_elem{id = 5000+Num, x = X, y = Y});
        _ -> ignore
    end,
    create_cloud(MapId, Num - 1).

%% 创建添加仙府房子资源元素
create_elems(#ore_area{}, NextRoomId, [], List) ->
    ?DEBUG("仙府ID产生到：~w", [NextRoomId]),
    update_ore_room(List),
    NextRoomId;
create_elems(OreArea = #ore_area{pid = AreaPid, map_id = MapId, list = IdList}, NextRoomId, [{ElemBaseId, Name, Lev, X, Y} | T], List) ->
    case map_data_elem:get(ElemBaseId) of
        Elem = #map_elem{type = ?elem_cross_ore} ->
            map:elem_enter(MapId, Elem#map_elem{id = NextRoomId, name = Name, x = X, y = Y}),
            OreRoom = #ore_room{id = NextRoomId, name = Name, lev = Lev, elem_id = ElemBaseId, area_pid = AreaPid, map_id = MapId},
            create_elems(OreArea#ore_area{list = [NextRoomId | IdList]}, NextRoomId + 1, T, [OreRoom | List]);
        _ ->
            create_elems(OreArea, NextRoomId, T, List)
    end.

%% 添加仙府房子资源列表
%% 此处做了一个假设定，容错活动期间关服
%% TODO: 活动期间重启后重载仙府房子时，更新地图和分区的信息，因为:
%% 地图元素创建按照仙府ID自增规则
%% 而玩家自己查看仙府不受分区和地图影响
update_ore_room([]) -> ok;
update_ore_room([OreRoom = #ore_room{id = Id, map_id = MapId, area_pid = AreaPid} | T]) ->
    case ets:lookup(ets_ore_room_list, Id) of
        [] ->
            ets:insert(ets_ore_room_list, OreRoom);
        [OldOreRoom] ->
            ets:insert(ets_ore_room_list, OldOreRoom#ore_room{map_id = MapId, area_pid = AreaPid})
    end,
    update_ore_room(T).

%% 更新玩家的记录信息
update_role_info(RoleId, RoleName, RolePid) ->
    case ets:lookup(ets_ore_role_info, RoleId) of
        [] ->
            ets:insert(ets_ore_role_info, #ore_role_info{role_id = RoleId, name = RoleName, pid = RolePid});
        [RoleInfo = #ore_role_info{}] ->
            ets:insert(ets_ore_role_info, RoleInfo#ore_role_info{pid = RolePid});
        _ -> ignore
    end.

%% 更新玩家附加信息
update_role_misc(RoleId, RoleName) ->
    case ets:lookup(ets_ore_role_misc, RoleId) of
        [] ->
            ets:insert(ets_ore_role_misc, #ore_role_misc{role_id = RoleId, name = RoleName});
        [_RoleInfo] ->
            ignore
    end.

%% 异步回调：进出地图
apply_enter_map(Role = #role{cross_srv_id = <<>>, event = ?event_no, pid = RolePid, pos = #pos{map = LastMapId, x = LastX, y = LastY}}, {MapId, X, Y}) ->
    %% 队长带队的情况
    case map:role_enter(MapId, X, Y, Role#role{cross_srv_id = <<"center">>, event = ?event_cross_ore, ride = ?ride_fly}) of
        {ok, NewRole = #role{pos = NewPos}} ->
            NewRole1 = NewRole#role{pos = NewPos#pos{last = {LastMapId, LastX, LastY}}},
            role:pack_send(RolePid, 17804, {?true, ?L(<<"欢迎参加争夺仙府活动。三人组队，点击地图上任意仙府即可对该仙府进行争夺或打劫。">>)}),
            team:update_ride(NewRole1), %% 更新队伍的飞行状态
            {ok, NewRole1};
        _E ->
            ?ERR("进入跨服地图失败：~w", [_E]),
            center:cast(cross_ore_mgr, info, [{enter_failed, MapId}]),
            {ok}
    end;
apply_enter_map(_, {MapId, _, _}) ->
    center:cast(cross_ore_mgr, info, [{enter_failed, MapId}]),
    {ok};
apply_enter_map(Role = #role{cross_srv_id = <<>>, event = ?event_no, pid = RolePid, pos = #pos{map = LastMapId, x = LastX, y = LastY}}, MapId) ->
    %% 随机点
    X = 2160 + util:rand(-720, 720),
    Y = 2400 + util:rand(-1350, 1350),
    case map:role_enter(MapId, X, Y, Role#role{cross_srv_id = <<"center">>, event = ?event_cross_ore, ride = ?ride_fly}) of
        {ok, NewRole = #role{pos = NewPos}} ->
            role:pack_send(RolePid, 17804, {?true, ?L(<<"欢迎参加争夺仙府活动。三人组队，点击地图上任意仙府即可对该仙府进行争夺或打劫。">>)}),
            {ok, NewRole#role{pos = NewPos#pos{last = {LastMapId, LastX, LastY}}}};
        _E ->
            ?ERR("进入跨服地图失败：~w", [_E]),
            center:cast(cross_ore_mgr, info, [{enter_failed, MapId}]),
            {ok}
    end;
apply_enter_map(_, MapId) ->
    center:cast(cross_ore_mgr, info, [{enter_failed, MapId}]),
    {ok}.

apply_leave_map(Role = #role{cross_srv_id = <<"center">>}) ->
    X = 5400 + util:rand(-100, 100),
    Y = 1500 + util:rand(-100, 100),
    case map:role_enter(10003, X, Y, Role#role{cross_srv_id = <<>>, event = ?event_no, ride = ?ride_no}) of
        {ok, NewRole} ->
            team:update_ride(NewRole), %% 更新队伍的飞行状态
            {ok, NewRole};
        _E ->
            ?ERR("退出跨服地图失败：~w", [_E]),
            {ok}
    end;
apply_leave_map(_Role) ->
    ?ERR("跨服仙府，玩家离开地图异常[NAME:~s, SRV:~s]", [_Role#role.name, _Role#role.cross_srv_id]),
    {ok}.

sync_leave_map(Role = #role{cross_srv_id = <<"center">>}) ->
    X = 5400 + util:rand(-100, 100),
    Y = 1500 + util:rand(-100, 100),
    case map:role_enter(10003, X, Y, Role#role{cross_srv_id = <<>>, event = ?event_no, ride = ?ride_no}) of
        {ok, NewRole} ->
            team:update_ride(NewRole), %% 更新队伍的飞行状态
            {ok, ok, NewRole};
        _E ->
            ?ERR("退出跨服地图失败：~w", [_E]),
            {ok, false}
    end;
sync_leave_map(_Role) ->
    ?ERR("跨服仙府，玩家离开地图异常[NAME:~s, SRV:~s]", [_Role#role.name, _Role#role.cross_srv_id]),
    {ok, false}.

%% 销毁分区进程
destory_area([]) -> ok;
destory_area([#ore_area{pid = Pid} | T]) ->
    Pid ! stop,
    destory_area(T).

%% 销毁地图
destory_map([]) -> ok;
destory_map([#ore_area{map_pid = MapPid} | T]) ->
    map:stop(MapPid),
    destory_map(T).

%% 活动踢出角色地图
kick_out() ->
    L = ets:tab2list(ets_ore_role_info),
    lists:foreach(fun(#ore_role_info{pid = Pid}) ->
                case is_pid(Pid) of
                    true ->
                        role:apply(sync, Pid, {cross_ore_mgr, sync_leave_map, []});
                    _ ->
                        ok
                end
    end, L).

%% 活动通知
broadcast(State) ->
    c_mirror_group:cast(all, cross_ore_mgr, broadcast_srv, [State]).

broadcast_srv(State) ->
    do_broadcast(State).

do_broadcast(prepare) ->
    role_group:pack_cast(world, 17800, {?cross_ore_status_prepare, ?DEF_PREPARE_INTERVAL_TIME});
do_broadcast(active) ->
    role_group:pack_cast(world, 17800, {?cross_ore_status_active, get_end_act_time()});
do_broadcast(stop) ->
    role_group:pack_cast(world, 17800, {?cross_ore_status_stop, 0});
do_broadcast(_) ->
    ok.

%% 转化为战斗角色
to_fighter(Rids) when is_list(Rids) ->
    to_fighter(Rids, []).
to_fighter([], Back) ->
    Back;
to_fighter([RolePid | T], Back) when is_pid(RolePid) ->
    case catch role_api:lookup(by_pid, RolePid, to_fighter) of
        {ok, _, Fighter} ->
            to_fighter(T, [Fighter | Back]);
        _Why ->
            ?ERR("跨服仙府争夺，转换玩家战斗信息出错：~w", [_Why]),
            to_fighter(T, Back)
    end;
to_fighter([Rid = {_, _} | T], Back) ->
    case catch c_proxy:role_lookup(by_id, Rid, to_fighter) of
        {ok, _, Fighter} ->
            to_fighter(T, [Fighter | Back]);
        _Why ->
            ?ERR("跨服仙府争夺，转换玩家战斗信息出错：~w", [_Why]),
            to_fighter(T, Back)
    end;
to_fighter([NpcBaseId | T], Back) ->
    %% 转换神兽或散仙为fighter
    {ok, CF} = npc_convert:do(to_fighter, NpcBaseId),
    to_fighter(T, [CF | Back]).

%% 转换仙府防卫战斗Npc或克隆角色
convert_fighter_clone(#ore_room{flag = 0, lev = Lev}) ->
    SanXianList = cross_ore_data:get_sanxian(Lev),
    to_fighter(SanXianList); %% 转换默认散仙NPC为fighter
convert_fighter_clone(#ore_room{flag = 1, roles = [H], lev = Lev}) ->
    SanXianList = cross_ore_data:get_sanxian(Lev),
    to_fighter_clone([util:rand_list(SanXianList), util:rand_list(SanXianList), H]);
convert_fighter_clone(#ore_room{flag = 1, roles = [H1, H2], lev = Lev}) ->
    SanXianList = cross_ore_data:get_sanxian(Lev),
    to_fighter_clone([util:rand_list(SanXianList), H1, H2]);
convert_fighter_clone(#ore_room{flag = 1, roles = [H1, H2, H3]}) ->
    to_fighter_clone([H1, H2, H3]);
convert_fighter_clone(_) ->
    [].

to_fighter_clone(Roles) ->
    Fun1 = fun({Rid, SrvId, _Name}) ->
            case ets:lookup(ets_ore_role_misc, {Rid, SrvId}) of
                [RoleMisc = #ore_role_misc{}] -> RoleMisc;
                _ -> error
            end;
        (SanXianId) -> SanXianId
    end,
    L = [Fun1(X) || X <- Roles],
    FighterList = to_fighter_clone(L, []),
    {NpcL1, NpcL2} = get_all_animal(Roles),
    NpcList = to_fighter_npc(NpcL1, NpcL2),
    FighterList ++ NpcList.

to_fighter_clone([], L) ->
    L;
to_fighter_clone([NpcBaseId | T], L) when is_integer(NpcBaseId) ->
    {ok, CF} = npc_convert:do(to_fighter, NpcBaseId), %% 散仙
    to_fighter_clone(T, [CF | L]);
to_fighter_clone([#ore_role_misc{combat_cache = 0} | T], L) ->
    to_fighter_clone(T, L);
to_fighter_clone([#ore_role_misc{role_id = RoleId, name = Name, combat_cache = {Sex, Career, Lev, HpMax, MpMax, Attr, Eqm, Skill, PetBag, RoleDemon, Looks, Ascend}} | T], L) ->
    {ok, F} = role_convert:do(to_fighter, {{RoleId, Name, Sex, Career, Lev, HpMax, MpMax, Attr, Eqm, Skill, PetBag, RoleDemon, Looks, Ascend}, clone_ore}),
    to_fighter_clone(T, [F | L]);
to_fighter_clone([_ | T], L) ->
    to_fighter_clone(T, L).

to_fighter_npc([], []) -> [];
to_fighter_npc([], L2) ->
    Npc2 = cross_ore_data:get_shenshou(2, lists:max([Lev || {2, _, Lev} <- L2])),
    to_fighter([Npc2]);
to_fighter_npc(L1, []) ->
    Npc1 = cross_ore_data:get_shenshou(2, lists:max([Lev || {1, _, Lev} <- L1])),
    to_fighter([Npc1]);
to_fighter_npc(L1, L2) ->
    %% 离珠
    Npc1 = cross_ore_data:get_shenshou(1, lists:max([Lev || {_, _, Lev} <- L1])),
    %% 金乌
    Npc2 = cross_ore_data:get_shenshou(2, lists:max([Lev || {_, _, Lev} <- L2])),
    to_fighter([Npc1, Npc2]).

%% 仙府主人所有的神兽
get_all_animal(Roles) ->
    get_all_animal(Roles, [], []).
get_all_animal([], NpcL1, NpcL2) -> {NpcL1, NpcL2};
get_all_animal([{Rid, SrvId, _Name} | T], NpcL1, NpcL2) ->
    case ets:lookup(ets_ore_role_info, {Rid, SrvId}) of
        [#ore_role_info{npc_1 = 0, npc_2 = 0}] ->
            get_all_animal(T, NpcL1, NpcL2);
        [#ore_role_info{npc_1 = 0, npc_2 = N2}] ->
            get_all_animal(T, NpcL1, [N2 | NpcL2]);
        [#ore_role_info{npc_1 = N1, npc_2 = 0}] ->
            get_all_animal(T, [N1 | NpcL1], NpcL2);
        [#ore_role_info{npc_1 = N1, npc_2 = N2}] ->
            get_all_animal(T, [N1 | NpcL1], [N2 | NpcL2]);
        _E ->
            ?DEBUG("********************_E:~w", [_E]),
            get_all_animal(T, NpcL1, NpcL2)
    end;
get_all_animal([RoleInfo | T], NpcL1, NpcL2) ->
    case RoleInfo of
        #ore_role_info{npc_1 = 0, npc_2 = 0} ->
           get_all_animal(T, NpcL1, NpcL2);
        #ore_role_info{npc_1 = 0, npc_2 = N2} ->
           get_all_animal(T, NpcL1, [N2 | NpcL2]);
        #ore_role_info{npc_1 = N1, npc_2 = 0} ->
           get_all_animal(T, [N1 | NpcL1], NpcL2);
        #ore_role_info{npc_1 = N1, npc_2 = N2} ->
            get_all_animal(T, [N1 | NpcL1], [N2 | NpcL2]);
        _ ->
            get_all_animal(T, NpcL1, NpcL2)
    end.

%% 多个神兽中最强的2个，返回list()
get_most_nb_animal([], []) -> [];
get_most_nb_animal(NpcL1, []) ->
    Lv1 = lists:max([Lev || {_, _, Lev} <- NpcL1]),
    [{1,?L(<<"应龙">>),Lv1}];
get_most_nb_animal([], NpcL2) ->
    Lv2 = lists:max([Lev || {_, _, Lev} <- NpcL2]),
    [{2, ?L(<<"金乌">>),Lv2}];
get_most_nb_animal(NpcL1, NpcL2) ->
    Lv1 = lists:max([Lev || {_, _, Lev} <- NpcL1]),
    Lv2 = lists:max([Lev || {_, _, Lev} <- NpcL2]),
    [{1,?L(<<"应龙">>),Lv1},{2, ?L(<<"金乌">>),Lv2}].

%% 驯养神兽
do_call_animal(OreRI = #ore_role_info{npc_1 = 0}, 1) ->
    ets:insert(ets_ore_role_info, OreRI#ore_role_info{npc_1 = {1, ?L(<<"应龙">>), 1}}),
    ok;
do_call_animal(OreRI = #ore_role_info{npc_2 = 0}, 2) ->
    ets:insert(ets_ore_role_info, OreRI#ore_role_info{npc_2 = {2, ?L(<<"金乌">>), 1}}),
    ok;
do_call_animal(_OreRI, _) ->
    {false, ?L(<<"您已经驯养了此神兽">>)}.

%% 升级神兽
do_upgrade_animal(OreRI = #ore_role_info{npc_1 = {1, _, Lev}}, 1) ->
    NewLev = Lev + 1,
    ets:insert(ets_ore_role_info, OreRI#ore_role_info{npc_1 = {1, ?L(<<"应龙">>), NewLev}}),
    ok;
do_upgrade_animal(OreRI = #ore_role_info{npc_2 = {2, _, Lev}}, 2) ->
    NewLev = Lev + 1,
    ets:insert(ets_ore_role_info, OreRI#ore_role_info{npc_2 = {2, ?L(<<"金乌">>), NewLev}}),
    ok;
do_upgrade_animal(_OreRI, _) ->
    {false, ?L(<<"您还未驯养此神兽">>)}.

%% 预览升级神兽
do_preview_upgrade_animal(#ore_role_info{npc_1 = {1, _, Lev}}, 1) ->
    {ok, Lev + 1};
do_preview_upgrade_animal(#ore_role_info{npc_2 = {2, _, Lev}}, 2) ->
    {ok, Lev + 1};
do_preview_upgrade_animal(_OreRI, _) ->
    {false, ?L(<<"您还未驯养此神兽">>)}.

%% 清除仙府被打劫次数，玩家打劫次数
clean_cnt([]) -> ok;
clean_cnt([OreRoom = #ore_room{} | T]) ->
    ets:insert(ets_ore_room_list, OreRoom#ore_room{robed_cnt = 0}),
    clean_cnt(T);
clean_cnt([RoleMisc = #ore_role_misc{} | T]) ->
    ets:insert(ets_ore_role_misc, RoleMisc#ore_role_misc{rob_cnt = 0}),
    clean_cnt(T).

set_clean_timer() ->
    Now = util:unixtime(),
    Sec = util:unixtime({tomorrow, Now}) - Now,
    ?INFO("跨服仙府争夺管理进程设置清0定时器:~w", [Sec]),
    erlang:send_after(Sec * 1000, self(), clean_cnt).

%% 增加玩家的打劫次数
add_rob_cnt([], _RobId) -> ok;
add_rob_cnt([RoleId | T], RobId) ->
    case ets:lookup(ets_ore_role_misc, RoleId) of
        [OreRM = #ore_role_misc{rob_cnt = RobCnt}] ->
            ets:insert(ets_ore_role_misc, OreRM#ore_role_misc{rob_cnt = RobCnt + 1, last_rob = RobId, last_time = util:unixtime()});
        _ -> ignore
    end,
    add_rob_cnt(T, RobId).

%% 筛选角色列表
filter_roles(_, [], L) -> L;
filter_roles({Rid, SrvId}, [{Rid, SrvId, _} | T], L) ->
    filter_roles({Rid, SrvId}, T, L);
filter_roles(RoleId, [{Rid, SrvId, Name} | T], L) ->
    filter_roles(RoleId, T, [{Rid, SrvId, Name} | L]).

%% 处理主人放弃时的仙府
check_and_handle_room_abandon(RoomId, RoleId = {Rid, SrvId}) ->
    case ets:lookup(ets_ore_room_list, RoomId) of
        [] -> {false, ?L(<<"暂时还不能操作">>)};
        [#ore_room{combat_pid = CombatPid}] when is_pid(CombatPid) ->
            {false, ?L(<<"仙府在战斗中，您暂时不能放弃">>)};
        [#ore_room{roles = []}] ->
            {false, ?L(<<"这个仙府不属于您，您不能操作">>)};
        [OreRoom = #ore_room{roles = [{Rid, SrvId, _}]}] -> %% 仙府最后的主人放弃该仙府
            ets:insert(ets_ore_room_list, OreRoom#ore_room{roles = [], flag = 0}),
            ok;
        [OreRoom = #ore_room{roles = Roles}] ->
            ets:insert(ets_ore_room_list, OreRoom#ore_room{roles = filter_roles(RoleId, Roles, [])}),
            ok
    end.
