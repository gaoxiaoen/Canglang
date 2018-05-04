%% **************************
%% 队伍外部接口
%% @author wpf(wprehard@qq.com)
%% *************************
-module(team_api).
-export([
        is_leader/1
        ,is_member/1
        ,is_tempout_member/1
        ,is_tempout_member/2
        ,get_team_leader/1
        ,get_team_info/1
        ,get_members_id/1
        ,get_member_count/1
        ,create_team/2
        ,tempout/1                  %% 队员选择暂离
        ,force_tempout/2            %% 强制队员暂离
        ,back_team/1
        ,quit/1                     %% 退出队员
        ,chat/3
        ,stop/1
        ,stop/2
        %% ,combat_over/2
        ,team_listener/2
    ]).
-export([
        get_member_index/2
        ,check_exclude/1            %% 检测是否可以组队/入队
        ,check_special/2
        ,check_back/1               %% 检测是否可以归队
        ,sync_check_create/1        %% 同步调用检测
        ,check_and_join/2
        ,check_and_join_dungeon/2   %% 副本招募加入时，直接判断并取消打坐双修状态，归队
        ,join_invited/2
        %% ,pack_proto_msg/2
    ]).

-include("common.hrl").
-include("role.hrl").
-include("team.hrl").
%%
-include("pos.hrl").
-include("link.hrl").

%% ---------------------------------
%% 对外接口
%% ---------------------------------

%% @spec team_listener(Args, Role) -> NewRole
%% @doc handle_rpc操作监听
team_listener(apply, Role) ->
    %% 取消双人骑乘状态
    Role1 = both_ride:cancel_both_ride(Role),
    map:role_update(Role1),
    Role1;
team_listener(appoint, Role) ->
    both_ride:cancel_both_ride(Role);
team_listener(tempout, Role) ->
    both_ride:cancel_both_ride(Role);
team_listener(quit, Role) ->
    both_ride:cancel_both_ride(Role);
team_listener(kick_out, Role) ->
    both_ride:cancel_both_ride(Role);
team_listener(_, Role) ->
    Role.

