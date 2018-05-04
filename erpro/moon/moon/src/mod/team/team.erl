%% ************************
%% 队伍进程
%% @author wpf wpf0208@jieyou.cn
%% ************************
-module(team).
-behaviour(gen_server).
-export([
        start/1
        %% 同步
        ,is_leader/2                %% 是否队长
        ,is_tempout_member/2        %% 是否是暂离队员
        ,is_can_fight/2             %% 是否能npc攻击
        ,get_leader/1               %% 获取队长
        ,get_member_count/1         %% 获取队伍人数
        ,get_team_info/1            %% 获取队伍信息
        ,get_members_id/1
        ,join/2                     %% 加入队伍
        ,kick_out/2                 %% 移出队员
        ,combat_tempout/1           %% 战斗死亡/逃脱暂离:队长死亡，直接让队员暂离
        ,back_team/1                %% 归队
        %% 上下线处理
        ,member_offline/1           %% 队员下线
        ,member_offline/2
        ,member_online/1            %% 队员上线
        ,member_online/2
        ,member_switch/1            %% 顶号情况
        ,member_switch/3
        ,delete_member_global/1
        ,add_member_global/2
        %% 异步
        ,pull_other_looks/2         %% 获取队员外观
        ,set_apply_rule/2           %% 设置申请规则
        ,update_dungeon_hall/3    %% 注册到副本招募大厅
        ,set_ride/1                 %% 队伍飞行状态设置
        ,update_ride/1              %% 队伍飞行状态更新
        ,update_attr/1              %% 队伍属性更新
        ,update_lineup/1            %% 队伍阵法更新
        ,chat/3
        ,apply_in/3
        ,appoint/2                  %% 委任
        ,tempout/2                  %% 暂离
        ,quit/1                     %% 退出
        ,recall/2                   %% 召唤归队
        ,stop/1                     %% 结束队伍
        ,stop/2                     %% 结束队伍
        %% 场景相关
        ,enter/3
        ,fly/2
    ]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("common.hrl").
-include("role.hrl").
-include("link.hrl").
-include("pos.hrl").
%%
-include("team.hrl").
-include("map.hrl").
-include("skill.hrl").
-include("attr.hrl").

%% 40s自检测间隔
-define(SELF_CHECK_TIME, 40000).

%% 生成队员和队长的角色队伍数据
-define(TO_ROLE_MEMBER,
    #role_team{team_id = TeamId, lineup = Lineup, speed = Speed,
        follow = case Mode of
            ?MODE_NORMAL -> ?true;
            _ -> ?false
        end
    }).
-define(TO_ROLE_LEADER,
    #role_team{team_id = TeamId, lineup = Lineup, is_leader = ?true, speed = Speed,
        follow = case Mode of
            ?MODE_NORMAL -> ?true;
            _ -> ?false
        end
    }).

%% @spec start(Team) -> {ok, Pid} | ignore | {error, Err}
%% Team = #team{}
%% @doc 创建队伍进程: 要求队伍建立时，至少一个人
start(Team) ->
    gen_server:start(?MODULE, [Team], []).

%% @spec stop(Arg) -> any()
%% @spec stop(Pid, Msg) -> any()
%% Arg = #role{} | pid()
%% Msg = atom() 关闭原因
%% @doc 异步结束队伍进程，关闭队伍
stop(Pid) when is_pid(Pid) ->
    team_cross:send(Pid, {stop, normal});
