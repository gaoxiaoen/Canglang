%% ********************
%% 组队rpc处理
%% wpf wprehard@qq.com
%% ********************
-module(team_rpc).
-export([
        handle/3
    ]).

-include("common.hrl").
%%
-include("team.hrl").
-include("role.hrl").
-include("vip.hrl").
-include("pos.hrl").
-include("map.hrl").
-include("link.hrl").
-include("attr.hrl").
-include("pet.hrl").

%% 获取队伍列表: 正常请求或顶号情况下
handle(10800, {TeamId}, #role{name = _Name, team_pid = TeamPid}) when is_pid(TeamPid) ->
    case team:get_team_info(TeamPid) of
        {ok, #team{team_id = Tid, leader = Leader = #team_member{id = {LId, LSrvId}}, member = MemberList}} ->
            {reply, {<<>>, Tid, LId, LSrvId,
                [
                    [Id, SrvId, Name, Lev, Career, Sex, VipType, FaceId, Mode, HpMax, MpMax, Hp, Mp, Fight, PetFight] ||
                    #team_member{id = {Id, SrvId}, name = Name, lev = Lev, career = Career, sex = Sex, hp = Hp, mp = Mp,
                        fight = Fight, pet_fight = PetFight, hp_max = HpMax, mp_max = MpMax, vip_type = VipType, face_id = FaceId,
                        mode = Mode} <- [Leader | lists:reverse(MemberList)]]
            }};
        _T ->
            ?DEBUG("T:~w", [_T]),
            {reply, {?L(<<"你还没有队伍">>), TeamId, 0, <<>>, []}}
    end;
handle(10800, {0}, Role) ->
    %% 上线请求
    team:member_online(Role),
    {ok};
handle(10800, {_}, _Role) ->
    {ok};

%% 非正常状态不允许操作队伍
handle(_, _, #role{status = ?status_fight})     -> {ok};
handle(_, _, #role{status = ?status_die})       -> {ok};
handle(_, _, #role{status = ?status_transfer})  -> {ok}; %% TODO:

%% 队长设置队伍的申请规则
handle(10801, {IsDirect}, #role{id = Rid, team_pid = TeamPid})
when IsDirect =:= 0 orelse IsDirect =:= 1 ->
    team:set_apply_rule(TeamPid, {Rid, IsDirect}),
    {reply, {IsDirect}};

%% 获取玩家列表
handle(10810, Data, Role) ->
    case role:check_cd(team_10810, 1) of
        true -> do_handle(10810, Data, Role);
        false -> {ok}
    end;
%% 获取附近队伍队长列表
%% TODO: 2012/07/03取消
%% handle(10811, {}, #role{id = RoleId, team_pid = RoleTeamPid, pos = #pos{map_pid = MapPid, x = X, y = Y}}) ->
%%     L = map:role_in_grid(MapPid, X, Y),
%%     Fun = fun(#map_role{rid = Id, srv_id = SrvId, name = Name, sex = Sex, lev = Lev, pid = Pid}) when is_pid(Pid) ->
%%             case role_api:lookup(by_pid, Pid, [#role.team_pid, #role.team]) of
%%                 {ok, _, [RoleTeamPid, #role_team{is_leader = ?true}]} when is_pid(RoleTeamPid) ->
%%                     false;
%%                 {ok, _, [TeamPid, #role_team{is_leader = ?true}]} when is_pid(TeamPid) ->
%%                     Cnt = team:get_member_count(TeamPid),
%%                     {Id, SrvId, Name, Lev, Sex, Cnt};
%%                 _ -> false
%%             end;
%%           (_) -> false
%%     end,
%%     L0 = [Fun(Xm) || Xm = #map_role{rid = Id, srv_id = SrvId} <- L, {Id ,SrvId} =/= RoleId],
%%     Msg = [Xm || Xm <- L0, Xm =/= false],
%%     {reply, {Msg}};

%% 获取全区快速组队列表
handle(10812, {}, #role{pid = RolePid}) ->
    case role:check_cd(team_10812, 30) of
        false -> {reply, {[]}}; %% CD时间内返回空列表，客户端不做刷新
        true ->
            case role_api:local_lookup_all_online(by_pid) of
                {ok, PidList} ->
                    Fun = fun(Pid) when Pid =:= RolePid -> error;
                        ([Pid]) when is_pid(Pid) ->
                            case role_api:lookup(by_pid, Pid, [#role.id, #role.name, #role.lev, #role.sex, #role.career, #role.attr, #role.pet]) of
                                {ok, _N, [{Id, SrvId}, Name, Lev, Sex, Career, #attr{fight_capacity = Fight}, #pet_bag{active = #pet{fight_capacity = FightPet}}]}
                                when Lev >= 55 ->
                                    {Id, SrvId, Name, Lev, Sex, Career, Fight, FightPet};
                                {ok, _N, [{Id, SrvId}, Name, Lev, Sex, Career, #attr{fight_capacity = Fight}, #pet_bag{}]}
                                when Lev >= 55 ->
                                    {Id, SrvId, Name, Lev, Sex, Career, Fight, 0};
                                _X -> error
                            end;
                        (_Pid) -> error
                    end,
                    L = [Fun(X) || X <- PidList],
                    {reply, {[X || X <- L, is_tuple(X)]}};
                _ -> {reply, {[]}}
            end
    end;

%% 获取其他队员的外观
handle(10803, {Id, SrvId}, #role{id = {Id, SrvId}}) -> {ok};
handle(10803, {Id, SrvId}, Role) ->
    team:pull_other_looks({Id, SrvId}, Role),
    {ok};

%% 创建队伍
handle(10842, {}, #role{team_pid = TeamPid}) when is_pid(TeamPid) ->
    {reply, {?false, ?L(<<"你已经在队伍中">>)}};
handle(10842, {}, Role) ->
    case team_api:check_exclude(Role) of
        {false, Reason} -> {reply, {?false, Reason}};
        ok ->
            case team_mgr:create_team(Role) of
                {false, Bin} -> {reply, {?false, Bin}};
                Pid ->
                    NewRole = role_listener:acc_event(Role#role{team_pid = Pid}, {102, 1}),
                    {reply, {?true, <<>>}, NewRole}
            end
    end;

%% 邀请组队
handle(10805, {_Id, _SrvId, ApplyMsg}, _) when byte_size(ApplyMsg) > 240 -> {ok};
handle(10805, {Id, SrvId, _ApplyMsg}, #role{id = {Id, SrvId}}) -> {ok};
handle(10805, {Id, SrvId, ApplyMsg}, Role = #role{team_pid = TeamPid, id = {Rid, Rsrvid}, name = Rname})
when is_pid(TeamPid) -> %% 当前有队伍
    case role:check_cd(team_10805, 3) of
        false -> {ok};
        true ->
            case team_api:check_exclude(Role) of
                {false, Reason} ->
                    {reply, {?false, Reason}};
                ok ->
                    case team_api:is_leader(Role) of
                        {true, _TeamId} ->
                            case role_api:c_lookup(by_id, {Id, SrvId}, [#role.team_pid, #role.event, #role.link, #role.looks]) of
                                {ok, _, [TeamPid, _, _, _]} ->
                                    {reply, {?false, ?L(<<"操作失败，对方在你的队伍中">>)}};
                                {ok, _, [Tpid, _, _, _]} when is_pid(Tpid) ->
                                    {reply, {?false, ?L(<<"操作失败，对方已经有队伍">>)}};
                                {ok, _, [_, Event2, #link{conn_pid = ConnPid2}, Looks2]} ->
                                    ProtoMsg = case team_api:check_special(Role, {{Id, SrvId}, Event2, Looks2}) of
                                        ok ->
                                            case node(ConnPid2) =:= node() of
                                                true ->
                                                    sys_conn:pack_send(ConnPid2, 10806, {Rid, Rsrvid, Rname, ApplyMsg});
                                                false ->
                                                    center:cast(sys_conn, pack_send, [ConnPid2, 10806, {Rid, Rsrvid, Rname, ApplyMsg}])
                                            end,
                                            ?DEBUG("队长[NAME:~s]邀请~w组队, 已转发", [Role#role.name, {Id, SrvId}]),
                                            {?true, <<>>};
                                        {false, Msg} ->
                                            {?false, Msg}
                                    end,
                                    NewRole = team_api:team_listener(apply, Role),
                                    {reply, ProtoMsg, NewRole};
                                _ ->
                                    {reply, {?false, ?L(<<"操作失败，对方不在线">>)}}
                            end;
                        _ -> {reply, {?false, ?L(<<"操作失败，你不是队长">>)}}
                    end
            end
    end;
handle(10805, {Id, SrvId, ApplyMsg}, Role = #role{id = {Rid, Rsrvid}, name = Rname}) -> %% 当前无队伍
    case role:check_cd(team_10805, 3) of
        false -> {ok};
        true ->
            case team_api:check_exclude(Role) of
                {false, Msg} ->
                    {reply, {?false, Msg}};
                ok ->
                    case role_api:c_lookup(by_id, {Id, SrvId}, [#role.team_pid, #role.event, #role.link, #role.looks]) of
                        {ok, _, [TeamPid, Event2, _, Looks2]} when is_pid(TeamPid) -> %% 对方有队伍
                            case team_api:check_special(Role, {{Id, SrvId}, Event2, Looks2}) of
                                ok ->
                                    team:apply_in(TeamPid, Role, ApplyMsg),
                                    {ok};
                                {false, Msg} ->
                                    {reply, {?false, Msg}}
                            end;
                        {ok, _, [_, Event2, #link{conn_pid = ConnPid2}, Looks2]} ->
                            case team_api:check_special(Role, {{Id, SrvId}, Event2, Looks2}) of
                                ok ->
                                    case node(ConnPid2) =:= node() of
                                        true ->
                                            sys_conn:pack_send(ConnPid2, 10806, {Rid, Rsrvid, Rname, ApplyMsg});
                                        false ->
                                            center:cast(sys_conn, pack_send, [ConnPid2, 10806, {Rid, Rsrvid, Rname, ApplyMsg}])
                                    end,
                                    {reply, {?true, <<>>}};
                                {false, Msg} ->
                                    {reply, {?false, Msg}}
                            end;
                        _ ->
                            {reply, {?false, ?L(<<"操作失败，对方不在线">>)}}
                    end
            end
    end;
handle(10805, _, _) ->
    ?DEBUG("邀请忽略"),
    {ok};

%% -----------------------------------------------------------------
%% 邀请/申请返回处理:采用同一个协议, 合并到这里
handle(10807, {_Result, Id, SrvId}, #role{id = {Id, SrvId}}) -> {ok};
handle(10807, {?true, _, _}, #role{event = Event}) 
when Event =:= ?event_arena_prepare 
orelse Event =:= ?event_arena_match
orelse Event =:= ?event_escort
orelse Event =:= ?event_c_world_compete_11
orelse Event =:= ?event_c_world_compete_22
orelse Event =:= ?event_c_world_compete_33
orelse Event =:= ?event_cross_king_prepare
orelse Event =:= ?event_cross_king_match
orelse Event =:= ?event_top_fight_match
orelse Event =:= ?event_top_fight_prepare
orelse Event =:= ?event_cross_warlord_match
orelse Event =:= ?event_guard_counter
->
    {reply, {?false, ?L(<<"当前活动状态不可以组队">>)}};
%% 同意申请：正常流程
%% 同意邀请：1、角色已创建了队伍; 2、邀请人已进入其他队伍
handle(10807, {?true, Id, SrvId}, Role = #role{team_pid = TeamPid, team = #role_team{is_leader = ?true}})
when is_pid(TeamPid) ->
    case role_api:c_lookup(by_id, {Id, SrvId}, [#role.pid, #role.team_pid, #role.event, #role.looks]) of
        {ok, _, [_, TeamPid, _, _]} -> %% 同一队伍中
            {reply, {?false, ?L(<<"操作失败，对方在你的队伍中">>)}};
        {ok, _, [_, OtherTeamPid, _, _]} when is_pid(OtherTeamPid) ->
            {reply, {?false, ?L(<<"操作失败，对方已经有队伍">>)}};
        {ok, _, [Pid, _, Event, Looks]} ->
            case team_api:check_special(Role, {{Id, SrvId}, Event, Looks}) of
                ok ->
                    ?DEBUG("角色[NAME: ~s]加入队伍", [Role#role.name]),
                    role:c_apply(async, Pid, {team_api, check_and_join, [TeamPid]}),
                    {ok, team_api:team_listener(apply, Role)};
                {false, Msg} ->
                    {reply, {?false, Msg}}
            end;
        _ -> {ok}
    end;
handle(10807, {?true, _Id, _SrvId}, #role{team_pid = TeamPid})
when is_pid(TeamPid) ->
    {reply, {?false, ?L(<<"操作失败，你不是队长">>)}};
%% 同意邀请: 正常处理
%% 同意申请: 1、队长已离开队伍 2、队长已移交或者进入其他队伍
handle(10807, {?true, Id, SrvId}, Role) ->
    case team_api:check_exclude(Role) of
        {false, Reason} ->
            {reply, {?false, Reason}};
        ok ->
            case role_api:c_lookup(by_id, {Id, SrvId}, [#role.pid, #role.event, #role.looks]) of
                {ok, _, [Pid, Event, Looks]} ->
                    case team_api:check_special(Role, {{Id, SrvId}, Event, Looks}) of
                        ok ->
                            case role:c_apply(sync, Pid, {team_api, sync_check_create, []}) of
                                {ok, TeamPid} ->
                                    case team:join(TeamPid, Role) of
                                        {ok, NewRole} ->
                                            {reply, {?true, <<>>}, NewRole};
                                        {false, Reason} ->
                                            {reply, {?false, Reason}}
                                    end;
                                {false, Reason} ->
                                    {reply, {?false, Reason}}
                            end;
                        {false, Msg} ->
                            {reply, {?false, Msg}}
                    end;
                _ ->
                    {reply, {?false, ?L(<<"操作失败，对方不在线">>)}}
            end
    end;
handle(10807, {?false, _, _}, _Role) -> %% 拒绝
    {ok};

%% 委任队长
handle(10815, {}, #role{event = Event})
when Event =:= ?event_c_world_compete_11 orelse Event =:= ?event_c_world_compete_22 orelse Event =:= ?event_c_world_compete_33 ->
    {reply, {?false, ?L(<<"跨服仙道会进行中，不能委任">>)}};
handle(10815, {Mid, MSrvId}, #role{id = {Mid, MSrvId}}) ->
    {reply, {?false, ?L(<<"操作失败，不能委任自己">>)}};
handle(10815, {Mid, MSrvId}, Role) ->
    case team:appoint(Role, {Mid, MSrvId}) of
        {false, Msg} -> {reply, {?false, Msg}};
        {ok} ->
            {ok}
    end;

%% 暂离
handle(10831, {}, #role{event = Event})
when Event =:= ?event_c_world_compete_11 orelse Event =:= ?event_c_world_compete_22 orelse Event =:= ?event_c_world_compete_33 ->
    {reply, {?false, ?L(<<"跨服仙道会进行中，不能暂离">>)}};
handle(10831, {}, Role) ->
    case team_api:tempout(Role) of
        {false, Msg} -> {reply, {?false, Msg}};
        _ -> {ok}
    end;
handle(10831, _Msg, _R) ->
    {reply, {?false, ?L(<<"你还没有队伍">>)}};

%% 移出队员
handle(10819, {}, #role{event = Event})
when Event =:= ?event_c_world_compete_11 orelse Event =:= ?event_c_world_compete_22 orelse Event =:= ?event_c_world_compete_33 ->
    {reply, {?false, ?L(<<"跨服仙道会进行中，不能移出队员">>)}};
handle(10819, {Id, SrvId}, Role) ->
    case team:kick_out(Role, {Id, SrvId}) of
        {false, Reason} -> {reply, {?false, Reason}};
        ok -> {ok}
    end;

%% 归队
handle(10832, {}, Role = #role{team_pid = TeamPid, action = Action})
when is_pid(TeamPid)
andalso Action >= ?action_sit andalso Action =< ?action_sit_lovers ->
    NewRole = sit:handle_sit(?action_no, Role),
    handle(10832, {}, NewRole);
handle(10832, {}, Role = #role{team_pid = TeamPid, event = Event, pos = #pos{map = MapId, map_base_id = MapBaseId}}) when is_pid(TeamPid) ->
    case team_api:check_back(Role) of
        {false, Reason} ->
            {reply, {?false, Reason, 0, 0, 0}};
        ok ->
            case team:back_team(Role) of
                {ok, NewRole} ->
                    {ok, NewRole};
                {false, Reason} ->
                    {reply, {?false, Reason, 0, 0, 0}};
                {false, #pos{map_base_id = MapBaseId, x = X, y = Y}, Reason}
                when Event =:= ?event_guild_war ->
                    %% 旧帮战(阵营战)同地图允许飞鞋传送归队
                    {reply, {2, Reason, MapBaseId, X, Y}};
                {false, #pos{}, Reason}
                when Event =:= ?event_guild_war ->
                    %% 旧帮战(阵营战)非同地图不允许飞鞋传送归队
                    {reply, {?false, Reason, 0, 0, 0}};
                {false, #pos{map_base_id = MapBaseId, x = X, y = Y}, Reason}
                when Event =:= ?event_guild_arena orelse Event =:= ?event_cross_ore ->
                    %% 新帮战、跨服仙府  同地图归队直接传送至队长位置
                    case map:role_enter(MapId, X, Y, Role) of
                        {ok, NewRole} ->
                            {reply, {?false, Reason, 0, 0, 0}, NewRole};
                        _ ->
                            {reply, {?false, Reason, 0, 0, 0}}
                    end;
                {false, #pos{}, Reason}
                when Event =:= ?event_guild_arena ->
                    %% 新帮战非同地图归队不传送
                    {reply, {?false, Reason, 0, 0, 0}};
                {false, #pos{map_base_id = MapBaseId, x = X, y = Y}, Reason}
                when MapBaseId =:= 30015 ->
                    %% 跨服比武场
                    case map:role_enter(MapId, X, Y, Role) of
                        {ok, NewRole} ->
                            {reply, {?false, Reason, 0, 0, 0}, NewRole};
                        _ ->
                            {reply, {?false, Reason, 0, 0, 0}}
                    end;
                {false, #pos{map_base_id = BaseId, x = X, y = Y}, Reason} ->
                    {reply, {2, Reason, BaseId, X, Y}};
                {false, _, _} ->
                    {reply, {?false, ?L(<<"操作失败，队长可能已经离线">>), 0, 0, 0}}
            end
    end;
handle(10832, _Msg, _R) ->
    {reply, {?false, ?L(<<"你还没有队伍">>), 0, 0, 0}};

%% 退出队伍
%% handle(10841, {}, Role) ->
%%     case team:quit(Role) of
%%         {false, Reason} ->
%%             ?DEBUG("角色[NAME:~s]退出队伍失败：~w", [Role#role.name, Reason]),
%%             {reply, {?false, Reason}};
%%         {ok, NewRole} ->
%%             {reply, {?true, <<>>}, NewRole}
%%     end;
handle(10841, {}, #role{event = Event})
when Event =:= ?event_c_world_compete_11 orelse Event =:= ?event_c_world_compete_22 orelse Event =:= ?event_c_world_compete_33 ->
    {reply, {?false, ?L(<<"跨服仙道会进行中，不能退出队伍">>)}};
handle(10841, {}, Role) ->
    team:quit(Role),
    {reply, {?true, <<>>}};

%% 召回队员
handle(10817, {}, #role{id = RoleId, team_pid = TeamPid}) when is_pid(TeamPid) ->
    team:recall(TeamPid, RoleId),
    {ok};
handle(10817, _Msg, _R) ->
    {reply, {?false, ?L(<<"操作失败，你不是队长">>)}};

%% 请求当前被邀请的列表
%% handle(10851, {}, #role{id = Rid}) ->
%%     {reply, team_api:pack_proto_msg(10851, Rid)};
%% 
%% %% 请求当前被申请的列表
%% handle(10852, {}, Role = #role{team_pid = TeamPid}) when is_pid(TeamPid) ->
%%     case team_api:is_leader(Role) of
%%         false ->
%%             {reply, {[]}};
%%         {true, TeamId} ->
%%             {reply, team_api:pack_proto_msg(10852, TeamId)}
%%     end;
%% handle(10852, {}, _R) ->
%%     {reply, {[]}};

%% 副本大厅邀请 -- 免确认
%% 副本大厅申请入队 -- 免确认
%% handle(10854, {_DungId, Id, SrvId}, #role{id = {Id, SrvId}}) -> {ok};
%% handle(10854, {_DungId, Id, SrvId}, Role = #role{team_pid = TeamPid})
%% when is_pid(TeamPid) ->
%%     ?DEBUG("招募邀请"),
%%     case team_api:check_exclude(Role) of
%%         {false, Reason} ->
%%             {reply, {?false, Reason}};
%%         ok ->
%%             case team_api:is_leader(Role) of
%%                 {true, _TeamId} ->
%%                     case role_api:lookup(by_id, {Id, SrvId}, #role.pid) of
%%                         {ok, _, Pid} ->
%%                             role:apply(async, Pid, {team_api, check_and_join_dungeon, [TeamPid]}),
%%                             {ok};
%%                         _ ->
%%                             {reply, {?false, ?L(<<"操作失败，对方不在线">>)}}
%%                     end;
%%                 _ ->
%%                     {reply, {?false, ?L(<<"操作失败，你不是队长">>)}}
%%             end
%%     end;
%% handle(10854, {_DungId, Id, SrvId}, Role) ->
%%     ?DEBUG("招募申请"),
%%     case team_api:check_exclude(Role) of
%%         {false, Msg} ->
%%             {reply, {?false, Msg}};
%%         ok ->
%%             case role_api:lookup(by_id, {Id, SrvId}, #role.team_pid) of
%%                 {ok, _, TeamPid} when is_pid(TeamPid) -> %% 对方有队伍
%%                     team:apply_in(TeamPid, Role, <<>>),
%%                     {ok};
%%                 {ok, _, _} ->
%%                     {reply, {?false, ?L(<<"操作失败，对方还没有队伍">>)}};
%%                 _ ->
%%                     {reply, {?false, ?L(<<"操作失败，对方不在线">>)}}
%%             end
%%     end;

%% 请求大厅列表
handle(10855, {DungId}, Role) ->
    L = team_dungeon:get_team_list(DungId),
    {reply, team_dungeon:pack_proto_msg(10855, Role, L)};
handle(10856, {DungId}, Role) ->
    L = team_dungeon:get_role_list(DungId),
    {reply, team_dungeon:pack_proto_msg(10856, Role, L)};

%% 副本招募大厅注册
%% handle(10857, {DungId}, Role) ->
%%     case team_dungeon:register_to_hall(Role, DungId) of
%%         ok ->
%%             {reply, {?true, <<>>}};
%%         {false, Msg} ->
%%             {reply, {?false, Msg}}
%%     end;
%% handle(10858, {DungId}, Role) ->
%%     case team_dungeon:cancel_register(Role, DungId) of
%%         ok ->
%%             {reply, {?true, <<>>}};
%%         {false, Msg} ->
%%             {reply, {?false, Msg}}
%%     end;
    
handle(_Cmd, _Msg, _State) ->
    ?DEBUG("队伍rpc模块收到错误的数据[CMD:~w, MSG:~w]", [_Cmd, _Msg]),
    {error, unknow_command}.
    
%% ---------------------------------------------------
%% 内部函数
%% ---------------------------------------------------
do_handle(10810, {Type}, #role{id = {Rid, _}, pos = #pos{map_pid = MapPid, x = X, y = Y}, team = #role_team{team_id = TeamId1}})
when Type =:= 1 ->
    L = map:role_in_grid(MapPid, X, Y),
    Msg = [{Id, SrvId, Name, Lev, Career, Sex, Fight} || #map_role{rid = Id, srv_id = SrvId, name = Name, sex = Sex, career = Career, lev = Lev, team_id = TeamId2, fight_capacity = Fight} <- L,
        Id =/= Rid andalso TeamId1 =/= TeamId2], %% (过滤同一个队伍的)
    {reply, {Type, Msg}};
do_handle(10810, {Type}, #role{id = {Rid, _}, pos = #pos{map_pid = MapPid, x = X, y = Y}})
when Type =:= 1 ->
    L = map:role_in_grid(MapPid, X, Y),
    Msg = [{Id, SrvId, Name, Lev, Career, Sex, Fight} || #map_role{rid = Id, srv_id = SrvId, name = Name, sex = Sex, career = Career, lev = Lev, fight_capacity = Fight} <- L, Id =/= Rid],
    {reply, {Type, Msg}};
do_handle(10810, {Type}, Role = #role{id = {Rid, Rsrvid}})
when Type =:= 2 -> %% 帮会在线玩家
    L = [{Id, SrvId, Name, Lev, Career, Sex, Fight} || {Id, SrvId, Name, Lev, Career, Sex, Fight} <- guild_mem:members_online(Role), {Id, SrvId} =/= {Rid, Rsrvid}],
    {reply, {Type, L}};
do_handle(10810, {Type}, _Role)
when Type =:= 3 -> %% 好友在线玩家
    L = friend:get_friend_online_list(),
    {reply, {Type, L}};
do_handle(_, _, _) -> {ok}.
