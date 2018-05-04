%%----------------------------------------------------
%%  帮会副本 
%% @author shawn 
%%----------------------------------------------------
-module(guild_td_api).
-export([
        role_leave/1
        ,role_enter/1
        ,get_guild/1
        ,get_guild_entrance/1
        ,start_guild/2
        ,stop_guild_td_notify/1
        ,get_status/1
    ]
).

-include("guild_td.hrl").
-include("role.hrl").
-include("pos.hrl").
-include("guild.hrl").
-include("team.hrl").
-include("common.hrl").


%% 获取帮会state
get_guild({Gid, GsrvId}) ->
    case guild_mgr:lookup(by_id, {Gid, GsrvId}) of
        false -> false;
        G -> G
    end.

%% 获取运行中帮会副本的状态
get_status(TdPid) ->
    case gen_fsm:sync_send_all_state_event(TdPid, get_state) of
        pre_stop -> false;
        _ -> true
    end.

%% 获取帮会领地传送点
get_guild_entrance({Gid, GsrvId}) ->
    case get_guild({Gid, GsrvId}) of
        false -> false;
        #guild{pid = Pid} -> {Pid, ?GUILD_TD_EXIT_MAP_ID, ?GUILD_TD_EXIT_X, ?GUILD_TD_EXIT_Y}
    end.

%% 开启帮会副本
start_guild({Gid, GsrvId}, StartLev) ->
    case get_guild({Gid, GsrvId}) of
        false -> {?GUILD_TD_NOT_EXIST, ?L(<<"帮会不存在,无法开启">>)};
        G = #guild{members = Members} ->
            {Hp, _} = guild_td_data:get_td_conf(guild_td_data:wave2lev(StartLev)),
            case guild_td:start(G, #guild_td{td_lev = StartLev, start_lev = StartLev, hp = Hp}) of
                {false, Reason} -> {false, Reason};
                {ok, _} ->
                    guild_td:pack_14907(Members, 1),
                    {ok, ?L(<<"帮会降魔除妖开启成功,请通知帮会成员尽快进入副本">>)}
            end
    end.

%% 副本结束时广播团员
stop_guild_td_notify({Gid, GsrvId}) ->
     case get_guild({Gid, GsrvId}) of
        false -> skip;
        #guild{members = Members} ->
            guild_td:pack_14907(Members, 0)
    end.

role_enter(#role{team_pid = TeamPid}) when is_pid(TeamPid) ->
    {false, ?L(<<"组队中不能进入帮会降妖,请先离队">>)};
role_enter(#role{event = ?event_guild_td, event_pid = Pid}) when is_pid(Pid) ->
    {false, ?L(<<"您已经在副本中了，无需再次进入了">>)};
role_enter(#role{event = ?event_dungeon}) ->
    {false, ?L(<<"副本中,不能进入帮会降妖">>)};
role_enter(#role{combat_pid = CPid}) when is_pid(CPid) ->
    {false, ?L(<<"战斗中,不能进入帮会降妖">>)};
role_enter(#role{cross_srv_id = CrossSrvId}) when CrossSrvId =/= <<>> ->
    {false, ?L(<<"请先返回本服服务器,再参加帮会降妖活动">>)};

role_enter(Role = #role{event = Event, guild = #role_guild{gid = Gid, srv_id = GsrvId}})
when Event =:= ?event_no ->
    %% TODO 传送检测
    case guild_td_mgr:get_guild_td({Gid, GsrvId}) of 
        {false, Reason} -> {false, Reason};
        pre_stop -> {false, ?L(<<"军团副本已经关闭">>)};
        {TdPid, MapId} ->
            case is_pid(TdPid) andalso is_process_alive(TdPid) of
                true -> 
                    case enter_guild_td(Role, TdPid, MapId) of
                        {ok, NewRole} -> {ok, NewRole};
                        Other -> Other
                    end;
                false -> {false, ?L(<<"军团副本没有开启, 请先开启">>)}
            end
    end;
role_enter(_Role) -> {false, ?L(<<"当前状态不能参加军团副本">>)}.

role_leave(Role = #role{team_pid = TeamPid, event_pid = TdPid}) ->
    case is_pid(TeamPid) andalso is_process_alive(TeamPid) of
        true ->
            case leave_guild_td(Role, TdPid) of
                {ok, NewRole} ->
                    Pids = get_other_role(Role),
                    asyn_team_leave(Pids, TdPid),
                    {ok, NewRole};
                Other -> Other
            end;
        false -> 
            case leave_guild_td(Role, TdPid) of
                {ok, NewRole} -> {ok, NewRole};
                Other -> Other
            end
    end.

%% 退出副本
leave_guild_td(Role = #role{guild = #role_guild{gid = Gid, srv_id = GsrvId}}, TdPid) ->
    {Pid, Event, MapId, X, Y} = case guild_td_api:get_guild_entrance({Gid, GsrvId}) of
        false -> {0, ?event_no, ?GUILD_TD_EXIT_MAP_ID, ?GUILD_TD_EXIT_X, ?GUILD_TD_EXIT_Y};
        {Epid, M, Lx, Ly} -> {Epid, ?event_no, M, Lx, Ly}
    end,
    case map:role_enter(MapId, X, Y, Role#role{event = Event}) of
        {false, Reason} -> {false, Reason};
        {ok, NewRole} ->
            guild_td:leave(TdPid, Role),
            {ok, NewRole#role{event = Event, event_pid = Pid}}
    end.

%% 异步退出
asyn_leave_guild_td(Role, TdPid) ->
    case leave_guild_td(Role, TdPid) of
        {false, _Reason} ->
            {ok};
        {ok, NewRole} ->
            {ok, NewRole}
    end.

%% 进入副本
enter_guild_td(Role = #role{pos = #pos{map = LMapId, x = Lx, y = Ly}}, TdPid, MapId) ->
    NoRideRole = role_api:set_ride(Role, ?ride_no),
    NewRole = guild_area:moved(NoRideRole), %% 去除帮会宝座状态
    case map:role_enter(MapId, ?GUILD_TD_DEFAULT_X, ?GUILD_TD_DEFAULT_Y, NewRole#role{event = ?event_guild_td}) of
        {false, Reason} -> {false, Reason};
        {ok, Nr = #role{pos = Pos}}->
            guild_td:enter(TdPid, Nr),
            {ok, Nr#role{event = ?event_guild_td, event_pid = TdPid, pos = Pos#pos{last = {LMapId, Lx, Ly}}}}
    end.


%% 给组员发送异步退出
asyn_team_leave([], _TdPid) -> ok;
asyn_team_leave([Pid | T], TdPid) ->
    role:apply(async, Pid, {fun asyn_leave_guild_td/2, [TdPid]}),
    asyn_team_leave(T, TdPid).

%% 获取其他组员的Pid
get_other_role(Role = #role{pid = Pid, team_pid = TeamPid}) ->
    case team_api:is_leader(Role) of
        {true, _} -> get_team_members(TeamPid, Pid);
        false -> []
    end.

%% 取组员的pid, 不包括队长
get_team_members(TeamPid, Rpid) ->
    case team_api:get_team_info(TeamPid) of
        {ok, #team{member = Members}} -> 
            [Pid || #team_member{pid = Pid, mode = Mode} <- Members, Mode =:= 0 andalso Pid =/= Rpid];
        _ -> []
    end.
