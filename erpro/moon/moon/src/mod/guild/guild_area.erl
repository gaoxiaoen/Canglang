%%----------------------------------------------------
%%  帮会领地
%% @author liuweihua(yjbgwxf@gmail.com)
%%----------------------------------------------------
-module(guild_area).
-export([sit/2              %% 上座位
        ,enter/2            %% 进入帮会领地
        ,leave/1            %% 离开帮会领地
        ,moved/1            %% 角色在帮会领地内移动
        ,move_out/1         %% 将角色请出帮会领地
        ,clear_throne/1
        ,leave_direct/1
    ]
).
-export([sit_async/2, moved_async/2, team_member_async_enter/2, team_member_async_leave/1, team_member_async_tempout/1]).

-include("common.hrl").
-include("guild.hrl").
-include("role.hrl").
-include("link.hrl").
-include("map.hrl").
-include("pos.hrl").
%%
-include("team.hrl").
-include("gain.hrl").

-define(guild_vip_npc_guild_war, {31002, 2400,1600}).
-define(guild_vip_npc_guild_arena, {31002, 1800, 900}).
-define(guild_piv_npc_guild_war, {31001, 1800,1600}).
-define(guild_piv_npc_guild_arena, {31001, 1800,900}).
-define(guild_quick_back, 10).          %% 快速会帮消耗10点帮贡

