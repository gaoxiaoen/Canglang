%% *************************
%% 打坐双修的协议处理
%% @author wpf (wprehard@qq.com)
%% *************************
-module(sit_rpc).
-export([handle/3]).

-include("common.hrl").
-include("role.hrl").
-include("attr.hrl").
-include("pos.hrl").
-include("map.hrl").
-include("link.hrl").
-include("sit.hrl").
-include("team.hrl").
%%
-include("looks.hrl").

%% 死亡状态或者战斗中不允许操作
handle(_, _, #role{status = ?status_die}) -> ?DEBUG("角色死亡状态，对请求打坐的操作不予处理"), {ok};
handle(_, _, #role{status = ?status_transfer}) -> ?DEBUG("角色传送中状态，收到打坐请求，不予处理"), {ok};
handle(_, _, #role{status = ?status_fight}) -> {ok};

%% 打坐&&取消打坐
handle(11601, {}, Role = #role{ride = ?ride_fly}) ->
    {reply, sit:pack_proto_msg(11601, {?sit_cancel, ?L(<<"飞行中不允许打坐">>), Role})};

%% 取消打坐
handle(11601, {}, Role = #role{action = Action}) when Action >= ?action_sit andalso Action =< ?action_sit_lovers ->
    {ok, sit:handle_sit(?action_no, Role)};

handle(11601, {}, Role) ->
    {ok, sit:handle_sit(?action_sit, Role)};

%% 邀请玩家双修
handle(11611, {Id, SrvId, _, _}, #role{id = InviteId}) when {Id, SrvId} =:= InviteId ->
    {ok};
handle(11611, _, #role{action = Action}) when Action =:= ?action_ride_both ->
    {reply, {?L(<<"您处于双人骑乘中">>), 0, 0}};
handle(11611, _, #role{action = Action}) when Action >= ?action_sit_both andalso Action =< ?action_sit_lovers ->
    {reply, {?L(<<"您已经在双修中">>), 0, 0}};
handle(11611, {Id, SrvId, _, _}, Role = #role{id = Rid, team_pid = TeamPid}) when is_pid(TeamPid)->
    case team:get_team_info(TeamPid) of
        {ok, #team{leader = #team_member{id = Rid}}} -> %% 队长可以双修
            case sit:both_sit(Role, {Id, SrvId}) of
                {false, Reason} -> {reply, {Reason, 0, 0}};
                %% {ok, BothType} ->
                    %% {ok, sit:handle_sit({BothType, {Id, SrvId}}, Role)}
                {ok, BothInfo} ->
                    {ok, sit:handle_sit(BothInfo, Role)}
            end;
        {ok, #team{member = MemList}} ->
            case lists:keyfind(Rid, #team_member.id, MemList) of
                #team_member{mode = Mode} when Mode =:= ?MODE_NORMAL ->
                    {reply, {?L(<<"对方在队伍中，不能进行双修">>), 0, 0}};
                _ ->
                    case sit:both_sit(Role, {Id, SrvId}) of
                        {false, Reason} -> {reply, {Reason, 0, 0}};
                        %% {ok, BothType} -> {ok, sit:handle_sit({BothType, {Id, SrvId}}, Role)}
                        {ok, BothInfo} -> {ok, sit:handle_sit(BothInfo, Role)}
                    end
            end;
        _ -> {reply, {?L(<<"您现在不能双修">>), 0, 0}}
    end;

handle(11611, {Id, SrvId, _, _}, Role) ->
    case sit:both_sit(Role, {Id, SrvId}) of
        {false, Reason} -> {reply, {Reason, 0, 0}};
        %% {ok, BothType} -> {ok, sit:handle_sit({BothType, {Id, SrvId}}, Role)}
        {ok, BothInfo} -> {ok, sit:handle_sit(BothInfo, Role)}
    end;

%% 1邀请/2申请玩家双人骑乘
handle(11620, {Type, Rid, SrvId}, Role = #role{team_pid = RoleTeamPid, id = {Rid1, SrvId1}, name = RoleName, sex = Sex1, team = RoleTeam, mounts = Mounts1}) ->
    case both_ride:check_both_ride(Role) of
        {false, Msg} -> 
            {reply, {?false, Msg}};
        ok ->
            case role_api:c_lookup(by_id, {Rid, SrvId}, [#role.link, #role.team_pid, #role.action, #role.event, #role.sex, #role.mounts, #role.team]) of
                {ok, Node, [#link{conn_pid = ConnPid}, RoleTeamPid, Action, Event, Sex2, _Mounts2, _TeamInfo]}
                when is_pid(RoleTeamPid) ->
                    %% 同一个队伍，则队伍只能有2人，发起人是队长，对方是队员
                    Args = [
                        {action, Action}
                        ,{event, Event}
                        ,{sex, {Sex1, Sex2}}
                        ,{leader, RoleTeam}
                        ,{team, {RoleTeamPid, 2}}
                    ],
                    case both_ride:check_both_ride2(Args) of
                        {false, Msg} -> {reply, {?false, Msg}};
                        ok ->
                            case mount:is_both_mount(Mounts1) of
                                false -> {reply, {?false, ?L(<<"您必须装备一个双人坐骑或打开双人坐骑形象，才能请求双人骑乘">>)}};
                                true ->
                                    case Node =:= node() of
                                        true ->
                                            sys_conn:pack_send(ConnPid, 11621, {Type, Rid1, SrvId1, RoleName});
                                        false ->
                                            center:cast(sys_conn, pack_send, [ConnPid, 11621, {Type, Rid1, SrvId1, RoleName}])
                                    end,
                                    {reply, {?true, <<>>}}
                            end
                    end;
                {ok, Node, [#link{conn_pid = ConnPid}, RoleTeamPid, Action, Event, Sex2, Mounts2, _TeamInfo]} ->
                    %% 都无队伍
                    Args = [
                        {action, Action}
                        ,{event, Event}
                        ,{sex, {Sex1, Sex2}}
                    ],
                    case both_ride:check_both_ride2(Args) of
                        {false, Msg} -> {reply, {?false, Msg}};
                        ok ->
                            case both_ride:check_mounts(Mounts1, Mounts2) of
                                {false, Msg} -> {reply, {?false, Msg}};
                                ok ->
                                    case Node =:= node() of
                                        true ->
                                            sys_conn:pack_send(ConnPid, 11621, {Type, Rid1, SrvId1, RoleName});
                                        false ->
                                            center:cast(sys_conn, pack_send, [ConnPid, 11621, {Type, Rid1, SrvId1, RoleName}])
                                    end,
                                    {reply, {?true, <<>>}}
                            end
                    end;
                {ok, _Node, [_, TeamPid, _Action, _Event, _Sex2, _Mounts2, _TeamInfo]} when is_pid(RoleTeamPid) andalso is_pid(TeamPid) ->
                    %% 不是同一个队伍
                    {reply, {?false, ?L(<<"您和对方不在同一个队伍，不能请求双人共同骑乘">>)}};
                {ok, Node, [#link{conn_pid = ConnPid}, TeamPid, Action, Event, Sex2, Mounts2, TeamInfo]} when is_pid(TeamPid) ->
                    %% 对方有队伍，则队伍只能1人且其是队长
                    Args = [
                        {action, Action}
                        ,{event, Event}
                        ,{sex, {Sex1, Sex2}}
                        ,{leader, TeamInfo}
                        ,{team, {TeamPid, 1}}
                    ],
                    case both_ride:check_both_ride2(Args) of
                        {false, Msg} -> {reply, {?false, Msg}};
                        ok ->
                            case mount:is_both_mount(Mounts2) of
                                false ->
                                    {reply, {?false, ?L(<<"对方没有装备双人坐骑或打开双人骑乘形象，无法请求双人骑乘">>)}};
                                true ->
                                    case Node =:= node() of
                                        true ->
                                            sys_conn:pack_send(ConnPid, 11621, {Type, Rid1, SrvId1, RoleName});
                                        false ->
                                            center:cast(sys_conn, pack_send, [ConnPid, 11621, {Type, Rid1, SrvId1, RoleName}])
                                    end,
                                    {reply, {?true, <<>>}}
                            end
                    end;
                {ok, Node, [#link{conn_pid = ConnPid}, _TeamPid, Action, Event, Sex2, _Mounts2, _TeamInfo]} ->
                    %% 对方无队伍，则要求当前角色是队长，有坐骑
                    Args = [
                        {action, Action}
                        ,{event, Event}
                        ,{sex, {Sex1, Sex2}}
                        ,{leader, RoleTeam}
                        ,{team, {RoleTeamPid, 1}}
                    ],
                    case both_ride:check_both_ride2(Args) of
                        {false, Msg} -> {reply, {?false, Msg}};
                        ok ->
                            case mount:is_both_mount(Mounts1) of
                                false ->
                                    {reply, {?false, ?L(<<"您没有装备双人坐骑或打开双人骑乘形象，无法请求双人骑乘">>)}};
                                true ->
                                    case Node =:= node() of
                                        true ->
                                            sys_conn:pack_send(ConnPid, 11621, {Type, Rid1, SrvId1, RoleName});
                                        false ->
                                            center:cast(sys_conn, pack_send, [ConnPid, 11621, {Type, Rid1, SrvId1, RoleName}])
                                    end,
                                    {reply, {?true, <<>>}}
                            end
                    end;
                _ -> {reply, {?false, ?L(<<"对方不在线">>)}}
            end
    end;

%% 处理双人骑乘的请求结果
handle(11622, {Ret = ?false, _, Rid, SrvId}, #role{}) ->
    case role_api:c_lookup(by_id, {Rid, SrvId}, [#role.name, #role.link]) of
        {ok, Node, [Name, #link{conn_pid = ConnPid}]} ->
            Msg = util:fbin(?L(<<"~s拒绝了您的双人共同骑乘请求">>), [Name]),
            case Node =:= node() of
                true ->
                    sys_conn:pack_send(ConnPid, 11620, {Ret, Msg});
                false ->
                    center:cast(sys_conn, pack_send, [ConnPid, 11620, {Ret, Msg}])
            end;
        _ -> ignore
    end,
    {ok};
handle(11622, {_Ret = ?true, _Type, Rid, SrvId}, Role = #role{team_pid = RoleTeamPid, id = RoleId, name = RoleName, sex = Sex1, mounts = Mounts1}) ->
    case both_ride:check_both_ride(Role) of
        {false, Msg} -> {reply, {?false, Msg}};
        ok ->
            case role_api:c_lookup(by_id, {Rid, SrvId}, [#role.pid, #role.team_pid, #role.action, #role.event, #role.sex, #role.mounts, #role.team, #role.name]) of
                {ok, _, [OtherPid, RoleTeamPid, Action, Event, Sex2, Mounts2, TeamInfo, _Name]} when is_pid(RoleTeamPid) ->
                    %% 同一个队伍，则只能队伍有2人，请求人是队长，当前角色是队员
                    case mount:is_both_mount(Mounts2) of
                        false -> %% 对方没有双人坐骑
                            {reply, {?false, ?L(<<"对方没有装备双人坐骑或打开双人骑乘形象，无法请求双人骑乘">>)}};
                        true ->
                            Args = [
                                {action, Action}
                                ,{event, Event}
                                ,{sex, {Sex1, Sex2}}
                                ,{leader, TeamInfo}
                                ,{team, {RoleTeamPid, 2}}
                            ],
                            case both_ride:check_both_ride2(Args) of
                                {false, Msg} -> {reply, {?false, Msg}};
                                ok ->
                                    role:c_apply(async, OtherPid, {fun do_ride_both/2, [{RoleId, RoleName, self()}]}),
                                    {ok}
                            end
                    end;
                {ok, _, [OtherPid, RoleTeamPid, Action, Event, Sex2, Mounts2, _TeamInfo, Name]} ->
                    %% 都没有队伍
                    Args = [
                        {action, Action}
                        ,{event, Event}
                        ,{sex, {Sex1, Sex2}}
                    ],
                    case both_ride:check_both_ride2(Args) of
                        {false, Msg} -> {reply, {?false, Msg}};
                        ok ->
                            case mount:is_both_mount(Mounts2) of
                                true -> %% 请求方有双人坐骑
                                    role:c_apply(async, OtherPid, {fun do_ride_both/2, [{RoleId, RoleName, self()}]}),
                                    {ok};
                                false -> %% 对方没有双人坐骑
                                    case mount:is_both_mount(Mounts1) of
                                        false -> {reply, {?false, ?L(<<"您没有装备双人坐骑或打开双人骑乘形象，无法请求">>)}};
                                        true ->
                                            do_ride_both(Role, {{Rid, SrvId}, Name, OtherPid})
                                    end
                            end
                    end;
                {ok, _Node, [_, TeamPid, _Action, _Event, _Sex2, _Mounts2, _TeamInfo, _Name]} when is_pid(RoleTeamPid) andalso is_pid(TeamPid) ->
                    %% 不是同一个队伍
                    {reply, {?false, ?L(<<"您和对方不在同一个队伍，不能请求双人共同骑乘">>)}};
                {ok, _Node, [OtherPid, TeamPid, Action, Event, Sex2, Mounts2, TeamInfo, _Name]} when is_pid(TeamPid) ->
                    %% 请求方有队伍(当前角色无队伍)，则只能队伍1人且其是队长，有双人坐骑
                    Args = [
                        {action, Action}
                        ,{event, Event}
                        ,{sex, {Sex1, Sex2}}
                        ,{leader, TeamInfo}
                        ,{team, {TeamPid, 1}}
                    ],
                    case both_ride:check_both_ride2(Args) of
                        {false, Msg} -> {reply, {?false, Msg}};
                        ok ->
                            case mount:is_both_mount(Mounts2) of
                                false -> {reply, {?false, ?L(<<"对方没有装备双人坐骑或打开双人骑乘形象，无法请求">>)}};
                                true ->
                                    role:c_apply(async, OtherPid, {fun do_ride_both/2, [{RoleId, RoleName, self()}]}),
                                    {ok}
                            end
                    end;
                {ok, _Node, [OtherPid, _TeamPid, Action, Event, Sex2, _Mounts2, _TeamInfo, Name]} ->
                    %% 请求方无队伍(当前角色有队伍)，则要求当前角色是队长，有坐骑
                    Args = [
                        {action, Action}
                        ,{event, Event}
                        ,{sex, {Sex1, Sex2}}
                        ,{team, {RoleTeamPid, 1}}
                    ],
                    case both_ride:check_both_ride2(Args) of
                        {false, Msg} -> {reply, {?false, Msg}};
                        ok ->
                            case mount:is_both_mount(Mounts1) of
                                false -> {reply, {?false, ?L(<<"您没有装备双人坐骑或打开双人骑乘形象，无法请求">>)}};
                                true ->
                                    do_ride_both(Role, {{Rid, SrvId}, Name, OtherPid})
                            end
                    end;
                _ -> {reply, {?false, ?L(<<"对方已经离线">>)}}
            end
    end;
%% handle(11622, {_Ret = ?true, _Type = 2, Rid, SrvId}, Role = #role{team_pid = RoleTeamPid, sex = Sex1}) -> %% 同意申请
%%     case both_ride:check_both_ride(Role) of
%%         {false, Msg} -> {reply, {?false, Msg}};
%%         ok ->
%%             case role_api:c_lookup(by_id, {Rid, SrvId}, [#role.pid, #role.team_pid, #role.action, #role.event, #role.name, #role.sex]) of
%%                 {ok, _, [OtherPid, TeamPid, Action, Event, Name, Sex2]} ->
%%                     Args = [
%%                         {action, Action}
%%                         ,{team, {RoleTeamPid, TeamPid}}
%%                         ,{event, Event}
%%                         ,{sex, {Sex1, Sex2}}
%%                     ],
%%                     case both_ride:check_both_ride2(Args) of
%%                         {false, Msg} -> {reply, {?false, Msg}};
%%                         ok -> %% TODO: 
%%                             case team_api:create_team(Role, [OtherPid]) of
%%                                 {false, _} -> {reply, {?false, <<"操作失败">>}};
%%                                 {ok, _Tid} ->
%%                                     {ok, both_ride:handle_both_ride({1, {Rid, SrvId}, Name, OtherPid}, Role)}
%%                             end
%%                     end;
%%                 _ -> {reply, {?false, <<"对方已经离线">>}}
%%             end
%%     end;

%% 容错
handle(_Cmd, _Msg, _Role) ->
    {error, unknow_command}.

%% ---------------------------------------------------
%% 内部函数
%% ---------------------------------------------------

do_ride_both(Role, {OtherId, OtherName, OtherPid}) ->
    NewRole = both_ride:handle_both_ride({1, OtherId, OtherName, OtherPid}, Role),
    case team_api:create_team(NewRole, [OtherPid]) of
        {false, _E} ->
            ?ERR("双人骑乘请求组队失败：~w", [_E]),
            {ok};
        {ok, _} ->
            {ok, NewRole}
    end.