stop(#role{team_pid = TeamPid}) ->
    stop(TeamPid);
stop(_) -> ignore.
stop(#role{team_pid = TeamPid}, Msg) ->
    stop(TeamPid, Msg);
stop(Pid, Msg) when is_pid(Pid) ->
    team_cross:send(Pid, {stop, Msg});
stop(_, _) -> ignore.

%% @spec is_leader(TeamPid, Id) -> {true, TeamId} | false
%% Id = {integer(), bitstring()}
%% TeamPid = pid()
%% @doc 是否队长
is_leader(TeamPid, Id) when is_pid(TeamPid)->
    case team_cross:call(TeamPid, {is_leader, Id}) of
        {badrpc, _} -> false;
        Res -> Res
    end;
is_leader(_, _) ->
    false.

%% @spec is_tempout_member(TeamPid, Id) -> true | false
%% Id = {integer(), bitstring()}
%% TeamPid = pid()
%% @doc 是否暂离队员
is_tempout_member(TeamPid, Id) when is_pid(TeamPid)->
    case team_cross:call(TeamPid, {is_tempout, Id}) of
        {badrpc, _} -> false;
        Res -> Res
    end;
is_tempout_member(_, _) ->
    false.

%% @spec pull_other_looks(OtherId, Role) -> any()
%% @doc 获取其他队员的外观
pull_other_looks(OtherId, #role{team_pid = TeamPid, link = #link{conn_pid = ConnPid}}) when is_pid(TeamPid) ->
    team_cross:send(TeamPid, {pull_looks, ConnPid, OtherId});
pull_other_looks(_, _) -> error.

%% @spec is_tempout_member(TeamPid, Id) -> true | false
%% Id = {integer(), bitstring()}
%% TeamPid = pid()
%% @doc 是否可以发起战斗
is_can_fight(TeamPid, Id) ->
    team_cross:call(TeamPid, {is_can_fight, Id}).

%% @spec get_leader(TeamPid) -> {ok, TeamId, Leader} | any()
%% TeamPid = pid()
%% @doc 获取队长信息
get_leader(TeamPid) ->
    team_cross:call(TeamPid, get_leader).

%% @spec get_member_count(TeamPid) -> integer() | {error, Reason} | {badrpc, Reason}
%% TeamPid = pid()
%% @doc 获取队伍人数，包括队长
get_member_count(TeamPid) ->
    team_cross:call(TeamPid, get_member_count).

%% @spec get_team_info(TeamPid) -> {ok, TeamState} | error | any()
%% TeamPid = pid()
%% Teamstate = #team{}
%% @doc 获取队伍信息
get_team_info(TeamPid) when is_pid(TeamPid) ->
    team_cross:call(TeamPid, get_team_info).

get_members_id(TeamPid) ->
    team_cross:call(TeamPid, get_members_id).

%% @spec apply_in(TeamPid, ApplyRole, ApplyMsg) -> any()
%% TeamPid = pid()
%% ApplyRole = #role{}
%% ApplyMsg = bitstring()
%% @doc 申请加入队伍
apply_in(TeamPid, #role{pid = ApplyPid, id = ApplyId, name = Name, link = #link{conn_pid = ConnPid}, event = Event}, ApplyMsg)
when is_pid(TeamPid) ->
    team_cross:send(TeamPid, {apply_in, ApplyMsg, ApplyPid, ApplyId, Name, ConnPid, Event});
apply_in(_, _, _) ->
    {false, ?L(<<"邀请组队失败，对方不在线或者当前不能组队">>)}.

%% @spec join(TeamPid, Role) -> {false, Reason} | {ok, NewRole}
%% Role = #role{}
%% @doc 角色加入队伍,要加入队伍的角色进程调用
join(TeamPid, Role = #role{action = Action, event = Event})
when is_pid(TeamPid) andalso Action >= ?action_sit andalso Action =< ?action_sit_lovers ->
    {ok, Member} = role_convert:do(to_team_member, Role),
    ?DEBUG("角色[NAME:~s]加入队伍，暂离模式", [Role#role.name]),
    case team_cross:call(TeamPid, {join_tempout, Member, Event}) of
        {ok, NewTeam} ->
            Role0 = role_listener:acc_event(Role, {102, 1}),
            add_team_info(Role0, NewTeam);
        {false, Reason} -> {false, Reason};
        _ -> {false, ?L(<<"操作失败">>)}
    end;
join(TeamPid, Role = #role{pos = Pos, event = Event}) when is_pid(TeamPid) ->
    {ok, Member} = role_convert:do(to_team_member, Role),
    case team_cross:call(TeamPid, {join, Member, Event, Pos}) of
        {ok, NewTeam} ->
            Role0 = role_listener:acc_event(Role, {102, 1}),
            add_team_info(Role0, NewTeam);
        {false, Reason} -> {false, Reason};
        _ -> {false, ?L(<<"操作失败">>)}
    end;
join(_, _) -> {false, ?L(<<"操作失败">>)}.

%% @spec appoint(Role, MembeRoleId) -> {false, Reason} | {ok}
%% TeamPid = pid()
%% Role = NewRole = #role{}
%% MembeRoleId = {integer(), bitstring()}
%% @doc 委任队长
appoint(#role{id = RoleId, team_pid = TeamPid, ride = ?ride_fly}, MemberId)
when is_pid(TeamPid) ->
    team_cross:send(TeamPid, {appoint_flying, RoleId, MemberId}),
    {ok};
appoint(#role{team_pid = TeamPid, id = RoleId, action = Action}, MemberId)
when is_pid(TeamPid) andalso Action >= ?action_sit andalso Action =< ?action_sit_lovers ->
    team_cross:send(TeamPid, {appoint_sitting, RoleId, MemberId}),
    {ok};
appoint(#role{team_pid = TeamPid, id = RoleId}, MemberId)
when is_pid(TeamPid) ->
    team_cross:send(TeamPid, {appoint, RoleId, MemberId}),
    {ok};
appoint(_, _) ->
    {false, ?L(<<"操作失败，您现在没有队伍">>)}.

%% @spec tempout(Role, Type) -> {false, Reason} | {ok}
%% Type = atom() 暂离的方式：normal | sit
%% Role = NewRole = #role{}
%% @doc 暂离 Member = #role{}
%% <div> 可做角色回调函数 </div>
tempout(#role{team_pid = TeamPid, ride = ?ride_fly}, sit)
when is_pid(TeamPid) ->
    {false, ?L(<<"飞行状态不允许打坐暂离">>)};
tempout(#role{team_pid = TeamPid, team = #role_team{follow = ?false}}, sit)
when is_pid(TeamPid) ->
    {ok};
tempout(Role = #role{team_pid = TeamPid}, sit)
when is_pid(TeamPid) ->
    tempout(Role, normal);
tempout(#role{id = RoleId, team_pid = TeamPid}, normal)
when is_pid(TeamPid) ->
    team_cross:send(TeamPid, {tempout, RoleId}), 
    {ok};
tempout(_, _) ->
    {false, ?L(<<"操作失败，您现在没有队伍">>)}.

%% @spec combat_tempout(Role) -> NewRole
%% Role = NewRole = #role{}
%% @doc 战斗完死亡、逃跑暂离队伍
%% <div> 队长死亡/逃跑，则强制队员暂离 </div>
combat_tempout(Role = #role{id = Rid, team_pid = TeamPid}) when is_pid(TeamPid) ->
    case team_cross:call(TeamPid, {combat_tempout, Rid}) of
        false ->
            ?ERR("战斗完成，队伍更新数据出错[NAME：~s]", [Role#role.name]),
            Role;
        ok ->
            ?DEBUG("战斗完成，无须更新队伍数据[NAME：~s]", [Role#role.name]),
            team_api:team_listener(tempout, Role);
        {ok, NewTeam} ->
            Role1 = team_api:team_listener(tempout, Role),
            {ok, NewRole} = change_team_info(Role1, NewTeam, ?DO_TEMPOUT_COMBAT), %% 不广播
            NewRole
    end;
combat_tempout(Role) -> Role.

%% @spec kick_out(Role, MemberId) -> {false, Reason} | ok
%% Role = #role{}
%% MemberId = {integer(), bitstring()}
%% @doc 移出队员
kick_out(#role{team_pid = TeamPid, id = Rid}, MemberId)
when is_pid(TeamPid) ->
    team_cross:call(TeamPid, {kick_out, Rid, MemberId});
kick_out(_, _) -> {false, ?L(<<"操作失败，您现在没有队伍">>)}.

%% @spec back_team(Role) -> {false, Reason} | {ok, NewRole}
%% Role = NewRole = #role{}
%% @doc 归队
back_team(Role = #role{id = Rid, team_pid = TeamPid, pos = Pos}) when is_pid(TeamPid) ->
    case team_cross:call(TeamPid, {back_team, Rid, Pos}) of
        {ok, NewTeam} ->
            change_team_info(Role, NewTeam, ?DO_BACK);
        Other -> Other
    end;
back_team(_) -> {false, ?L(<<"操作失败，您现在没有队伍">>)}.

%% @spec quit(Role) -> {false, Reason} | {ok, NewRole}
%% Role = #role{}
%% @doc 请求离开队伍
quit(#role{id = Rid, pid = RolePid, team_pid = TeamPid}) when is_pid(TeamPid) ->
    team_cross:send(TeamPid, {quit, Rid, RolePid});
quit(_) -> {false, ?L(<<"操作失败，您现在没有队伍">>)}.

%% @spec recall(TeamPid, LeaderId) -> any()
%% LeaderId = {integer(), bitstring()}
%% @doc 召集所有暂离队员
recall(TeamPid, LeaderId) when is_pid(TeamPid) ->
    team_cross:send(TeamPid, {recall, LeaderId});
recall(_, _) ->
    ignore.

%% @spec set_apply_rule(TeamPid, {Rid, IsDirect}) -> any()
%% @doc 设置队伍的申请规则
set_apply_rule(TeamPid, {Rid, IsDirect}) when is_pid(TeamPid) ->
    team_cross:send(TeamPid, {set_apply_rule, Rid, IsDirect});
set_apply_rule(_, _) ->
    ignore.

%% @spec update_dungeon_hall(TeamPid, DungId, IsRegister) -> any()
%% @doc 队伍注册/取消招募大厅后，更新队伍信息
update_dungeon_hall(TeamPid, DungId, IsRegister) when is_pid(TeamPid) ->
    team_cross:send(TeamPid, {update_dungeon_hall, DungId, IsRegister});
update_dungeon_hall(_TeamPid, _DungId, _IsRegister) ->
    ignore.

%% @spec chat(TeamPid, Cmd, Data) -> any()
%% @doc 聊天消息转发
chat(TeamPid, Cmd, Data) when is_pid(TeamPid) ->
    team_cross:send(TeamPid, {chat, Cmd, Data});
chat(_TeamPid, _Cmd, _Data) -> ok.

%% @spec member_offline(TeamPid, Member) -> any() 
%% @doc 队员下线
member_offline(#role{id = Rid, team_pid = TeamPid}) when is_pid(TeamPid) ->
    member_offline(TeamPid, Rid);
member_offline(_) -> ignore.

%% @spec member_offline(TeamPid, MemberId) -> any()
%% @doc 队员下线
member_offline(TeamPid, Member) ->
    team_cross:send(TeamPid, {member_offline, Member}).

%% @spec member_online(Role) -> NewRole
%% Role = NewRole = #role{}
%% @doc 队员上线，查找队伍信息，并处理
member_online(#role{pid = Rpid, id = Rid, link = #link{conn_pid = ConnPid}}) ->
    case ets:lookup(ets_team_member, Rid) of
        [#member_global{team_pid = TeamPid}] when is_pid(TeamPid) ->
            member_online(TeamPid, {Rpid, Rid, ConnPid});
        _ -> 
            ignore
    end,
    ets:delete(ets_team_member, Rid);
member_online(_) ->
    ignore.
member_online(TeamPid, {Mpid, Mid, ConnPid}) ->
    team_cross:send(TeamPid, {member_online, {Mpid, Mid, ConnPid}}).

%% @spec member_switch(Role) -> any()
%% @doc 队员顶号上线情况
member_switch(#role{team_pid = TeamPid, id = Rid, link = #link{conn_pid = ConnPid}})
when is_pid(TeamPid) ->
    team_cross:send(TeamPid, {member_switch, Rid, ConnPid});
member_switch(_R) ->
    ignore.
member_switch(TeamPid, RoleId, RoleConnPid) ->
    team_cross:send(TeamPid, {member_switch, RoleId, RoleConnPid}).

%% @spec delete_member_global(Member) -> any()
%% Member = #team_member{} | {integer(), bitstring}
%% @doc 处理队员的离线全局记录表，删除记录(包括跨服处理)
delete_member_global(#team_member{pid = Mpid, id = Mid}) when is_pid(Mpid) ->
    Node = node(Mpid),
    case Node =:= node() of
        true ->
            ets:delete(ets_team_member, Mid);
        false ->
            ?DEBUG("跨服删除队员的全局离线记录表"),
            center:cast(rpc, cast, [Node, team, delete_member_global, [Mid]])
    end;
delete_member_global(#team_member{id = Mid, name = _Name, pid = _pid}) ->
    ?DEBUG("队伍解散，删除队员离线信息失败[NAME:~s, Pid:~w]", [_Name, _pid]),
    ets:delete(ets_team_member, Mid);
delete_member_global(Mid) ->
    ets:delete(ets_team_member, Mid).

%% @spec add_member_global(Member, TeamPid) -> any()
%% Member = #team_member{} | {integer(), bitstring}
%% TeamPid = pid()
%% @doc 处理队员的离线全局记录表，增加记录(包括跨服处理)
add_member_global(#team_member{pid = Mpid, id = Mid}, TeamPid) ->
    Node = node(Mpid),
    case Node =:= node() of
        true ->
            ets:insert(ets_team_member, #member_global{member_id = Mid, team_pid = TeamPid});
        false ->
            ?DEBUG("跨服添加队员的全局离线记录表"),
            center:cast(rpc, cast, [Node, team, add_member_global, [Mid, TeamPid]])
    end;
add_member_global(Mid, TeamPid) ->
    ets:insert(ets_team_member, #member_global{member_id = Mid, team_pid = TeamPid}).

%% @spec enter(TeamPid, RoleId, {MapId, X, Y}) -> any()
%% RoleId = {Id, SrvId} 请求切换地图的队员ID
%% @doc 队伍进入地图，队长操作
enter(TeamPid, Rid, {MapId, X, Y}) when is_pid(TeamPid) ->
    team_cross:send(TeamPid, {enter, Rid, {MapId, X, Y}});
enter(_, _, _) ->
    error.

%% @spec fly(TeamPid, Role) -> any()
%% @doc 进入或取消飞行状态
fly(TeamPid, Role) ->
    team_cross:send(TeamPid, {fly, Role}).

%% @spec update_attr(Role) -> NewRole
%% Role = NewRole = #role{}
%% @doc 角色属性更新通知队伍进程
%% <div>
%% 返回新的Role结构
%% 其中根据#role_team{}结构内容，对于特殊情况特殊处理
%% </div>
update_attr(Role = #role{team_pid = TeamPid, id = Rid, lev = Lev, career = Career, sex = Sex, hp = Hp, mp = Mp, attr = #attr{fight_capacity = Fight},
        hp_max = HpMax, mp_max = MpMax, speed = Speed, team = RoleTeam = #role_team{is_leader = ?true}})
when is_pid(TeamPid) -> %% 队长
    team_cross:send(TeamPid, {update_attr, Rid, Lev, Career, Sex, Hp, Mp, HpMax, MpMax, Fight, Speed}),
    Role#role{team = RoleTeam#role_team{speed = Speed}};
update_attr(Role = #role{team_pid = TeamPid, id = Rid, lev = Lev, career = Career, sex = Sex, hp = Hp, mp = Mp, attr = #attr{fight_capacity = Fight},
        hp_max = HpMax, mp_max = MpMax, speed = Speed})
when is_pid(TeamPid) ->
    team_cross:send(TeamPid, {update_attr, Rid, Lev, Career, Sex, Hp, Mp, HpMax, MpMax, Fight, Speed}),
    Role;
update_attr(Role) ->
    Role.

%% @spec set_ride(Role) -> any()
%% Role = #role{}
%% @doc 设置队伍的飞行骑乘状态(由调用者操作场景更新和广播)
set_ride(#role{team_pid = TeamPid, id = Rid, ride = Ride}) when is_pid(TeamPid) ->
    team_cross:send(TeamPid, {set_ride, Rid, Ride});
set_ride(_) ->
    ignore.

%% @spec update_ride(Role) -> any()
%% Role = #role{}
%% @doc 角色飞行状态更新通知队伍进程修改，会更新并广播至相关队员
update_ride(#role{team = #role_team{is_leader = ?false}}) ->
    ignore;
update_ride(#role{team_pid = TeamPid, id = Rid, ride = Ride}) when is_pid(TeamPid) ->
    team_cross:send(TeamPid, {update_ride, Rid, Ride});
update_ride(_) ->
    ignore.

%% @spec update_lineup(Role) -> any()
%% Role = #role{}
%% @doc 角色选择阵法更新通知队伍进程修改
update_lineup(#role{team_pid = TeamPid, id = RoleId, skill = #skill_all{lineup = LineupId}})
when is_pid(TeamPid) ->
    team_cross:send(TeamPid, {update_lineup, RoleId, LineupId});
update_lineup(_) ->
    ignore.

%% ----------------------------------------
%% gen_server 内部处理
%% ----------------------------------------
init([Team = #team{leader = #team_member{pid = Pid}}]) ->
    NewTeam = Team#team{team_pid = self()},
    %% 广播队伍成员消息，并通知队长队伍创建成功
    self() ! create_success_cast,
    %% 自检测
    erlang:send_after(?SELF_CHECK_TIME, self(), self_check),
    role:c_apply(async, Pid, {fun add_team_info/2, [NewTeam]}),
    {ok, NewTeam}.

%% 获取队伍信息
handle_call(get_team_info, _From, TeamState) ->
    {reply, {ok, TeamState}, TeamState};

handle_call(get_members_id, _From, TeamState = #team{member = Members}) ->
    Reply = [Id || #team_member{id = Id, mode = ?MODE_NORMAL} <- Members],
    {reply, Reply, TeamState};

%% 获取队伍中的人数
handle_call(get_member_count, _From, TeamState = #team{member = []}) ->
    {reply, 1, TeamState};
handle_call(get_member_count, _From, TeamState = #team{member = [_]}) ->
    {reply, 2, TeamState};
handle_call(get_member_count, _From, TeamState = #team{member = [_, _]}) ->
    {reply, 3, TeamState};

%% 是否队长
handle_call({is_leader, Rid}, _From, TeamState = #team{team_id = Tid, leader = #team_member{id = Rid}}) ->
    {reply, {true, Tid}, TeamState};
handle_call({is_leader, _Rid}, _From, TeamState) ->
    {reply, false, TeamState};

%% 是否暂离队员
handle_call({is_tempout, Rid}, _From, TeamState = #team{member = Member}) ->
    Ret = case lists:keyfind(Rid, #team_member.id, Member) of
        #team_member{mode = ?MODE_TEMPOUT} -> true;
        _ -> false
    end,
    {reply, Ret, TeamState};

%% 是否可以被攻击
handle_call({is_can_fight, Lid}, _From, TeamState = #team{leader = #team_member{id = Lid}}) ->
    {reply, true, TeamState};
handle_call({is_can_fight, Rid}, _From, TeamState = #team{member = Member}) ->
    Ret = case lists:keyfind(Rid, #team_member.id, Member) of
        #team_member{mode = ?MODE_TEMPOUT} -> true;
        _ -> false
    end,
    {reply, Ret, TeamState};

%% 获取队长
handle_call(get_leader, _From, TeamState = #team{team_id = TeamId, leader = Leader}) ->
    {reply, {ok, TeamId, Leader}, TeamState};

%% 加入队伍
handle_call({join, M = #team_member{name = Mname}, Event, Pos1}, _From, TeamState = #team{leader = #team_member{id = Lid, pid = Lpid}, member = Members}) ->
    case length(Members) < get_member_limit(Event) of
        false when Event =:= ?event_guild_arena ->
            ?DEBUG("角色[NAME:~s]加入队伍失败", [Mname]),
            {reply, {false, ?L(<<"帮战中，只能两人组队。">>)}, TeamState};
        false ->
            ?DEBUG("角色[NAME:~s]加入队伍失败", [Mname]),
            {reply, {false, ?L(<<"操作失败，对方队伍已满">>)}, TeamState};
        true ->
            case role_api:c_lookup(by_pid, Lpid, #role.pos) of
                {ok, _N, Pos2} ->
                    NewM = case map:calc_distance(Pos1, Pos2) of
                        false ->
                            M#team_member{mode = ?MODE_TEMPOUT};%% 非同一场景，置暂离
                        {ok, {DistX, DistY}} ->
                            case DistX =< ?BACK_GRID andalso DistY =< ?BACK_GRID of
                                false -> M#team_member{mode = ?MODE_TEMPOUT};
                                true -> M
                            end
                    end,
                    NewMembers = [NewM | Members],
                    NewTeam = TeamState#team{member = NewMembers},
                    case NewM#team_member.mode of
                        ?MODE_TEMPOUT ->
                            team_cast(NewTeam, util:fbin(?L(<<"【~s】加入了队伍，距离队伍太远，自动暂离队伍">>), [Mname]));
                        _ ->
                            team_cast(NewTeam, util:fbin(?L(<<"【~s】加入了队伍">>), [Mname]))
                    end,
                    friend:refresh_buff([{Lpid, Lid} | [{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- NewMembers]]),
                    sworn_api:refresh_buff([{Lpid, Lid} | [{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- NewMembers]]),
                    {reply, {ok, NewTeam}, NewTeam};
                _ -> {reply, {false, ?L(<<"操作失败，未能加入队伍">>)}, TeamState}
            end
    end;
handle_call({join, _, _, _}, _, TeamState) ->
    {reply, {false, <<>>}, TeamState};
%% 加入队伍, 暂离模式
handle_call({join_tempout, M = #team_member{name = Mname}, Event}, _From, TeamState = #team{member = Members}) ->
    case length(Members) < get_member_limit(Event) of
        false ->
            {reply, {false, ?L(<<"操作失败，对方队伍已满">>)}, TeamState};
        true ->
            NewList = [M#team_member{mode = ?MODE_TEMPOUT} | Members],
            NewTeam = TeamState#team{member = NewList},
            team_cast(NewTeam, util:fbin(?L(<<"【~s】加入了队伍，处于打坐状态中，自动暂离队伍">>), [Mname])),
            {reply, {ok, NewTeam}, NewTeam}
    end;
handle_call({join_tempout, _, _}, _, TeamState) ->
    {reply, {false, <<>>}, TeamState};

%% 战斗死亡/逃跑暂离
handle_call({combat_tempout, Lid}, _From, TeamState = #team{leader = #team_member{id = Lid}, member = []}) ->
    {reply, ok, TeamState};
%% 队长死亡/逃跑, 队员全部暂离
handle_call({combat_tempout, Lid}, _From, TeamState = #team{leader = #team_member{id = Lid, pid = Lpid},
        member = [M = #team_member{id = Mid, pid = Mpid, name = Mname, mode = ?MODE_NORMAL}]}) ->
    NewTeam = TeamState#team{member = [M#team_member{mode = ?MODE_TEMPOUT}]},
    team_cast(NewTeam, util:fbin(?L(<<"【~s】暂离了队伍">>), [Mname])),
    friend:remove_buff([{Lpid, Lid}, {Mpid, Mid}]), %% 亲密度
    sworn_api:remove_buff([{Lpid, Lid}, {Mpid, Mid}]),
    role:c_apply(async, Mpid, {fun change_team_info/3, [NewTeam, ?DO_TEMPOUT]}),
    {reply, {ok, NewTeam}, NewTeam};
handle_call({combat_tempout, Lid}, _From, TeamState = #team{leader = #team_member{id = Lid, pid = Lpid},
        member = [M1 = #team_member{id = Mid1, pid = Mpid1, name = Mname1, mode = ?MODE_NORMAL},
            M2 = #team_member{id = Mid2, pid = Mpid2, name = Mname2, mode = ?MODE_NORMAL}]}) ->
    NewMembers = [M1#team_member{mode = ?MODE_TEMPOUT}, M2#team_member{mode = ?MODE_TEMPOUT}],
    NewTeam = TeamState#team{member = NewMembers},
    team_cast(NewTeam, util:fbin(?L(<<"【~s】、【~s】暂离了队伍">>), [Mname1, Mname2])),
    friend:remove_buff([{Lpid, Lid}, {Mpid1, Mid1}, {Mpid2, Mid2}]), %% 亲密度
    sworn_api:remove_buff([{Lpid, Lid}, {Mpid1, Mid1}, {Mpid2, Mid2}]),
    role:c_apply(async, Mpid1, {fun change_team_info/3, [NewTeam, ?DO_TEMPOUT]}),
    role:c_apply(async, Mpid2, {fun change_team_info/3, [NewTeam, ?DO_TEMPOUT]}),
    {reply, {ok, NewTeam}, NewTeam};
handle_call({combat_tempout, Lid}, _From, TeamState = #team{leader = #team_member{id = Lid, pid = Lpid},
        member = [M1 = #team_member{id = Mid1, pid = Mpid1, name = Mname1, mode = ?MODE_NORMAL}, M2]}) ->
    NewMembers = [M1#team_member{mode = ?MODE_TEMPOUT}, M2],
    NewTeam = TeamState#team{member = NewMembers},
    team_cast(NewTeam, util:fbin(?L(<<"【~s】暂离了队伍">>), [Mname1])),
    friend:remove_buff([{Lpid, Lid}, {Mpid1, Mid1}]), %% 亲密度
    sworn_api:remove_buff([{Lpid, Lid}, {Mpid1, Mid1}]),
    role:c_apply(async, Mpid1, {fun change_team_info/3, [NewTeam, ?DO_TEMPOUT]}),
    {reply, {ok, NewTeam}, NewTeam};
handle_call({combat_tempout, Lid}, _From, TeamState = #team{leader = #team_member{id = Lid, pid = Lpid},
        member = [M1, M2 = #team_member{id = Mid2, pid = Mpid2, name = Mname2, mode = ?MODE_NORMAL}]}) ->
    NewMembers = [M1, M2#team_member{mode = ?MODE_TEMPOUT}],
    NewTeam = TeamState#team{member = NewMembers},
    team_cast(NewTeam, util:fbin(?L(<<"【~s】暂离了队伍">>), [Mname2])),
    friend:remove_buff([{Lpid, Lid}, {Mpid2, Mid2}]), %% 亲密度
    sworn_api:remove_buff([{Lpid, Lid}, {Mpid2, Mid2}]),
    role:c_apply(async, Mpid2, {fun change_team_info/3, [NewTeam, ?DO_TEMPOUT]}),
    {reply, {ok, NewTeam}, NewTeam};
handle_call({combat_tempout, Lid}, _From, TeamState = #team{leader = #team_member{id = Lid}}) ->
    {reply, ok, TeamState};
%% 队员死亡/逃跑
handle_call({combat_tempout, Rid}, _From, TeamState = #team{leader = #team_member{id = Lid, pid = Lpid}, member = Members}) ->
    case lists:keyfind(Rid, #team_member.id, Members) of
        false -> {reply, false, TeamState}; %% 不存在
        M = #team_member{id = Mid, pid = Mpid, name = Mname, mode = ?MODE_NORMAL} ->
            NewMembers = lists:keyreplace(Rid, #team_member.id, Members, M#team_member{mode = ?MODE_TEMPOUT}),
            NewTeam = TeamState#team{member = NewMembers},
            team_cast(NewTeam, util:fbin(?L(<<"【~s】暂离了队伍">>), [Mname])),
            friend:refresh_buff([{Lpid, Lid} | [{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- NewMembers]]), %% 亲密度
            sworn_api:refresh_buff([{Lpid, Lid} | [{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- NewMembers]]),
            friend:remove_buff([{Mpid, Mid}]),
            sworn_api:remove_buff([{Mpid, Mid}]),
            {reply, {ok, NewTeam}, NewTeam};
        _ -> {reply, ok, TeamState}
    end;

%% 归队
handle_call({back_team, Mid, Mpos}, _From, TeamState = #team{leader = #team_member{id = Lid, pid = Lpid}, member = Members}) ->
    case lists:keyfind(Mid, #team_member.id, Members) of
        false ->
            {reply, {false, ?L(<<"操作失败，无此队员">>)}, TeamState};
        M = #team_member{name = Name, mode = ?MODE_TEMPOUT} ->
            case role_api:c_lookup(by_pid, Lpid, #role.pos) of
                {ok, _N, Lpos} ->
                    case map:calc_distance(Mpos, Lpos) of
                        false ->
                            {reply, {false, Lpos, ?L(<<"不在同一场景中，需要传送归队">>)}, TeamState};
                        {ok, {DistGx, DistGy}} ->
                            case DistGx =< ?BACK_GRID andalso DistGy =< ?BACK_GRID of
                                false ->
                                    {reply, {false, Lpos, ?L(<<"距离队长太远，需要传送归队">>)}, TeamState};
                                true ->
                                    NewMembers = lists:keyreplace(Mid, #team_member.id, Members, M#team_member{mode = ?MODE_NORMAL}),
                                    NewTeam = TeamState#team{member = NewMembers},
                                    team_cast(NewTeam, util:fbin(?L(<<"【~s】回到了队伍">>), [Name])),
                                    friend:refresh_buff([{Lpid, Lid} | [{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- NewMembers]]), %% 亲密度
                                    sworn_api:refresh_buff([{Lpid, Lid} | [{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- NewMembers]]),
                                    {reply, {ok, NewTeam}, NewTeam}
                            end
                    end;
                _ -> {reply, {false, ?L(<<"操作失败">>)}, TeamState}
            end;
        _ -> {reply, {false, ?L(<<"你已经在队伍中">>)}, TeamState}
    end;
handle_call({back_team, _, _}, _From, TeamState) ->
    {reply, {false, <<>>}, TeamState};

%% 移出队员
handle_call({kick_out, Lid, Mid}, _From,
TeamState = #team{team_id = TeamId, leader = #team_member{id = Lid, pid = Lpid}, member = Members}) ->
    %% ?DEBUG("队长操作移出队员[MID:~w, Members:~w]", [Mid, Members]),
    case lists:keyfind(Mid, #team_member.id, Members) of
        false ->
            {reply, {false, <<>>}, TeamState};
        M = #team_member{id = Mid, name = Mname, mode = ?MODE_OFFLINE} ->
            delete_member_global(M), %% 删除队员的离线记录，否则此队员再上线会有bug
            NewMembers = lists:keydelete(Mid, #team_member.id, Members),
            NewTeam = TeamState#team{member = NewMembers},
            friend:refresh_buff([{Lpid, Lid} | [{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- NewMembers]]), %% 亲密度
            sworn_api:refresh_buff([{Lpid, Lid} | [{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- NewMembers]]),
            team_cast(NewTeam, util:fbin(?L(<<"【~s】离开了队伍">>), [Mname])),
            {reply, ok, NewTeam};
        M = #team_member{id = Mid, pid = Mpid, name = Mname} ->
            friend:remove_buff([{Mpid, Mid}]),
            sworn_api:remove_buff([{Mpid, Mid}]),
            NewMembers = lists:keydelete(Mid, #team_member.id, Members),
            NewTeam = TeamState#team{member = NewMembers},
            team_cast_member([M], 10820, {TeamId, ?L(<<"你被移出了队伍">>)}),
            team_cast(NewTeam, util:fbin(?L(<<"【~s】离开了队伍">>), [Mname])),
            friend:refresh_buff([{Lpid, Lid} | [{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- NewMembers]]), %% 亲密度
            sworn_api:refresh_buff([{Lpid, Lid} | [{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- NewMembers]]),
            role:c_apply(async, Mpid, {fun clean_team_info/1, []}), %% 更新被移除队员角色进程数据
            {reply, ok, NewTeam}
    end;
handle_call({kick_out, _, _}, _From, TeamState) ->
    {reply, {false, ?L(<<"操作失败，你不是队长">>)}, TeamState};

handle_call(_Request, _From, TeamState) ->
    {noreply, TeamState}.

handle_cast(_Msg, TeamState) ->
    {noreply, TeamState}.

%%  队伍创建成功，广播队伍列表
handle_info(create_success_cast, TeamState) ->
    team_cast(TeamState, ?L(<<"成功创建队伍">>)),
    {noreply, TeamState};

%% 申请入队
handle_info({apply_in, ApplyMsg, ApplyPid, {Aid, SrvId}, Name, ConnPid, Event}, TeamState = #team{applied = IsApply, dung_id = DungId,
        leader = #team_member{conn_pid = Lconnpid}, member = Members}) ->
    case lists:keyfind({Aid, SrvId}, #team_member.id, Members) of
        false ->
            case length(Members) < get_member_limit(Event) of
                true when IsApply =:= ?true orelse DungId =/= 0 -> %% 直接入队
                    role:c_apply(async, ApplyPid, {team_api, check_and_join_dungeon, [self()]});
                true ->
                    team_cross:pack_send(ConnPid, 10805, {?true, <<>>}),
                    team_cross:pack_send(Lconnpid, 10806, {Aid, SrvId, Name, ApplyMsg});
                false when Event =:= ?event_guild_arena -> %% 帮战只能两人组队
                    team_cross:pack_send(ConnPid, 10805, {?false, ?L(<<"帮战中，只能两人组队。">>)});
                false -> %% 满员
                    team_cross:pack_send(ConnPid, 10805, {?false, ?L(<<"操作失败，对方队伍已满">>)})
            end;
        _ ->
            team_cross:pack_send(ConnPid, 10805, {?false, ?L(<<"你已经在队伍中">>)})
    end,
    {noreply, TeamState};

%% 队伍切换地图
handle_info({enter, RoleId, NewPos}, TeamState = #team{leader = Leader = #team_member{id = RoleId}, member = Members}) ->
    member_enter(NewPos, [Leader | Members]),
    {noreply, TeamState};
handle_info({enter, RoleId, NewPos}, TeamState = #team{member = Members}) ->
    case lists:keyfind(RoleId, #team_member.id, Members) of
        #team_member{pid = MemPid, mode = ?MODE_TEMPOUT} ->
            role:c_apply(async, MemPid, {fun member_enter_callback/2, [NewPos]});
        _ -> %% 其他情况忽略
            ?DEBUG("队员过地图，忽略处理"),
            ignore
    end,
    {noreply, TeamState};

%% 属性和速度更新 -- 队长本身速度场景广播也以队伍速度为准
handle_info({update_attr, Rid, Lev, Career, Sex, Hp, Mp, HpMax, MpMax, Fight, Speed},
    TeamState = #team{leader = #team_member{id = Rid, lev = Lev, career = Career, sex = Sex, hp = Hp, mp = Mp, hp_max = HpMax, mp_max = MpMax, fight = Fight, speed = Speed}}) ->
    {noreply, TeamState};
handle_info({update_attr, Rid, Lev, Career, Sex, Hp, Mp, HpMax, MpMax, Fight, Speed},
    TeamState = #team{leader = Leader = #team_member{id = Rid, speed = Speed}}) -> %% 速度没变不用场景广播
    NewTeam = TeamState#team{leader = Leader#team_member{lev = Lev, career = Career, sex = Sex, hp = Hp, mp = Mp, hp_max = HpMax, mp_max = MpMax, fight = Fight}},
    team_cast(NewTeam, <<>>),
    {noreply, TeamState};
handle_info({update_attr, Rid, Lev, Career, Sex, Hp, Mp, HpMax, MpMax, Fight, Speed},
    TeamState = #team{leader = Leader = #team_member{id = Rid}, member = Members}) ->
    NewTeam = TeamState#team{leader = Leader#team_member{lev = Lev, career = Career, sex = Sex, hp = Hp, mp = Mp, fight = Fight, hp_max = HpMax, mp_max = MpMax, speed = Speed}},
    team_cast(NewTeam, <<>>),
    [role:c_apply(async, Pid, {fun do_update_member_speed/2, [Speed]}) || #team_member{pid = Pid, mode = ?MODE_NORMAL} <- Members],
    {noreply, NewTeam};
handle_info({update_attr, Rid, Lev, Career, Sex, Hp, Mp, HpMax, MpMax, Fight, Speed},
TeamState = #team{member = Members}) ->
    case lists:keyfind(Rid, #team_member.id, Members) of
        false ->
            {noreply, TeamState};
        #team_member{mode = ?MODE_OFFLINE} ->
            {noreply, TeamState};
        #team_member{lev = Lev, career = Career, sex = Sex, hp = Hp, mp = Mp, hp_max = HpMax, mp_max = MpMax, fight = Fight, speed = Speed}->
            {noreply, TeamState};
        M ->
            NewM = M#team_member{lev = Lev, career = Career, sex = Sex, hp = Hp, mp = Mp, hp_max = HpMax, mp_max = MpMax, fight = Fight, speed = Speed},
            NewTeam = TeamState#team{member = lists:keyreplace(Rid, #team_member.id, Members, NewM)},
            team_cast(NewTeam, <<>>),
            {noreply, NewTeam}
    end;

%% 设置队伍的飞行状态
handle_info({set_ride, Rid, Ride}, TeamState = #team{ride = Ride, leader = #team_member{id = Rid}}) ->
    {noreply, TeamState};
handle_info({set_ride, Rid, Ride}, TeamState = #team{leader = #team_member{id = Rid}}) ->
    NewTeam = TeamState#team{ride = Ride},
    {noreply, NewTeam};
handle_info({set_ride, _, _}, TeamState) ->
    {noreply, TeamState};

%% 更新队伍的骑乘状态
handle_info({update_ride, RoleId, Ride}, TeamState = #team{ride = Ride, leader = #team_member{id = RoleId}}) ->
    {noreply, TeamState};
handle_info({update_ride, RoleId, Ride}, TeamState = #team{leader = #team_member{id = RoleId}, member = Members}) ->
    NewTeam = TeamState#team{ride = Ride},
    [role:c_apply(async, Pid, {fun do_update_member_ride/2, [Ride]})
        || #team_member{pid = Pid, mode = ?MODE_NORMAL} <- Members],
    {noreply, NewTeam};
handle_info({update_ride, _, _}, TeamState) ->
    {noreply, TeamState};

%% 更新队员的阵法
handle_info({update_lineup, Rid, LineupId}, TeamState = #team{leader = Leader = #team_member{id = Rid}, member = Members}) ->
    NewTeam = TeamState#team{leader = Leader#team_member{lineup = LineupId}},
    [role:c_apply(async, Pid, {fun do_update_member_lineup/2, [LineupId]})
        || #team_member{pid = Pid, mode = ?MODE_NORMAL} <- Members], %% 通知队员
    {noreply, NewTeam};
handle_info({update_lineup, Rid, LineupId}, TeamState = #team{member = Members}) ->
    case lists:keyfind(Rid, #team_member.id, Members) of
        false -> {noreply, TeamState};
        M ->
            NewTeam = TeamState#team{member =
                lists:keyreplace(Rid, #team_member.id, Members, M#team_member{lineup = LineupId})},
            {noreply, NewTeam}
    end;

%% 聊天
handle_info({chat, Cmd, Data}, TeamState = #team{leader = Leader, member = MemberList}) ->
    team_cast_member([Leader | MemberList], Cmd, Data),
    {noreply, TeamState};

%% 委任队长
handle_info({appoint, Lid, Mid}, TeamState = #team{leader = Leader = #team_member{id = Lid, conn_pid = ConnPid}, member = Members}) ->
    case lists:keyfind(Mid, #team_member.id, Members) of
        false ->
            {noreply, TeamState};
        M = #team_member{pid = Mpid, name = MemberName, mode = ?MODE_NORMAL} ->
            NewMembers = lists:keyreplace(Mid, #team_member.id, Members, Leader),
            NewTeam = TeamState#team{leader = M, member = NewMembers},
            team_cast(NewTeam, util:fbin(?L(<<"【~s】成为队长">>), [MemberName])),
            %% -----------------------
            role:c_apply(async, Mpid, {fun change_team_info/3, [NewTeam, ?DO_CHANGE_LEADER]}),
            [role:c_apply(async, Pid, {fun change_team_info/3, [NewTeam, ?DO_CHANGE_LEADER]})
                || #team_member{pid = Pid, mode = ?MODE_NORMAL} <- NewMembers],
            %% -----------------------
            {noreply, NewTeam};
        M = #team_member{pid = Mpid, name = MemberName, mode = ?MODE_TEMPOUT} ->
            %% 委任暂离队员
            Members0 = lists:keyreplace(Mid, #team_member.id, Members, Leader),
            NewMembers = set_all_tempout(Members0),
            NewTeam0 = TeamState#team{leader = M#team_member{mode = ?MODE_NORMAL}, member = NewMembers},
            NewTeam = check_and_set_team_ride(M, NewTeam0), %% 队伍飞行状态重置
            team_cast(NewTeam, util:fbin(?L(<<"【~s】成为队长">>), [MemberName])),
            %% -----------------------
            role:c_apply(async, Mpid, {fun change_team_info/3, [NewTeam, ?DO_CHANGE_LEADER]}),
            [role:c_apply(async, Pid, {fun change_team_info/3, [NewTeam, ?DO_TEMPOUT]})
                || #team_member{pid = Pid, mode = ?MODE_NORMAL} <- Members0],
            %% -----------------------
            friend:remove_buff([{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- [Leader | Members]]), %% 清除亲密度BUFF
            sworn_api:remove_buff([{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- [Leader | Members]]),
            {noreply, NewTeam};
        _ -> %% 不允许委任离队队员
            team_cross:pack_send(ConnPid, 10815, {?false, ?L(<<"操作失败，不能委任离线队员">>)}),
            {noreply, TeamState}
    end;
handle_info({appoint, _, _}, TeamState) ->
    {noreply, TeamState};
%% 飞行中委任
handle_info({appoint_flying, Lid, Mid}, TeamState = #team{leader = Leader = #team_member{id = Lid, conn_pid = ConnPid}, member = Members}) ->
    case lists:keyfind(Mid, #team_member.id, Members) of
        false ->
            {noreply, TeamState};
        M = #team_member{pid = Mpid, name = MemberName, mode = ?MODE_NORMAL} ->
            case role:c_apply(sync, Mpid, {fun check_can_fly/1, []}) of
                true ->
                    NewMembers = lists:keyreplace(Mid, #team_member.id, Members, Leader),
                    NewTeam = TeamState#team{leader = M, member = NewMembers},
                    team_cast(NewTeam, util:fbin(?L(<<"【~s】成为队长">>), [MemberName])),
                    %% -----------------------
                    %% 通知其他队员进程和当前角色进程
                    role:c_apply(async, Mpid, {fun change_team_info/3, [NewTeam, ?DO_CHANGE_LEADER]}),
                    [role:c_apply(async, Pid, {fun change_team_info/3, [NewTeam, ?DO_CHANGE_LEADER]}) || #team_member{pid = Pid, mode = ?MODE_NORMAL} <- NewMembers],
                    %% -----------------------
                    {noreply, NewTeam};
                _ ->
                    team_cross:pack_send(ConnPid, 10815, {?false, ?L(<<"操作失败，该队员无法飞行，不能委任">>)}),
                    {noreply, TeamState}
            end;
        M = #team_member{pid = Mpid, name = MemberName, mode = ?MODE_TEMPOUT} ->
            Members0 = lists:keyreplace(Mid, #team_member.id, Members, Leader),
            NewMembers = set_all_tempout(Members0),
            NewTeam0 = TeamState#team{leader = M#team_member{mode = ?MODE_NORMAL}, member = NewMembers},
            NewTeam = check_and_set_team_ride(M, NewTeam0), %% 队伍飞行状态重置
            team_cast(NewTeam, util:fbin(?L(<<"【~s】成为队长">>), [MemberName])),
            %% -----------------------
            role:c_apply(async, Mpid, {fun change_team_info/3, [NewTeam, ?DO_CHANGE_LEADER]}),
            [role:c_apply(async, Pid, {fun change_team_info/3, [NewTeam, ?DO_TEMPOUT]}) || #team_member{pid = Pid, mode = ?MODE_NORMAL} <- Members0],
            %% -----------------------
            friend:remove_buff([{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- [Leader | Members]]), %% 清除亲密度BUFF
            sworn_api:remove_buff([{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- [Leader | Members]]),
            {noreply, NewTeam};
        _ -> %% 不允许委任离线队员
            team_cross:pack_send(ConnPid, 10815, {?false, ?L(<<"操作失败，不能委任离线队员">>)}),
            {noreply, TeamState}
    end;
handle_info({appoint_flying, _, _}, TeamState) ->
    {noreply, TeamState};
%% 打坐或双修状态中 -> 委任队长
handle_info({appoint_sitting, Lid, Mid}, TeamState = #team{leader = Leader = #team_member{id = Lid, pid = Lpid}, member = Members}) ->
    case lists:keyfind(Mid, #team_member.id, Members) of
        false ->
            {noreply, TeamState};
        M = #team_member{pid = Mpid, name = MemberName, mode = ?MODE_NORMAL} ->
            NewMember = Leader#team_member{mode = ?MODE_TEMPOUT}, %% 原队长在打坐状态，则置暂离
            NewMembers = lists:keyreplace(Mid, #team_member.id, Members, NewMember),
            NewTeam = TeamState#team{leader = M, member = NewMembers},
            team_cast(NewTeam, util:fbin(?L(<<"【~s】成为队长">>), [MemberName])),
            %% -----------------------
            role:c_apply(async, Lpid, {fun change_team_info/3, [NewTeam, ?DO_TEMPOUT]}),
            role:c_apply(async, Mpid, {fun change_team_info/3, [NewTeam, ?DO_CHANGE_LEADER]}),
            [role:c_apply(async, Pid, {fun change_team_info/3, [NewTeam, ?DO_CHANGE_LEADER]}) || #team_member{id = _Id, pid = Pid, mode = ?MODE_NORMAL} <- NewMembers],
            %% -----------------------
            friend:remove_buff([{Lpid, Lid}]), %% 清除亲密度BUFF
            sworn_api:remove_buff([{Lpid, Lid}]),
            friend:refresh_buff([{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- [M | NewMembers]]), %% 亲密度
            sworn_api:refresh_buff([{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- [M | NewMembers]]),
            {noreply, NewTeam};
        M = #team_member{pid = Mpid, name = MemberName, mode = ?MODE_TEMPOUT} ->
            Members0 = lists:keyreplace(Mid, #team_member.id, Members, Leader),
            NewMembers = set_all_tempout(Members0),
            NewTeam0 = TeamState#team{leader = M#team_member{mode = ?MODE_NORMAL}, member = NewMembers},
            NewTeam = check_and_set_team_ride(M, NewTeam0), %% 队伍飞行状态重置
            team_cast(NewTeam, util:fbin(?L(<<"【~s】成为队长">>), [MemberName])),
            %% -----------------------
            role:c_apply(async, Mpid, {fun change_team_info/3, [NewTeam, ?DO_CHANGE_LEADER]}),
            [role:c_apply(async, Pid, {fun change_team_info/3, [NewTeam, ?DO_TEMPOUT]}) || #team_member{pid = Pid, mode = ?MODE_NORMAL} <- Members0],
            %% -----------------------
            friend:remove_buff([{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- [Leader | Members]]), %% 清除亲密度BUFF
            sworn_api:remove_buff([{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- [Leader | Members]]),
            {noreply, NewTeam};
        _ ->
            {noreply, TeamState}
    end;
handle_info({appoint_sitting, _, _}, TeamState) ->
    {noreply, TeamState};

%% 暂离
handle_info({tempout, Rid}, TeamState = #team{leader = #team_member{id = Rid}}) ->
    %% 队长不需要暂离队伍 TODO: 可以直接解散
    {noreply, TeamState};
handle_info({tempout, Mid}, TeamState = #team{leader = #team_member{id = Lid, pid = Lpid}, member = Members}) ->
    case lists:keyfind(Mid, #team_member.id, Members) of
        false ->
            {noreply, TeamState};
        M = #team_member{id = Mid, pid = Mpid, name = Mname, mode = ?MODE_NORMAL} ->
            NewMembers = lists:keyreplace(Mid, #team_member.id, Members, M#team_member{mode = ?MODE_TEMPOUT}),
            NewTeam = TeamState#team{member = NewMembers},
            team_cast(NewTeam, util:fbin(?L(<<"【~s】暂离了队伍">>), [Mname])),
            role:c_apply(async, Mpid, {fun change_team_info/3, [NewTeam, ?DO_TEMPOUT]}),
            friend:remove_buff([{Mpid, Mid}]),
            sworn_api:remove_buff([{Mpid, Mid}]),
            friend:refresh_buff([{Lpid, Lid} | [{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- NewMembers]]),
            sworn_api:refresh_buff([{Lpid, Lid} | [{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- NewMembers]]),
            {noreply, NewTeam};
        _M ->
            ?DEBUG("处理队员[Member:~w]暂离请求时，忽略请求", [_M]),
            {noreply, TeamState}
    end;
handle_info({tempout, _}, TeamState) ->
    {noreply, TeamState};

%% 退出队伍
handle_info({quit, RoleId, _}, TeamState = #team{leader = #team_member{id = RoleId, pid = RolePid}, member = []}) ->
    role:c_apply(async, RolePid, {fun clean_team_info/1, []}),
    self() ! {stop, normal},
    {noreply, TeamState};
handle_info({quit, Lid, _}, TeamState = #team{ride = ?ride_fly, leader = #team_member{id = Lid, pid = Lpid, name = Lname}, member = Members}) ->
    role:c_apply(async, Lpid, {fun clean_team_info/1, []}),
    case get_next_leader(Members) of
        false ->
            self() ! {stop, normal},
            {noreply, TeamState};
        {true, NewLeader = #team_member{id = Mid, pid = Mpid}, ML} ->
            case role:c_apply(sync, Mpid, {fun check_can_fly/1, []}) of
                true ->
                    NewMembers = ML,
                    NewTeam = TeamState#team{leader = NewLeader, member = NewMembers},
                    team_cast(NewTeam, util:fbin(?L(<<"【~s】离开了队伍">>), [Lname])),
                    friend:refresh_buff([{Mpid, Mid} | [{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- ML]]),
                    sworn_api:refresh_buff([{Mpid, Mid} | [{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- ML]]),
                    friend:remove_buff([{Lpid, Lid}]),
                    sworn_api:remove_buff([{Lpid, Lid}]),
                    [role:c_apply(async, Pid, {fun change_team_info/3, [NewTeam, ?DO_CHANGE_LEADER]})
                        || #team_member{pid = Pid, mode = ?MODE_NORMAL} <- [NewLeader | NewMembers]],
                    {noreply, NewTeam};
                false -> %% 获取的新队长不可飞行,将所有队员置暂离
                    Fun = fun(M = #team_member{mode = ?MODE_NORMAL}) -> M#team_member{mode = ?MODE_TEMPOUT};
                        (M) -> M
                    end,
                    NewMembers = [Fun(M) || M <- ML],
                    NewTeam1 = TeamState#team{leader = NewLeader, member = NewMembers},
                    team_cast(NewTeam1, util:fbin(?L(<<"【~s】离开了队伍">>), [Lname])),
                    friend:remove_buff([{Lpid, Lid} | [{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- Members]]),
                    sworn_api:remove_buff([{Lpid, Lid} | [{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- Members]]),
                    %% 场景更新: 新队长
                    role:c_apply(async, Mpid, {fun change_team_info/3, [NewTeam1, ?DO_TEMPOUT]}), %% 这里其实是暂离操作,不然新队长不能正确更新飞行状态
                    NewTeam2 = NewTeam1#team{ride = ?ride_no},
                    %% 场景更新: 通知其他队员暂离
                    [role:c_apply(async, Pid, {fun change_team_info/3, [NewTeam2, ?DO_TEMPOUT]}) || #team_member{pid = Pid, mode = ?MODE_NORMAL} <- ML],
                    {noreply, NewTeam2};
                _ -> {stop, normal, TeamState}
            end
    end;
handle_info({quit, Lid, _}, TeamState = #team{leader = #team_member{id = Lid, pid = Lpid, name = Lname}, member = Members}) ->
    role:c_apply(async, Lpid, {fun clean_team_info/1, []}),
    case get_next_leader(Members) of
        false ->
            ?DEBUG("角色[~s]退出队伍，获取下个队长错误", [Lname]),
            self() ! {stop, normal},
            {noreply, TeamState};
        {true, NewLeader = #team_member{id = Mid, pid = Mpid}, NewMembers} ->
            NewTeam = TeamState#team{leader = NewLeader, member = NewMembers},
            team_cast(NewTeam, util:fbin(?L(<<"【~s】离开了队伍">>), [Lname])),
            friend:refresh_buff([{Mpid, Mid} | [{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- NewMembers]]),
            sworn_api:refresh_buff([{Mpid, Mid} | [{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- NewMembers]]),
            friend:remove_buff([{Lpid, Lid}]),
            sworn_api:remove_buff([{Lpid, Lid}]),
            [role:c_apply(async, Pid, {fun change_team_info/3, [NewTeam, ?DO_CHANGE_LEADER]}) || #team_member{pid = Pid, mode = ?MODE_NORMAL} <- [NewLeader | NewMembers]],
            {noreply, NewTeam}
    end;
handle_info({quit, Mid, Mpid}, TeamState = #team{leader = #team_member{id = Lid, pid = Lpid}, member = Members}) ->
    role:c_apply(async, Mpid, {fun clean_team_info/1, []}),
    case lists:keyfind(Mid, #team_member.id, Members) of
        false ->
            {noreply, TeamState};
        #team_member{pid = Mpid, name = Name} ->
            friend:remove_buff([{Mpid, Mid}]), %% 清除亲密度
            sworn_api:remove_buff([{Mpid, Mid}]),
            NewMembers = lists:keydelete(Mid, #team_member.id, Members),
            NewTeam = TeamState#team{member = NewMembers},
            team_cast(NewTeam, util:fbin(?L(<<"【~s】离开了队伍">>), [Name])),
            friend:refresh_buff([{Lpid, Lid} | [{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- NewMembers]]),
            sworn_api:refresh_buff([{Lpid, Lid} | [{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- NewMembers]]),
            {noreply, NewTeam}
    end;

%% 召回队员 -- 已忽略
handle_info({recall, Lid}, TeamState = #team{team_id = Tid, leader = #team_member{id = Lid}, member = MemberList}) ->
    %% 转发召唤通知--给所有暂离队员
    List = [M || M = #team_member{mode = Mode} <- MemberList, Mode =:= ?MODE_TEMPOUT],
    team_cast_member(List, 10818, {Tid, ?L(<<"队长召唤你们归队">>)}),
    {noreply, TeamState};
handle_info({recall, _}, TeamState) ->
    {noreply, TeamState};

%% 设置队伍的申请规则
handle_info({set_apply_rule, Rid, IsDirect}, TeamState = #team{leader = #team_member{id = Rid}}) ->
    {noreply, TeamState#team{applied = IsDirect}};
handle_info({set_apply_rule, _, _}, TeamState) ->
    {noreply, TeamState};

%% 设置队伍的招募大厅副本ID
handle_info({update_dungeon_hall, DungId, ?true}, TeamState = #team{dung_id = 0}) ->
    ?DEBUG("设置队伍报名副本大厅"),
    {noreply, TeamState#team{dung_id = DungId, applied = ?true}};
handle_info({update_dungeon_hall, DungId, ?true}, TeamState) ->
    ?DEBUG("更新队伍报名副本大厅"),
    {noreply, TeamState#team{dung_id = DungId, applied = ?true}};
handle_info({update_dungeon_hall, _DungId, ?false}, TeamState) ->
    ?DEBUG("取消队伍报名副本大厅"),
    {noreply, TeamState#team{dung_id = 0}};

%% 队长下线
handle_info({member_offline, Lid}, TeamState = #team{leader = #team_member{id = Lid, name = _Lname}, member = []}) ->
    ?DEBUG("队长[~s]下线, 解散队伍", [_Lname]),
    {stop, normal, TeamState};
handle_info({member_offline, Lid}, TeamState = #team{ride = ?ride_fly, leader = Leader = #team_member{id = Lid, name = Lname}, member = Members}) ->
    NewMember = Leader#team_member{mode = ?MODE_OFFLINE},
    case get_next_leader(Members) of %% 队伍在飞行，则队员直接全部暂离
        {true, NewLeader = #team_member{id = Mid, pid = Mpid}, ML} ->
            add_member_global(Leader, self()),
            case role:c_apply(sync, Mpid, {fun check_can_fly/1, []}) of
                true ->
                    NewTeam = TeamState#team{leader = NewLeader, member = [NewMember | ML]},
                    team_cast(NewTeam, util:fbin(?L(<<"【~s】离线了">>), [Lname])),
                    friend:refresh_buff([{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- [NewLeader | ML]]),
                    sworn_api:refresh_buff([{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- [NewLeader | ML]]),
                    role:c_apply(async, Mpid, {fun change_team_info/3, [NewTeam, ?DO_CHANGE_LEADER]}),
                    {noreply, NewTeam};
                false -> %% 将所有队员暂离
                    Fun = fun(M = #team_member{mode = ?MODE_NORMAL}) -> M#team_member{mode = ?MODE_TEMPOUT};
                        (M) -> M
                    end,
                    NewMembers = [Fun(M) || M <- [NewMember | ML]],
                    NewTeam1 = TeamState#team{leader = NewLeader, member = NewMembers},
                    team_cast(NewTeam1, util:fbin(?L(<<"【~s】离线了">>), [Lname])),
                    friend:remove_buff([{Mpid, Mid} | [{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- Members]]),
                    sworn_api:remove_buff([{Mpid, Mid} | [{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- Members]]),
                    role:c_apply(async, Mpid, {fun change_team_info/3, [NewTeam1, ?DO_TEMPOUT]}), %% 这里其实是暂离操作
                    NewTeam2 = NewTeam1#team{ride = ?ride_no},
                    %% 只通知原来在队伍中的队员暂离
                    [role:c_apply(async, Pid, {fun change_team_info/3, [NewTeam2, ?DO_TEMPOUT]}) || #team_member{pid = Pid, mode = ?MODE_NORMAL} <- ML],
                    {noreply, NewTeam2};
                _ -> %% 访问新队长进程异常(可能跨服)，判断下个队员是否在线， 若在线则暂离所有人，否则解散
                    case ML of
                        [NewLeader2 = #team_member{pid = Pid2}] when is_pid(Pid2) -> %% 假设不能飞行，均做暂离处理
                            Fun = fun(M = #team_member{mode = ?MODE_NORMAL}) -> M#team_member{mode = ?MODE_TEMPOUT};
                                (M) -> M
                            end,
                            NewMembers = [Fun(M) || M <- [NewMember, NewLeader]],
                            NewTeam1 = TeamState#team{leader = NewLeader2, member = NewMembers},
                            team_cast(NewTeam1, util:fbin(?L(<<"【~s】离线了">>), [Lname])),
                            friend:remove_buff([{Mpid, Mid} | [{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- Members]]),
                            sworn_api:remove_buff([{Mpid, Mid} | [{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- Members]]),
                            role:c_apply(async, Pid2, {fun change_team_info/3, [NewTeam1, ?DO_TEMPOUT]}), %% 这里其实是暂离操作
                            NewTeam2 = NewTeam1#team{ride = ?ride_no},
                            {noreply, NewTeam2};
                        _ -> {stop, normal, TeamState}
                    end
            end;
        _ ->
            {stop, normal, TeamState}
    end;
handle_info({member_offline, Lid}, TeamState = #team{leader = Leader = #team_member{id = Lid, name = Lname}, member = Members}) ->
    NewMember = Leader#team_member{mode = ?MODE_OFFLINE},
    case get_next_leader(Members) of
        false ->
            {stop, normal, TeamState};
        {true, NewLeader = #team_member{id = Mid, pid = Mpid}, ML} ->
            add_member_global(Leader, self()),
            NewMembers = [NewMember | ML],
            NewTeam = TeamState#team{leader = NewLeader, member = NewMembers},
            team_cast(NewTeam, util:fbin(?L(<<"【~s】离线了">>), [Lname])),
            friend:refresh_buff([{Mpid, Mid} | [{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- NewMembers]]),
            sworn_api:refresh_buff([{Mpid, Mid} | [{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- NewMembers]]),
            role:c_apply(async, Mpid, {fun change_team_info/3, [NewTeam, ?DO_CHANGE_LEADER]}),
            {noreply, NewTeam}
    end;
handle_info({member_offline, Mid}, TeamState = #team{leader = #team_member{id = Lid, pid = Lpid}, member = Members}) ->
    case lists:keyfind(Mid, #team_member.id, Members) of
        false ->
            {noreply, TeamState};
        M = #team_member{name = Name} ->
            add_member_global(M, self()),
            NewMembers = lists:keyreplace(Mid, #team_member.id, Members, M#team_member{conn_pid = 0, mode = ?MODE_OFFLINE}),
            NewTeam = TeamState#team{member = NewMembers},
            team_cast(NewTeam, util:fbin(?L(<<"【~s】离线了">>), [Name])),
            friend:refresh_buff([{Lpid, Lid} | [{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- NewMembers]]), %% 亲密度
            sworn_api:refresh_buff([{Lpid, Lid} | [{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- NewMembers]]),
            {noreply, NewTeam}
    end;

%% 队员上线
handle_info({member_online, {Mpid, Mid, ConnPid}}, TeamState = #team{member = Members}) ->
    case lists:keyfind(Mid, #team_member.id, Members) of
        M = #team_member{name = Mname, mode = ?MODE_OFFLINE} ->
            NewMembers = lists:keyreplace(Mid, #team_member.id, Members,
                M#team_member{pid = Mpid, conn_pid = ConnPid, mode = ?MODE_TEMPOUT}),
            NewTeam = TeamState#team{member = NewMembers},
            team_cast(NewTeam, util:fbin(?L(<<"【~s】上线了">>), [Mname])),
            role:c_apply(async, Mpid, {fun change_team_info/3, [NewTeam, ?DO_TEMPOUT]}),
            {noreply, NewTeam};
        #team_member{name = Mname} ->
            ?DEBUG("队员[NAME:~s]上线，信息异常", [Mname]),
            NewMembers = lists:keydelete(Mid, #team_member.id, Members),
            NewTeam = TeamState#team{member = NewMembers},
            team_cast(NewTeam, util:fbin(?L(<<"【~s】离开了队伍">>), [Mname])),
            role:c_apply(async, Mpid, {fun clean_team_info/1, []}),
            {noreply, NewTeam};
        _ ->
            {noreply, TeamState}
    end;

%% 队员顶号: 角色连接进程PID改变
handle_info({member_switch, Lid, NewConnPid}, TeamState = #team{leader = Leader = #team_member{id = Lid}}) ->
    {noreply, TeamState#team{leader = Leader#team_member{conn_pid = NewConnPid}}};
handle_info({member_switch, Mid, NewConnPid}, TeamState = #team{member = MemberList}) -> 
    case lists:keyfind(Mid, #team_member.id, MemberList) of
        M = #team_member{} ->
            NewML = lists:keyreplace(Mid, #team_member.id, MemberList, M#team_member{conn_pid = NewConnPid}),
            NewTeam = TeamState#team{member = NewML},
            {noreply, NewTeam};
        _ ->
            {noreply, TeamState}
    end;

%% 获取并推送队员的外观属性
handle_info({pull_looks, ConnPid, OtherId = {Id, SrvId}}, TeamState) ->
    case catch role_api:c_lookup(by_id, OtherId, #role.looks) of
        {ok, _N, Looks} ->
            team_cross:pack_send(ConnPid, 10803, {Id, SrvId, Looks});
        _ ->
            ignore
    end,
    {noreply, TeamState};

%% 队伍自检测 判断是否有异常
handle_info(self_check, TeamState = #team{leader = #team_member{pid = Pid}}) ->
    role:c_apply(async, Pid, {fun check_pos/2, [TeamState]}),
    erlang:send_after(?SELF_CHECK_TIME, self(), self_check),
    {noreply, TeamState};

%% 队伍手动销毁
handle_info({stop, Msg}, TeamState = #team{leader = Leader = #team_member{pid = Lpid}, member = Members}) ->
    friend:remove_buff([{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- [Leader | Members], is_pid(Pid)]),
    sworn_api:remove_buff([{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- [Leader | Members], is_pid(Pid)]),
    role:c_apply(async, Lpid, {fun clean_team_info/1, []}),
    put(stop_msg, Msg),
    {stop, normal, TeamState};

handle_info(_Info, TeamState) ->
    ?DEBUG("队伍进程收到无效的Info消息：~w", [_Info]),
    {noreply, TeamState}.

%% 队伍进程结束：广播队伍解散消息/队伍信息清除
terminate(normal, TeamState = #team{leader = Leader, member = Members}) ->
    Msg = case get(stop_msg) of
        undefined -> ?L(<<"您的队伍解散了">>);
        sworn -> <<>>;
        _ -> <<>>
    end,
    [delete_member_global(M) || M <- Members],
    team_cast_member([Leader | Members], 10841, {?true, Msg}), %% TODO: 广播消息
    [role:c_apply(async, Pid, {fun clean_team_info/1, []}) || #team_member{pid = Pid} <- Members, is_pid(Pid)],
    team_listener:break_up(TeamState),
    ?DEBUG("队伍销毁，完成处理"),
    ok;
terminate(_Reason, TeamState = #team{leader = Leader, member = Members}) ->
    [delete_member_global(M) || M <- [Leader | Members]],
    team_cast_member([Leader | Members], 10841, {?true, ?L(<<"您的队伍解散了">>)}),
    [role:c_apply(async, Pid, {fun clean_team_info/1, []}) || #team_member{pid = Pid} <- [Leader | Members], is_pid(Pid)], %% 异常退出，确保所有成员都清除队伍数据
    friend:remove_buff([{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- [Leader | Members], is_pid(Pid)]),
    sworn_api:remove_buff([{Pid, Id} || #team_member{id = Id, pid = Pid, mode = ?MODE_NORMAL} <- [Leader | Members], is_pid(Pid)]),
    team_listener:break_up(TeamState),
    ?DEBUG("队伍进程异常关闭[REASON:~w, TEAM:~w]", [_Reason, TeamState]),
    ok.

code_change(_OldVsn, TeamState, _Extra) ->
    {ok, TeamState}.

%% ------------------------------------------------------------------
%% 内部函数
%% ------------------------------------------------------------------

%% 广播队伍列表更新信息(需要确保角色进程和链接进程PID信息能及时更新到#team_member{}结构中)</div>
team_cast(#team{team_id =Tid, leader = Leader = #team_member{id = {Lid, Lsrvid}}, member = Members}, Info) ->
    TmpList = [Leader | lists:reverse(Members)],
    %% 按照队长1，队员2、3顺序发送队伍列表
    Msg = {Info, Tid, Lid, Lsrvid,
            [
                [Id, SrvId, Name, Lev, Career, Sex, VipType, FaceId, Mode, HpMax, MpMax, Hp, Mp, Fight, PetFight] ||
                #team_member{id = {Id, SrvId}, name = Name, lev = Lev, career = Career, sex = Sex, hp = Hp, mp = Mp, fight = Fight, pet_fight = PetFight,
                    hp_max = HpMax, mp_max = MpMax, vip_type = VipType, face_id = FaceId, mode = Mode} <- TmpList
            ]
        },
    team_cast_member(TmpList, 10800, Msg).

%% 给所有在线队员发送信息
team_cast_member([], _Cmd, _Msg) -> ok;
team_cast_member([#team_member{mode = ?MODE_OFFLINE} | T], Cmd, Msg) ->
    team_cast_member(T, Cmd, Msg);
team_cast_member([#team_member{conn_pid = ConnPid} | T], Cmd, Msg)
when is_pid(ConnPid) ->
    team_cross:pack_send(ConnPid, Cmd, Msg),
    team_cast_member(T, Cmd, Msg);
team_cast_member([_ | T], Cmd, Msg) ->
    team_cast_member(T, Cmd, Msg).

%% 队长变队员/队员变队长 需要场景广播
do_change_team_info(Role, ?DO_CHANGE_LEADER) ->
    Role1 = team_api:team_listener(appoint, Role),
    map:role_update(Role1),
    {ok, Role1};
do_change_team_info(Role, ?DO_BACK) ->
    map:role_update(Role),
    {ok, Role};
do_change_team_info(Role, ?DO_TEMPOUT) ->
    Role1 = team_api:team_listener(tempout, Role),
    case member_leave(Role1) of
        {ok, NewRole} ->
            map:role_update(NewRole),
            {ok, NewRole};
        {ok, {MapId, Dx, Dy}, NewRole} ->
            case map:role_enter(MapId, Dx, Dy, NewRole) of
                {false, _Reason} ->
                    ?ELOG("队员[NAME:~s]退出队伍回复活点失败:~s", [Role#role.name, _Reason]),
                    map:role_update(NewRole),
                    {ok, NewRole};
                {ok, NewRole1} ->
                    {ok, NewRole1}
            end;
        _ -> {ok}
    end;
do_change_team_info(Role = #role{ride = ?ride_fly}, ?DO_TEMPOUT_COMBAT) ->
    Role1 = team_api:team_listener(tempout, Role),
    case member_leave(Role1) of
        {ok, NewRole} ->
            {ok, NewRole};
        {ok, {MapId, Dx, Dy}, NewRole} ->
            case map:role_enter(MapId, Dx, Dy, NewRole) of
                {false, _Reason} ->
                    ?ERR("队员[NAME:~s]退出队伍回复活点失败:~s", [Role#role.name, _Reason]),
                    map:role_update(NewRole),
                    {ok, NewRole};
                {ok, NewRole1} ->
                    {ok, NewRole1}
            end;
        _ -> {ok}
    end;
do_change_team_info(Role, ?DO_TEMPOUT_COMBAT) ->
    Role1 = team_api:team_listener(tempout, Role),
    {ok, Role1};
do_change_team_info(Role, ?DO_NOTHING) ->
    map:role_update(Role),
    {ok, Role};
do_change_team_info(Role, _) ->
    {ok, Role}.

%% 队员暂离/离队时，根据 飞行、活动事件等条件 决定场景更新
member_leave(Role = #role{event = ?event_cross_ore, ride = ?ride_fly}) ->
    {ok, Role}; %% 跨服仙府争夺战场景，默认保持飞行
member_leave(Role = #role{ride = ?ride_fly}) ->
    case fly_api:check_can_fly(Role) of
        true -> %% 可以飞行
            {ok, Role};
        false ->
            do_member_down(Role#role{ride = ?ride_no})
    end;
member_leave(Role) ->
    {ok, Role}.

%% 处理队员需要落地时的情况
do_member_down(Role = #role{pos = #pos{map = MapId, map_base_id = MapBaseId, x = X, y = Y}}) ->
    case map_mgr:is_blocked(MapBaseId, X, Y) of
        true -> %% 不可行走区域
            case map:get_revive(MapBaseId) of
                {ok, {Dx, Dy}} ->
                    {ok, {MapId, Dx, Dy}, Role};
                _ ->
                    ?DEBUG("队员落在了不可行走区域，自救吧"),
                    {ok, Role}
            end;
        false -> {ok, Role}
    end.

%% 回调函数: 检查队员角色是否可以飞行
check_can_fly(Role) ->
    {ok, fly_api:check_can_fly(Role)}.

%% 委任暂离队员时，根据新队长的飞行状态 更新队伍的飞行状态
check_and_set_team_ride(#team_member{pid = Mpid}, Team) ->
    case role_api:c_lookup(by_pid, Mpid, #role.ride) of
        {ok, _, ?ride_fly} ->
            Team#team{ride = ?ride_fly};
        _ -> %% 不能飞行或者其他情况，一律处理成地面状态
            Team#team{ride = ?ride_no}
    end.

%% 队伍自检测，检查: 队伍成员位置，TeamPid
check_pos(#role{team_pid = TeamPid, pos = Pos}, #team{team_pid = TeamPid, member = Members})
when is_list(Members) ->
    [role:c_apply(async, Pid, {fun do_check_pos/2, [Pos]}) || #team_member{pid = Pid, mode = ?MODE_NORMAL} <- Members],
    {ok};
check_pos(Role, #team{team_pid = TeamPid, member = Members})
when is_list(Members) ->
    ?ERR("检测到队长的队伍进程PID异常:~w, ~w", [Role#role.team_pid, TeamPid]),
    {ok, Role#role{team_pid = TeamPid}};
check_pos(_, _) ->
    {ok}.
do_check_pos(Role = #role{pos = Pos}, LeaderPos) ->
    case map:calc_distance(Pos, LeaderPos) of
        false ->
            Role1 = team_api:team_listener(tempout, Role),
            tempout(Role1, normal),
            %% role:apply(async, Pid, {fun tempout/2, [normal]});
            {ok, Role1};
        {ok, {DistX, DistY}} ->
            case DistX =< ?BACK_GRID andalso DistY =< ?BACK_GRID of
                true -> {ok};
                false -> %% 队伍自检测，队员与队长位置太远自动暂离
                    Role1 = team_api:team_listener(tempout, Role),
                    tempout(Role1, normal),
                    {ok, Role1}
            end
    end.

%% 暂离所有队员；已经离队的保持离队
set_all_tempout(Members) ->
    Fun = fun(M = #team_member{mode = ?MODE_NORMAL}) ->
            M#team_member{mode = ?MODE_TEMPOUT};
        (M) ->
            M
    end,
    [Fun(M) || M <- Members].

%% 队伍切换地图
member_enter(_, []) -> ok;
member_enter(DestPos, [#team_member{pid = Rpid, mode = ?MODE_NORMAL} | T]) ->
    role:c_apply(async, Rpid, {fun member_enter_callback/2, [DestPos]}),
    member_enter(DestPos, T);
member_enter(DestPos, [_ | T]) ->
    member_enter(DestPos, T).
%% 回调函数：队员切换地图
member_enter_callback(Role, {MapId, X, Y}) ->
    case map:role_enter(MapId, X, Y, Role) of
        {false, _Reason} ->
            tempout(Role, normal),
            {ok};
        {ok, NewRole} ->
            ?DEBUG("队员成功过场景后的地图[MAP:~w, X:~w]", [NewRole#role.pos#pos.map, NewRole#role.pos#pos.x]),
            {ok, NewRole}
    end.

%% 异步回调：更新队员骑乘飞行状态
do_update_member_ride(#role{ride = Ride}, Ride) -> {ok};
do_update_member_ride(#role{team = #role_team{follow = ?false}}, _) -> {ok};
do_update_member_ride(Role = #role{team_pid = TeamPid, ride = ?ride_fly, pos = #pos{map_base_id = MapBaseId, x = X, y = Y}}, ?ride_no)
when is_pid(TeamPid) ->
    Role0 = Role#role{ride = ?ride_no},
    case map_mgr:is_blocked(MapBaseId, X, Y) of
        true ->
            {ok, _, #team_member{pid = Lpid}} = get_leader(TeamPid),
            case role_api:c_lookup(by_pid, Lpid, #role.pos) of
                {ok, _N, #pos{map = MapId, x = Dx, y = Dy}} ->
                    case map:role_enter(MapId, Dx, Dy, Role0) of
                        {false, _Reason} ->
                            ?ERR("队员[NAME:~s]取消飞行传送回队长目标位置失败:~s", [Role#role.name, _Reason]),
                            {ok, Role};
                        {ok, NewRole} ->
                            {ok, NewRole}
                    end;
                _ ->
                    ?DEBUG("队员遇到不可以移动区域, 获取队长的位置失败"),
                    map:role_update(Role0),
                    {ok, Role0}
            end;
        false ->
            map:role_update(Role0),
            {ok, Role0}
    end;
do_update_member_ride(Role, Ride) ->
    NewRole = Role#role{ride = Ride},
    map:role_update(NewRole),
    {ok, NewRole}.

%% 更新并广播队员的事件状态和移动速度
%% do_update_member_event(#role{team = #role_team{follow = ?false}}, _Event, _Speed) -> {ok};
%% do_update_member_event(#role{team = #role_team{event = Event}}, Event, _Speed) -> {ok};
%% do_update_member_event(Role = #role{team = RoleTeam}, Event, Speed) ->
%%     NewRole = Role#role{team = RoleTeam#role_team{event = Event, speed = Speed}},
%%     map:role_update(NewRole),
%%     ?DEBUG("队伍有队员更新事件状态，队员[NAME:~s]速度更新为：~w", [NewRole#role.name, Speed]),
%%     {ok, NewRole}.

%% 更新并广播队员的移动速度
do_update_member_speed(#role{team = #role_team{speed = Speed}}, Speed) -> {ok};
do_update_member_speed(#role{team = #role_team{follow = ?false}}, _Speed) -> {ok};
do_update_member_speed(Role = #role{team = RoleTeam}, Speed) ->
    NewRole = Role#role{team = RoleTeam#role_team{speed = Speed}},
    map:role_update(NewRole),
    ?DEBUG("队伍有队员属性更新，队员[NAME:~s]速度更新为：~w", [NewRole#role.name, Speed]),
    {ok, NewRole}.

%% 更新并队员的阵法
do_update_member_lineup(#role{team = #role_team{lineup = Lineup}}, Lineup) -> {ok};
do_update_member_lineup(#role{team = #role_team{follow = ?false}}, _) -> {ok};
do_update_member_lineup(Role = #role{team = RoleTeam}, Lineup) ->
    NewRole = Role#role{team = RoleTeam#role_team{lineup = Lineup}},
    {ok, NewRole}.

%% 判断并获取下个队长，设置MODE位
%% 用于队长退队或离线时,移交队标
%% 返回：false | {true, NewLeader, []} 
get_next_leader([]) ->
    false;
get_next_leader([#team_member{mode = ?MODE_OFFLINE}]) ->
    false;
get_next_leader([M = #team_member{mode = ?MODE_TEMPOUT}]) ->
    {true, M#team_member{mode = ?MODE_NORMAL}, []};
get_next_leader([M]) ->
    {true, M, []};
get_next_leader([M1, M2 = #team_member{mode = ?MODE_NORMAL}]) ->
    {true, M2, [M1]};
get_next_leader([M1 = #team_member{mode = ?MODE_NORMAL}, M2 = #team_member{mode = ?MODE_TEMPOUT}]) ->
    {true, M1, [M2]};
get_next_leader([M1, M2 = #team_member{mode = ?MODE_TEMPOUT}]) ->
    {true, M2#team_member{mode = ?MODE_NORMAL}, [M1]};
get_next_leader([#team_member{mode = ?MODE_OFFLINE}, #team_member{mode = ?MODE_OFFLINE}]) ->
    false;
get_next_leader([M1, M2 = #team_member{mode = ?MODE_OFFLINE}]) ->
    {true, M1#team_member{mode = ?MODE_NORMAL}, [M2]};
get_next_leader(_) ->
    false.

%% 获取组队人数限制
get_member_limit(?event_guild_arena) ->
    ?MEMBER_COUNT_MAX - 1; %% 新帮战最多只能2人组队
get_member_limit(_) ->
    ?MEMBER_COUNT_MAX.

%% 角色进程回调函数：角色加入队伍操作时,设置相关状态和数据
add_team_info(Role = #role{id = Rid, special = Special}, #team{team_pid = TeamPid, team_id = TeamId, ride = Ride,
        leader = #team_member{id = Rid = {Id, SrvId}, speed = Speed, lineup = Lineup, mode = Mode}}) -> %% 队长
    NewSpecial = [{?special_team_leader, Id, SrvId} | Special],
    NewRole = Role#role{team_pid = TeamPid, team = ?TO_ROLE_LEADER, ride = Ride, special = NewSpecial},
    map:role_update(NewRole),
    cross_pk:role_update(NewRole),
    {ok, NewRole};
add_team_info(Role = #role{id = Rid}, #team{team_id = TeamId, team_pid = TeamPid, ride = Ride,
        leader = #team_member{speed = Speed, lineup = Lineup}, member = Members}) ->
    NewRole = case lists:keyfind(Rid, #team_member.id, Members) of
        false -> Role;
        #team_member{mode = Mode} when Mode =:= ?MODE_NORMAL ->
            Role#role{team_pid = TeamPid, ride = Ride, team = ?TO_ROLE_MEMBER};
        #team_member{mode = Mode} ->
            Role#role{team_pid = TeamPid, team = ?TO_ROLE_MEMBER}
    end,
    map:role_update(NewRole),
    cross_pk:role_update(NewRole),
    ?DEBUG("角色[NAME:~s]加入队伍[RIDE:~w, TEAMSPEED:~w]", [NewRole#role.name, NewRole#role.ride, NewRole#role.team#role_team.speed]),
    {ok, NewRole}.

%% 角色进程回调函数：设置队伍相关信息
%% 注意：队伍的飞行直接影响角色的飞行状态; 移动速度和阵法设置，角色进程会保留一份缓冲
change_team_info(Role = #role{id = Lid, special = Special}, #team{team_id = TeamId, team_pid = TeamPid, ride = TeamRide,
        leader = #team_member{id = Lid = {Id, SrvId}, speed = Speed, lineup = Lineup, mode = Mode}}, Doing) -> %% 队长
    NewSpecial = case lists:keyfind(?special_team_leader, 1, Special) of
        false -> [{?special_team_leader, Id, SrvId} | Special];
        {?special_team_leader, Id, SrvId} -> Special;
        _ -> lists:keyreplace(?special_team_leader, 1, Special, {?special_team_leader, Id, SrvId})
    end,
    NewRole = Role#role{
        ride = TeamRide, %% 更新队伍的飞行状态；这里可以避免委任时产生问题
        team_pid = TeamPid,
        team = ?TO_ROLE_LEADER,
        special = NewSpecial
    },
    ?DEBUG("队长[NAME:~s]更新队伍信息【速度：~w，队伍速度：~w，操作：~w】", [Role#role.name, NewRole#role.speed, NewRole#role.team#role_team.speed, Doing]),
    do_change_team_info(NewRole, Doing);
change_team_info(Role = #role{id = Rid, special = Special}, #team{team_id = TeamId, team_pid = TeamPid, ride = TeamRide,
        leader = #team_member{speed = Speed, lineup = Lineup}, member = Members}, Doing) ->
    NewSpecial = lists:keydelete(?special_team_leader, 1, Special),
    case lists:keyfind(Rid, #team_member.id, Members) of
        #team_member{mode = Mode} when Mode =:= ?MODE_NORMAL ->
            NewRole = Role#role{
                ride = TeamRide,
                team_pid = TeamPid,
                team = ?TO_ROLE_MEMBER,
                special = NewSpecial
            },
            ?DEBUG("角色[NAME:~s]更新队伍信息【速度：~w，队伍速度：~w，操作：~w】", [Role#role.name, NewRole#role.speed, NewRole#role.team#role_team.speed, Doing]),
            do_change_team_info(NewRole, Doing);
        #team_member{mode = Mode} when Mode =:= ?MODE_TEMPOUT ->
            NewRole = Role#role{
                team_pid = TeamPid,
                team = ?TO_ROLE_MEMBER,
                special = NewSpecial
            },
            ?DEBUG("角色[NAME:~s]更新队伍信息【速度：~w，队伍速度：~w，操作：~w】", [Role#role.name, NewRole#role.speed, NewRole#role.team#role_team.speed, Doing]),
            do_change_team_info(NewRole, Doing);
        _E ->
            ?DEBUG("列表未找到队员异常：~w", [_E]),
            {ok, Role}
    end;
change_team_info(Role, _Team, _Doing) ->
    ?ELOG("更新角色的队伍信息异常[ROLE:~w~nTEAM:~w~nDOING:~w~n]", [Role, _Team, _Doing]),
    {ok, Role}.

%% 角色进程调用函数：退出队伍时，清除队伍相关数据；如果在副本中，则需要退出副本
%% <div> ; 副本中退出队伍 </div>
clean_team_info(Role = #role{special = Special}) ->
    Role1 = Role#role{team_pid = 0, team = 0, special = lists:keydelete(?special_team_leader, 1, Special)},
    NewRole = team_api:team_listener(quit, Role1),
    cross_pk:role_update(NewRole),
    do_clean_team_info(NewRole).
do_clean_team_info(Role = #role{event = ?event_dungeon}) ->
    case dungeon_api:leave_team(Role) of
        {ok, NewRole} -> {ok, NewRole};
        _ -> {ok, Role}
    end;
do_clean_team_info(Role) ->
    case member_leave(Role) of
        {ok, NewRole} ->
            map:role_update(NewRole),
            {ok, NewRole};
        {ok, {MapId, Dx, Dy}, NewRole} ->
            case map:role_enter(MapId, Dx, Dy, NewRole) of
                {false, _Reason} ->
                    ?ELOG("队员[NAME:~s]退出队伍回复活点失败:~s", [Role#role.name, _Reason]),
                    map:role_update(NewRole),
                    {ok, NewRole};
                {ok, NewRole1} ->
                    {ok, NewRole1}
            end;
        _ -> {ok, Role}
    end.