%% @spec is_leader(Role) -> false | {true, TeamId::integer()}
%% Role = #role{}
%% @doc 是否是队长
is_leader(#role{team_pid = TeamPid, team = #role_team{team_id = TeamId, is_leader = ?true}})
when is_pid(TeamPid) ->
    {true, TeamId};
is_leader(#role{team_pid = TeamPid, team = #role_team{is_leader = ?false}})
when is_pid(TeamPid) ->
    false;
is_leader(#role{id = Rid, team_pid = TeamPid})
when is_pid(TeamPid) ->
    case is_process_alive(TeamPid) of
        true ->
            team:is_leader(TeamPid, Rid);
        false ->
            false
    end;
is_leader(_R) -> false.

%% @spec is_member(Role) -> false | {true, TeamId}
%% @doc 是否队伍成员，不包括队长
is_member(#role{team_pid = TeamPid, team = #role_team{team_id = TeamId, is_leader = ?false}})
when is_pid(TeamPid) ->
    {true, TeamId};
is_member(#role{team_pid = TeamPid})
when is_pid(TeamPid) ->
    false;
is_member(_) ->
    false.

%% @spec is_tempout_member(Role) -> true | false
%% @doc 是否队伍暂离成员
is_tempout_member(#role{team_pid = TeamPid, team = #role_team{is_leader = ?false, follow = ?true}})
when is_pid(TeamPid) ->
    false;
is_tempout_member(_) ->
    true.

%% @spec is_tempout_member(TeamPid, RoleId) -> true | false
%% Id = {integer(), bitstring()}
%% TeamPid = pid()
%% @doc 是否暂离队员(适合活动、非角色进程的情况下)
is_tempout_member(TeamPid, RoleId) when is_pid(TeamPid)->
    team:is_tempout_member(TeamPid, RoleId);
is_tempout_member(_, _) ->
    false.

%% @spec get_team_leader(Args) -> {ok, TeamId, Leader} | any()
%% Args = #role{} | pid()       角色信息 | TeamPid
%% Leader = #team_member{}      队长信息
%% @doc 根据队伍进程PID获取队长信息#team_member{}
get_team_leader(#role{team_pid = TeamPid}) when is_pid(TeamPid) ->
    team:get_leader(TeamPid);
get_team_leader(TeamPid) when is_pid(TeamPid) ->
    team:get_leader(TeamPid);
get_team_leader(_) ->
    error.

%% @spec get_team_info(Args) -> {ok, TeamState} | any()
%% Args = #role{} | pid()
%% @doc 获取队伍信息#team{}
get_team_info(#role{team_pid = TeamPid}) ->
    get_team_info(TeamPid);
get_team_info(TeamPid) when is_pid(TeamPid) ->
    team:get_team_info(TeamPid);
get_team_info(_) ->
    error.

%% @spec get_members_id(Args) -> list() | any()
%% Args = #role{} | pid()
%% @doc 获取队员ID列表
get_members_id(#role{team_pid = TeamPid}) ->
    get_members_id(TeamPid);
get_members_id(TeamPid) when is_pid(TeamPid) ->
    team:get_members_id(TeamPid);
get_members_id(_) ->
    error.

%% @spec get_member_count(TeamPid) -> integer() | {error, Reason} | {badrpc, Reason}
%% TeamPid = pid()
%% @doc 获取队伍人数，包括队长
get_member_count(TeamPid) ->
    team:get_member_count(TeamPid).

%% @spec get_member_index(Id, MemList) -> Index
%% Index = integer()
%% @doc 获取成员的跟随序号: 0:无跟随  1:队长  2,3:队员
get_member_index(_Id, []) -> 0;
get_member_index(Id, [#team_member{id = Id, mode = ?MODE_NORMAL}]) -> 2;
get_member_index(Id, [#team_member{mode = ?MODE_NORMAL} | #team_member{id = Id, mode = ?MODE_NORMAL}]) -> 3;
get_member_index(Id, [_ | #team_member{id = Id, mode = ?MODE_NORMAL}]) -> 2;
get_member_index(_, _) -> 0.

%% @spec tempout(Role) -> {ok} | {false, Msg}
%% @doc 队员角色暂离队伍
tempout(Role)->
    team:tempout(Role, normal).

%% @spec force_tempout(TeamPid, MemberIds) -> any()
%% Memberids = {Rid, SrvId} | [{Rid, SrvId}, ...]
%% @doc 强制某个队员暂离队伍
force_tempout(_TeamPid, []) -> ok;
force_tempout(TeamPid, [MemberId | T]) when is_pid(TeamPid) ->
    team_cross:send(TeamPid, {tempout, MemberId}),
    force_tempout(TeamPid, T);
force_tempout(TeamPid, MemberId) when is_pid(TeamPid) -> 
    team_cross:send(TeamPid, {tempout, MemberId});
force_tempout(_, _) -> ok.

%% @spec back_team(Role) -> error | {ok, NewRole}
%% @doc 归队
back_team(Role = #role{team = #role_team{is_leader = ?false}}) ->
    case back_team(Role) of
        {ok, NewRole} -> {ok, NewRole};
        _ -> error
    end;
back_team(_Role) -> error.

%% @spec quit(Role) -> ok
%% @doc 退出某个队员（包括队长）
quit(Role = #role{team_pid = TeamPid, link = #link{conn_pid = ConnPid}}) when is_pid(TeamPid) ->
    team:quit(Role),
    sys_conn:pack_send(ConnPid, 10841, {?true, <<>>}),
    ok;
quit(_Role) ->
    ok.

%% @spec chat(TeamPid, Cmd, Data) -> any()
%% @doc 队伍消息转发
chat(TeamPid, Cmd, Data) when is_pid(TeamPid) ->
    team:chat(TeamPid, {chat, Cmd, Data});
chat(_TeamPid, _Cmd, _Data) -> ok.

%% @spec stop(TeamPid) -> any()
%% TeamPid = pid()
%% @doc 异步结束队伍进程，关闭队伍
stop(TeamPid) ->
    team:stop(TeamPid).

%% @spec stop(Pid, Msg) -> any()
%% Arg = pid()
%% Msg = atom() 关闭原因
%% @doc 异步结束队伍进程，关闭队伍
stop(TeamPid, Msg) ->
    team:stop(TeamPid, Msg).

%% @spec check_exclude(Role) -> {false, Reason} | ok
%% @doc 检测角色是否可以创建/加入队伍
check_exclude(#role{status = ?status_die}) ->
    {false, ?L(<<"死亡状态不允许队伍操作">>)};
check_exclude(#role{exchange_pid = ExcPid}) when is_pid(ExcPid) ->
    {false, ?L(<<"交易中不允许组队">>)};
check_exclude(#role{event = ?event_arena_match}) ->
    {false, ?L(<<"竞技中不允许组队">>)};
check_exclude(#role{event = ?event_arena_prepare}) ->
    {false, ?L(<<"竞技中不允许组队">>)};
check_exclude(#role{event = ?event_escort}) ->
    {false, ?L(<<"护送中不允许组队">>)};
check_exclude(#role{event = ?event_super_boss}) ->
    {false, ?L(<<"远古巨龙活动中不能组队">>)};
check_exclude(#role{event = ?event_jiebai}) ->
    {false, ?L(<<"结拜活动中，暂时不能组队">>)};
check_exclude(#role{event = ?event_hall}) ->
    {false, ?L(<<"您在大厅中，暂时不能组队">>)};
check_exclude(#role{event = ?event_top_fight_match}) ->
    {false, ?L(<<"巅峰对决中不允许组队">>)};
check_exclude(#role{event = ?event_top_fight_prepare}) ->
    {false, ?L(<<"巅峰对决中不允许组队">>)};
check_exclude(#role{event = ?event_cross_warlord_match}) ->
    {false, ?L(<<"武神坛战区中不允许组队">>)};
check_exclude(#role{event = ?event_guard_counter}) ->
    {false, ?L(<<"洛水反击中不允许组队">>)};
check_exclude(#role{event = Event})
when Event =:= ?event_c_world_compete_11 orelse Event =:= ?event_c_world_compete_22 orelse Event =:= ?event_c_world_compete_33 ->
    {false, ?L(<<"参加跨服仙道会中，不能组队">>)};
check_exclude(#role{cross_srv_id = <<"center">>, pos = #pos{map_base_id = 30100}}) ->
    {false, ?L(<<"您在天位之战准备区中，暂时不能组队">>)};
check_exclude(#role{cross_srv_id = <<"center">>, pos = #pos{map_base_id = MbaseId}}) when MbaseId =:= 30401 orelse MbaseId =:= 30402 orelse MbaseId =:= 30501 orelse MbaseId =:= 30502 ->
    {false, ?L(<<"您在跨服副本准备区中，暂时不能组队">>)};
check_exclude(#role{cross_srv_id = <<"center">>, event = ?event_pk_duel}) ->
    {false, ?L(<<"参加跨服决斗中，不能组队">>)};
check_exclude(#role{cross_srv_id = <<"center">>, event = ?event_cross_king_prepare}) ->
    {false, ?L(<<"参加至尊王者赛中，不能组队">>)};
check_exclude(#role{cross_srv_id = <<"center">>, event = ?event_cross_king_match}) ->
    {false, ?L(<<"参加至尊王者赛中，不能组队">>)};
%% TODO: 其他检测
check_exclude(_Role) -> ok.

%% @spec check_back(Role) -> {false, Reason} | ok
%% @doc 检测角色是否可以归队
check_back(#role{status = ?status_die}) ->
    {false, ?L(<<"死亡状态不允许队伍操作">>)};
check_back(#role{exchange_pid = ExcPid}) when is_pid(ExcPid) ->
    {false, ?L(<<"交易中不允许组队">>)};
check_back(#role{event = ?event_arena_match}) ->
    {false, ?L(<<"竞技中不允许组队">>)};
check_back(#role{event = ?event_arena_prepare}) ->
    {false, ?L(<<"竞技中不允许组队">>)};
check_back(#role{event = ?event_escort}) ->
    {false, ?L(<<"护送中不允许组队">>)};
check_back(#role{event = ?event_super_boss}) ->
    {false, ?L(<<"远古巨龙活动中不能组队">>)};
check_back(#role{event = ?event_jiebai}) ->
    {false, ?L(<<"结拜活动中，暂时不能组队">>)};
%% TODO: 其他检测
check_back(_Role) -> ok.

%% @spec check_special(Role, {InvitedId, Event2, Looks2}) -> ok | {false, Msg}
%% @doc 检查特殊状态的情况
%% 跨服竞技
check_special(_, {_, Event2, _})
when Event2 =:= ?event_c_world_compete_11 orelse Event2 =:= ?event_c_world_compete_22 orelse Event2 =:= ?event_c_world_compete_33 ->
    {false, ?L(<<"对方正在参加跨服仙道会活动中，不能组队">>)};
%% 阵营战
check_special(#role{event = ?event_guild_war}, {_InvitedId, Event2, _Looks2})
when Event2 =/= ?event_guild_war ->
    {false, ?L(<<"对方没有参加圣地之争活动，不能组队">>)};
check_special(#role{event = Event}, {_InvitedId, ?event_guild_war, _Looks2})
when Event =/= ?event_guild_war ->
    {false, ?L(<<"对方在参加圣地之争活动中，不能组队">>)};
check_special(Role = #role{event = ?event_guild_war}, {_InvitedId, ?event_guild_war, Looks2}) ->
    case guild_war_api:is_can_team(Role, Looks2) of
        true -> ok;
        false -> {false, ?L(<<"圣地之争中不能和对立联盟成员组队">>)}
    end;
%% 新帮战
check_special(Role, {InvitedId, Event2, _Looks2}) ->
    guild_arena:team_check(Role, InvitedId, Event2);
check_special(_Role, _) ->
    ok.

%% @spec sync_check_create(Role) -> {ok, Reply}
%% Reply = {false, Reason} | {ok, TeamPid}
%% @doc 同步回调函数，检测角色是否可以创建队伍, 可以则创建队伍返回队伍PID
sync_check_create(Role) ->
    {ok, do_sync_check_create(Role)}.
do_sync_check_create(#role{team_pid = TeamPid, team = #role_team{is_leader = ?true}})
when is_pid(TeamPid) -> %% 此角色已经是队长
    {ok, TeamPid};
do_sync_check_create(#role{team_pid = TeamPid})
when is_pid(TeamPid) ->
    {false, ?L(<<"操作失败，对方已经有队伍">>)}; %% 此角色已经加入其他队伍
do_sync_check_create(Role) ->
    case check_exclude(Role) of
        {false, Reason} -> {false, Reason};
        ok ->
            case team_mgr:create_team(Role) of
                {false, Reason} -> {false, Reason};
                TeamPid -> {ok, TeamPid}
            end
    end.

%% @spec join_invited({Id, SrvId}, RoleJoin) -> {ok, NewRoleJoin} | {false, Msg} | ignore
%% Rolejoin = NewRoleJoin = #role{}
%% @doc 玩家同意邀请加入队伍
%% 被邀请加入，需要判断是否已有队伍
join_invited(InviteId, RoleJoin) ->
    case check_exclude(RoleJoin) of
        {false, Reason} ->
            {false, Reason};
        ok ->
            case role_api:c_lookup(by_id, InviteId, #role.pid) of
                {ok, _, Pid} ->
                    case role:c_apply(sync, Pid, {?MODULE, sync_check_create, []}) of
                        {ok, TeamPid} ->
                            team:join(TeamPid, RoleJoin);
                        {false, Reason} ->
                            {false, Reason}
                    end;
                {error, _Err} ->
                    {false, ?L(<<"操作失败，对方不在线">>)};
                _E ->
                    ?DEBUG("角色[ID:~w]查找到的PID信息异常:~w", [InviteId, _E]),
                    {false, ?L(<<"操作失败">>)}
            end
    end.

%% @spec check_and_join(RoleJoin, TeamPid) -> {ok, NewRole} | {ok}
%% RoleJoin = #role{}   角色信息
%% TeamPid = pid()      要加入队伍进程PID
%% @doc 检查并加入队伍
%% <div> 角色异步回调函数
%%  1、同一个队伍的暂离队员，默认归队处理
%%  2、队员已经有队伍的，默认不处理
%% </div>
check_and_join(Role = #role{team_pid = TeamPid, team = #role_team{follow = ?false}}, TeamPid) -> %% 辅助归队
    case team:back_team(Role) of
        {ok, NewRole} -> {ok, NewRole};
        _ -> {ok}
    end;
check_and_join(#role{team_pid = TeamPid}, _) when is_pid(TeamPid) ->
    {ok};
check_and_join(RoleJoin, TeamPid) ->
    case check_exclude(RoleJoin) of
        {false, _Reason} ->
            ?DEBUG("角色[NAME:~s]加入队伍失败：~s", [RoleJoin#role.name, _Reason]),
            {ok};
        ok ->
            case team:join(TeamPid, RoleJoin) of
                {ok, NewRole} ->
                    {ok, NewRole};
                {false, _Reason} ->
                    ?DEBUG("角色[NAME:~s]加入队伍出现错误:~w", [RoleJoin#role.name, _Reason]),
                    {ok}
            end
    end.

%% @spec check_and_join_dungeon(RoleJoin, TeamPid) -> {ok, NewRole} | {ok}
%% RoleJoin = #role{}   角色信息
%% TeamPid = pid()      要加入队伍进程PID
%% @doc 检查并加入队伍，副本大厅操作
%% <div> 角色异步回调函数 </div>
check_and_join_dungeon(#role{team_pid = RoleTeamPid}, _) when is_pid(RoleTeamPid) ->
    {ok};
check_and_join_dungeon(RoleJoin, TeamPid) ->
    case check_exclude(RoleJoin) of
        {false, _Reason} ->
            ?DEBUG("角色[NAME:~s]加入队伍失败：~s", [RoleJoin#role.name, _Reason]),
            {ok};
        ok ->
            NewRoleJoin = sit:handle_sit(?action_no, RoleJoin),
            case team:join(TeamPid, NewRoleJoin) of
                {ok, NewRole} ->
                    {ok, NewRole};
                {false, _Reason} ->
                    ?DEBUG("角色[NAME:~s]加入队伍出现错误:~w", [RoleJoin#role.name, _Reason]),
                    {ok}
            end
    end.

%% @spec create_team(Role, Members) -> {ok, TeamPid} | {false, Reason}
%% Role = #role{}
%% Members = [M | ...]
%%   M = {integer(), bitstring()} | pid() | #role{}
%% @doc 玩家创建队伍
%% <div> 适合以下情况：
%%  1、由节点服创建队伍
%%  2、同一个队伍的暂离队员，默认自动归队
%% </div>
create_team(#role{team_pid = TeamPid, team = #role_team{is_leader = ?true}}, Members) ->
    do_join_team(TeamPid, Members),
    {ok, TeamPid};
create_team(#role{team_pid = TeamPid}, _Members) when is_pid(TeamPid) ->
    {false, ?L(<<"指定的队长已经有队伍了">>)};
create_team(Role, Members) ->
    case check_exclude(Role) of
        {false, Reason} -> {false, Reason};
        ok ->
            case team_mgr:create_team(Role) of
                {false, Reason} -> {false, Reason};
                TeamPid ->
                    ?DEBUG("Members:~w", [Members]),
                    do_join_team(TeamPid, Members)
            end
    end.

%% -------------------------------------------------------------------------
%% 内部函数
%% -------------------------------------------------------------------------

do_join_team(TeamPid, []) -> {ok, TeamPid};
do_join_team(TeamPid, [{Rid, SrvId} | T]) ->
    case role_api:c_lookup(by_id, {Rid, SrvId}, [#role.pid, #role.team_pid]) of
        {ok, _, [_, Tpid]} when is_pid(Tpid) andalso TeamPid =/= Tpid ->
            {false, ?L(<<"已经有队伍">>)};
        {ok, _, [Pid, _]} ->
            role:c_apply(async, Pid, {team_api, check_and_join, [TeamPid]}),
            do_join_team(TeamPid, T);
        _ ->
            do_join_team(TeamPid, T)
    end;
do_join_team(TeamPid, [RolePid | T]) when is_pid(RolePid) ->
    role:c_apply(async, RolePid, {team_api, check_and_join, [TeamPid]}),
    do_join_team(TeamPid, T);
do_join_team(TeamPid, [#role{team_pid = Tpid} | _]) when is_pid(Tpid) andalso TeamPid =/= Tpid ->
    {false, ?L(<<"已经有队伍">>)};
do_join_team(TeamPid, [#role{pid = Pid} | T]) ->
    role:c_apply(async, Pid, {team_api, check_and_join, [TeamPid]}),
    do_join_team(TeamPid, T);
do_join_team(_, _) ->
    {false, ?L(<<"参数不对">>)}.

%% %% @spec del_invited_list(InvitedId, InviteId) -> skip | {ok, Msg}
%% %% InvitedId = {integer(), bitstring()} 受邀玩家的ID
%% %% InviteId = {integer(), bitstring()} 邀请人的ID
%% %% @doc 删除受邀请ets表中单个数据, 返回新的受邀请列表
%% del_invited_list(InvitedId, InviteId) ->
%%     case ets:lookup(ets_team_invite, InvitedId) of
%%         [] -> skip;
%%         [#team_invited{list = []}] ->
%%             ets:delete(ets_team_invite, InvitedId),
%%             skip;
%%         [#team_invited{list = [Msg = #team_apply_msg{id = InviteId}]}] ->
%%             ets:delete(ets_team_invite, InvitedId),
%%             {ok, Msg};
%%         [I = #team_invited{list = L}] ->
%%             case lists:keyfind(InviteId, #team_apply_msg.id, L) of
%%                 false -> skip;
%%                 Msg ->
%%                     NewL = lists:keydelete(InviteId, #team_apply_msg.id, L),
%%                     ets:insert(ets_team_invite, I#team_invited{list = NewL}),
%%                     {ok, Msg}
%%             end
%%     end.
%% 
%% %% @spec del_apply_list(LeaderId, ApplyId) -> skip | {ok, Msg}
%% %% LeaderId = {integer(), bitstring()} 队长的ID
%% %% ApplyId = {integer(), bitstring()} 申请人的ID
%% %% @doc 删除受申请的列表单个数据
%% del_apply_list(LeaderId, ApplyId) ->
%%     case ets:lookup(ets_team_apply, LeaderId) of
%%         [] -> skip;
%%         [#team_invited{list = []}] ->
%%             ets:delete(ets_team_apply, LeaderId),
%%             skip;
%%         [#team_invited{list = [Msg = #team_apply_msg{id = LeaderId}]}] ->
%%             ets:delete(ets_team_invite, LeaderId),
%%             {ok, Msg};
%%         [A = #team_apply{applied_id = LeaderId, list = L}] ->
%%             case lists:keyfind(ApplyId, #team_apply_msg.id, L) of
%%                 false -> skip;
%%                 Msg ->
%%                     NewL = lists:keydelete(ApplyId, #team_apply_msg.id, L),
%%                     ets:insert(ets_team_apply, A#team_apply{list = NewL}),
%%                     {ok, Msg}
%%             end
%%     end.
%% 
%% %% @spec add_invited_list(InvitedId, ApplyMsg) -> {false, Reason} | ok
%% %% ApplyMsg = #team_apply_msg{}
%% %% @doc 向邀请列表添加一条消息
%% add_invited_list(InvitedId, ApplyMsg = #team_apply_msg{id = Id}) ->
%%     Now = util:unixtime(),
%%     Msg = ApplyMsg#team_apply_msg{s_time = Now},
%%     case ets:lookup(ets_team_invite, InvitedId) of
%%         [#team_invited{list = [#team_apply_msg{id = Id, s_time = Stime}]}] when (Now - Stime) < ?APPLY_TIMEOUT ->
%%             {false, ?L(<<"已经邀请过对方">>)};
%%         [I = #team_invited{list = L}] ->
%%             TmpList = [M || M = #team_apply_msg{s_time = STime} <- L, (Now - STime) < ?APPLY_TIMEOUT],
%%             case lists:keyfind(Id, #team_apply_msg.id, TmpList) of
%%                 false -> 
%%                     NewI = I#team_invited{list = [Msg | TmpList]},
%%                     ets:insert(ets_team_invite, NewI),
%%                     ok;
%%                 _X ->
%%                     {false, ?L(<<"已经邀请过对方">>)}
%%             end;
%%         _ ->
%%             NewI = #team_invited{invited_id = InvitedId, list = [Msg]},
%%             ets:insert(ets_team_invite, NewI),
%%             ok
%%     end.
%% 
%% %% @spec add_apply_list(LeaderId, ApplyMsg) -> {false, Reason} | ok
%% %% LeaderId = tuple() 队长ID
%% %% ApplyMsg = #team_apply_msg{}
%% %% @doc 向申请列表添加一条消息
%% add_apply_list(LeaderId, ApplyMsg = #team_apply_msg{id = Id}) ->
%%     Now = util:unixtime(),
%%     Msg = ApplyMsg#team_apply_msg{s_time = Now},
%%     case ets:lookup(ets_team_apply, LeaderId) of
%%         [#team_apply{list = [#team_apply_msg{id = Id, s_time = Stime}]}] when (Now - Stime) < ?APPLY_TIMEOUT ->
%%             {false, ?L(<<"已经申请过对方">>)};
%%         [A = #team_apply{list = L}] ->
%%             TmpList = [M || M = #team_apply_msg{s_time = STime} <- L, (Now - STime) < ?APPLY_TIMEOUT],
%%             case lists:keyfind(Id, #team_apply_msg.id, TmpList) of
%%                 false -> 
%%                     NewA = A#team_apply{list = [Msg | TmpList]},
%%                     ets:insert(ets_team_apply, NewA),
%%                     ok;
%%                 _ ->
%%                     {false, ?L(<<"已经申请过对方">>)}
%%             end;
%%         _ ->
%%             NewA = #team_apply{applied_id = LeaderId, list = [Msg]},
%%             ets:insert(ets_team_apply, NewA),
%%             ok
%%     end.
