%%----------------------------------------------------
%% 地图进程
%% @author yeahoo2000@gmail.com
%% @end
%%----------------------------------------------------
-module(map).
-behaviour(gen_server).
-export(
    [
        gid/1
        ,gid/3
        ,role_enter/4
        ,role_enter/2
        ,role_leave/6
        ,role_leave/2
        ,role_move_step/6
        ,role_move_step/7
        ,role_move_step/3
        ,role_move_step/4
        ,role_move_towards/7
        ,role_jump/6
        ,role_follow/3
        ,role_update/1
        ,role_update/2
        ,role_cast/2
        ,role_in_slice/3
        ,role_in_range/4
        ,role_info/2
        ,role_list/1
        %,role_shadow/2
        ,npc_enter/2
        ,npc_move/4
        ,npc_update/2
        ,npc_leave/2
        ,npc_leave_without_cast/2
        ,npc_list/1
        ,cast_special_npc/2
        ,create_npc/4
        ,elem_enter/2
        ,elem_leave/2
        ,elem_info/2
        ,elem_fetch/2
        ,lookup_elems/2
        ,elem_action/4
        ,elem_change/3
        ,init_hide_box/2
        ,elem_update/2
        ,elem_enable/2
        ,elem_disable/3
        ,followers_enter/2
        ,send_10111/5
        ,send_to_all/2
        ,pack_send_to_all/3
        ,send_to_near/3
        ,pack_send_to_near/4
        ,calc_distance/2
        ,get_revive/1
        ,is_security/1
        ,is_town/1
        ,start_link/1
        ,stop/1
        ,reset/1
        ,reset/3
        ,fight_npc/2
        ,pack_enter_msg/1
        ,send_enter_msg/2
        ,send_npc_enter_msg/2
    ]
).
-export([
    i/1     
]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("role.hrl").
-include("map.hrl").
-include("link.hrl").
-include("pos.hrl").
-include("npc.hrl").
%%
-include("condition.hrl").
-include("combat.hrl").
-include("expedition.hrl").

-define(HIDDEN, 1).
-define(SHOW, 0).

-define(DX(DestX, W), if DestX < 0 -> 0; DestX > W -> W; true -> DestX end). %% 将目标X坐标限定在有效范围
-define(DY(DestY, H), if DestY < 0 -> 0; DestY > H -> H; true -> DestY end). %% 将目标Y坐标限定在有效范围

%% 找到map_pid并执行Do
-define(DO_WITH_MAPID(MapGid, Do),
    case ets:lookup(map_info, MapGid) of
        [#map{pid = MapPid}] -> Do;
        _ -> ok
    end
).

%% 3格广播
-define(CAST(Slice, Msg),
    %% ?DEBUG("广播到列表:~w", [L1]),
    slice_cast([get(P) || P <- ?SLICE_NEAR(Slice)], Msg)
).
-define(CAST(RolePid, Slice, Msg),
    %% ?DEBUG("广播到列表:~w", [L1]),
    slice_cast(RolePid, [get(P) || P <- ?SLICE_NEAR(Slice)], Msg)
).



%% 取得附近18格
-define(SLICE_NEAR(Slice),
    [
        Slice - 1
        ,Slice
        ,Slice + 1
    ]
).

%% 区域角色id列表
-define(IDS(Slice), lists:flatten([ [_MapRole#map_role.id || _MapRole <- get(_S) ] || _S <- ?SLICE_NEAR(Slice) ])).
-define(NAMES(Slice), lists:flatten([ [_MapRole#map_role.name || _MapRole <- get(_S) ] || _S <- ?SLICE_NEAR(Slice) ])).

%% 角色移动时的跨区域处理
%% Leave = Slice 离开的区域
%% Enter = Slice 新进入的区域
-define(CROSS_SLICE(Leave, Enter), 
    ?DEBUG("角色[~w]从区域~w(~w,~w)进入区域~w向(~w,~w)方向移动", [Rid, Leave, _OldX, _OldY, Enter, _DestX, _DestY]),
    put(OldSlice, lists:keydelete(Rpid, #map_role.pid, get(OldSlice))), %% 离开原区域
    put(NewSlice, [R | get(NewSlice)]), %% 加入新区域
    put(Rpid, NewSlice),
    case State#map.type of
        ?map_type_dungeon -> ignore;  %% 副本内，不需要广播跨区域通知
        ?map_type_expedition -> ignore;
        _ ->
            EnterL = get(Enter),
            LeaveL = get(Leave),
            do_cast(EnterL, pack_enter_msg(R)), %% 广播角色进入消息给新入区域内的角色
            ?DEBUG("new role:===================== ~p", [EnterL]),
            send_role_list(R#map_role.conn_pid, EnterL, LeaveL), %% 发送新区域的角色列表
            {ok, LeaveMsg} = proto_101:pack(srv, 10114, {Rid, SrvId}),
            do_cast(LeaveL, LeaveMsg)     %% 发送离开广播给旧区域
    end
).

%% 从map_info查询地图元素信息
-define(ELEM_INFO(Type, MapGid, ElemId),
    case ets:lookup(map_info, MapGid) of
        [#map{Type = Elems}] -> lists:keyfind(ElemId, #Type.id, Elems);
        _ -> false
    end
).

%%----------------------------------------------------
%% 对外接口
%%----------------------------------------------------

% gid(Line, ?capital_map_id) -> {Line, ?capital_map_id};
% gid(Line, ?capital_map_id2) -> {Line, ?capital_map_id2};
% gid(Line, ?capital_map_id3) -> {Line, ?capital_map_id3};
% gid(Line, ?capital_map_id4) -> {Line, ?capital_map_id4};
% gid(Line, ?capital_map_id5) -> {Line, ?capital_map_id5};
% gid(_Line, MapId) -> {1, MapId};

gid(#pos{line = Line, map = MapId, map_base_id = MapBaseId}) -> 
    gid(Line, MapId, MapBaseId).

gid(Line, MapId, MapBaseId) -> 
    case map_data:get(MapBaseId) of
        #map_data{type = ?map_type_town} -> {Line, MapId};
        _ -> {?map_def_line, MapId}
    end.

%% @spec role_enter(MapId, X, Y, Role) -> {ok, NewRole} | {false, bad_pos} | {false, } 
%% MapId = integer()
%% X = integer()
%% Y = integer()
%% Role = NewRole = #role{}
%% Why = atom()
%% @doc 角色进入地图(需要对进入条件进行验证)
role_enter(MapId, DestX, DestY, Role = #role{pos = #pos{line = Line}}) when is_integer(MapId) ->
    role_enter(map:gid(Line, MapId, MapId), DestX, DestY, Role);
    
role_enter(MapGid, DestX, DestY, Role = #role{status = ?status_transfer}) ->
    case get(transfer_time) of
        undefined -> 
            role_enter(MapGid, DestX, DestY, Role#role{status = ?status_normal});
        TransferTime ->
            case util:unixtime() - TransferTime > 60 of
                true -> role_enter(MapGid, DestX, DestY, Role#role{status = ?status_normal});
                _ -> {false, 'bad_status'}
            end
    end;
role_enter(MapGid = {Line, MapId}, DestX, DestY, Role = #role{cross_srv_id = CrossSrvId, name = Name, event = Event,
        id = {Rid, SrvId}, pid = RolePid, status = Status, pos = Pos = #pos{map_base_id = LastMapBaseId, map_pid = LastMapPid, x = X, y = Y, town_map_pid = LastTownPid}}) ->
    case map_mgr:get_map_info(CrossSrvId, MapGid) of
        %% 坐标合法性检查
        [#map{width = W, height = H}]
        when DestX < 0 orelse DestY < 0 orelse DestX > W orelse DestY > H ->
            ?ERR("角色[RoleId:~w, SrvId:~s, Name:~s, event:~s, MapGid:~p, X:~s, Y:~s, Line:~s]进入地图出错", 
                [Rid, SrvId, Name, Event, MapGid, DestX, DestY, Line]),
            {false, 'bad_pos'};

        %% %% 目标地图pid跟当前地图pid相同，执行同一地图内跳转 TODO 暂时禁用
        %% %% (并且无视下面的条件检查，防止原本已经进入的地图出现无法进入的情况)
        %% [#map{pid = LastMapPid}] ->
        %%     LastMapPid ! {role_jump, RolePid, X, Y, DestX, DestY},
        %%     {ok, Role#role{pos = Pos#pos{x = DestX, y = DestY}}};

        %% TODO:进入条件检查
        %% TODO:人数检查

        %% 进入新地图
        [#map{pid = MapPid, base_id = BaseId, type = _Type}] ->
            FromTownToDungeon = case map_data:get(BaseId) of
                #map_data{type = ?map_type_dungeon} ->
                    case map_data:get(LastMapBaseId) of  %% 从主城进入副本
                        #map_data{type = ?map_type_town} -> true;
                        _ -> false
                    end;
                _ -> false
            end,
            case LastMapPid =/= MapPid of
                true ->
                    case FromTownToDungeon of
                        true -> 
                            role_shadow(LastMapPid, RolePid);
                        _ ->
                            role_leave(LastMapPid, RolePid, Rid, SrvId, X, Y) %% 离开上一个地图
                    end;
                _ -> 
                    ignore
            end,
            case is_pid(LastTownPid) of %% 消除主城副本前残影
                true -> role_leave(LastTownPid, RolePid);
                _ -> ignore
            end,
          %%  R0  = dungeon_poetry:correct_status(Role, BaseId),  %% 不是古诗副本场景一律要清掉古诗状态
            Role0 = guild_area:clear_throne(Role),               %% 帮会领地，宝座重置需求, 这里需要原始 Role 
            Role1 = story_npc:clear(Role0, BaseId),
            NewRole0 = case Status =:= ?status_normal of
                true ->
                    Role1#role{status = ?status_transfer, pos = Pos#pos{map_pid = MapPid, map = MapId, map_base_id = BaseId, x = DestX, y = DestY}};
                false ->
                    Role1#role{pos = Pos#pos{map_pid = MapPid, map = MapId, map_base_id = BaseId, x = DestX, y = DestY}}
            end,
            NewRole1 = case FromTownToDungeon of
                true ->
                    NewRole0#role{pos = NewRole0#role.pos#pos{town_map_pid = LastMapPid}};
                _ ->
                    NewRole0#role{pos = NewRole0#role.pos#pos{town_map_pid = 0}}
            end,
            put(transfer_time, util:unixtime()), % 记录请求进入地图时间
            NewRole = sit:handle_enter_map(NewRole1),
            {ok, MapRole} = role_convert:do(to_map_role, NewRole),
            MapPid ! {role_enter, MapRole},
            {ok, NewRole};

        %% 异常情况
        _E ->
            ?DEBUG("进入地图失败:不存在的地图, cross_srv_id = ~s, map_id = ~w, error = ~w", [CrossSrvId, MapId, _E]),
            {false, 'bad_map'}
    end.

role_enter(MapPid, MapRole) when is_pid(MapPid) ->
    MapPid ! {role_enter, MapRole};
role_enter(_MapPid, _MapRole) ->
    ok.

%% @spec role_leave(MapPid, RolePid, Rid, SrvId, X, Y) -> ok
%% MapPid = pid()
%% RolePid = pid()
%% Rid = integer()
%% SrvId = bitstring()
%% X = Y = integer()
%% @doc 角色离开地图
role_leave(MapPid, RolePid, Rid, SrvId, X, Y) when is_pid(MapPid) ->
    MapPid ! {role_leave, RolePid, Rid, SrvId, X, Y};
role_leave(_MapPid, _RolePid, _Rid, _SrvId, _X, _Y) ->
    %% ?DEBUG("离开地图时收到的MapPid[~w]无效，不是一个pid()", [_MapPid]),
    ignore.

role_leave(MapPid, RolePid) when is_pid(MapPid), is_pid(RolePid) ->
    MapPid ! {role_leave, RolePid};
role_leave(_MapPid, _RolePid) ->
    ignore.

%% @spec role_move_step(MapPid, RolePid, X, Y) -> ok
%% MapPid = pid()
%% RolePid = pid()
%% X = integer()
%% Y = integer()
%% @doc 角色移动
role_move_step(MapPid, RolePid, X, Y, DestX, DestY) ->
    MapPid ! {role_move_step, RolePid, X, Y, DestX, DestY, _NotifyNpc=true}.

role_move_step(MapPid, RolePid, X, Y, DestX, DestY, IsNotifyNpc) ->
    MapPid ! {role_move_step, RolePid, X, Y, DestX, DestY, IsNotifyNpc}.

role_move_step(_Role = #role{pid=RolePid, pos=#pos{map_pid=MapPid, x=X, y=Y}}, DestX, DestY) ->
    role_move_step(MapPid, RolePid, X, Y, DestX, DestY).

role_move_step(_Role = #role{pid=RolePid, pos=#pos{map_pid=MapPid, x=X, y=Y}}, DestX, DestY, IsNotifyNpc) ->
    role_move_step(MapPid, RolePid, X, Y, DestX, DestY, IsNotifyNpc).


%% 角色发送拐点、改变方向
role_move_towards(MapPid, RolePid, X, Y, TargetX, TargetY, Dir) ->
    role_location_updater:activate(MapPid),
    MapPid ! {role_move_towards, RolePid, X, Y, TargetX, TargetY, Dir}.

role_jump(MapPid, RolePid, X, Y, DestX, DestY) ->
    MapPid ! {role_jump, RolePid, X, Y, DestX, DestY}.

%% @spec role_follow(Role, X, Y) -> any() | ignore
%% Role = #role{}
%% X = integer()
%% Y = integer()
%% @doc 角色跟随目标
role_follow(#role{link = #link{conn_pid = ConnPid}}, X, Y) ->
    role_follow(ConnPid, X, Y);

%% @spec role_follow(ConnPid, X, Y) -> any() | ignore
%% ConnPid = pid()
role_follow(ConnPid, X, Y) when is_pid(ConnPid) ->
    sys_conn:pack_send(ConnPid, 10118, {X, Y});
role_follow(_, _, _) ->
    ignore.

%% @spec role_update(Role) -> ok
%% Role = #role{}
%% @doc 更新地图中的角色信息(注意:map, x, y, slice不能通过非map接口进行更新，否则会出现错误)
role_update(R = #role{pos = #pos{map_pid = MapPid}}) ->
    case role_convert:do(to_map_role, R) of
        {ok, Mr} -> role_update(MapPid, Mr);
        _ -> ok
    end.

%% @spec role_update(MapPid, MapRole) -> ok
%% MapPid = pid()
%% MapRole = #map_role{}
%% @doc 更新地图中的角色信息(注意:map, x, y, slice不能通过非map接口进行更新，否则会出现错误)
role_update(MapPid, MapRole) when is_pid(MapPid) ->
    MapPid ! {role_update, MapRole};

role_update(_MapPid, _MapRole) ->
    ?DEBUG("role_update_error: map_pid = ~w, map_role = ~w", [_MapPid, _MapRole]).

%% @spec role_cast{#role{}} 
%% 全场景广播玩家
role_cast(all, R = #role{pos = #pos{map_pid = MapPid}}) ->
    {ok, Mr} = role_convert:do(to_map_role, R),
    Bin = pack_refresh_msg(Mr),
    send_to_all(MapPid, Bin);

role_cast(near, R = #role{pos = #pos{map_pid = MapPid, x = X, y = Y}}) ->
    {ok, Mr} = role_convert:do(to_map_role, R),
    Bin = pack_refresh_msg(Mr),
    send_to_near(MapPid, {X, Y}, Bin).

%% @spec role_in_slice(MapId, X, Y) -> RoleList
%% MapId = integer() | pid()
%% X = integer()
%% Y = integer()
%% RoleList = [#map_role{}]
%% @doc 获取指定坐标周围的角色列表(附近九格)
role_in_slice(MapPid, X, Y) when is_pid(MapPid) ->
    gen_server:call(MapPid, {get_role_in_slice, X, Y});
role_in_slice(MapGid, X, Y) ->
    ?DO_WITH_MAPID(MapGid, gen_server:call(MapPid, {get_role_in_slice, X, Y})).

%% @doc 查找指定范围内的角色列表
role_in_range(MapPid, X, Y, Range) ->
    gen_server:call(MapPid, {get_role_in_range, X, Y, Range}).

%% @spec role_info(MapId, RolePid) -> false | #map_role{}
%% MapId = integer() | pid()
%% RolePid = pid()
%% @doc 查询指定地图中某个角色的信息
role_info(MapPid, RolePid) when is_pid(MapPid) ->
    gen_server:call(MapPid, {get_role_info, RolePid});
role_info(MapGid, RolePid) ->
    ?DO_WITH_MAPID(MapGid, gen_server:call(MapPid, {get_role_info, RolePid})).

%% @spec role_list(MapId) -> RoleList
%% MapId = integer() | pid()
%% RoleList = [#map_role{}]
%% @doc 获取地图中所有的角色
role_list(MapPid) when is_pid(MapPid) ->
    gen_server:call(MapPid, get_role_list);
role_list(MapGid) ->
    ?DO_WITH_MAPID(MapGid, gen_server:call(MapPid, get_role_list)).

role_shadow(MapPid, RolePid) when is_pid(MapPid), is_pid(RolePid) ->
    MapPid ! {role_shadow, RolePid};
role_shadow(_MapPid, _RolePid) ->
    ignore.

%% @spec npc_enter(MapId, MapNpc) -> Result
%% MapId = integer() | pid()
%% MapNpc = #map_npc{}
%% Result = pid() | false
%% @doc NPC进入地图
npc_enter(MapPid, MapNpc) when is_pid(MapPid) ->
    MapPid ! {npc_enter, MapNpc},
    MapPid;
npc_enter(MapId, MapNpc) when is_integer(MapId) -> %% 默认进入第一条线
    npc_enter({1, MapId}, MapNpc);
npc_enter(MapGid, MapNpc) ->
    case ets:lookup(map_info, MapGid) of
        [#map{pid = MapPid, base_id = BaseId}] ->
            npc_enter(MapPid, MapNpc),
            {BaseId, MapPid};
        _ -> false
    end.

%% @spec npc_move(MapPid, NpcId, DestX, DestY) -> ok
%% MapPid = pid()
%% NpcId = integer()
%% DestX = integer()
%% DestY = integer()
%% @doc NPC移动
npc_move(MapPid, NpcId, DestX, DestY) ->
    case is_pid(MapPid) andalso is_process_alive(MapPid) of 
        true ->
            MapPid ! {npc_move, NpcId, DestX, DestY};
        false ->
            ok
    end.

%% @spec npc_leave(MapId, NpcId) -> ok
%% MapId = integer() | pid()
%% NpcId = integer()
%% @doc NPC离开地图
npc_leave(MapPid, NpcId) when is_pid(MapPid) ->
    MapPid ! {npc_leave, NpcId, cast};
npc_leave(MapGid, NpcId) ->
    ?DO_WITH_MAPID(MapGid, MapPid ! {npc_leave, NpcId, cast}).

npc_leave_without_cast(MapPid, NpcId) when is_pid(MapPid) ->
    MapPid ! {npc_leave, NpcId, no_cast};
npc_leave_without_cast(MapGid, NpcId) ->
    ?DO_WITH_MAPID(MapGid, MapPid ! {npc_leave, NpcId, no_cast}).

%% @spec npc_update(MapPid, MapNpc) -> ok
%% MapId = pid() | integer()
%% MapNpc = #map_npc{}
%% @doc 更新地图中的NPC信息
npc_update(MapPid, MapNpc) when is_pid(MapPid) ->
    MapPid ! {npc_update, MapNpc};
npc_update(MapGid, MapNpc) ->
    ?DO_WITH_MAPID(MapGid, MapPid ! {npc_update, MapNpc}).

%% @spec npc_list(MapId) -> NpcList
%% MapId = integer() | pid()
%% NpcList = [#map_npc{}]
%% @doc 获取NPC列表
npc_list(MapPid) when is_pid(MapPid) ->
    gen_server:call(MapPid, get_npc_list);
npc_list(MapGid) ->
    ?DO_WITH_MAPID(MapGid, gen_server:call(MapPid, get_npc_list)).

%% @spec cast_special_npc(MapId, Snpcs) -> 
%% MapId = integer() | pid()
%% Snpcs = [#npc_special{}]
%% @doc 广播npc的特效
cast_special_npc(MapPid, Snpcs) when is_pid(MapPid) ->
    MapPid ! {cast_special_npc, Snpcs};
cast_special_npc(MapGid, Snpcs) ->
    ?DO_WITH_MAPID(MapGid, MapPid ! {cast_special_npc, Snpcs}).

%% @spec create_npc(MapId, NpcBaseId, X, Y) ->
%% NpcBaseId = integer() | pid()
%% MapId = integer()
%% X = Y = integer()
%% 创建npc
create_npc(MapPid, NpcBaseId, X, Y) when is_pid(MapPid) ->
    MapPid ! {create_npc, NpcBaseId, X, Y};
create_npc(MapGid, NpcBaseId, X, Y) ->
    ?DO_WITH_MAPID(MapGid, MapPid ! {create_npc, NpcBaseId, X, Y}).

%% @spec elem_enter(MapId, ElemId, Name, X, Y, Data) -> ok
%% MapId = integer() | pid()
%% ElemId = integer()
%% X = Y = integer()
%% Data = tuple()
%% @doc 地图元素进入指定地图
elem_enter(_MapId, Elem) when not is_record(Elem, map_elem) -> ok;
elem_enter(MapPid, Elem) when is_pid(MapPid) ->
    MapPid ! {elem_enter, Elem};
elem_enter(MapGid, Elem) ->
    ?DO_WITH_MAPID(MapGid, MapPid ! {elem_enter, Elem}).

%% @spec elem_leave(MapId, ElemId) -> ok
%% MapId = integer() | pid()
%% ElemId = integer()
%% @doc 地图元素离开地图
elem_leave(MapPid, ElemId) when is_pid(MapPid) ->
    MapPid ! {elem_leave, ElemId};
elem_leave(MapGid, ElemId) ->
    ?DO_WITH_MAPID(MapGid, MapPid ! {elem_leave, ElemId}).

%% @spec elem_info(MapGid, ElemId) -> ok
%% MapGid = {integer(), integer()}
%% ElemId = integer()
%% @doc 查询地图元素信息
elem_info(MapGid, ElemId) ->
    case ets:lookup(map_info, MapGid) of
        [#map{elem = Elems}] -> lists:keyfind(ElemId, #map_elem.id, Elems);
        _ -> false
    end.

%% @spec lookup_elems(MapId, BaseId) -> ElemList
%% MapId = BaseId = integer()
%% ElemList = [#elem{} | ...]
%% @doc 根据 baseid 查找地图元素
lookup_elems(MapGid, BaseId) ->
    case ets:lookup(map_info, MapGid) of
        [#map{elem = Elems}] -> [Elem || Elem = #map_elem{base_id = Bid} <- Elems, Bid =:= BaseId];
        _ -> []
    end.

%% @spec elem_action(MapId, ElemId, Status, Role) -> {ok} | {ok, NewRole} | {false, Reason}
%% MapId = integer()
%% ElemId = integer()
%% Status = integer()
%% Role = NewRole = #role{}
%% Reason = bitstring()
%% @doc 处理角色对地图元素的操作事件
%% <div>事件定义在map_elem_action.erl中，未定义的事件将被忽略</div> 
elem_action(MapGid, ElemId, Status, Role = #role{cross_srv_id = CrossSrvId, pos = #pos{x = X, y = Y}}) -> case map_mgr:get_map_info(CrossSrvId, MapGid) of [] ->
            ?DEBUG("地图[~w]不存在，无法进行操作", [MapGid]),
            {ok};
        [Map = #map{elem = Elems, pid = _MapPid}] ->
            case lists:keyfind(ElemId, #map_elem.id, Elems) of
                false ->
                    ?DEBUG("地图[~w]中不存在地图元素[~w]", [MapGid, ElemId]),
                    {ok};

                %% 距离检查
                #map_elem{name = _Name, x = Ex, y = Ey} when abs(Ex - X) > 500 orelse abs(Ey - Y) > 500 ->
                    {false, ?L(<<"距离目标太远，无法操作">>)};
                
                %% 禁止操作
                #map_elem{disabled = Disabled} when Disabled =/= <<>> ->
                    {false, Disabled};
                
                Elem = #map_elem{condition = Conditions} ->
                    case role_cond:check(Conditions, Role) of 
                        {false, #condition{msg = Msg}} ->
                            {false, Msg};
                        true ->
                            case map_elem_action:def(Elem, Status) of
                                undefined ->
                                    ?DEBUG("无法对地图[~w]中的元素[~w]进行操作", [MapGid, ElemId]),
                                    {ok};
                                EventName -> map_elem_action:do(EventName, Elem, Map, Role)
                            end
                    end
            end
    end.

%% @spec elem_change(MapPid, ElemId, Status) -> ok
%% MapPid = pid()
%% ElemId = integer()
%% Status = integer()
%% @doc 更新地图元素状态
elem_change(MapPid, ElemId, Status) ->
    MapPid ! {elem_change, ElemId, Status}.

%%初始隐藏副本宝箱状态
init_hide_box(MapPid, OpenedBoxes) ->
    gen_server:call(MapPid, {init_hide_box, OpenedBoxes}).

%% @spec elem_update(MapPid, Elem) -> ok
%% MapPid = pid()
%% Elem = #map_elem{}
%% @doc 更新地图元素信息
elem_update(MapPid, Elem) when is_pid(MapPid) ->
    MapPid ! {elem_update, Elem};
elem_update(MapGid, Elem) ->
    ?DO_WITH_MAPID(MapGid, MapPid ! {elem_update, Elem}).

%% @spec elem_enable(MapPid, ElemId) -> ok
%% MapPid = pid()
%% ElemId = integer()
%% 激活地图元素为可操作
elem_enable(MapPid, ElemId) ->
    MapPid ! {elem_enable, ElemId}.

%% @spec elem_disable(MapPid, ElemId, Reason) -> ok
%% MapPid = pid()
%% ElemId = integer()
%% Reason = bitstring()
%% 禁止地图元素操作
elem_disable(MapPid, ElemId, Reason) ->
    MapPid ! {elem_disable, ElemId, Reason}.

%% @spec elem_fetch(MapId, ElemId) -> true | false
%% @doc 从地图中取出某个地图元素(一般用于宝箱或其它独占类的元素)
elem_fetch(MapPid, ElemId) when is_pid(MapPid) ->
    gen_server:call(MapPid, {elem_fetch, ElemId}).

%% @spec followers_enter(MapId, MapRole) -> Result
%% MapId = integer() | pid()
%% MapRoles = [#map_role{}]
%% Result = pid() | false
%% @doc FollowerRole进入地图
followers_enter(_, []) ->
    false;
followers_enter(MapPid, Roles = [#role{}|_]) when is_pid(MapPid) ->
    MapRoles = lists:foldr(fun(R, Acc)->
        case role_convert:do(to_map_role, R) of
            {ok, MR} -> [MR|Acc];
            _ -> Acc
        end
    end, [], Roles),
    followers_enter(MapPid, MapRoles);
followers_enter(MapPid, MapRoles) when is_pid(MapPid) ->
    MapPid ! {followers_enter, MapRoles},
    MapPid;
followers_enter(MapId, MapRoles) when is_integer(MapId) -> %% 默认进入第一条线
    followers_enter({1, MapId}, MapRoles);
followers_enter(MapGid, MapRoles) ->
    case ets:lookup(map_info, MapGid) of
        [#map{pid = MapPid, base_id = BaseId}] ->
            followers_enter(MapPid, MapRoles),
            {BaseId, MapPid};
        _ -> false
    end.

%% @spec send_10111(MapPid, RolePid, ConnPid, X, Y) -> ok
%% MapPid = pid()
%% RolePid = pid()
%% X = Y = integer()
%% @doc 发送10111地图数据包(出于优化考虑，直接将数据发出，避免进程间传输数据)
send_10111(MapPid, RolePid, ConnPid, X, Y) ->
    MapPid ! {send_10111, RolePid, ConnPid, X, Y}.

%% @spec send_to_near(MapGid, {X, Y}, Bin) -> ok
%% MapPid = pid() | {int(), int()}
%% X = integer()
%% Y = integer()
%% Bin = binary()
%% @doc 广播消息到邻近(九宫格)
send_to_near(MapPid, {X, Y}, Bin) when is_pid(MapPid) ->
    MapPid ! {send_to_near, X, Y, Bin};
send_to_near(MapGid, {X, Y}, Bin) ->
    ?DO_WITH_MAPID(MapGid, MapPid ! {send_to_near, X, Y, Bin}).

%% @spec pack_send_to_near(MapPid, {X, Y}, Cmd, Data) -> ok
%% MapPid = integer() | pid()
%% X = integer()
%% Y = integer()
%% Cmd = integer()
%% Data = tuple()
%% @doc 打包并广播消息到邻近(九宫格)
pack_send_to_near(MapPid, {X, Y}, Cmd, Data) ->
    case sys_conn:pack(Cmd, Data) of
        {ok, Bin} ->
            send_to_near(MapPid, {X, Y}, Bin);
        {false, Reason} ->
            ?ERR("打包数据出错[Reason:~w Cmd:~w Data:~w]", [Reason, Cmd, Data])
    end.

%% @spec send_to_all(MapGid, Bin) -> ok
%% MapGid = {integer(), integer()} | pid()
%% Bin = binary()
%% @doc 广播消息到全地图
send_to_all(MapPid, Bin) when is_pid(MapPid) ->
    MapPid ! {send_to_all, Bin};
send_to_all(MapGid, Bin) ->
    ?DO_WITH_MAPID(MapGid, MapPid ! {send_to_all, Bin}).

%% @spec pack_send_to_all(MapGid, Cmd, Data) -> ok
%% MapId = {integer(), integer()} | pid()
%% Cmd = integer()
%% Data = tuple()
%% @doc 打包并发送数据到地图中的所有角色
pack_send_to_all(MapGid, Cmd, Data) ->
    case sys_conn:pack(Cmd, Data) of
        {ok, Bin} ->
            send_to_all(MapGid, Bin);
        {false, Reason} ->
            ?ERR("打包数据出错[Reason:~w Cmd:~w Data:~w]", [Reason, Cmd, Data])
    end.

%% @spec calc_disttance(Pos1, Pos2) -> {ok, {Dx, Dy}} | false
%% Pos1 = Pos2 = #pos{}
%% Dist = DistY = integer()
%% @doc 计算两个位置的距离(pixel)，不在同场景的返回false
calc_distance(#pos{map_pid = MapPid, x = X1, y = Y1}, #pos{map_pid = MapPid, x = X2, y = Y2}) ->
    Dx = erlang:abs(X1 - X2),
    Dy = erlang:abs(Y1 - Y2),
    {ok, {Dx, Dy}};
calc_distance(_, _) ->
    false.

%% @spec get_revive(MapBaseId) -> {ok, Revive} | {false, Reason}
%% MapBaseId = integer() 地图基础ID
%% ReviveList = {integer(), integer()} 复活点 {x, y}
%% @doc 获取地图的复活点列表
%% <div> 此接口只符合 BaseId和MapId值相同时有效 </div>
get_revive(MapBaseId) ->
    case map_data:get(MapBaseId) of
        false -> {false, ?L(<<"地图不存在">>)};
        #map_data{revive = []} -> {false, ?L(<<"未找到复活点">>)};
        #map_data{revive = L} ->
            {ok, util:rand_list(L)} %% 随机复活点
    end.

%% @spec is_security(Pos) -> boolean()
%% Pos = #pos{} 位置信息
%% @doc 判断是否处于安全区域，或者是否主城
is_security(#pos{map_base_id = MapBaseId}) ->
    case map_data:get(MapBaseId) of
        #map_data{type = ?map_type_safe} -> true;
        #map_data{} -> false;
        _ -> false
    end;
is_security(_) -> false.

is_town(MapBaseId) ->
    case map_data:get(MapBaseId) of
        #map_data{type = ?map_type_town} -> true;
        #map_data{} -> false;
        _ -> false
    end.

%% @spec start_link(Map) -> ok
%% Map = #map{}
%% @doc 启动一个地图进程
start_link(Map) ->
    gen_server:start_link(?MODULE, [Map], []).

%% @spec stop(MapPid) -> ok
%% @doc 关闭某个地图
stop(MapPid) ->
    MapPid ! stop.

%% @spec reset(MapPid) -> ok
%% @doc 重置地图信息（清空地图上所有人物）
reset(MapPid) ->
    MapPid ! reset.
reset(MapPid, FeedbackPid, FeedbackMsg) ->
    MapPid ! {reset, FeedbackPid, FeedbackMsg}.

%%----------------------------------------------------
%% 内部处理
%%----------------------------------------------------

init([Map = #map{id = _Id, base_id = _BaseId, width = W, height = _H}]) ->
    %% process_flag(min_heap_size, 10240),
    process_flag(trap_exit, true),
    %% erlang:register(list_to_atom(lists:concat(["map_", Id, BaseId])), self()),
    put(role_list, []),
    put(npc_list, []),
    put(followers_list, []),
    group(?SLICE(W) + 1),
    M = Map#map{pid = self()},
    sync(M), %% 同步地图信息
    {ok, M}.

%% 获取指定坐标周围的角色列表(附近九宫格)
handle_call({get_role_in_slice, X, _Y}, _From, State = #map{width = W, height = _H}) ->
    Dx = ?DX(X, W),
    L = [get(P) || P <- ?SLICE_NEAR(?SLICE(Dx))],
    {reply, flatmap(L, []), State};

%% 获取指定范围内的角色列表(附近九宫格内一定像素范围内)
handle_call({get_role_in_range, X, Y, Range}, _From, State = #map{width = W, height = H}) ->
    Dx = ?DX(X, W),
    Dy = ?DY(Y, H),
    L = [get(P) || P <- ?SLICE_NEAR(?SLICE(Dx))],
    RoleList = [Role || Role <- flatmap(L, []), math:pow(Role#map_role.x - Dx, 2) + math:pow(Role#map_role.y - Dy, 2) < math:pow(Range, 2) ], 
    {reply, RoleList, State};

%% 查询指定角色的信息
handle_call({get_role_info, RolePid}, _From, State) ->
    {reply, lists:keyfind(RolePid, #map_role.pid, get(role_list)), State};

%% 获取所有的角色
handle_call(get_role_list, _From, State) ->
    {reply, get(role_list), State};

%% 获取NPC列表
handle_call(get_npc_list, _From, State) ->
    {reply, get(npc_list), State};

%% 从地图中取出某个地图元素(一般用于宝箱或其它独占类的元素)
handle_call({elem_fetch, Id}, _From, State = #map{elem = Elems}) ->
    case lists:keyfind(Id, #map_elem.id, Elems) of
        false -> {reply, false, State};
        _Elem ->
            {ok, Msg} = proto_101:pack(srv, 10131, {Id}),
            do_cast(get(role_list), Msg),
            NewState = State#map{elem = lists:keydelete(Id, #map_elem.id, Elems)},
            sync(NewState),
            {reply, true, NewState}
    end;

%% 获取内部状态信息
handle_call(i, _From, State = #map{width=W}) ->
    Info = [ 
        case get(Slice) of 
            undefined -> 0;
            L -> length(L)
        end || Slice <- lists:seq(0, ?SLICE(W)) ],
    {reply, Info, State};

handle_call({init_hide_box, OpenedBoxes}, _From, State = #map{elem = Elems}) ->
    Elems2 = lists:map(fun(Elem = #map_elem{id = Id}) ->
                case lists:member(Id, OpenedBoxes) of
                    false ->
                        Elem;
                    true ->
                        Elem#map_elem{status = ?box_open}
                end
        end, Elems),
    State2 = State#map{elem = Elems2},
    sync(State2),
    {reply, ok, State2};

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

%% 获取10111数据
handle_info({send_10111, RolePid, ConnPid, X, Y}, State = #map{elem = Elems}) ->
    L0 = get(role_list),
    L = case State#map.type of
        ?map_type_dungeon ->
            lists:keydelete(RolePid, #map_role.pid, get(role_list)); %% 如果是副本，获取全场景所有角色数据
        ?map_type_expedition ->
            lists:keydelete(RolePid, #map_role.pid, get(role_list));
        _ ->
            flatmap([lists:keydelete(RolePid, #map_role.pid, RL) || P <- ?SLICE_NEAR(?SLICE(X)), (RL = get(P)) =/= undefined], [])
    end,
    L2 = case {L0, get(followers_list)} of
        {_, []} -> L;
        {[#map_role{}], FollowersL} ->
            {FollowersL2, _} =  lists:mapfoldl(fun(FR, I)->
                    {Fx, Fy} = case I of
                        1 -> {X - 40, Y + 40};
                        _ -> {X - 80, Y}
                    end,
                    {FR#map_role{x = Fx, y = Fy, dest_x = Fx, dest_y = Fy}, I+1}
            end, 1, FollowersL),
            L ++ FollowersL2;
        {_, FollowersL} -> L ++ FollowersL
    end,
    case catch proto_101:pack(srv, 10111, {Elems, get(npc_list), L2}) of
        {ok, Msg} -> 
            ConnPid ! {send_data, Msg},
            %% 处理特效NPC
            npc_mgr:handle_special_npc(ConnPid, [BaseId || #map_npc{base_id = BaseId} <- get(npc_list)]);
        _Err ->
            ?DEBUG("地图进程发生错误: ~w", [_Err])
    end,
    {noreply, State};

%% 全地图广播处理
handle_info({send_to_all, Bin}, State) ->
    do_cast(get(role_list), Bin),
    {noreply, State};

%% 附近广播处理
handle_info({send_to_near, X, Bin}, State) ->
    ?CAST(?SLICE(X), Bin),
    {noreply, State};

%% 进入地图处理
handle_info({role_enter, MapRole = #map_role{rid = Rid, srv_id = SrvId, name = _Name, pid = Rpid, conn_pid = ConnPid, x = X, y = Y}}, State = #map{id = MapId, base_id = BaseId, width = W, height = H}) ->
    Dx = ?DX(X, W),
    Dy = ?DY(Y, H),
    Slice = ?SLICE(Dx),
    R = MapRole#map_role{map = MapId, slice = Slice, dir = ?map_role_dir_right},
    RoleList = get(role_list),
    %% change by hyq 修改格子有多个maprole问题
    case lists:keyfind(Rpid, #map_role.pid, RoleList) of
        false ->
            put(role_list, [R | RoleList]),
            case State#map.type of
                ?map_type_dungeon -> do_cast(get(role_list), pack_enter_msg(R));  %% 副本内，广播进入消息给全场景
                ?map_type_expedition -> do_cast(get(role_list), pack_enter_msg(R));
                _ -> ?CAST(Slice, pack_enter_msg(R)) %% 广播进入消息到附近
            end,
            put(Rpid, Slice),
            case find_by_rid(get(Slice), Rid, SrvId) of
                false -> 
                    put(Slice, [R | get(Slice)]); %% 注册进入区域
                #map_role{pid = MapRolePid} ->
                    ?ERR("纠正角色[~s]旧MapRole信息", [_Name]),
                    put(Slice, lists:keydelete(MapRolePid, #map_role.pid, get(Slice))),
                    put(Slice, [R | get(Slice)]);
                _ -> 
                    ignore
            end,
            ?DEBUG("角色[~s]进入了地图[Id:~w BaseId:~w]，注册到了[~w:~w][Slice:~w][~p]", [_Name, MapId, BaseId, Dx, Dy, Slice, ?NAMES(Slice)]),
            sys_conn:pack_send(ConnPid, 10110, {BaseId, Dx, Dy}),
            trigger_event({role_enter, {{Rid, SrvId}, Rpid}}, {}, State);

        #map_role{} -> %% (role_list里面map_role的slice不更新)
            case put(Rpid, Slice) of
                undefined ->
                    ?ERR("error : undefined"),
                    sys_conn:pack_send(ConnPid, 10110, {BaseId, Dx, Dy});
                Slice ->  %% 回到原来的广播区域中
                    ?DEBUG("角色[~s]进入了地图，已经在地图中", [_Name]),
                    replace_map_role(Slice, Rpid, R), %% 可能是副本外影子，需要替换
                    sys_conn:pack_send(ConnPid, 10110, {BaseId, Dx, Dy});
                OldSlice ->  %% 相同地图，不同广播区域 
                    ?DEBUG("角色[~s]进入了地图操作失败，已经在地图中", [_Name]),
                    put(OldSlice, lists:keydelete(Rpid, #map_role.pid, get(OldSlice))), %% 离开原区域
                    put(Slice, [R | get(Slice)]), %% 加入新区域
                    put(role_list, lists:keyreplace(Rpid, #map_role.pid, get(role_list), R)),
                    {ok, LeaveMsg} = proto_101:pack(srv, 10114, {Rid, SrvId}),  %% 广播离开区域
                    case State#map.type of
                        ?map_type_dungeon -> 
                            do_cast(get(role_list), LeaveMsg),
                            do_cast(get(role_list), pack_enter_msg(R));  %% 副本内，广播进入消息给全场景
                        ?map_type_expedition -> 
                            do_cast(get(role_list), LeaveMsg),
                            do_cast(get(role_list), pack_enter_msg(R));
                        _ -> 
                            ?CAST(OldSlice, LeaveMsg),
                            ?CAST(Slice, pack_enter_msg(R)) %% 广播进入消息到附近
                    end,
                    sys_conn:pack_send(ConnPid, 10110, {BaseId, Dx, Dy})
            end
    end,
    {noreply, State};

%% 角色移动
handle_info({role_move_step, RolePid, OldX, OldY, NewX, NewY, IsNotifyNpc}, State = #map{width = W, height = H}) ->
    ?DEBUG("role_move_step (~p, ~p) -> (~p, ~p)", [OldX, OldY, NewX, NewY]),
    Ox = ?DX(OldX, W),
    Oy = ?DY(OldY, H),
    Slice = ?SLICE(Ox),
    case lists:keyfind(RolePid, #map_role.pid, get(Slice)) of
        false ->
            ?DEBUG("无效的移动操作"),
            ignore;
        R ->
            Nx = ?DX(NewX, W),
            Ny = ?DY(NewY, H),
            NewR = R#map_role{x = Nx, y = Ny, slice = ?SLICE(Nx)},
            do_role_move_step(NewR, Ox, Oy, Slice, State),
            case IsNotifyNpc of
                true ->
                    check_fight_line(RolePid, R#map_role.x, Nx);  %% 检查战斗线(TODO 临时处理办法，低效) 
                _ -> 
                    ignore
            end,
            ok
    end,
    {noreply, State};

%% 角色发送拐点，改变方向
handle_info({role_move_towards, RolePid, Sx, Sy, DestX, DestY, Dir}, State = #map{width = W, height = H}) ->
    ?DEBUG("role_move_towards (~p, ~p) -> (~p, ~p) ------------------------", [Sx, Sy, DestX, DestY]),
    X = ?DX(Sx, W),
    Y = ?DY(Sy, H),
    Slice = ?SLICE(X),
    case lists:keyfind(RolePid, #map_role.pid, get(Slice)) of
        false ->
            ?DEBUG("无效的方向移动操作"),
            ignore;
        R = #map_role{rid = Rid, srv_id = SrvId} ->
            Dx = ?DX(DestX, W),
            Dy = ?DY(DestY, H),
            NewR = R#map_role{dest_x = Dx, dest_y = Dy, x = X, y = Y, dir = Dir},
            put(Slice, lists:keyreplace(RolePid, #map_role.pid, get(Slice), NewR)),
            {ok, MoveMsg} = proto_101:pack(srv, 10115, {Rid, SrvId, DestX, DestY}),
            case State#map.type of
                ?map_type_dungeon -> do_cast(get(role_list), MoveMsg); %% 副本全场景广播
                ?map_type_expedition -> do_cast(get(role_list), MoveMsg); 
                _ -> ?CAST(RolePid, Slice, MoveMsg)  %% 一般场景区域广播
            end,
            ok
    end,
    {noreply, State};

%% 角色即时移动(暂时只提供给多人副本战斗中会使用)
handle_info({role_jump, RolePid, OldX, OldY, NewX, NewY}, State = #map{width = W, height = H}) ->
    ?DEBUG("role_jump (~p, ~p) -> (~p, ~p)", [OldX, OldY, NewX, NewY]),
    Ox = ?DX(OldX, W),
    _Oy = ?DY(OldY, H),
    OldSlice = ?SLICE(Ox),
    case lists:keyfind(RolePid, #map_role.pid, get(OldSlice)) of
        false ->
            ?DEBUG("无效的移动操作"),
            ignore;
        R ->
            Nx = ?DX(NewX, W),
            Ny = ?DY(NewY, H),
            NewSlice = ?SLICE(Nx),
            NewR = R#map_role{x = Nx, y = Ny, dest_x = Nx, dest_y = Ny, slice = NewSlice},
            case OldSlice =/= NewSlice of
                true ->
                    put(RolePid, NewSlice),
                    put(OldSlice, lists:keydelete(RolePid, #map_role.pid, get(OldSlice))),  %% 从旧区域删除
                    put(NewSlice, [NewR | get(NewSlice)]); %% 加入新区域
                _ ->
                    ignore
            end,
            %% 暂时只有多人战斗中使用，暂不需要广播 
            %{ok, MoveMsg} = proto_101:pack(srv, 10115, {R#role_map.rid, R#role_map.srv_id, Nx, Ny}),
            %case State#map.type of
            %    ?map_type_dungeon -> do_cast(get(role_list), MoveMsg); %% 副本全场景广播
            %    _ -> ?CAST(RolePid, NewSlice, MoveMsg)  %% 一般场景区域广播
            %end,
            ok
    end,
    {noreply, State};


%% 角色离开地图处理
handle_info({role_leave, RolePid, Rid, SrvId, Sx, _Sy}, State = #map{id = _Id, width = W, height = _H}) ->
    X = ?DX(Sx, W),
    Slice = ?SLICE(X),
    erase(RolePid),
    put(role_list, lists:keydelete(RolePid, #map_role.pid, get(role_list))),
    put(Slice, lists:keydelete(RolePid, #map_role.pid, get(Slice))), %% 注销离开区域
    {ok, LeaveMsg} = proto_101:pack(srv, 10114, {Rid, SrvId}),
    case State#map.type of
        ?map_type_dungeon -> do_cast(get(role_list), LeaveMsg); %% 副本全场景广播
        ?map_type_expedition -> do_cast(get(role_list), LeaveMsg);
        _ -> ?CAST(Slice, LeaveMsg) %% 区域广播离开消息
    end,
    ?DEBUG("角色[~w:~s]离开了地图[~w]", [Rid, SrvId, _Id]),
    {noreply, State};

%% 角色离开地图处理
handle_info({role_leave, RolePid}, State = #map{id = _Id}) ->
    case erase(RolePid) of
        undefined -> ignore;
        Slice ->
            case lists:keyfind(RolePid, #map_role.pid, get(Slice)) of
                false ->
                    ignore;
                #map_role{rid = Rid, srv_id = SrvId} ->
                    put(role_list, lists:keydelete(RolePid, #map_role.pid, get(role_list))),
                    put(Slice, lists:keydelete(RolePid, #map_role.pid, get(Slice))), %% 注销离开区域
                    {ok, LeaveMsg} = proto_101:pack(srv, 10114, {Rid, SrvId}),
                    case State#map.type of
                        ?map_type_dungeon -> do_cast(get(role_list), LeaveMsg); %% 副本全场景广播
                        ?map_type_expedition -> do_cast(get(role_list), LeaveMsg);
                        _ -> ?CAST(Slice, LeaveMsg) %% 区域广播离开消息
                    end,
                    ?DEBUG("角色[~w:~s]离开了地图[~w]", [Rid, SrvId, _Id])
            end
    end,
    {noreply, State};


%% 更新角色信息(注意:map, x, y, slice不能通过非map接口进行更新，否则会出现错误)
handle_info({role_update, MapRole = #map_role{pid = RolePid, x = Sx, y = _Sy}}, State = #map{width = W, height = _H}) ->
    X = ?DX(Sx, W),
    Slice = ?SLICE(X),
    Mr = MapRole#map_role{slice = Slice},
    put(Slice, lists:keyreplace(RolePid, #map_role.pid, get(Slice), Mr)),
    ?DEBUG("角色[~s][帮会~s]更新了场景信息:[SPEED:~w, EVENT:~w]", [MapRole#map_role.name, MapRole#map_role.guild, MapRole#map_role.speed, MapRole#map_role.event]),
    Bin = pack_refresh_msg(Mr),
    case State#map.type of
        ?map_type_dungeon -> do_cast(get(role_list), Bin); %% 副本, 全场景广播
        ?map_type_expedition -> do_cast(get(role_list), Bin);
        _ -> ?CAST(Slice, Bin)  %% 一般场景，区域广播
    end,
    {noreply, State};

%% 设置角色为副本外的影子，不接受场景的广播
handle_info({role_shadow, RolePid}, State = #map{width = W, height = H}) ->
    case get(RolePid) of
        undefined -> ignore;
        Slice ->
            case lists:keyfind(RolePid, #map_role.pid, get(Slice)) of
                false -> ignore;
                R = #map_role{x = NowX, y = NowY} ->
                    Anger = util:rand(0, 180) * 3.14 / 180,
                    Range = util:rand(20, 70),
                    X0 = NowX - round(math:sin(Anger) * Range),
                    Y0 = NowY - round(math:cos(Anger) * Range),
                    X = ?DX(X0, W),
                    Y = ?DY(Y0, H),
                    NewR = R#map_role{conn_pid = undefined, x = X, y = Y, dest_x = X, dest_y = Y},
                    replace_map_role(Slice, RolePid, NewR)
            end
    end,
    {noreply, State};

%% NPC进入地图
handle_info({npc_enter, MapNpc = #map_npc{id = NpcId, status = Status, base_id = BaseId, speed = Speed, x = X, y = Y}}, State = #map{id = _MapId, width = W, height = H}) ->
    NpcList = get(npc_list),
    case lists:keyfind(NpcId, #map_npc.id, NpcList) of
        false ->
            Dx = ?DX(X, W),
            Dy = ?DY(Y, H),
            Npc = MapNpc#map_npc{ x = Dx, y = Dy},
            put(npc_list, [Npc | NpcList]),
            %% 10120协议改了记得一定要改wanted_npc的10120协议！！！！！
            {ok, Msg} = proto_101:pack(srv, 10120, {NpcId, Status, BaseId, Speed, Dx, Dy}),
            %% ?DEBUG("NPC[~w:~s]进入了地图", [NpcId, Name]),
            do_cast(get(role_list), Msg);
        _ ->
            ignore
    end,
    {noreply, State};

%% NPC移动
handle_info({npc_move, NpcId, DestX, DestY}, State = #map{width = W, height = H}) ->
    NpcList = get(npc_list),
    case lists:keyfind(NpcId, #map_npc.id, NpcList) of
        false ->
            ?DEBUG("无效的移动操作"),
            ignore;
        N = #map_npc{name = _Name} ->
            Dx = ?DX(DestX, W),
            Dy = ?DY(DestY, H),
            %% ?DEBUG("[~s]移动到了[~w:~w]", [_Name, Dx, Dy]),
            NewN = N#map_npc{x = Dx, y = Dy},
            put(npc_list, lists:keyreplace(NpcId, #map_npc.id, NpcList, NewN)),
            {ok, Msg} = proto_101:pack(srv, 10122, {NpcId, Dx, Dy}),
            do_cast(get(role_list), Msg)
    end,
    {noreply, State};

%% 更新NPC信息(map,x,y,slice不能被外部更新)
handle_info({npc_update, MapNpc = #map_npc{id = NpcId, status = Status, base_id = BaseId, speed = Speed}}, State) ->
    NpcList = get(npc_list),
    case lists:keyfind(NpcId, #map_npc.id, NpcList) of
        false -> ignore;
        #map_npc{map = MapId, x = X, y = Y} ->
            NewMapNpc = MapNpc#map_npc{map = MapId, x = X, y = Y},
            put(npc_list, lists:keyreplace(NpcId, #map_npc.id, NpcList, NewMapNpc)),
            {ok, Msg} = proto_101:pack(srv, 10120, {NpcId, Status, BaseId, Speed, X, Y}),
            do_cast(get(role_list), Msg)
    end,
    {noreply, State};

%% NPC离开地图处理
handle_info({npc_leave, NpcId}, State) ->
    handle_info({npc_leave, NpcId, cast}, State);

%% Cast = cast | no_cast
handle_info({npc_leave, NpcId, Cast}, State) ->
    NpcList = get(npc_list),
    case lists:keyfind(NpcId, #map_npc.id, NpcList) of
        false ->
            ?DEBUG("离开地图失败:NPC[~w]不在地图中", [NpcId]),
            {noreply, State};
        _Npc = #map_npc{base_id = NpcBaseId} ->
            put(npc_list, lists:keydelete(NpcId, #map_npc.id, NpcList)),
            case Cast of
                cast ->
                    {ok, Msg} = proto_101:pack(srv, 10121, {NpcId}),
                    do_cast(get(role_list), Msg);
                _ ->
                    ignore
            end,
            NewState = handle_kill_all_npc({npc_leave, NpcBaseId}, State),
            {noreply, NewState}
    end;

%% 创建NPC
handle_info({create_npc, NpcBaseId, X, Y}, State = #map{id = Mid}) ->
    npc_mgr:create(NpcBaseId, Mid, X, Y),
    {noreply, State};

%% 杀光地图所有活动npc
handle_info({clear_npc}, State) ->
    NpcList = get(npc_list),
    kill(NpcList),
    {noreply, State};

%% 杀光地图所有守卫洛水npc
handle_info({clear_guard_npc}, State) ->
    NpcList = get(npc_list),
    kill_guard(NpcList),
    {noreply, State};

%% 杀光帮会地图上所有的帮会怪物
handle_info({clear_guild_monster}, State) ->
    NpcList = get(npc_list),
    kill_guild_monster(NpcList),
    {noreply, State};

handle_info({clear_fun_type_npc, FunType}, State) ->
    NpcList = get(npc_list),
    kill_fun_type_npc(FunType, NpcList),
    {noreply, State};

%% 广播npc特效
handle_info({cast_special_npc, Snpcs}, State) ->
    {ok, Msg} = proto_101:pack(srv, 10124, {Snpcs}),
    do_cast(get(role_list), Msg),
    {noreply, State};

%% 地图元素出现
handle_info({elem_enter,
        Elem = #map_elem{id = Id, base_id = BaseId, status = Status, type = Type, x = X, y = Y}},
    State = #map{id = _MapId, name = _MapName, width = W, height = H, elem = Elems}
) ->
    case lists:keyfind(Id, #map_elem.id, Elems) of
        false ->
            Dx = ?DX(X, W),
            Dy = ?DY(Y, H),
            {ok, Msg} = proto_101:pack(srv, 10130, {Id, BaseId, Type, Status, Dx, Dy}),
            do_cast(get(role_list), Msg),
            E = Elem#map_elem{x = Dx, y = Dy},
            NewState = State#map{elem = [E | Elems]},
            sync(NewState),
            %% ?DEBUG("地图元素[~w:~s]进入了地图[~w:~s]", [NpcId, Name, _MapId, _MapName]),
            {noreply, NewState};
        _ ->
            {noreply, State}
    end;

%% 改变地图元素状态
handle_info({elem_change, Id, Status}, State = #map{elem = Elems}) ->
    case lists:keyfind(Id, #map_elem.id, Elems) of
        false ->
            ?DEBUG("操作失败:地图元素[~w]不在地图中", [Id]),
            {noreply, State};
        Elem ->
            {ok, Msg} = proto_101:pack(srv, 10132, {Id, Status}),
            do_cast(get(role_list), Msg),
            NewState = State#map{elem = lists:keyreplace(Id, #map_elem.id, Elems, Elem#map_elem{status = Status})},
            NewState2 = trigger_event({elem_status, Id, Status}, {}, NewState),
            sync(NewState2),
            {noreply, NewState2}
    end;

%% 更新地图元素属性
handle_info({elem_update,
        Elem = #map_elem{id = Id, base_id = BaseId, name = _Name, status = Status, type = Type, x = X, y = Y}},
    State = #map{width = W, height = H, elem = Elems}
)->
    Dx = ?DX(X, W),
    Dy = ?DY(Y, H),
    {ok, Msg} = proto_101:pack(srv, 10130, {Id, BaseId, Type, Status, Dx, Dy}),
    do_cast(get(role_list), Msg),
    E = Elem#map_elem{x = Dx, y = Dy},
    NewState = State#map{elem = lists:keyreplace(Id, #map_elem.id, Elems, E)},
    sync(NewState),
    ?DEBUG("地图元素[~w:~s]已更新属性", [Id, _Name]),
    {noreply, NewState};

%% 激活地图元素, 变为可操作
handle_info({elem_enable, ElemId}, State = #map{elem = Elems}) ->
    case lists:keyfind(ElemId, #map_elem.id, Elems) of
        false ->
            ?DEBUG("不存在此地图元素: ~w~n", [ElemId]),
            {noreply, State};
        E ->
            NewState = State#map{elem = lists:keyreplace(ElemId, #map_elem.id, Elems, E#map_elem{disabled = <<>>})},
            sync(NewState),
            {noreply, NewState}
    end;

%% 禁止地图元素， 变为不可操作
handle_info({elem_disable, ElemId, Reason}, State = #map{elem = Elems}) ->
    case lists:keyfind(ElemId, #map_elem.id, Elems) of
        false ->
            ?DEBUG("不存在此地图元素: ~w~n", [ElemId]),
            {noreply, State};
        E ->
            NewState = State#map{elem = lists:keyreplace(ElemId, #map_elem.id, Elems, E#map_elem{disabled = Reason})},
            sync(NewState),
            {noreply, NewState}
    end;


%% 地图元素消失
handle_info({elem_leave, Id}, State = #map{elem = Elems}) ->
    case lists:keyfind(Id, #map_elem.id, Elems) of
        false ->
            ?DEBUG("离开地图失败:地图元素[~w]不在地图中", [Id]),
            {noreply, State};
        _Elem ->
            {ok, Msg} = proto_101:pack(srv, 10131, {Id}),
            do_cast(get(role_list), Msg),
            NewState = State#map{elem = lists:keydelete(Id, #map_elem.id, Elems)},
            sync(NewState),
            {noreply, NewState}
    end;

%% 随从进入地图
handle_info({followers_enter, MapRoles = [_|_]}, State) ->
    put(followers_list, get(followers_list) ++ MapRoles),
    {noreply, State};

%% 关闭地图
handle_info(stop, State) ->
    {stop, normal, State};

%% NPC被杀消息
handle_info({kill_npc, NpcList}, State = #map{}) when is_list(NpcList) ->
    Evts = [{kill_npc, BaseId} || BaseId <- NpcList],
    NewState = trigger_kill_npc(Evts, 1, State),
    {noreply, NewState};

%% NPC被杀消息
handle_info({combat_over_result, Args}, State = #map{}) when is_list(Args) ->
    ?DEBUG("combat_over_result: ~w", [Args]),
    NpcList = case lists:keyfind(kill_npc, 1, Args) of
        {kill_npc, L} when is_list(L) -> 
            [_NpcId || _NpcId <- L, _NpcId =/= 0];
        _ -> 
            []
    end,
    Round = case lists:keyfind(round, 1, Args) of
        {round, X} when is_integer(X) ->
            X;
        _ ->
            0
    end,
    %% TODO NPC被杀发npc_leave消息
    lists:foreach(fun(NpcId) -> 
                map:npc_leave_without_cast(self(), NpcId) 
        end, NpcList),

    ?DEBUG("地图进程[~w]收到怪物被杀消息: ~w", [State#map.base_id, NpcList]),
    Evts = [{kill_npc, BaseId} || BaseId <- NpcList],
    NewState = trigger_kill_npc(Evts, Round, State),
    {noreply, NewState};

%% 重构elem消息
handle_info({recreate_elem, Elem, TimeAfter}, State) ->
    erlang:send_after(TimeAfter, self(), {recreate_elem, Elem}),
    {noreply, State};
handle_info({recreate_elem, Elem = #map_elem{id = Id, base_id = BaseId, name = Name, type = Type, status = Status, disabled = Disabled, x = X, y = Y}}, State = #map{id = _MapId, name = _MapName, width = W, height = H, elem = Elems}) ->
    case lists:keyfind(Id, #map_elem.id, Elems) of
        false ->
            Dx = ?DX(X, W),
            Dy = ?DY(Y, H),
            {ok, Msg} = proto_101:pack(srv, 10130, {Id, BaseId, Name, Type, Status, Disabled, Dx, Dy}),
            do_cast(get(role_list), Msg),
            E = Elem#map_elem{x = Dx, y = Dy},
            NewState = State#map{elem = [E | Elems]},
            sync(NewState),
            {noreply, NewState};
        _ ->
            {noreply, State}
    end;

%% 重置地图信息（清空地图上所有人物）
handle_info(reset, State = #map{width = W, height = _H}) ->
    put(role_list, []),
    group(?SLICE(W) + 1),
    {noreply, State};
handle_info({reset, FeedbackPid, FeedbackMsg}, State = #map{width = W, height = _H}) ->
    put(role_list, []),
    group(?SLICE(W) + 1),
    case is_pid(FeedbackPid) of
        true -> FeedbackPid ! FeedbackMsg;
        false -> ignore
    end,
    {noreply, State};

%%休闲玩法失败时触发副本评分
handle_info({combat_over_lost, _Args}, State = #map{owner_pid = OwnerPid}) ->
    ?DEBUG("combat_over_result: ~w", [_Args]),
    dungeon:post_event(OwnerPid, {dun_clear_leisure, ?combat_result_lost}),
    {noreply, State};

handle_info(_Info, State) ->
    ?DEBUG("地图进程收到无效的info消息: ~w", [_Info]),
    {noreply, State}.

terminate(_Reason, #map{gid = Gid}) ->
    %% 从mpa_info中注销信息
    catch ets:delete(map_info, Gid),
    %% 把固定NPC从npc_online中清除
    [catch ets:delete(npc_online, Nid) || #map_npc{type = Type, id = Nid} <- get(npc_list), Type =:= 0],
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ----------------------------------------------------
%% 私有函数
%% ----------------------------------------------------

%% 在同一格内移动
do_role_move_step(R = #map_role{pid = Rpid, slice = NewSlice}, _OldX, _OldY, OldSlice, _State) when NewSlice =:= OldSlice ->
    put(OldSlice, lists:keyreplace(Rpid, #map_role.pid, get(OldSlice), R)); %% 不广播
%% 向左移动
do_role_move_step(R = #map_role{pid = Rpid, rid = Rid, srv_id = SrvId, dest_x = _DestX, dest_y = _DestY, dir = _Dir, slice = NewSlice}, _OldX, _OldY, OldSlice, State)
when OldSlice > NewSlice ->
    ?CROSS_SLICE(OldSlice + 1, NewSlice - 1);
%% 向右移动
do_role_move_step(R = #map_role{pid = Rpid, rid = Rid, srv_id = SrvId, dest_x = _DestX, dest_y = _DestY, dir = _Dir, slice = NewSlice}, _OldX, _OldY, OldSlice, State)
when OldSlice < NewSlice ->
    ?CROSS_SLICE(OldSlice - 1, NewSlice + 1);
%% 数据异常
do_role_move_step(_R, _OldX, _OldY, _OldSlice, _State) ->
    ignore.


%% 同步地图在线信息
sync(Map) when is_record(Map, map) ->
    ets:insert(map_info, Map).

%% 初始化分组
group(-1) ->
    put(-1, []);
group(Slice) ->
    put(Slice, []),
    group(Slice - 1).

%% 广播处理
slice_cast([], _Msg) -> ok;
slice_cast([H | T], Msg) ->
    do_cast(H, Msg),
    slice_cast(T, Msg);
%% 非list，退出
slice_cast(_E, _Msg) ->
    ?DEBUG("slice_cast/2中接收到无效数据:~w", [_E]),
    ok.

slice_cast(_RolePid, [], _Msg) -> ok;
slice_cast(RolePid, [H | T], Msg) ->
    do_cast(RolePid, H, Msg),
    slice_cast(RolePid, T, Msg);
%% 非list，退出
slice_cast(_RolePid, _E, _Msg) ->
    ?DEBUG("slice_cast/2中接收到无效数据:~w", [_E]),
    ok.


%% 发送角色列表
send_role_list(_ConnPid, [], []) ->
    ignore;
send_role_list(ConnPid, AddL, DelL) ->
    ?DEBUG("<<<< 10116 : ~w", [AddL]),
    {ok, B} = proto_101:pack(srv, 10116, {AddL, DelL}),
    ConnPid ! {send_data, B}.

%% 发送广播数据
do_cast([], _Bin) -> ok;
do_cast(_, error) -> ok;
do_cast([#map_role{conn_pid = ConnPid} | T], Bin) when is_pid(ConnPid) ->
    ConnPid ! {send_data, Bin},
    do_cast(T, Bin);
%% 非#role{}，跳过
do_cast([_H | T], Bin) ->
    do_cast(T, Bin);
%% 非list类型，退出
do_cast(_E, _Bin) ->
    ?DEBUG("do_cast/2中接收到无效数据: ~w", [_E]),
    ok.

do_cast(_RolePid, [], _Bin) -> ok;
do_cast(_, _, error) -> ok;
do_cast(RolePid, [#map_role{pid = RolePid} | T], Bin) ->
    do_cast(T, Bin);
do_cast(_RolePid, [#map_role{conn_pid = ConnPid} | T], Bin) when is_pid(ConnPid) ->
    ConnPid ! {send_data, Bin},
    do_cast(T, Bin);
%% 非#role{}，跳过
do_cast(_RolePid, [_H | T], Bin) ->
    do_cast(T, Bin);
%% 非list类型，退出
do_cast(_RolePid, _E, _Bin) ->
    ?DEBUG("do_cast/2中接收到无效数据: ~w", [_E]),
    ok.


%% 平整化list
flatmap([], List) -> List;
flatmap([H | T], List) when is_list(H) -> flatmap(T, H ++ List);
flatmap([_H | T], List) ->
    %?DEBUG("flatmap/2中接收到无效数据:~w", [_H]),
    flatmap(T, List).

%% 触发杀死npc事件
trigger_kill_npc([], _Round, State) ->
    State;
trigger_kill_npc([H = {kill_npc, NbaseId} | T], Round, State) ->
    NewState = trigger_event(H, {NbaseId, Round}, State),
    trigger_kill_npc(T, Round, NewState).


%% 触发地图事件
%% 目前副本地图才触发事件， 其它地图不触发事件
trigger_event(Evt, Params, Map = #map{type = Type}) 
when is_list(Evt) =:= false andalso
(Type =:= ?map_type_dungeon orelse Type =:= ?map_type_expedition)
->
    ?DEBUG("trigger_event"),
    try map_event:dispatch(Evt, Params, Map) of
        NewMap = #map{} -> 
            NewMap;
        _ ->
            Map
    catch 
        Type:Reason ->
            ?ERR("处理地图事件出错, event = ~w, exception = ~w", [Evt, {Type, Reason}]),
            Map
    end;

trigger_event(Evt, _, Map) when is_list(Evt) =:= false ->
    Map;

trigger_event([], _, Map) -> 
    Map;

trigger_event([Evt | T], Params, Map) ->
    NewMap = trigger_event(Evt, Params, Map),
    trigger_event(T, Params, NewMap).


%% 处理杀光事件
%% 事件为空时不做检查
%handle_kill_all_npc(_Event, Map = #map{event = []}) ->
%    Map;
%% 目前副本地图才触发事件， 其它地图不触发事件
handle_kill_all_npc(_Event = {npc_leave, NpcBaseId}, Map = #map{owner_pid = OwnerPid, type = Type}) when is_pid(OwnerPid) andalso (Type =:= ?map_type_dungeon orelse Type =:= ?map_type_expedition) ->
    case is_kill_all_npc(NpcBaseId) of
        true ->
            %%?DEBUG("kill all npc: ~w,~n", [NpcBaseId]),
            NewMap = trigger_event({kill_all_npc, NpcBaseId}, {}, Map),
            %% 是否清理所有怪物
            case [BaseId || #map_npc{nature = Nature, base_id = BaseId} <- get(npc_list), (Nature =:= 0 orelse Nature =:= 1) ] of
                [] ->
                    %%TODO 目前是清场所有怪物会触发副本评分事件
                    dungeon:post_event(OwnerPid, {dun_clear}),
                    NewMap;
                    %% trigger_event({clear_npc}, {}, NewMap);
                _NpcBaseIds ->
                    ?DEBUG("left npc: ~w,~n", [_NpcBaseIds]),
                    NewMap
            end;
        false ->
            Map
    end;

%%休闲玩法
handle_kill_all_npc(_Event = {npc_leave, NpcBaseId}, Map = #map{owner_pid = OwnerPid, type = Type}) when is_pid(OwnerPid) andalso Type =:= ?map_type_leisure ->
    case is_kill_all_npc(NpcBaseId) of
        true ->
            %%?DEBUG("kill all npc: ~w,~n", [NpcBaseId]),
            NewMap = trigger_event({kill_all_npc, NpcBaseId}, {}, Map),
            
            %%先发一个杀怪的通知，统计怪的数量
            dungeon:post_event(OwnerPid, {leisure_kill_npc, NpcBaseId}),

            %% 是否清理所有怪物
            case [BaseId || #map_npc{nature = Nature, base_id = BaseId} <- get(npc_list), (Nature =:= 0 orelse Nature =:= 1) ] of
                [] ->
                    %%TODO 目前是清场所有怪物会触发副本评分事件
                    dungeon:post_event(OwnerPid, {dun_clear_leisure, ?combat_result_win}), %%副本新的星星数计算方式  OwnerPid 为副本pid
                    % leisure:event(dun_clear, OwnerPid), %%副本新的星星数计算方式  OwnerPid 为副本pid
                    NewMap;
                _NpcBaseIds ->
                    ?DEBUG("left npc: ~w,~n", [_NpcBaseIds]),
                    NewMap
            end;
        false ->
            Map
    end;

handle_kill_all_npc(_Event, Map) ->
    Map.

%% 判断某类怪物是否已被杀光
%% TODO 优化
is_kill_all_npc(NpcBaseId) ->
    NpcList = get(npc_list),
    case [BaseId || #map_npc{base_id = BaseId} <- NpcList, NpcBaseId =:= BaseId ] of
        [] ->
            true;
        _ ->
            false
    end.

%% 清场
kill([]) -> ok;
kill([#map_npc{type = 1, base_id = BaseId, id = Nid} | T]) ->
    case npc_mgr:lookup(by_id, Nid) of
        #npc{pid = Pid} ->
            self() ! {kill_npc, [BaseId]},
            npc:stop(Pid),
            kill(T);
        _ -> kill(T)
    end;
kill([_H | T]) ->
    kill(T).

%% 清理所有守卫洛水NPC
kill_guard([]) -> ok;
kill_guard([#map_npc{type = 1, base_id = BaseId, id = Nid} | T]) ->
    case npc_mgr:lookup(by_id, Nid) of
        #npc{pid = Pid, fun_type = ?npc_fun_type_guild_monster} ->
            self() ! {kill_npc, [BaseId]},
            npc:stop(Pid),
            kill_guard(T);
        _ -> kill_guard(T)
    end;
kill_guard([_H | T]) ->
    kill_guard(T).

%% 清理帮会地图怪物
kill_guild_monster([]) -> ok;
kill_guild_monster([#map_npc{type = 1, base_id = BaseId, id = Nid} | T]) ->
    case npc_mgr:lookup(by_id, Nid) of
        #npc{pid = Pid, fun_type = ?npc_fun_type_guild_monster} ->
            self() ! {kill_npc, [BaseId]},
            npc:stop(Pid),
            kill_guild_monster(T);
        _ -> kill_guild_monster(T)
    end;
kill_guild_monster([_H | T]) ->
    kill_guild_monster(T).



%% 清除某个功能类型的NPC
kill_fun_type_npc(_, []) -> ok;
kill_fun_type_npc(FunType, [#map_npc{type = 1, base_id = BaseId, id = Nid} | T]) ->
    case npc_mgr:lookup(by_id, Nid) of
        #npc{pid = Pid, fun_type = ?npc_fun_type_guard_counter} when is_pid(Pid) ->
            self() ! {kill_npc, [BaseId]},
            npc:stop(Pid),
            kill_fun_type_npc(FunType, T);
        _ ->
            kill_fun_type_npc(FunType, T)
    end;
kill_fun_type_npc(FunType, [_H | T]) ->
    kill_fun_type_npc(FunType, T).

%% 打包角色进入场景消息
pack_enter_msg(Mr = #map_role{
        rid = Rid, srv_id = SrvId, cross_srv_id = _CrossSrvId, name = Name, speed = Speed, 
        dir = Dir, x = X, y = Y, dest_x = DestX, dest_y = DestY,
        slice = _Slice, status = Status, action = Action, ride = _Ride, event = _Event,
        exchange = _Exchange, mod = _Mod,
        label = _Label, hidden = _Hidden, lev = _Lev, sex = Sex, career = Career, realm = _Realm,
        hp = _Hp, mp = _Mp, hp_max = _HpMax, mp_max = _MpMax, team_id = _TeamId,
        guild = _Guild, looks = Looks, special = Special, fight_capacity = _FightCapacity, vip_type = Vip
    }
) ->
    %%若10113协议修改了需要同时改wanted_role的to_proto_role方法
    case catch proto_101:pack(srv, 10113, {
            Rid, SrvId, Name, Speed, Dir, X, Y, DestX, DestY, Status, Action, 
            Sex, Career, Vip, Looks, Special
        }
    ) of
        {ok, Bin} ->
            Bin;
        _Reason ->
            ?ERR("pack_enter_msg error: role_id: ~w, reason: ~w, map_role: ~w", [Rid, _Reason, Mr]),
            error
    end.

pack_npc_enter_msg(MapNpc = #map_npc{id = NpcId, base_id = BaseId, status = Status,
        speed = Speed, x = X, y = Y}) ->
    case catch proto_101:pack(srv, 10120, {NpcId, Status, BaseId, Speed, X, Y}) of
        {ok, Bin} ->
            Bin;
        _Reason ->
            ?ERR("pack_npc_enter_msg error: npc_id: ~w, reason: ~w, map_npc: ~w", [NpcId, _Reason, MapNpc]),
            error
    end.

send_enter_msg(ConnPid, MapRole) ->
    case pack_enter_msg(MapRole) of
        error -> ignore;
        Bin -> sys_conn:send(ConnPid, Bin)
    end.

send_npc_enter_msg(ConnPid, MapNpc) ->
    case pack_npc_enter_msg(MapNpc) of
        error -> ignore;
        Bin -> sys_conn:send(ConnPid, Bin)
    end.

%% 打包角色状态更新消息
pack_refresh_msg(#map_role{
        rid = Rid, srv_id = SrvId, cross_srv_id = _CrossSrvId, speed = Speed, status = Status, action = Action,
        ride = _Ride, event = _Event, exchange = _Exchange, mod = _Mod, label = _Label,
        hidden = _Hidden, lev = _Lev, sex = Sex, career = Career, realm = _Realm,
        hp = _Hp, mp = _Mp, hp_max = _HpMax, mp_max = _MpMax, team_id = _TeamId,
        dir = Dir, fight_capacity = _FightCapacity,
        guild = _Guild, looks = Looks, special = Special, vip_type = VipLev
    }
) ->
    case catch proto_101:pack(srv, 10117, {
            Rid, SrvId, Speed, Dir, Status, Action, 
            Sex, Career, VipLev, Looks, Special
        }
    ) of 
        {ok, Bin} ->
            Bin;
        _Reason ->
            ?ERR("pack_refresh_msg error: role_id = ~w, reason = ~w", [Rid, _Reason]),
            error
    end.

%% 通过rid的srv_id查找场景角色
%% @spec find_by_rid(MapRoleList, Rid, SrvId) -> false | MapRole
find_by_rid([], _Rid, _SrvId) -> false;
find_by_rid([MapRole = #map_role{rid = Rid, srv_id = SrvId} | _], Rid, SrvId) ->
    MapRole;
find_by_rid([_MapRole | T], Rid, SrvId) ->
    find_by_rid(T, Rid, SrvId);
find_by_rid(_, _Rid, _SrvId) ->
    false.

%% -> any()
replace_map_role(Slice, RolePid, MapRole) ->
    put(Slice, lists:keyreplace(RolePid, #map_role.pid, get(Slice), MapRole)),
    put(role_list, lists:keyreplace(RolePid, #map_role.pid, get(role_list), MapRole)).

%% 检查战斗线
check_fight_line(RolePid, OldX, NewX) ->
    {RolePid, OldX, NewX}.
%    NpcList = get(npc_list),
%    lists:foreach(fun(Npc)->
%        case Npc#map_npc.nature=/=2 andalso OldX < Npc#map_npc.x - ?combat_range andalso NewX >= Npc#map_npc.x - ?combat_range of
%            true ->
%                role:apply(async, RolePid, {?MODULE, fight_npc, [Npc#map_npc.id]});
%            false ->
%                ignore
%        end
%    end, NpcList).

%% 向npc发起战斗
fight_npc(Role = #role{combat_pid = CombatPid}, _NpcId) when is_pid(CombatPid) ->
    notice:alert(error, Role, ?MSGID(<<"你正在战斗中，无法发起新的战斗">>)),
    {ok};
fight_npc(Role = #role{hp = Hp, status = Status}, _NpcId) when Status =/= ?status_normal orelse Hp < 1 ->
    notice:alert(error, Role, ?MSGID(<<"当前状态无法发起战斗">>)),
    {ok};
fight_npc(Role = #role{event = Event}, _NpcId) when Event =:= ?event_jiebai ->
    notice:alert(error, Role, ?MSGID(<<"马上要结拜了打打杀杀多不好">>)),
    {ok};
fight_npc(Role = #role{event = Event}, _NpcId) when Event =:= ?event_hall ->
    notice:alert(error, Role, ?MSGID(<<"当前状态无法发起战斗">>)),
    {ok};
fight_npc(Role = #role{id = RoleId, cross_srv_id = CrossSrvId}, NpcId) ->
    case combat:distance_check(Role, NpcId) of
        true ->
            case combat:team_check(Role) of
                true ->
                    case hook:combat_before(Role) of %% 判断挂机次数是否满了
                        ok ->
                            case npc_mgr:get_npc(CrossSrvId, NpcId) of
                                false -> 
                                    notice:alert(error, Role, ?MSGID(<<"目标不存在，无法发起战斗">>)),
                                    {ok};
                                Npc ->
                                    case combat_type:check(?combat_type_npc, Role, Npc) of
                                        {true, NewCombatType} ->
                                            case npc:fight(Npc, Role, NewCombatType) of
                                                {false, Reason} -> 
                                                    notice:alert(error, Role, Reason),
                                                    {ok};
                                                true -> {ok} %% 此处不返回信息，交给npc:fight/2处理
                                            end;
                                        %% 狂暴怪抢到别人的开出来的
                                        {rob, NewCombatType, OwerId} ->
                                            case npc:fight(Npc#npc{owner = OwerId}, Role, NewCombatType) of
                                                {false, Reason} -> 
                                                    notice:alert(error, Role, Reason),
                                                    {ok};
                                                true -> {ok} %% 此处不返回信息，交给npc:fight/2处理
                                            end;
                                        {true, NewCombatType, Referees} ->
                                            case npc:fight(Npc, Role, NewCombatType, Referees) of
                                                {false, Reason} -> 
                                                    notice:alert(error, Role, Reason),
                                                    {ok};
                                                true -> {ok} %% 此处不返回信息，交给npc:fight/2处理
                                            end;
                                        {guard_counter, NewCombatType, Referees} ->
                                            case npc:fight(Npc, Role, NewCombatType, Referees) of
                                                {false, Reason} -> 
                                                    notice:alert(error, Role, Reason),
                                                    {ok};
                                                true -> {ok} %% 此处不返回信息，交给npc:fight/2处理
                                            end;
                                        {false, Reason} -> 
                                            ?DEBUG("错误来到这里"),
                                            notice:alert(error, Role, Reason),
                                            {ok}
                                    end
                            end;
                        {false, Reason} ->
                            notice:alert(error, Role, Reason),
                            {ok}
                    end;
                false -> 
                    notice:alert(error, Role, ?MSGID(<<"你在队伍中，只有队长或者暂离队员才能发起战斗">>)),
                    {ok}
            end;
        false -> 
            notice:alert(error, Role, ?MSGID(<<"距离太远，发起战斗失败">>)),
            {ok};
        null_npc ->
            ?DEBUG("不存在的NPC,通知客户端移除"),
            role_api:c_pack_send(RoleId, 10121, {NpcId}),
            {ok}
    end.

%%
i(MapGid) ->
    case ets:lookup(map_info, MapGid) of
        [Map] ->
            gen_server:call(Map#map.pid, i);
        _ -> null
    end.

