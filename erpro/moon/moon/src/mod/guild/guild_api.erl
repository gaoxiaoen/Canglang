%%----------------------------------------------------
%%  军团系统
%% @author liuweihua(yjbgwxf@gmail.com)
%%----------------------------------------------------
-module(guild_api).
-export([is_guild_area/1
        ,get_guild_vip/1
    ]
).
-export([get_guild_id/1
        ,get_role_guild/1
        ,set/2              %% 设置角色军团属性
        ,join/2
        ,order_back_guild/1
        ,team_enter_guild/2
        ,team_leave_guild/1
        ,sync_to_guild/1
        ,get_guild_lvl/1
        ,reset_trigger/2
    ]
).

-include("guild.hrl").
-include("role.hrl").
-include("common.hrl").
-include("pos.hrl").
%%
-include("chat_rpc.hrl").
-include("link.hrl").
-include("team.hrl").

%% 
reset_trigger(Role, TargetIds) ->
    Role1 = guild_aim:clear_trigger(Role),
    Role2 = guild_role:add_target_trigger(TargetIds, Role1),
    {ok, Role2}.

%% @spec is_guild_area(Role) -> true | false
%% Role = #role{}
%% @doc 判断角色是否在军团领地
is_guild_area(#role{pos = #pos{map_base_id = ?guild_piv_mapid}}) ->
    true;
is_guild_area(#role{pos = #pos{map_base_id = ?guild_vip_mapid}}) ->
    true;
is_guild_area(_Role) ->
    false.

%% @spec get_guild_vip(Role) -> 0 | 1 | ignore
%% Role = #role{}
%% @doc 获取军团的vip类型: 0 非Vip帮会, 1 Vip帮会, ignore 还没有帮会或帮会已经解散 
get_guild_vip(#role{guild = #role_guild{gid = 0}}) -> 
    ignore;
get_guild_vip(#role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        false ->
            ?ERR("在ETS中查找不到军团{~w,~s}的数据", [Gid, Gsrvid]),
            ignore;
        #guild{gvip = Vip} ->
            Vip
    end.

%% @spec get_guild_id(Role)-> {integer(), binary()} | false
%% Role = #role{}
%% @doc 同步调用，获取角色的军团ID
get_guild_id(#role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    {ok, {Gid, Gsrvid}};
get_guild_id(_Role) ->
    {ok, false}.

%% @spec get_role_guild(Role) -> #role_guild{}
%% Role = #role{}
%% @doc 同步调用获取角色军团属性
get_role_guild(#role{guild = Guild}) ->
    {ok, Guild}.

%% @spec join(Role, Guild) -> {ok, true, NewRole} | {ok, false}
%% Role = NewRole = #role{}
%% @doc 用于军团进程同步调用，让角色加入帮会
join(Role = #role{guild = #role_guild{gid = Gid, read = Read, skilled = Skilled, welcome_times = Times}}, Guild) when is_record(Guild, role_guild), Gid =:= 0 ->
    Role1 = Role#role{guild = Guild#role_guild{read = Read, skilled = Skilled, welcome_times = Times}},
    NewRole = guild_role:listener(join, Role1),
    {ok, true, NewRole};
join(_Role, _G) ->
    {ok, false}.

%%---------------------------------------------------------------------------------
%% @spec set(R, {Type, Data}) -> {ok, NewRole} | {ok, true, NewRole} | {ok, false}
%% R = #role{}
%% NewRole = #role{}
%% {Type, Data} = {pid, pid()} | {position, integer()} | {guild, #role_guild{}}
%% @doc 用于军团进程异步调用设置角色的帮会属性
%%--------------------------------------------------------------------------------
%% 设置职位, 异步更新 权限
set(Role, {position, Job}) when Job >= ?guild_disciple, Job =< ?guild_chief ->
    NewRole = guild_role:alters([{position, Job}], Role),
    {ok, NewRole};

%% 取消职位
set(Role, unAppoint) ->
    Role1 = guild_role:alters([{position, ?guild_disciple}], Role),
    NewRole = guild_area:moved(Role1),   %% 检测角色是否坐在宝座上，若有则移出
    map:role_update(NewRole),
    {ok, NewRole};

%% 职位变更
set(Role = #role{lev = Lev}, {change_position, Job, Weal}) ->
    Role1 = guild_area:moved(Role),    %% 检测角色是否坐在宝座上，若有则移出
    NewRole = guild_role:alters([{position, Job}, {salary, guild_mem:salary(Lev, Weal, Job)}], Role1),
    map:role_update(NewRole),
    {ok, NewRole};

%% 更新俸禄值
set(R = #role{guild = #role_guild{position = Job}, lev = Lev}, {weal, Weal}) ->
    NewRole = guild_role:alters([{salary, guild_mem:salary(Lev, Weal, Job)}], R),
    {ok, NewRole};

%% 清除角色领用过的技能
set(Role, clear_skill) ->
    {ok, guild_role:alters([{skilled, 0}], Role)};

%% 清除角色经验俸禄领取状态
set(Role, {claim_exp, Status}) ->
    NewRole = guild_role:alters([{claim_exp, Status}], Role),
    {ok, NewRole};

%% 清除角色经验领用状态，技能领用状态，藏经阁阅读状态
set(Role, clear) ->
    NewRole = guild_role:alters([{claim_exp, ?false}, {skilled, 0}, {read, 0}], Role),
    guild_common:pack_send_notice(NewRole),
    {ok, NewRole};

%% 更新角色军团商城信息
set(Role, {shop_lvlup, NewLvl}) ->
    NewRole = guild_role:alters([{shop_lvlup, NewLvl}], Role),
    {ok, NewRole};

%% 更新角色军团许愿池信息
set(Role, {wish_lvlup, NewLvl}) ->
    NewRole = guild_role:alters([{wish_lvlup, NewLvl}], Role),
    {ok, NewRole};

%% 角色重新进入军团地图, 帮会进程重启
set(Role = #role{event = ?event_guild, name = Rname, pos = #pos{x = X, y = Y}}, {guild_restart, GPid, MapID}) ->
    guild_mem:update(pid, Role),
    case map:role_enter(MapID, X, Y, Role#role{event_pid = GPid}) of
        {false, Reason} ->
            ?ERR("军团进程重启，角色 【~s】 进入新帮会地图失败, 原因【~s】",[Rname, Reason]),
            {ok, Role};
        {ok, NewRole} ->
            {ok, guild_role:alters([{pid, GPid}], NewRole)}
    end;

set(Role, {guild_restart, GPid, _MapID}) ->
    guild_mem:update(pid, Role),
    {ok, guild_role:alters([{pid, GPid}], Role)};

set(Role, _Data) ->
    ?ERR("角色军团属性设置命令错误, Cmd:~w", [_Data]),
    {ok, Role}.

%% @spec order_back_guild(Role) -> {ok} | {ok, NewRole}
%% Role = NewRole = #role{}
%% @doc 队长下令各队员跟随回帮
order_back_guild(Role = #role{name = Rname, team = #role_team{is_leader = ?true}, guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case team_api:get_team_info(Role) of
        {ok, #team{member = Mems}} ->
            GuildID = {Gid, Gsrvid},
            lists:foreach(fun(#team_member{pid = MemPid}) -> catch role:apply(async, MemPid, {guild_api, team_enter_guild, [GuildID]}) end, Mems),
            team_enter_guild(Role, GuildID);
        error ->
            ?ERR("组队回帮时，获取角色 ~s 的队伍信息有误", [Rname]),
            {ok}
    end;
order_back_guild(_Role) ->
    {ok}.

%% @spec team_enter_guild(Role) -> {ok} | {ok, NewRole}
%% Role = NewRole = #role{}
%% @doc 异步调用，队伍成员进入军团领地
team_enter_guild(Role = #role{team = #role_team{follow = ?true}, guild = #role_guild{gid = Gid, srv_id = Gsrvid}}, GuildID) when GuildID =:= {Gid, Gsrvid} ->
    case guild:enter_team(Role) of
        {false, _Reason} ->
            {ok};
        {true, NewRole} ->
            {ok, NewRole}
    end;
team_enter_guild(Role = #role{team = #role_team{follow = ?true}}, _GuildID) ->
    team_api:tempout(Role),
    case guild:enter_team(Role) of
        {false, _Reason2} ->
            {ok};
        {true, NewRole} ->
            {ok, NewRole}
    end;
team_enter_guild(_Role, _GuildID) ->
    {ok}.

%% @spec team_leave_guild(Role) -> {ok} | {ok, NewRole}
%% Role = NewRole = #role{}
%% @doc 异步调用，队伍成员离开军团领地
team_leave_guild(Role) ->
    case guild:leave(team, Role) of
        {false, _Reason} ->
            {ok};
        {true, NewRole} ->
            {ok, NewRole}
    end.

%% @spec sync_to_guild(Role) -> {ok}
%% Role = #role{}
%% @doc 异步调用，军团定时通知成员更新最新数据到帮会
sync_to_guild(Role) ->
    guild_mem:update(guild_role, Role),
    {ok}.

get_guild_lvl(#role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{lev=GLvl} -> GLvl;
        false -> 0
    end.