%% @spec clear_throne(Role) -> NewRole
%% Role = NewRole = #role{}
%% @doc 角色切换场景调用帮会领地，宝座重置需求
clear_throne(Role = #role{id = {Rid, Rsrvid}, pos = #pos{map_pid = MapPid}, guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case guild_role:get_throne(Role) of
        false ->
            Role;
        ChairId ->
            Role1 = guild_role:clear_seat(Role),
            NewRole = looks:calc(Role1),
            map:elem_change(MapPid, ChairId, ?false), %% 重置宝座元素状态
            guild:apply(async, {Gid, Gsrvid}, {?MODULE, moved_async, [{stand, Rid, Rsrvid}]}),
            NewRole
    end.

%% @spec enter(Type, Role) -> {ok} | {ok, NewRole} | {false, Reason}
%% Type = quick | normal
%% Role = NewRole = #role{}
%% Reason = binary()
%% @doc 角色进入帮会领地, Type 为quick 时，是快速回帮模式，Type 为 normal 时正常的回帮(从NPC那里)模式
enter(_Type, Role = #role{event = ?event_guild}) ->
    {ok, Role};
enter(_Type, #role{event = Event}) when Event =/= ?event_no ->
    {false, ?MSGID(<<"当前状态下不可以回帮会领地">>)};
%% 没有帮会
enter(_Type, #role{guild = #role_guild{gid = 0}}) ->
    {false, ?MSGID(<<"您还没有加入任何帮会，赶紧去申请吧！">>)};

%% 快速回帮
enter(quick, #role{team_pid = Pid, team = #role_team{follow = ?true}}) when is_pid(Pid) ->
    {false, ?MSGID(<<"在队伍中，不能使用快速回帮">>)};
enter(quick, Role = #role{link = #link{conn_pid = ConnPid}, guild = #role_guild{devote = Devote, gid = Gid, srv_id = Gsrvid}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{pid = Pid, entrance = {MapId, X, Y}, gvip = Vip} ->
            case role_gain:do(#loss{label = guild_devote, val = ?guild_quick_back}, Role) of
                {ok, Role1 = #role{guild = #role_guild{devote = NewDevote}}} ->
                    case map:role_enter(MapId, X, Y, Role1#role{event_pid = Pid, event = ?event_guild, cross_srv_id = <<>>}) of
                        {false, Reason} ->
                            sys_conn:pack_send(ConnPid, 13700, {[{51, Devote}]}),
                            {false, Reason};
                        {ok, NewRole = #role{pos = Pos}} when Vip =:= ?guild_piv ->
                            sys_conn:pack_send(ConnPid, 13700, {[{51, NewDevote}]}),
                            {ok, NewRole#role{pos = Pos#pos{map_base_id = ?guild_piv_mapid}}};
                        {ok, NewRole = #role{pos = Pos}} ->
                            sys_conn:pack_send(ConnPid, 13700, {[{51, NewDevote}]}),
                            {ok, NewRole#role{pos = Pos#pos{map_base_id = ?guild_vip_mapid}}}
                    end;
                _ ->
                    {false, ?MSGID(<<"剩余帮会个人贡献不足10点">>)}
            end;
        _ ->
            {false, <<>>}
    end;

%% 队长发起组队回帮, 队长必须有帮会
enter(Where, Role = #role{name = Rname, team_pid = Pid, team = #role_team{is_leader = ?true}, guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) when is_pid(Pid) ->
    case team_api:get_team_info(Role) of
        {ok, #team{leader = Leader, member = Mems}} ->
            GuildID = {Gid, Gsrvid},
            Fun = fun(#team_member{pid = MemPid}) when is_pid(MemPid) -> role:apply(async, MemPid, {?MODULE, team_member_async_enter, [{Where, GuildID}]});
                (_TeamMember) -> ok
            end,
            lists:foreach(Fun, Mems ++ [Leader]),
            {ok};
        _ ->
            ?ERR("组队回帮时，获取角色 ~s 的队伍信息有误", [Rname]),
            {false, <<>>}
    end;

%% 跟随队员发起组队回帮
enter(_Where, #role{team_pid = Pid, team = #role_team{follow = ?true}}) when is_pid(Pid) ->
    {false, ?MSGID(<<"您不是队长 ，无法发起回帮请求！">>)};

%% 非组队 正常回帮
enter(normal, Role) ->
    {ok, enter_guild_area(normal, Role)};

%% 非组队 回到帮战NPC位置
enter(war_npc, Role) ->
    {ok, enter_guild_area(war_npc, Role)};

enter(arena_npc, Role) ->
    {ok, enter_guild_area(arena_npc, Role)};

enter(_Cmd, _Role) ->
    {false, ?MSGID(<<"当前状态下不可以回帮会领地">>)}.

%% @spec team_member_async_enter(Role) -> {ok} | {ok, NewRole}
%% Role = NewRole = #role{}
%% @doc 异步调用，队伍成员进入帮会领地
team_member_async_enter(Role = #role{team = #role_team{follow = ?true}, guild = #role_guild{gid = Gid, srv_id = Gsrvid}}, {Where, GuildID}) ->
    if GuildID =/= {Gid, Gsrvid} -> team_api:tempout(Role); true -> ok end,
    {ok, enter_guild_area(Where, Role)};
team_member_async_enter(_Role, _) ->
    {ok}.

%% 进入帮会领地
enter_guild_area(_Type, Role = #role{guild = #role_guild{gid = 0}}) -> Role;
enter_guild_area(Where, Role = #role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{gvip = Vip, pid = Pid, entrance = {MapId, _X, _Y}} ->
            {_, Dx, Dy} = where_to_position(Vip, Where),
            case map:role_enter(MapId, Dx, Dy, Role#role{event_pid = Pid, event = ?event_guild, cross_srv_id = <<>>}) of
                {false, _Reason} ->
                    Role;
                {ok, NewRole = #role{pos = Pos}} when Vip =:= ?guild_piv ->
                    NewRole#role{pos = Pos#pos{map_base_id = ?guild_piv_mapid}};
                {ok, NewRole = #role{pos = Pos}} ->
                    NewRole#role{pos = Pos#pos{map_base_id = ?guild_vip_mapid}}
            end;
        _ ->
            Role
    end.

%% 获取进入点
where_to_position(?guild_vip, war_npc) ->
    ?guild_vip_npc_guild_war;
where_to_position(?guild_vip, arena_npc) ->
    ?guild_vip_npc_guild_arena;
where_to_position(?guild_vip, _Type) ->
    ?guild_vip_map;
where_to_position(?guild_piv, war_npc) ->
    ?guild_piv_npc_guild_war;
where_to_position(?guild_piv, arena_npc) ->
    ?guild_piv_npc_guild_arena;
where_to_position(?guild_piv, _Type) ->
    ?guild_novip_map.

%% @spec leave(Role) -> {false, Reason} | {ok, NewRole} | {ok}
%% Role = NewRole = #role{}
%% Reason = binary()
%% @doc 角色离开帮会领地
leave(Role = #role{name = Rname, team_pid = Pid, team = #role_team{is_leader = ?true}}) when is_pid(Pid) ->
    case team_api:get_team_info(Role) of
        {ok, #team{leader = Leader, member = Mems}} ->
            Fun = fun(#team_member{pid = MemPid}) when is_pid(MemPid) -> role:apply(async, MemPid, {?MODULE, team_member_async_leave, []});
                (_TeamMember) -> ok
            end,
            lists:foreach(Fun, Mems ++ [Leader]),
            {ok};
        _ ->
            ?ERR("组队离帮时，获取角色 ~s 的队伍信息有误", [Rname]),
            {false, <<>>}
    end;
leave(#role{team_pid = Pid, team = #role_team{follow = ?true}}) when is_pid(Pid) ->
    {false, ?MSGID(<<"您不是队长，无法发起离开帮会领地请求">>)};

%% 正常离帮
leave(Role) ->
    case map:role_enter(?guild_exit_mapid, ?guild_exit_x, ?guild_exit_y, Role#role{event_pid = 0, event = ?event_no}) of
        {false, Reason} ->
            {false, Reason};
        {ok, NewRole = #role{pos = Pos}} ->
            {ok, NewRole#role{pos = Pos#pos{map_base_id = 10003}}}
    end.

%% @spec team_member_async_leave(Role) -> {ok} | {ok, NewRole}
%% Role = NewRole = #role{}
%% @doc 异步调用，队伍成员离开帮会领地
team_member_async_leave(Role = #role{team = #role_team{follow = ?true}}) ->
    case map:role_enter(?guild_exit_mapid, ?guild_exit_x, ?guild_exit_y, Role#role{event_pid = 0, event = ?event_no}) of
        {false, _Reason} ->
            {ok};
        {ok, NewRole = #role{pos = Pos}} ->
            {ok, NewRole#role{pos = Pos#pos{map_base_id = 10003}}}
    end;
team_member_async_leave(_Role) ->
    {ok}.

%% @spec move_out(Role) -> NewRole
%% Role = NewRole = #role{}
%% @doc 将角色清理出帮会领地（开除成员）
move_out(Role = #role{event = Event}) when Event =/= ?event_guild ->    %% 角色不在帮会领地，不处理
    Role;
move_out(Role = #role{team_pid = Pid, team = #role_team{is_leader = ?true}}) when is_pid(Pid) ->
    case team_api:get_team_info(Role) of
        {ok, #team{member = Mems}} ->
            Fun = fun(#team_member{pid = MemPid}) when is_pid(MemPid) -> role:apply(async, MemPid, {?MODULE, team_member_async_tempout, []});
                (_TeamMember) -> ok
            end,
            lists:foreach(Fun, Mems),
            leave_direct(Role);
        _ ->
            Role
    end;
move_out(Role = #role{team_pid = Pid}) when is_pid(Pid) ->
    team_api:tempout(Role),   
    leave_direct(Role);

move_out(Role) ->
    leave_direct(Role).

%% @spec team_member_async_tempout(Role) -> {ok}
%% @doc 队长被开除，队长异步暂离队员
team_member_async_tempout(Role) ->
    team_api:tempout(Role),   
    {ok}.

%% 直接离开帮会领地
leave_direct(Role) ->
    case map:role_enter(?guild_exit_mapid, ?guild_exit_x, ?guild_exit_y, Role#role{event_pid = 0, event = ?event_no}) of
        {false, _Reason} ->
            Role;
        {ok, NewRole = #role{pos = Pos}} ->
            NewRole#role{pos = Pos#pos{map_base_id = 10003}}
    end.

%% @spec sit(ChairID, Role) -> NewRole
%% ChairID = integer()
%% Role = NewRole = #role{}
%% @doc 通过地图元素操作来坐上座位，这里已通过了相关限制
sit(ChairID, Role = #role{id = {Rid, Rsrvid}, special = Spec, guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    guild:apply(async, {Gid, Gsrvid}, {?MODULE, sit_async, [{sit, ChairID, Rid, Rsrvid}]}),
    Role1 = Role#role{special = [{?special_guild_sit, ChairID, <<>>}|Spec]},
    NewRole = looks:calc(Role1),
    map:role_update(NewRole), %% 角色场景广播
    NewRole.

%% @spec moved(Role) -> NewRole
%% Role = NewRole = #role{}
%% @doc 帮会内走动了, 角色下线触发，重置宝座元素状态
moved(Role = #role{id = {Rid, Rsrvid}, event = ?event_guild, pos = #pos{map_pid = MapPid}, guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case guild_role:get_throne(Role) of
        false ->
            Role;
        ChairId ->
            Role1 = guild_role:clear_seat(Role),
            NewRole = looks:calc(Role1),
            guild:apply(async, {Gid, Gsrvid}, {?MODULE, moved_async, [{stand, Rid, Rsrvid}]}),
            map:elem_change(MapPid, ChairId, ?false), %% 重置宝座元素状态
            map:role_update(NewRole), %% 角色场景广播
            NewRole
    end;
moved(_Role) ->
    _Role.

%%---------------------------------------------------------------------
%% 帮会进程异步回调函数
%%--------------------------------------------------------------------
%% 帮会领地上座
sit_async(Guild = #guild{chairs = Chairs}, {sit, Chair, Rid, Rsrvid}) ->
    {ok, Guild#guild{chairs = lists:ukeysort(1, [{Chair, {Rid, Rsrvid}}|Chairs])}}.

%% 下座位
moved_async(Guild = #guild{chairs = Chairs}, {stand, Rid, Rsrvid}) ->
    {ok, Guild#guild{chairs = lists:keydelete({Rid, Rsrvid}, 2, Chairs)}}.

