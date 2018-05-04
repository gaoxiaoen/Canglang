%%----------------------------------------------------
%% @doc 新帮战系统
%%      本活动一共分idle（闲置），sign（帮派报名），ready（个人进入战区），round（战斗回合），finish（活动结束）这5种状态
%%      idle -> sign -> ready -> round -> finish -> idle
%%
%% @author Jangee@qq.com
%% @end
%%----------------------------------------------------
-module(guild_arena).
-behaviour(gen_fsm).
%% 外部调用接口
-export(
    [
        join/2,
        off/1,
        login/1,
        async_login/2,
        logout/1,
        team_check/3,
        combat_check/2,
        combat_start/1,
        combat_start/2,
        combat_over/3,
        combat_over/4,
        click_elem/2,
        stop_collect/1,
        collect_over/1,
        area_over/1,
        get_info/1,
        can_join/1,
        sort_guild/2,
        sort_role/2,
        get_rank/4,
        get_area_and_round/1,
        get_score_buff/1,
        adm_next/0,
        adm_restart/0,
        adm_stop/0,
        adm_hide/0,
        adm_id/1
    ]).


%% 各状态处理
-export([idle/2, sign/2, ready/2, round/2, finish/2, hide/2]).
%% otp apis
-export([start_link/0]).
-export([init/1, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).

-include("common.hrl").
-include("role.hrl").
-include("looks.hrl").
-include("role_online.hrl").
-include("attr.hrl").
-include("guild.hrl").
-include("map.hrl").
-include("pos.hrl").
-include("link.hrl").
-include("team.hrl").
-include("combat.hrl").
-include("mail.hrl").
-include("guild_arena.hrl").
%%

%% 帮战状态数据
-record(state, 
    {
        id = 0,         %% 第几届
        roles = [],     %% 参战玩家
        guilds = [],     %% 参战帮派
        areas = [],      %% 战区
        role_num = 0,
        guild_num = 0,
        area_num = 0,
        last_winner = 0, %% 上届冠军
        round = 0,       %% 当前是第几轮
        pass_areas = [], %% 已经回收的战区
        lost_guilds = [], %% 被淘汰的帮派
        lost_roles = [],  %% 被淘汰的玩家
        area_id_seed = 1, %% 战区ID初始值
        started = 0,     %% 当前状态开启时间
        robots = [],   %% 机器人列表
        robot_relive = 0 %% 机器人总复活次数
    }).

%% 发给前端的倒计时加上这个秒差吧
-define(guild_arena_push_time_late, -1).
%% 战斗胜利者也有一个保护时间，实际为失败方的保护时间减去这个数
-define(guild_arena_win_protect_time, 0).
%% 参战玩家积分要达到这个数才能发奖励物品给他
-define(guild_arena_base_reward_score, 30).
%% 剩余次数每一次对应的积分
-define(guild_arena_alive_score, 10).
%% 帮战机器人类型ID
-define(guild_arena_robot_id, [22500]).
%% 帮战积分加倍buff
-define(guild_arena_score_buff, guild_arena_score_buff).
%% 失败固定积分
-define(guild_arena_lost_score, 10).
%% 跨服失败固定积分
-define(guild_arena_lost_score_cross, 20).
%% 战胜机器人固定积分
-define(guild_arena_robot_score, 20).
%% 开服前两场积分前六名玩家奖励
-define(guild_arena_rank_role_reward, [{29110, 1, 1}, {29110, 1, 1}, {29110, 1, 1}, {29110, 1, 1}, {29110, 1, 1}, {29110, 1, 1}]).

%% ---------- 外部接口部分 ----------

%% @spec join(guild, Role) -> ok | {false, Why}
%% Role = record(role)
%% Why = atom() = not_in_guild 不在帮派 | no_permission 没有权限 | wrong_level 帮派等级不够 | already_join 已经参加 | wrong_time 不是报名时间
%% @doc 帮主或长老代表帮派参加帮战
join(guild, {Gid, SrvId, Name, Lev, Chief, Num}) ->
    sync_call({guild_join, Gid, SrvId, Name, Lev, Chief, Num});

%% @spec join(role, Role) -> ok | {false, Why}
%% Role = record(role)
%% Why = atom() = wrong_time 无效时间 | not_in_guild 还没进帮派 | already_join 已经参加 | in_team 组队中 | guild_not_join 帮派没有参战 | wrong_event 参与其他事件中 | flying 飞行中
%% @doc 个人进入准备区
join(role, {Id, Pid, Lev, Name, FC, {Gid, SrvId}, GuildName, Position}) ->
    sync_call({role_join, Id, Pid, Lev, Name, FC, {Gid, SrvId}, GuildName, Position, campaign_adm:is_camp_time(guild_arena)});

%% @spec join(to_war_area, Role) -> ok | {false, Why}
%% Role = record(role)
%% Why = atom() = wrong_time 无效时间 | not_in_guild 还没进帮派 | already_join 已经参加 | guild_not_join 帮派没有参战 | wrong_event 参与其他事件中
%% @doc 个人正式战区
join(to_war_area, Rids) ->
    sync_call({to_war_area, Rids}).


%% @spec get_info(all) -> Result
%% Result = record(state)
%% @doc 获取帮战所有状态信息
get_info(all) ->
    sync_call({info, all});

%% @spec get_info(guild_num) -> Result
%% Result = integer()
%% @doc 获取帮战报名帮派总数
get_info(guild_num) ->
    sync_call({info, guild_num});

%% @spec get_info(state_time) -> {Id, StateName, Timeout}
%% Rid = tuple() 玩家ID
%% Id = integer() 当前是第几届
%% StateName = atom() 状态名称
%% Timeout = integer() 距离下个状态还有多少毫秒
%% @doc 获取帮战的当前状态名称和距离下个状态的超时
get_info({state_time, Rid}) ->
    sync_call({info, state_time, Rid});


%% @spec get_info({guilds, Page}) -> {NewPage, Guilds, GuildNum}
%% Page = integer() 要查看的页码
%% NewPage = integer() 实际有效的页码
%% Guilds = list() 对应页的帮派列表
%% GuildNum = integer() 总帮派数
%% @doc 获取参战帮派信息（分页）
get_info({guilds, Page}) when is_integer(Page) ->
    get_page_list(sync_call({info, guilds}), Page, ?guild_arena_list_size);

%% @spec get_info({sign_guilds, Page}) -> {NewPage, Guilds, GuildNum}
%% Page = integer() 要查看的页码
%% NewPage = integer() 实际有效的页码
%% Guilds = list() 对应页的帮派列表
%% GuildNum = integer() 总帮派数
%% @doc 获取参战帮派信息按等级排名（分页）
get_info({sign_guilds, Page}) when is_integer(Page) ->
    get_page_list(sync_call({info, sign_guilds}), Page, ?guild_arena_list_size);

%% @spec get_info({area_guilds, Page, Rid}) -> {NewPage, Guilds, GuildNum}
%% Page = integer() 要查看的页码
%% Rid = tuple() = {integer(), string()} 玩家ID
%% NewPage = integer() 实际有效的页码
%% Guilds = list() 对应页的帮派列表
%% GuildNum = integer() 总帮派数
%% @doc 获取战区帮派信息（分页）
get_info({area_guilds, Page, Rid}) when is_integer(Page) ->
    get_page_list(sync_call({info, guilds, Rid}), Page, ?guild_arena_panel_size);

%% @spec get_info({roles, Page}) -> {NewPage, Roles, RoleNum}
%% Page = integer() 要查看的页码
%% NewPage = integer() 实际有效的页码
%% Roles = list() 对应页的玩家列表
%% RoleNum = integer() 总参战人数
%% @doc 获取参战玩家信息（分页）
get_info({roles, Page}) when is_integer(Page) ->
    get_page_list(sync_call({info, roles}), Page, ?guild_arena_list_size);

%% @spec get_info({area_roles, Page, Rid}) -> {NewPage, Guilds, GuildNum}
%% Page = integer() 要查看的页码
%% Rid = tuple() = {integer(), string()} 玩家ID
%% NewPage = integer() 实际有效的页码
%% Guilds = list() 对应页的帮派列表
%% GuildNum = integer() 总帮派数
%% @doc 获取战区玩家信息（分页）
get_info({area_roles, Page, Rid}) when is_integer(Page) ->
    get_page_list(sync_call({info, roles, Rid}), Page, ?guild_arena_panel_size);

%% @spec get_info({my_rank, Rid}) -> {NewPage, Guilds, GuildNum}
%% Rid = tuple() = {integer(), string()} 玩家ID
%% NewPage = integer() 实际有效的页码
%% Roles = list() 对应页的玩家列表
%% RoleNum = integer() 总帮派数
%% @doc 获取玩家排名所在的页
get_info({my_rank, Rid}) ->
    {RoleNum, Roles} = sync_call({info, roles, Rid}),
    RankNum = get_rank(role, 1, Rid, Roles),
    Page = util:ceil(RankNum / ?guild_arena_list_size),
    get_page_list({RoleNum, Roles}, Page, ?guild_arena_list_size);

%% @spec get_info({my_guild_rank, Gid}) -> {NewPage, Guilds, GuildNum}
%% Gid = tuple() = {integer(), string()} 帮派ID
%% NewPage = integer() 实际有效的页码
%% Guilds = list() 对应页的帮派列表
%% GuildNum = integer() 总帮派数
%% @doc 获取战区玩家信息（分页）
get_info({my_guild_rank, Gid}) ->
    {GuildNum, Guilds} = sync_call({info, guilds}),
    RankNum = get_rank(guild, 1, Gid, Guilds),
    Page = util:ceil(RankNum / ?guild_arena_list_size),
    get_page_list({GuildNum, Guilds}, Page, ?guild_arena_list_size);

%% @spec get_info({mine, Id}) -> {ArenaRole}
%% Id = tuple() 玩家ID
%% ArenaRole = record(guild_arena_role)
%% @doc 获取个人战绩
get_info({mine, Id}) ->
    sync_call({info, mine, Id});

%% @doc 获取指定帮会成员战绩
get_info({guild_member, Gid}) ->
    case ets:match_object(ets_guild_arena_role_cross, #guild_arena_role{gid = Gid, _ = '_'}) of
        [] -> sync_call({info, guild_member, Gid});
        L -> {specify_guild_member_score, L}
    end;

%% @doc 获取指定帮会战绩
get_info({guild, Gid}) ->
    case ets:lookup(ets_guild_arena_guild_cross, Gid) of
        [Guild] -> {specify_guild, Guild};
        _ -> sync_call({info, guild, Gid})
    end;

get_info(_Type) ->
    ?DEBUG("无效参数 ~p", [_Type]).

%% @spec get_info(can_join, Id) -> Result
%% Result = integer()
%% @doc 获取是否可以进入帮战战区
can_join(#role{lev = Lev}) when Lev < ?join_lev_limit ->
    0;
can_join(#role{id = Rid, guild = #role_guild{gid = Gid, srv_id = SrvId}, cross_srv_id = <<"center">>}) ->
    ?CENTER_CALL(guild_arena_center_mgr, can_join, [Rid, {Gid, SrvId}]);
can_join(#role{id = Rid, guild = #role_guild{gid = Gid, srv_id = SrvId}}) ->
    sync_call({can_join, Rid, {Gid, SrvId}});
can_join(_) ->
    0.

%% 获取跨服战区和轮数
get_area_and_round(#role{event = ?event_guild_arena, cross_srv_id = <<"center">>, event_pid = EventPid}) ->
    sync_call(EventPid, get_area_and_round);
get_area_and_round(_) ->
    {0, 0}.


%% @spec get_score_buff(Role) -> Flag
%% Role = record(role)
%% Flag = integer()
%% 检测是否拥有积分加倍
get_score_buff(Role = #role{event = ?event_guild_arena}) ->
    case buff:check_buff(Role, ?guild_arena_score_buff) of
        false -> 0;
        _ -> 1
    end;
get_score_buff(_) -> 0.

%% @spec adm_next() -> ok
%% @doc GM命令进入下一状态
adm_next() ->
    case async_call(admin) of
        ok ->
            ?INFO("新帮战成功进入新的状态");
        _R ->
            ?INFO("新帮战切换状态失败 ~p", [_R])
    end.

%% @spec adm_restart() -> ok
%% @doc GM命令帮战重新开始
adm_restart() ->
    case async_call(admin_restart) of
        ok ->
            ?INFO("新帮战启动成功");
        _R ->
            ?INFO("新帮战启动失败 ~p", [_R])
    end.

%% @spec adm_stop() -> ok
%% @doc GM命令帮战终止
adm_stop() ->
    case async_call(admin_stop) of
        ok ->
            ?INFO("新帮战成功终止");
        _R ->
            ?INFO("新帮战终止失败 ~p", [_R])
    end.

%% @spec adm_hide() -> ok
%% @doc GM命令把帮战隐藏起来
adm_hide() ->
    case async_call(admin_hide) of
        ok ->
            ?INFO("新帮战成功隐藏");
        _R ->
            ?INFO("新帮战隐藏失败 ~p", [_R])
    end.

%% @spec adm_id(Id) -> ok
%% @doc GM命令设定当前帮战的届次
adm_id(Id) when is_integer(Id) ->
    case async_call({admin_id, Id}) of
        ok ->
            ?INFO("新帮战设置届次成功");
        _R ->
            ?INFO("新帮战设置届次失败 ~p", [_R])
    end;
adm_id(_Id) ->
    ?DEBUG("无效参数 ~p", [_Id]).

%% @spec off(Role) -> ok
%% Role = record(role)
%% @doc 玩家退出帮战
off(#role{team_pid = TeamPid, event = ?event_guild_arena}) when is_pid(TeamPid) ->
    {false, in_team};
off(#role{id = Id, event = ?event_guild_arena, pid = Pid, event_pid = EventPid, cross_srv_id = <<"center">>}) when is_pid(EventPid) ->
    async_call(EventPid, {off, Id}),
    send_role_off_map(Pid),
    ok;
off(#role{id = Id, event = ?event_guild_arena, pid = Pid}) ->
    async_call({off, Id}),
    send_role_off_map(Pid),
    ok;
off(_R) ->
    ok.

%% @spec login(Role) -> NewRole
%% Role = NewRole = record(role)
%% @doc 玩家登陆时做相关处理
login(Role =  #role{lev = Lev}) when Lev < ?join_lev_limit ->
    Role;
login(Role =  #role{guild = #role_guild{gid = 0}}) ->
    Role;
login(Role =  #role{id = Id, pid = Pid, guild = #role_guild{gid = Gid, srv_id = SrvId}, cross_srv_id = <<"center">>, event = Event, pos = Pos, looks = Looks}) ->
    async_call({winner_login, Pid}),
    case center:is_connect() of
        {true, _} ->
            ?CENTER_CAST(guild_arena_center_mgr, login, [{Id, Pid, {Gid, SrvId}}]),
            Role;
        _ ->
            case {Event, Pos} of
                {?event_guild_arena, _} ->
                    {MapId, X, Y} = ?leave_guild_arena_point,
                    NewLooks = lists:keydelete(?LOOKS_TYPE_ALPHA, 1, Looks),
                    Role#role{event = ?event_no, event_pid = 0, pos = #pos{map = MapId, x = X, y = Y}, looks = NewLooks};
                %% 由于某些原因导致人物在帮派领地，但event不对的就在这里恢复下
                {?event_no, #pos{map_base_id = OldMap}} when OldMap =:= 31002 orelse OldMap =:= 31001 ->
                    Role#role{event = ?event_guild};
                _ -> 
                    Role
            end
    end;
login(Role =  #role{id = Id, pid = Pid, guild = #role_guild{gid = Gid, srv_id = SrvId}}) ->
    async_call({login, Id, Pid, {Gid, SrvId}}),
    Role;
login(Role) ->
    Role.

%%  异步登录处理
async_login(Role =  #role{pos = Pos, event = Event, looks = Looks}, LoginData) ->
    NR = case LoginData of
        [ok, round, Map, EventPid] when Map =/= 0 andalso is_pid(EventPid) -> 
            %% 如果已经开战，就不能再停留在准备区
            case {Pos, Event} of
                {#pos{map_base_id = ?guild_arena_ready_map}, ?event_guild_arena} ->
                    {MapId, NewX, NewY} = get_enter_point(Map, ok, ok),
                    Role#role{event_pid = EventPid, pos = #pos{map = MapId, x = NewX, y = NewY}};
                _ ->
                    ?DEBUG("位置信息 ~w", [Pos]),
                    Role#role{event_pid = EventPid}
            end;
        [ok, _, _, EventPid] when is_pid(EventPid) -> 
            Role#role{event_pid = EventPid};
        %% 阵亡还在战区中
        [dead, EventPid] when Event =:= ?event_guild_arena andalso is_pid(EventPid) -> 
            NewLooks = case lists:keyfind(?LOOKS_TYPE_ALPHA, 1, Looks) of
                false -> [{?LOOKS_TYPE_ALPHA, 0, ?LOOKS_VAL_ALPHA_ARENA} | Looks];
                _Other -> lists:keyreplace(?LOOKS_TYPE_ALPHA, 1, Looks, {?LOOKS_TYPE_ALPHA, 0, ?LOOKS_VAL_ALPHA_ARENA})
            end,
            Role#role{looks = NewLooks, event_pid = EventPid};

        %% 在中央服时，会默认来到一次这里保证称号和buff领到
        [winner_login, Winner] ->
            ?DEBUG("winner_login"),
            login_buff_honor(Role, Winner);

        %% 本服部分
        [ok, Winner, round, Map, EventPid] when Map =/= 0 -> 
            %% 如果已经开战，就不能再停留在准备区
            case {Pos, Event} of
                {#pos{map_base_id = ?guild_arena_ready_map}, ?event_guild_arena} ->
                    {MapId, NewX, NewY} = get_enter_point(Map, ok, ok),
                    login_buff_honor(Role#role{event_pid = EventPid, pos = #pos{map = MapId, x = NewX, y = NewY}}, Winner);
                _ ->
                    ?DEBUG("位置信息 ~w", [Pos]),
                    login_buff_honor(Role#role{event_pid = EventPid}, Winner)
            end;
        [ok, Winner, _, _, EventPid] -> 
            login_buff_honor(Role#role{event_pid = EventPid}, Winner);
        %% 阵亡还在战区中
        [dead, Winner] when Event =:= ?event_guild_arena -> 
            NewLooks = case lists:keyfind(?LOOKS_TYPE_ALPHA, 1, Looks) of
                false -> [{?LOOKS_TYPE_ALPHA, 0, ?LOOKS_VAL_ALPHA_ARENA} | Looks];
                _Other -> lists:keyreplace(?LOOKS_TYPE_ALPHA, 1, Looks, {?LOOKS_TYPE_ALPHA, 0, ?LOOKS_VAL_ALPHA_ARENA})
            end,
            login_buff_honor(Role#role{looks = NewLooks}, Winner);
        %% 其他情况特别处理
        [_R, Winner] ->
            ?DEBUG("login data ~w", [LoginData]),
            NewRole = case {Event, Pos} of
                {?event_guild_arena, _} ->
                    case apply_leave_map(Role, ?leave_guild_arena_point) of
                        {ok, Role1} -> Role1;
                        _ -> Role
                    end;
                %% 由于某些原因导致人物在帮派领地，但event不对的就在这里恢复下
                {?event_no, #pos{map_base_id = OldMap}} when OldMap =:= 31002 orelse OldMap =:= 31001 ->
                    Role#role{event = ?event_guild};
                _Else -> 
                    ?DEBUG("未知的状态~w", [_Else]),
                    Role
            end,
            login_buff_honor(NewRole, Winner);
        _Else ->
            ?DEBUG("未知的状态~w", [_Else]),
            case {Event, Pos} of
                {?event_guild_arena, _} ->
                    case apply_leave_map(Role, ?leave_guild_arena_point) of
                        {ok, Role1} -> Role1;
                        _ -> Role
                    end;
                %% 由于某些原因导致人物在帮派领地，但event不对的就在这里恢复下
                {?event_no, #pos{map_base_id = OldMap}} when OldMap =:= 31002 orelse OldMap =:= 31001 ->
                    Role#role{event = ?event_guild};
                _ -> 
                    Role
            end
    end,
    {ok, NR}.

%% @spec logout(Role) -> ok
%% Role = record(role)
%% @doc 玩家退出帮战
logout(#role{id = Id, event = ?event_guild_arena, event_pid = EventPid}) when is_pid(EventPid) ->
    async_call(EventPid, {off, Id});
logout(#role{id = Id, event = ?event_guild_arena}) ->
    async_call({off, Id});
logout(_R) ->
    ok.

%% @spec team_check(Role, Rid) -> ok | {false, Why}
%% Attacker = record(role)
%% Why = string()
%% @doc 检查开战者是否可以和对方组队
team_check(#role{event = ?event_guild_arena, id = MRid, cross_srv_id = <<"center">>, event_pid = EventPid}, Rid, ?event_guild_arena) ->
    sync_call(EventPid, {team_check, [MRid, Rid]});
team_check(#role{event = ?event_guild_arena, id = MRid}, Rid, ?event_guild_arena) ->
    sync_call({team_check, [MRid, Rid]});
team_check(#role{event = ?event_guild_arena}, _, _Event) ->
    {false, ?L(<<"组队失败，对方没有参加帮战">>)};
team_check(#role{event = _Event}, _, ?event_guild_arena) ->
    {false, ?L(<<"组队失败，你没有参加帮战">>)};
team_check(_A, _D, _E) ->
    ok.

%% @spec combat_check(Attacker, Defender) -> ok | wrong_time | {false, Why}
%% Attacker = Defender = record(role)
%% Why = string()
%% @doc 检查开战者是否符合开战资格
combat_check(#role{guild = #role_guild{gid = Gid, srv_id = SrvId}}, #role{guild = #role_guild{gid = Gid, srv_id = SrvId}}) ->
    {false, ?L(<<"不能对自己弟兄动手呐">>)};
%% 跨服
combat_check(#role{event = ?event_guild_arena, id = ARid, event_pid = EventPid, cross_srv_id = <<"center">>}, #role{event = ?event_guild_arena, id = DRid, event_pid = EventPid}) ->
    sync_call(EventPid, {combat_check, [ARid, DRid]});
combat_check(#role{event = ?event_guild_arena, id = ARid}, #role{event = ?event_guild_arena, id = DRid}) ->
    sync_call({combat_check, [ARid, DRid]});
%% 与机器打
combat_check(#role{id = {Id, SrvId}, cross_srv_id = <<"center">>, event_pid = EventPid}, NpcId) when is_integer(NpcId) ->
    case lists:member(NpcId, ?guild_arena_robot_id) of
        true ->
            sync_call(EventPid, {combat_robot_check, {Id, SrvId}});
        _ ->
            {false, ?L(<<"发起战斗失败">>)}
    end;
combat_check(#role{id = {Id, SrvId}}, NpcId) when is_integer(NpcId) ->
    case lists:member(NpcId, ?guild_arena_robot_id) of
        true ->
            sync_call({combat_robot_check, {Id, SrvId}});
        _ ->
            {false, ?L(<<"发起战斗失败">>)}
    end;
combat_check(_A, _D) ->
    {false, ?L(<<"发起战斗失败">>)}.

%% @spec combat_start(FighterIds) -> ok
%% FighterIds = list() = [Id | _]
%% Id = tuple() = {integer(), string()} 玩家ID
%% @doc 开战前要处理的一些东西
combat_start(Fighters) ->
    async_call({combat_start, Fighters}).

combat_start(EventPid, Fighters) ->
    async_call(EventPid, {combat_start, Fighters}).

%% @spec combat_over(_P, Winner, Loser) -> ok
%% _P = 0 | pid()
%% Winner = Loser = list() = [record(fighter) | _])
%% @doc 玩家战斗结果
combat_over(_P, [], []) ->
    ok;
%% 与机器打
combat_over(robot, Winner, Loser) ->
    case Winner of
        %% 机器人赢了
        [#fighter{type = ?fighter_type_npc, name = Name}] ->
            %% 失败者每人固定得10分
            NewLoser = [{{LoserId, LoserSrvId}, calc_buff_score(?guild_arena_lost_score, GLflag), lost, ?true} || #fighter{rid = LoserId, srv_id = LoserSrvId, gl_flag = GLflag} <- Loser],
            async_call({combat_over, [], NewLoser, [{0, <<>>, Name}], []});
        %% 玩家赢了
        [#fighter{type = ?fighter_type_role} | _] ->
            %% 战胜机器人没人固定得20分
            NewWinner = [{{WinId, WinSrvId}, calc_buff_score(?guild_arena_robot_score, GLflag), win, IsDie} || #fighter{rid = WinId, srv_id = WinSrvId, is_die = IsDie, gl_flag = GLflag} <- Winner],
            async_call({combat_over, NewWinner, [], [], []}),
            case Loser of
                [#fighter{type = ?fighter_type_npc, rid = NpcId}] ->
                    async_call({combat_robot_over, NpcId});
                _ -> ok
            end;
        _ ->
            ?DEBUG("未知的战斗数据winner: ~w loser: ~w", [Winner, Loser])
    end;
%% 与人打
combat_over(EventPid, Winner, Loser) when is_pid(EventPid) ->
    %% 胜利积分计算：(30 ~ 120) = ((5000 - 战斗力差) * 6 / 500)
    F = fun(WFC) ->
            ScoreL = [min(120, max(30, round((5000 - (WFC - LFC)) * 6 div 500))) || #fighter{attr = #attr{fight_capacity = LFC}} <- Loser],
            lists:sum(ScoreL)
    end,
    %% 两人平均分
    WinScore = round(lists:sum([F(FC) || #fighter{attr = #attr{fight_capacity = FC}} <- Winner]) / max(1, length(Winner))),
    NewWinner = [{{WinId, WinSrvId}, calc_buff_score(WinScore, GLflag), win, IsDie} || #fighter{rid = WinId, srv_id = WinSrvId, is_die = IsDie, gl_flag = GLflag} <- Winner],
    %% 失败者每人固定得20分
    NewLoser = [{{LoserId, LoserSrvId}, calc_buff_score(?guild_arena_lost_score_cross, GLflag2), lost, ?true} || #fighter{rid = LoserId, srv_id = LoserSrvId, gl_flag = GLflag2} <- Loser],
    %% 对手名字记下来
    WinnerNames = [{Wid, Wsrv, WName} || #fighter{rid = Wid, srv_id = Wsrv, name = WName} <- Winner],
    LoserNames = [{Lid, Lsrv, LName} || #fighter{rid = Lid, srv_id = Lsrv, name = LName} <- Loser],
    async_call(EventPid,{combat_over, NewWinner, NewLoser, WinnerNames, LoserNames});
combat_over(_EventPid, Winner, Loser) ->
    %% 胜利积分计算：(l2 ~ 60) = ((5000 - 战斗力差) * 3 / 500)
    F = fun(WFC) ->
            ScoreL = [min(60, max(12, round((5000 - (WFC - LFC)) * 3 div 500))) || #fighter{attr = #attr{fight_capacity = LFC}} <- Loser],
            lists:sum(ScoreL)
    end,
    %% 两人平均分
    WinScore = round(lists:sum([F(FC) || #fighter{attr = #attr{fight_capacity = FC}} <- Winner]) / max(1, length(Winner))),
    NewWinner = [{{WinId, WinSrvId}, calc_buff_score(WinScore, GLflag), win, IsDie} || #fighter{rid = WinId, srv_id = WinSrvId, is_die = IsDie, gl_flag = GLflag} <- Winner],
    %% 失败者每人固定得10分
    NewLoser = [{{LoserId, LoserSrvId}, calc_buff_score(?guild_arena_lost_score, GLflag2), lost, ?true} || #fighter{rid = LoserId, srv_id = LoserSrvId, gl_flag = GLflag2} <- Loser],
    %% 对手名字记下来
    WinnerNames = [{Wid, Wsrv, WName} || #fighter{rid = Wid, srv_id = Wsrv, name = WName} <- Winner],
    LoserNames = [{Lid, Lsrv, LName} || #fighter{rid = Lid, srv_id = Lsrv, name = LName} <- Loser],
    async_call({combat_over, NewWinner, NewLoser, WinnerNames, LoserNames}).

%% 有裁判
combat_over(_E, _P, [], []) ->
    ok;
%% 与机器打
combat_over(EventPid, robot, Winner, Loser) ->
    case Winner of
        %% 机器人赢了
        [#fighter{type = ?fighter_type_npc, name = Name}] ->
            %% 失败者每人固定得10分
            NewLoser = [{{LoserId, LoserSrvId}, calc_buff_score(?guild_arena_lost_score, GLflag), lost, ?true} || #fighter{rid = LoserId, srv_id = LoserSrvId, gl_flag = GLflag} <- Loser],
            async_call(EventPid, {combat_over, [], NewLoser, [{0, <<>>, Name}], []});
        %% 玩家赢了
        [#fighter{type = ?fighter_type_role} | _] ->
            %% 战胜机器人没人固定得20分
            NewWinner = [{{WinId, WinSrvId}, calc_buff_score(?guild_arena_robot_score, GLflag), win, IsDie} || #fighter{rid = WinId, srv_id = WinSrvId, is_die = IsDie, gl_flag = GLflag} <- Winner],
            async_call(EventPid, {combat_over, NewWinner, [], [], []}),
            case Loser of
                [#fighter{type = ?fighter_type_npc, rid = NpcId}] ->
                    async_call({combat_robot_over, NpcId});
                _ -> ok
            end;
        _ ->
            ?DEBUG("未知的战斗数据winner: ~w loser: ~w", [Winner, Loser])
    end.

%% @spec click_elem(Role, MapElem) -> {ok} | {false, Why}
%% Role = record(role)
%% MapElem = record(map_elem)
%% 玩家开始采集仙石
click_elem(_Role, _MapElem) ->
    {false, ?L(<<"采集仙石失败">>)}.

%% @spec collect_over(Rids) -> ok
%% Rids = list() = [Rid | _]
%% Rid = tuple() = {integer(), string()} 玩家ID
%% @doc 玩家采集仙石结果
collect_over(Rids) ->
    async_call({collect_over, Rids}).

%% @spec stop_collect(Role) -> ok
%% Role = record(role)
%% @doc 取消一个玩家的采集运动
stop_collect(_) ->
    ok.

%% @spec area_over(Rid) -> ok
%% Rid = tuple() = {integer(), string()} 玩家ID
%% @doc 一个战区的比赛结束，该评选优胜者
area_over(Aid) ->
    async_call({area_over, Aid}).

%% ----- otp接口部分 ------

start_link()->
    gen_fsm:start_link({global, ?MODULE}, ?MODULE, [], []).

%% 启动初始化后立即进入空闲状态吧
init([])->
    ?DEBUG("新帮战进入 ~p 状态", [idle]),
    State = case init_db() of
        [OldData | _] ->
            case OldData of
            #state{id = Id, last_winner = LastWinner, lost_guilds = LostGuilds, lost_roles = LostRoles} when is_integer(Id) -> 
                erlang:send_after(1000, self(), save_db),
                #state{id = Id + 1, round = 0, last_winner = LastWinner, lost_guilds = LostGuilds, lost_roles = LostRoles};
            _ ->
                erlang:send_after(1000, self(), load_db),
                #state{id = 1, round = 0}
        end;
        _S -> 
            ?DEBUG("新帮战异常初始化数据 ~w 状态", [_S]),
            erlang:send_after(1000, self(), load_db),
            #state{id = 1, round = 0}
    end,
    {ok, idle, State, timeout(idle, State)}.

%% GM命令进入下个状态
handle_event(admin, StateName, State) ->
    ?MODULE:StateName(timeout, State);

%% GM命令帮战重新开始
handle_event(admin_restart, _, State) ->
    finish(timeout, State),
    idle(timeout, State);

%% GM命令帮战终止
handle_event(admin_stop, _, State) ->
    finish(timeout, State);

%% GM命令把帮战隐藏起来
handle_event(admin_hide, _, State) ->
    hide(timeout, State);

%% GM命令更改当前帮战届次
handle_event({admin_id, Id}, StateName, State) ->
    {next_state, StateName, State#state{id = Id}, timeout(StateName, State)};

%% 玩家退出帮战,对应帮派总战斗力减少,参战总人数减少
%% 只在战斗期间和准备期间要处理下数据，其他阶段忽略
handle_event({off, _Id}, sign, State) ->
    {next_state, sign, State, timeout(sign, State)};
%% 退出帮战如果不是已阵亡的人退出帮战要看看他的帮派是否已阵亡
handle_event({off, Id}, StateName, State = #state{roles = Roles, guilds = Guilds, role_num = RoleNum, areas = Areas}) ->
    {NewRoles, NewGuilds, NewRoleNum, NewAreas2} = case lists:keyfind(Id, #guild_arena_role.id, Roles) of
        %% 要确定下个人是否已经参战
        ArenaRole = #guild_arena_role{gid = Gid} ->
            %% 帮派要参战才有继续处理的必要
            {ArenaGuilds, NewAreas1} = case lists:keyfind(Gid, #arena_guild.id, Guilds) of
                ArenaGuild = #arena_guild{id = Gid} ->
                    {NewArenaGuild, NewAreas} = role_off(StateName, ArenaGuild, ArenaRole, Areas),
                    {
                        lists:keyreplace(Gid, #arena_guild.id, Guilds, NewArenaGuild),
                        NewAreas
                    };
                _ -> {Guilds, Areas}
            end,
            %% 确保下两组返回值个数统一吧
            {
                lists:keyreplace(Id, #guild_arena_role.id, Roles, ArenaRole#guild_arena_role{offline = 1}),
                ArenaGuilds, 
                RoleNum - 1, 
                NewAreas1
            };
        _ -> {Roles, Guilds, RoleNum, Areas}
    end,
    NewState = State#state{
        roles = NewRoles, 
        guilds = NewGuilds, 
        areas = NewAreas2,
        role_num = NewRoleNum
    },
    {next_state, StateName, NewState, timeout(StateName, State)};

%% TODO 战前要处理的一些数据，目前会有中断采集相关操作
handle_event({combat_start, Fighters}, StateName, State = #state{roles = Roles}) ->
    F = fun(Id, Rs) ->
            case lists:keyfind(Id, #guild_arena_role.id, Rs) of
                Role = #guild_arena_role{id = Id} ->
                    lists:keyreplace(Id, #guild_arena_role.id, Rs, Role#guild_arena_role{is_fighting = 1});
                _ -> Rs
            end
    end,
    NewRoles = lists:foldl(F, Roles, Fighters),
    {next_state, StateName, State#state{roles = NewRoles}, timeout(StateName, State)};

%% 战斗结束后记录结果(这里不做计算，只是做记录和排序)
handle_event({combat_over, [], [], _, _}, round, State) ->
    ?DEBUG("收到战斗双方均为空的数据"),
    {next_state, round, State, timeout(round, State)};
handle_event({combat_over, Winner, Loser, WinnerNames, LoserNames}, round, State = #state{areas = [Area], roles = Roles, guilds = Guilds}) ->
    _StMs = util:unixtime(ms),
    %% 全部写在一句里是有点坑爹，这里其实是先处理好失败者在处理胜利者
    {NewArenaArea, NewRoles, NewArenaGuilds, _W, _L} = lists:foldl(fun calc_score/2, lists:foldl(fun calc_score/2, {Area, Roles, Guilds, WinnerNames, LoserNames}, Loser), Winner),
    %% 在这里通知战区刷新下数据
    PushData = sort_guild(score, NewArenaGuilds),
    push_to_area(area_guilds, {Area#arena_area.id, PushData, NewRoles}),
    ?DEBUG("time used ~p", [util:unixtime(ms) - _StMs]),
    {next_state, round, State#state{areas = [NewArenaArea], roles = NewRoles, guilds = NewArenaGuilds}, timeout(round, State)};
handle_event({combat_over, _, _, _, _}, StateName, State) ->
    {next_state, StateName, State, timeout(StateName, State)};

%% 机器人阵亡后的处理
handle_event({combat_robot_over, NpcId}, round, State = #state{robot_relive = RobotRelive, robots = Robots, areas = [#arena_area{map = {_, MapId}}]}) ->
        NewRelive = RobotRelive - 1,
        ?DEBUG("npcd id ---------------> ~w", [NpcId]),
        NewRobots = case NewRelive rem ?guild_arena_role_max_die of
            0 -> lists:delete(NpcId, Robots);
            _ -> 
                create_robot(?guild_arena_robot_id, MapId, 1, lists:delete(NpcId, Robots))
        end,
    {next_state, round, State#state{robots = NewRobots, robot_relive = NewRelive}, timeout(round, State)};
handle_event({combat_robot_over, _}, StateName, State) ->
    {next_state, StateName, State, timeout(StateName, State)};


%% 某战区比赛提前结束（战区被清场）
%% 只有一个战区的时候就直接结束所有比赛
handle_event({area_over, _Aid}, round, State = #state{id = Id, areas = [Area], roles = Roles, round = Round, guilds = Guilds, last_winner = OldWinner}) ->
    Timeout = ?guild_arena_rest_interval,
    Started = util:unixtime(ms),
    %% 终止所有采集活动
    %% guild_arena_area:stop_areas(),
    %% 每一轮结束到这里要找出胜利者
    NewAreas = find_area_winner([Area], [], Guilds, Round),
    ?DEBUG("新帮战提前进入 ~p 状态", [finish]),
    push_to_onlines(state_time, {Id, idle, ?guild_arena_rest_interval}),
    Winner = case NewAreas of
        [#arena_area{winner = WinGid}] -> WinGid;
        _ -> 0
    end,
    %% 上届胜利者去掉buff和称号
    case OldWinner of
        0 -> ok;
        %% 如果是同一个帮派就不用处理了
        Winner -> ok;
        _ -> 
            handle_buff(del, OldWinner),
            handle_honor(del, OldWinner)
    end,
    {NewRoles, NewGuilds} = round_push_and_reward(Id, {Round, finish}, NewAreas, Roles, Guilds),
    NewState = State#state{
        started = Started, 
        areas = NewAreas, 
        last_winner = Winner, 
        roles = NewRoles, 
        guilds = NewGuilds
    },
    {next_state, finish, NewState, Timeout};
handle_event({area_over, _}, StateName, State) ->
    {next_state, StateName, State, timeout(StateName, State)};

%% 重新登录时要注册下
handle_event({login, _Rid, Pid, _Gid}, StateName, State = #state{last_winner = LastWinner}) when StateName =:= idle orelse StateName =:= sign orelse StateName =:= finish ->
    role:apply(async, Pid, {?MODULE, async_login, [[wrong_time, LastWinner]]}),
    {next_state, StateName, State, timeout(StateName, State)};
handle_event({login, Rid, Pid, Gid}, StateName, State = #state{guilds = Guilds, roles = Roles, areas = Areas, last_winner = LastWinner}) ->
    %% 先看看帮派有没参战
    {Reply, NewRoles, NewGuilds, NewAreas2} = case lists:keyfind(Gid, #arena_guild.id, Guilds) of
        false -> 
            {[guild_not_join, LastWinner], Roles, Guilds, Areas};
        %% 再看看自己是否已经参战
        ArenaGuild = #arena_guild{die = MDie, join_num = JoinNum} -> 
            case lists:keyfind(Rid, #guild_arena_role.id, Roles) of
                %% 已经阵亡的话，就不需要处理什么，否则就阵亡人数减一
                ArenaRole = #guild_arena_role{die = RDie, aid = Aid} ->
                    {Res, NewMDie, NewAreas, NewAid} = case RDie >= ?guild_arena_role_max_die of
                        true -> 
                            {[dead, LastWinner], MDie, Areas, Aid};
                        _ -> 
                            %% 如果之前的帮派被判断为阵亡的话要让他复活
                            NewAreas1 = case MDie >= JoinNum of
                                true ->
                                    case Areas of
                                        [Area = #arena_area{guild_die = GuildDead}] ->
                                            [Area#arena_area{guild_die = GuildDead - 1}];
                                        _ -> 
                                            Areas
                                    end;
                                _ ->
                                    Areas
                            end,
                            %% 防止已经开战了重新登录的玩家还在准备区，这里返回状态给调用方对比
                            case NewAreas1 of
                                [#arena_area{map = Map1, id = AreaId} | _] ->
                                    {[ok, LastWinner, StateName, Map1, self()], max(0, MDie - 1), NewAreas1, AreaId};
                                _ ->
                                    {[ok, LastWinner, StateName, 0, self()], max(0, MDie - 1), NewAreas1, Aid}
                            end
                    end,
                    NewArenaRole = ArenaRole#guild_arena_role{pid = Pid, offline = 0, aid = NewAid},
                    NewArenaGuild = ArenaGuild#arena_guild{die = NewMDie},
                    {
                        Res, 
                        lists:keyreplace(Rid, #guild_arena_role.id, Roles, NewArenaRole), 
                        lists:keyreplace(Gid, #arena_guild.id, Guilds, NewArenaGuild), 
                        NewAreas
                    };
                _ -> {[not_in, LastWinner], Roles, Guilds, Areas}
            end
    end,
    role:apply(async, Pid, {?MODULE, async_login, [Reply]}),
    {next_state, StateName, State#state{roles = NewRoles, guilds = NewGuilds, areas = NewAreas2}, timeout(StateName, State)};

%% 登录处理称号
handle_event({winner_login, Pid}, StateName, State = #state{last_winner = LastWinner}) ->
    Reply = [winner_login, LastWinner],
    role:apply(async, Pid, {?MODULE, async_login, [Reply]}),
    {next_state, StateName, State, timeout(StateName, State)};

handle_event(_Event, StateName, State) ->
    ?DEBUG("unkown event ~w ~w ~n", [_Event, StateName]),
    {next_state, StateName, State, timeout(StateName, State)}.

%% 帮派报名,参战帮派数增加
%% 在报名期间才可以
handle_sync_event({guild_join, Id, SrvId, Name, Lev, Chief, Num}, _From, sign, State = #state{guilds = Guilds, guild_num = GuildNum}) ->
    {Reply, NewGuilds, NewGuildNum} = case lists:keyfind({Id, SrvId}, #arena_guild.id, Guilds) of
        false -> 
            Map = case map_mgr:create(?guild_arena_ready_map) of 
                {ok, Pid, Mid} ->
                    {Pid, Mid};
                _ ->
                    ?ERR("启动新帮战战区失败：map_base_id = ~w", [?guild_arena_area_map]),
                    {0, 0}
            end,
            ArenaGuild = #arena_guild{id = {Id, SrvId}, lev = Lev, name = Name, chief = Chief, member_num = Num, aid = Map},
            push_to_onlines(guild_num, {GuildNum + 1}),
            {ok, [ArenaGuild | Guilds], GuildNum + 1};
        _ -> {already_join, Guilds, GuildNum}
    end,
    {reply, Reply, sign, State#state{guilds = NewGuilds, guild_num = NewGuildNum}, timeout(sign, State)};
%% 帮派只能在报名阶段进行报名
handle_sync_event({guild_join, _Id, _SrvId, _Name, _Lev, _Chief, _Num}, _From, StateName, State) ->
    {reply, wrong_time, StateName, State, timeout(StateName, State)};

%% 个人进入准备区,对应帮派战斗力增加,参战总人数增加
%% 准备阶段已报名帮派的玩家可以选择进入准备区
handle_sync_event({role_join, Rid, Pid, Lev, Name, FC, Gid, GuildName, Position, IsCampAdmTime}, _From, ready, State = #state{guilds = Guilds, roles = Roles, role_num = RoleNum, lost_guilds = LostGuilds}) ->
    {Reply, NewRoles, NewGuilds, NewRoleNum} = case lists:keyfind(Gid, #arena_guild.id, Guilds) of
        %% 帮派已经报名了，这里就把人数给上了
        ArenaGuild = #arena_guild{fc = GuildFC, members = Members, join_num = JoinNum, aid = Aid, die = MDie} -> 
            case lists:keyfind(Rid, #guild_arena_role.id, Roles) of
                false ->
                    ArenaRole = #guild_arena_role{id = Rid, pid = Pid, lev = Lev, name = Name, gid = Gid, fc = FC, guild_name = GuildName, position = Position, aid = Aid, is_camp_adm_time = IsCampAdmTime},
                    send_role_to_map(ArenaRole),
                    NewArenaGuild = ArenaGuild#arena_guild{fc = GuildFC + FC, join_num = JoinNum + 1, members= [Rid | Members]},
                    {ok, [ArenaRole | Roles], lists:keyreplace(Gid, #arena_guild.id, Guilds, NewArenaGuild), RoleNum + 1};
                %% 如果已经在帮战里面就要区分下是否离线吧
                ArenaRole = #guild_arena_role{die = RDie} ->
                    NewArenaRole = ArenaRole#guild_arena_role{aid = Aid, pid = Pid, offline = 0},
                    send_role_to_map(NewArenaRole),
                    NewMDie = case RDie >= ?guild_arena_role_max_die of
                        true -> MDie;
                        _ -> MDie - 1
                    end,
                    NewArenaGuild = ArenaGuild#arena_guild{fc = GuildFC, die = NewMDie},
                    {ok, lists:keyreplace(Rid, #guild_arena_role.id, Roles, NewArenaRole), lists:keyreplace(Gid, #arena_guild.id, Guilds, NewArenaGuild), RoleNum}
            end;
        _ -> 
            %% 看看是没报名还是被淘汰了
            case lists:keyfind(Gid, #arena_guild.id, LostGuilds) of
                false ->
                    {guild_not_join, Roles, Guilds, RoleNum};
                _ ->
                    {guild_lost, Roles, Guilds, RoleNum}
            end
    end,
    {reply, Reply, ready, State#state{roles = NewRoles, guilds = NewGuilds, role_num = NewRoleNum}, timeout(ready, State)};
handle_sync_event({role_join, _Rid, _Pid, _Lev, _Name, _FC, _Gid, _GuildName, _Position, _IsCampAdmTime}, _From, StateName, State) ->
    {reply, wrong_time, StateName, State, timeout(StateName, State)};

%% 正式开战阶段个人进入战场
handle_sync_event({to_war_area, Rids}, _From, round, State = #state{areas = [#arena_area{id = Aid, map = Map, guild_points = GuildPoints}], roles = Roles}) ->
    %% 预设一个随机点
    EnterPoint = get_enter_point(Map, 0, GuildPoints),
    F = fun ({Rid, Pid}, {Res, Rs}) ->
            case lists:keyfind(Rid, #guild_arena_role.id, Rs) of
                %% 如果已经在帮战里面就要区分下是否离线吧
                ArenaRole = #guild_arena_role{id = Rid, offline = 0} ->
                    NewArenaRole = ArenaRole#guild_arena_role{aid = Aid, pid = Pid, offline = 0},
                    send_role_to_map(NewArenaRole, EnterPoint),
                    {Res, lists:keyreplace(Rid, #guild_arena_role.id, Rs, NewArenaRole)};
                %% 只能从准备区进入
                _ ->
                    {Res, Rs}
            end
    end,
    {Reply, NewRoles} = lists:foldl(F, {ok, Roles}, Rids),
    {reply, Reply, round, State#state{roles = NewRoles}, timeout(round, State)};
handle_sync_event({to_war_area, _Rids}, _From, StateName, State) ->
    {reply, wrong_time, StateName, State, timeout(StateName, State)};


%% 检查是否可以进入战区
%% 已报名帮派的玩家可以选择进入战场
%% 其他冷却和报名阶段不能进入
handle_sync_event({can_join, _, _}, _From, StateName, State) when StateName =:= idle orelse StateName =:= sign ->
    {reply, 0, StateName, State, timeout(StateName, State)};
handle_sync_event({can_join, Rid, Gid}, _From, StateName, State = #state{guilds = Guilds, roles = Roles}) ->
    Reply = case lists:keyfind(Gid, #arena_guild.id, Guilds) of
        false -> 0;
        #arena_guild{id = Gid} when StateName =:= ready -> 1;
        _ ->
            case lists:keyfind(Rid, #guild_arena_role.id, Roles) of
                #guild_arena_role{id = Rid} -> 2;
                false -> 0
            end
    end,
    {reply, Reply, StateName, State, timeout(StateName, State)};

%% 检查是否可以开战
handle_sync_event({combat_check, FighterIds}, _From, round, State = #state{roles = Roles, areas = Areas}) ->
    Reply = check_fighters(FighterIds, Roles, Areas),
    {reply, Reply, round, State, timeout(round, State)};
handle_sync_event({combat_check, _}, _From, StateName, State) ->
    {reply, {false, ?L(<<"现在不是动手时间，不能发起战斗">>)}, StateName, State, timeout(StateName, State)};

%% 检查是否可以与机器人开战
handle_sync_event({combat_robot_check, Rid}, _From, round, State = #state{roles = Roles, robots = Robots, robot_relive = RobotRelive}) ->
    [Reply, NewRoles] = case lists:keyfind(Rid, #guild_arena_role.id, Roles) of
        false -> 
            [{false, ?L(<<"你不在战区，不能发起战斗">>)}, Roles];
        #guild_arena_role{die = ?guild_arena_role_max_die} -> 
            [{false, ?L(<<"你重生次数已用完，不能发起战斗">>)}, Roles];
        _ when Robots =:= [] orelse RobotRelive < 1 ->
            [{false, ?L(<<"发起战斗失败">>)}, Roles];
        Role = #guild_arena_role{id = Rid} -> 
            [true, lists:keyreplace(Rid, #guild_arena_role.id, Roles, Role#guild_arena_role{is_fighting = 1})];
        _ -> 
            [{false, ?L(<<"发起战斗失败">>)}, Roles]
    end,
    {reply, Reply, round, State#state{roles = NewRoles}, timeout(round, State)};
handle_sync_event({combat_robot_check, _}, _From, StateName, State) ->
    {reply, {false, ?L(<<"现在不是动手时间，不能发起战斗">>)}, StateName, State, timeout(StateName, State)};

%% 检查是否可以组队，只有同帮派同战区才能组队
handle_sync_event({team_check, [MyId, OtherId]}, _From, StateName, State = #state{roles = Roles}) ->
    Reply = case lists:keyfind(MyId, #guild_arena_role.id, Roles) of
        #guild_arena_role{die = ?guild_arena_role_max_die} ->
            {false, ?L(<<"你已经用完重生次数，不能再次参与组队">>)};
        #guild_arena_role{gid = Gid, aid = Aid} ->
            case lists:keyfind(OtherId, #guild_arena_role.id, Roles) of
                %% 开战状态用完重生次数的人不能再次组队
                #guild_arena_role{die = ?guild_arena_role_max_die} when StateName =:= round ->
                    {false, ?L(<<"对方已经用完重生次数，不能再次参与组队">>)};
                #guild_arena_role{gid = Gid, aid = Aid} -> 
                    ok;
                _ -> {false, ?L(<<"组队失败，你们不是同一个帮会的">>)}
            end;
        _ -> {false, ?L(<<"组队失败，你没有参加帮战">>)}
    end,
    {reply, Reply, StateName, State, timeout(StateName, State)};

%% 获取帮战的当前状态名称和距离下个状态的超时
handle_sync_event({info, state_time, Rid}, _From, round, State = #state{id= Id, roles = Roles, areas = Areas}) ->
    %% 已经清场的战区要特殊处理
    Type = case lists:keyfind(Rid, #guild_arena_role.id, Roles) of
        #guild_arena_role{aid = Aid, gid = Gid} ->
            case lists:keyfind(Aid, #arena_area.id, Areas) of
                %% 战区已经出胜负了，只有胜利帮派是收到进入下一阶段倒计时
                #arena_area{winner = Winner} when Winner =:= Gid -> finish;
                #arena_area{winner = Winner} when Winner =/= 0 -> idle;
                _ -> round
            end;
        _ -> round
    end,
    Timeout = timeout(round, State),
    Reply = {Id, state_to_integer(Type), (Timeout div 1000) + ?guild_arena_push_time_late},
    {reply, Reply, round, State, Timeout};
handle_sync_event({info, state_time, _}, _From, StateName, State = #state{id= Id}) ->
    Timeout = timeout(StateName, State),
    %% 加多5秒延迟
    Reply = {Id, state_to_integer(StateName), (Timeout div 1000) + ?guild_arena_push_time_late},
    {reply, Reply, StateName, State, Timeout};

%% 获取帮战所有状态信息
handle_sync_event({info, all}, _From, StateName, State) ->
    {reply, State, StateName, State, timeout(StateName, State)};

%% 获取上场冠军
handle_sync_event(last_winner, _From, StateName, State = #state{last_winner = LastWinner}) ->
    {reply, LastWinner, StateName, State, timeout(StateName, State)};

%% 获取帮战所有报名帮派总数
handle_sync_event({info, guild_num}, _From, StateName, State = #state{guild_num = GuildNum}) ->
    {reply, GuildNum, StateName, State, timeout(StateName, State)};

%% 获取参战帮派信息
handle_sync_event({info, guilds}, _From, StateName, State = #state{guilds = Guilds, lost_guilds = LostGuilds, round = Round}) ->
    %% 话说 小++大要比 大++小 好
    AllGuilds = case Round > 1 of
        true -> Guilds ++ LostGuilds;
        _ -> LostGuilds ++ Guilds
    end,
    Reply = {length(AllGuilds), sort_guild(sum_score, AllGuilds)},
    {reply, Reply, StateName, State, timeout(StateName, State)};

%% 获取参战帮派信息按等级排名
handle_sync_event({info, sign_guilds}, _From, StateName, State = #state{guild_num = GuildNum, guilds = Guilds}) ->
    Reply = {GuildNum, sort_guild(lev, Guilds)},
    {reply, Reply, StateName, State, timeout(StateName, State)};

%% 获取参战玩家信息
handle_sync_event({info, roles}, _From, StateName, State = #state{roles = Roles, lost_roles = LostRoles, round = Round}) ->
    AllRoles = case Round of
        1 -> LostRoles ++ Roles;
        _ -> Roles ++ LostRoles
    end,
    Reply = {length(AllRoles), sort_role(sum_score, AllRoles)},
    {reply, Reply, StateName, State, timeout(StateName, State)};

%% 获取当前战区帮派信息
handle_sync_event({info, guilds, _Rid}, _From, StateName, State = #state{guilds = Guilds, lost_guilds = LostGuilds}) ->
    Timeout = timeout(StateName, State),
    AllGuilds = case Guilds of
        [] -> LostGuilds;
        _ -> Guilds
    end,
    Reply = {length(AllGuilds), sort_guild(score, AllGuilds)},
    {reply, Reply, StateName, State, Timeout};

%% 获取当前战区玩家信息
handle_sync_event({info, roles, Rid}, _From, StateName, State = #state{roles = Roles, lost_roles = LostRoles}) ->
    Timeout = timeout(StateName, State),
    %% 如果还没被淘汰则看看现在战区的
    case lists:keyfind(Rid, #guild_arena_role.id, Roles) of
        #guild_arena_role{aid = Aid} when Aid =/=0 ->
            ArenaRoles = [R || R = #guild_arena_role{aid = Raid} <- Roles, Raid =:= Aid],
            Reply = {length(ArenaRoles), sort_role(score, ArenaRoles)},
            {reply, Reply, StateName, State, Timeout};
        _ ->
            %% 如果已经被淘汰
            case lists:keyfind(Rid, #guild_arena_role.id, LostRoles) of
                #guild_arena_role{aid = Aid} when Aid =/=0 ->
                    ArenaRoles = [R || R = #guild_arena_role{aid = Raid} <- LostRoles, Raid =:= Aid],
                    Reply = {length(ArenaRoles), sort_role(score, ArenaRoles)},
                    {reply, Reply, StateName, State, Timeout};
                _ ->
                    {reply, {0, []}, StateName, State, Timeout}
            end
    end;

%% 获取个人战绩
handle_sync_event({info, mine, Rid}, _From, StateName, State = #state{roles = Roles}) ->
    Timeout = timeout(StateName, State),
    case lists:keyfind(Rid, #guild_arena_role.id, Roles) of
        ArenaRole = #guild_arena_role{} ->
            {reply, ArenaRole, StateName, State, Timeout};
        _ ->
            {reply, {}, StateName, State, Timeout}
    end;

%% 获取指定帮会成员战绩
handle_sync_event({info, guild_member, SpecGid}, _From, StateName, State = #state{lost_roles = Roles}) ->
    Timeout = timeout(StateName, State),
    Reply = [R || R = #guild_arena_role{gid = Gid} <- Roles, Gid =:= SpecGid],
    {reply, {specify_guild_member_score, Reply}, StateName, State, Timeout};

%% 获取指定帮会战绩
handle_sync_event({info, guild, SpecGid}, _From, StateName, State = #state{lost_guilds = Guilds}) ->
    Timeout = timeout(StateName, State),
    Reply =  lists:keyfind(SpecGid, #arena_guild.id, Guilds),
    {reply, {specify_guild, Reply}, StateName, State, Timeout};


handle_sync_event(_Event, _From, StateName, State) ->
    ?DEBUG("invailid event ~p ~n", [_Event]),
    {reply, unkown, StateName, State, timeout(StateName, State)}.

%% 时间到所有在场的人要都去开打
handle_info(all_go_fight, round, State = #state{areas = [Area = #arena_area{id = Aid, guild_num = GuildNum}], roles = Roles, guilds = Guilds}) ->
    F = fun(R = #guild_arena_role{id = Id, aid = RAid, offline = 0}, Rs) when RAid =/= Aid ->
            NewR = R#guild_arena_role{aid = Aid},
            send_role_to_map(R, Area),
            lists:keyreplace(Id, #guild_arena_role.id, Rs, NewR);
        (_, Rs) ->
            Rs
    end,
    NewRoles = lists:foldl(F, Roles, Roles),
    %% {NewGuilds, GuildNum, Gids} = find_empty_guilds(Guilds, {[], 0, []}),
    GuildDead = find_dead_guild_num(Guilds),
    %% [map:elem_leave(Mid, Eid) || Eid <- ?guild_arena_area_blocks],
    NewState = State#state{
        roles = NewRoles, 
        areas = [Area#arena_area{guild_die = GuildDead}]
    },
    %% 如果不够两个帮派的话就提前结束吧
    case GuildNum - GuildDead > 1 of
        true ->
            {next_state, round, NewState, timeout(round, State)};
        _ ->
            round(timeout, NewState)
    end;

%% 初始时从数据库读取上一场帮战信息
handle_info(load_db, StateName, State) ->
    NewState = case guild_arena_dao:load() of
        {Id, Roles, _RoleNum, Guilds, _GuildNum, LastWinner, Round} ->
            State#state{
                id = Id + 1,
                lost_guilds = Guilds,
                lost_roles = Roles,
                round = Round,
                last_winner = LastWinner
            };
        _ -> 
            State
    end,
    {next_state, StateName, NewState, timeout(StateName, State)};

%% 第一次从dets转到mysql的时候要转存下数据
handle_info(save_db, StateName, State = #state{id = Id, lost_guilds = Guilds}) when Id > 1 andalso Guilds =/= [] ->
    save_db(State#state{id = Id - 1}),
    {next_state, StateName, State, timeout(StateName, State)};

handle_info(_Info, StateName, State) ->
    {next_state, StateName, State, timeout(StateName, State)}.

terminate(_Reason, _StateName, #state{guilds = Guilds, lost_guilds = LostGuilds}) ->
    %% 活动异常所有报名帮派解锁
    F2 = fun(#arena_guild{id = UnlockId, aid = {GMpid, _}}) ->
            map:stop(GMpid),
            guild_mem:limit_member_manage(UnlockId, able);
        (_A) ->
            ?DEBUG("未知参数 ~p", [_A])
    end,
    [F2(G) || G <- Guilds],
    [F2(G2) || G2 <- LostGuilds],
    ok.

code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.

%%------- 各种状态处理 --------

%% 冷却阶段：这时什么都不做，只是静静等待时间到跳到接受帮派报名
idle(timeout, #state{id = Id, last_winner = LastWinner}) ->
    ?DEBUG("新帮战进入 ~p 状态", [sign]),
    Timeout = ?guild_arena_sign_timeout,
    push_to_onlines(state_time, {Id, sign, Timeout}),
    notice:send(54, ?L(<<"帮战即将开启，各帮帮主请报名参加！">>)),
    %% 在这里要再次初始化一个比较干净的state
    {next_state, sign, #state{id = Id, last_winner = LastWinner, started = util:unixtime(ms)}, Timeout};
idle(_Else, State) ->
    {next_state, idle, State, timeout(idle, State)}.

%% 报名阶段完成后要在这里开始进行分区
%% 没有帮派报名直接结束
sign(timeout, State = #state{guilds = []}) ->
    {next_state, finish, State, 1};
%% 如果只有一个帮派报名则通知他启动失败
sign(timeout, State = #state{guilds = [#arena_guild{id = Id}], guild_num = 1}) ->
    guild:guild_mail(Id, {?L(<<"帮战开启失败通知">>), ?L(<<"很遗憾，本次帮战只有贵帮一个帮派报名参加，本次帮会战开启失败，无法发起帮会之间的对决！欢迎贵帮下次继续参加，并可邀请其他符合条件的帮会报名。帮战中，表现出色的帮会，有很大机会获得紫色护符和其他宝物哦！">>)}),
    {next_state, finish, State, 1};
sign(timeout, State = #state{id = Id, guilds = Guilds}) ->
    ?DEBUG("新帮战进入 ~p 状态", [ready]),
    Timeout = ?guild_arena_join_timeout,
    %% 这里如果是已报名帮派顺便打开邀请界面
    push_to_guilds(open_invite, 1, Guilds),
    push_to_onlines(state_time, {Id, ready, Timeout}),
    notice:send(54, ?L(<<"帮战正式开启，请报名的帮会，迅速进入战区,参与战区争夺战！">>)),
    {next_state, ready, State#state{started = util:unixtime(ms)}, Timeout};
sign(_Else, State) ->
    {next_state, sign, State, timeout(sign, State)}.

%% 玩家在准备阶段进入帮会战区后开始进入开战阶段
ready(timeout, State = #state{id = Id, guilds = Guilds, role_num = RoleNum}) ->
    ?DEBUG("新帮战进入 ~p1 状态", [round]),
    %% 创建战区场景
    Map = case map_mgr:create(?guild_arena_area_map) of 
        {ok, Pid, Mid} ->
            {Pid, Mid};
        _ ->
            ?ERR("启动新帮战战区失败：map_base_id = ~w", [?guild_arena_area_map]),
            {0, 0}
    end,
    Robots = init_robot(Map, RoleNum),
    {NewGuilds, GuildNum, _} = find_empty_guilds(Guilds, {[], 0, []}),
    Area = #arena_area{id = Map, id_name = 1, map = Map, enters = ?guild_arena_map_enter_point, guild_num = GuildNum},
    NewArea = fill_to_area(NewGuilds, ?guild_arena_map_enter_point, Area, ?guild_arena_map_enter_point),
    %% 设定一个时间如果玩家还不进入战场就强制送他进去
    erlang:send_after(?guild_arena_stay_interval, self(), all_go_fight),
    push_to_guilds(open_invite, 2, NewGuilds),
    push_to_onlines(state_time, {Id, round, ?guild_arena_round_interval}),
    {next_state, round, State#state{started = util:unixtime(ms), round = 1, areas = [NewArea], guild_num = GuildNum, guilds = NewGuilds, robots = Robots, robot_relive = length(Robots) * ?guild_arena_role_max_die}, ?guild_arena_round_interval};
ready(_Else, State) ->
    {next_state, ready, State, timeout(ready, State)}.


%% 每一轮结束后要再这里,评估胜利者并进入中场休息阶段
round(timeout, State = #state{id = Id, round = Round, guilds = Guilds, areas = Areas, roles = Roles, last_winner = OldWinner}) ->
    %% ?DEBUG("round ~p areas ~p", [Round, Areas]),
    Started = util:unixtime(ms),
    %% 终止所有采集活动
    %% guild_arena_area:stop_areas(),
    %% 每一轮结束到这里要找出胜利者
    NewAreas = find_area_winner(Areas, [], Guilds, Round),
    %% 如果是最后一轮则进入结束阶段，否则进入中场休息
    ?DEBUG("新帮战提前进入 ~p 状态", [finish]),
    push_to_onlines(state_time, {Id, idle, ?guild_arena_rest_interval}),
    %% ?DEBUG("winners ~p", [Winners]),
    Winner = case NewAreas of
        [#arena_area{winner = WinGid}] -> WinGid;
        _ -> 0
    end,
    %% 上届胜利者去掉buff和称号
    case OldWinner of
        0 -> ok;
        %% 如果是同一个帮派就不用处理了
        Winner -> ok;
        _ -> 
            handle_buff(del, OldWinner),
            handle_honor(del, OldWinner)
    end,
    {NewRoles, NewGuilds} = round_push_and_reward(Id, {Round, finish}, NewAreas, Roles, Guilds),
    NewState = State#state{
        started = Started, 
        areas = NewAreas, 
        last_winner = Winner, 
        roles = NewRoles, 
        guilds = NewGuilds
    },
    {next_state, finish, NewState, ?guild_arena_stay_interval};
round(_Else, State) ->
    {next_state, round, State, timeout(round, State)}.


%% 结束阶段：系统评选出冠军
finish(timeout, State = #state{id =Id, areas = Areas, roles = Roles, guilds = Guilds, lost_guilds = LostGuilds, lost_roles = LostRoles, last_winner = LastWinner, robots = Robots}) ->
    ?DEBUG("新帮战进入 ~p 状态", [idle]),
    %% 所有人都送出去吧送出去吧
    [kickout_map(R) || R <- Roles],
    %% 清掉原来战区的地图进程
    [map:stop(MPid) || #arena_area{map = {MPid, _}} <- Areas, is_pid(MPid)],
    %% 清掉所有机器人
    [npc_mgr:remove(RobotId) || RobotId <- Robots],

    %% 活动结束所有报名帮派解锁
    F2 = fun(#arena_guild{id = UnlockId, aid = {GMpid, _}}) ->
            map:stop(GMpid),
            guild_mem:limit_member_manage(UnlockId, able);
        (_A) ->
            ?DEBUG("未知参数 ~p", [_A])
    end,
    NewLostGuilds = sort_guild(sum_score, Guilds ++ LostGuilds),
    [F2(G) || G <- NewLostGuilds],
    %% 给新胜利帮派发称号和buff
    case LastWinner of
        0 -> ok;
        _ ->
            handle_buff(add, LastWinner),
            handle_honor(add, LastWinner)
    end,
    %% 初始化一个新状态以防一些未知的问题
    NewState = #state{
        id =Id + 1, 
        round = 0, 
        last_winner = LastWinner,
        lost_roles = Roles ++ LostRoles,
        lost_guilds = NewLostGuilds
    },
    %% 这里保存一下当届的结果
    save_db(NewState#state{id = Id}),
    push_to_onlines(state_time, {Id, idle, 1}),
    {next_state, idle, NewState, timeout(idle, State)};
finish(_Else, State) ->
    {next_state, finish, State, timeout(finish, State)}.

%% 把整个活动隐藏掉但进程保留
hide(_Else, State) ->
    {next_state, hide, State}.

%% ----------- 内部函数 ------------------


%% @spec role_off(StateName, Guild, Role, Areas, Guilds) -> {NewGuild, NewAreas}
%% 不同阶段针对处理
%% 1、比赛已开始阶段：未阵亡玩家离开要对应帮阵亡人数加一，并检查帮派是否全部阵亡
%% 2、已阵亡的玩家离开不需要处理什么
%% {NewArenaGuild, NewAreas} = case StateName of
%% 已经阵亡则什么都不用处理
role_off(_, Guild, #guild_arena_role{die = RDie}, Areas) when RDie >= ?guild_arena_role_max_die ->
    {Guild, Areas};
%% 已经出结果了也不需要再处理什么
role_off(finish, Guild, _, Areas) ->
    {Guild, Areas};
%% 否则要看看帮派是否全部阵亡
role_off(round, Guild = #arena_guild{die = GDie, join_num = JoinNum}, #guild_arena_role{aid = Aid}, Areas) when GDie + 1 >= JoinNum ->
    case lists:keyfind(Aid, #arena_area.id, Areas) of
        %% 如果战区只剩两个帮派了，那就把剩余一个标注为胜利
        Area = #arena_area{guild_die = GuildDie, guild_num = AreaGuildNum} when GuildDie + 2 >= AreaGuildNum ->
            %% 接下来要通知下该战区要结束了
            area_over(Aid),
            {
                Guild#arena_guild{
                    die = GDie + 1
                }, 
                lists:keyreplace(Aid, #arena_area.id, Areas, Area#arena_area{guild_die = GuildDie + 1})
            };
        %% 还有多个帮派的情况下就阵亡帮派加一
        Area = #arena_area{guild_die = GuildDie} ->
            {
                Guild#arena_guild{
                    die = GDie + 1
                }, 
                lists:keyreplace(Aid, #arena_area.id, Areas, Area#arena_area{guild_die = GuildDie + 1})
            };
        _A ->
            ?DEBUG("未知的战区数据 ~w", [_A]),
            {Guild#arena_guild{die = GDie + 1}, Areas}
    end;
%% 未阵亡玩家在还没出结果前离开对应帮派阵亡人数都要+1
role_off(_, Guild = #arena_guild{die = GDie}, #guild_arena_role{id = _Id}, Areas) ->
    {Guild#arena_guild{die = GDie + 1}, Areas}.

%% 把预设帮派据点
fill_to_area([], _, Area, _) ->
    Area;
fill_to_area(Guilds, [], Area, Points) ->
    ?DEBUG("异常，帮派数超过预设据点数"),
    fill_to_area(Guilds, Points, Area, Points);
fill_to_area([#arena_guild{id = Gid} | GT], [PH | PT], Area = #arena_area{gids = Gids, guild_points = GuildPoints}, Points) ->
    NewArea = Area#arena_area{gids = [Gid | Gids], guild_points = [{Gid, PH} | GuildPoints]},
    fill_to_area(GT, PT, NewArea, Points).

%% 筛选出不为空的帮派
find_empty_guilds([], {NewGuilds, GuildNum, Gids}) ->
    {NewGuilds, GuildNum, Gids};
find_empty_guilds([#arena_guild{id = Id, aid = {MPid, _}, join_num = 0} | T], {NewGuilds, GuildNum, Gids}) ->
    guild_mem:limit_member_manage(Id, able),
    map:stop(MPid),
    find_empty_guilds(T, {NewGuilds, GuildNum, Gids});
find_empty_guilds([H = #arena_guild{id = Id}| T], {NewGuilds, GuildNum, Gids}) ->
    find_empty_guilds(T, {[H | NewGuilds], GuildNum + 1, [Id | Gids]}).

%% 找一下死亡帮派数量
find_dead_guild_num(Guilds) ->
    length([Id || #arena_guild{id = Id, join_num = JoinNum, die = Die} <- Guilds, Die >= JoinNum]).


%% 计算当前状态距离下个状态的剩余时间(毫秒)
%% timeout(StateName, State) -> integer() > 0
%% StateName = atom() 当前状态名字
%% State = record(state)
timeout(idle, _) ->
    Day = calendar:day_of_the_week(date()),
    Time = util:datetime_to_seconds({date(), ?guild_arena_sign_time}) - util:unixtime(),
    %% 没有合过服的周日也要开一场
    SunDayTime = case util:is_merge() of
        false ->  3600 * 24;
        _ -> 0
    end,

    BaseTime = case sys_env:get(srv_open_time) of
        OpenTime when is_integer(OpenTime) ->
            max(0, (util:unixtime({today, OpenTime}) + 86400 * 2) - util:unixtime());
        _ -> 0
    end,

    %% 取出开服第三天是星期几
    NewDay = max(1, (BaseTime div (3600 * 24) + Day) rem 8),
    
    %% 帮战的开启周期是每周1、3、5这三天
    T = case NewDay of
        1 when Time >= 0 -> Time * 1000;
        1 when Time < 0 - ?guild_arena_total_time -> (Time + ?guild_arena_interval) * 1000;
        3 when Time >= 0 -> Time * 1000;
        3 when Time < 0 - ?guild_arena_total_time -> (Time + ?guild_arena_interval) * 1000;
        5 when Time >= 0 -> Time * 1000;
        %% 周五结束后要隔三天再启动
        5 when Time < 0 - ?guild_arena_total_time -> (Time + ?guild_arena_interval + 3600 * 24 - SunDayTime) * 1000;
        %% 周六的话隔两天
        6 -> (Time + ?guild_arena_interval - SunDayTime) * 1000;
        %% 周日如果没合过服当天也要开启一场
        7 when Time >= 0 andalso SunDayTime > 0 -> Time * 1000;
        7 when Time < 0 - ?guild_arena_total_time andalso SunDayTime > 0 -> (Time + ?guild_arena_interval) * 1000;
        %% 其余要隔一天再启动
        _ -> (Time + ?guild_arena_interval div 2) * 1000
    end,
    NewT = T + BaseTime * 1000,
    ?DEBUG("new day ~p about ~p ms to sign", [NewDay, NewT]),
    NewT;
timeout(sign, #state{started = Started}) ->
    PassMs = util:unixtime(ms) - Started,
    case PassMs >= ?guild_arena_sign_timeout of
        true -> 0;
        _ -> ?guild_arena_sign_timeout - PassMs
    end;
timeout(ready, #state{started = Started}) ->
    PassMs = util:unixtime(ms) - Started,
    case PassMs >= ?guild_arena_join_timeout of
        true -> 0;
        _ -> ?guild_arena_join_timeout - PassMs
    end;
timeout(round, #state{started = Started}) ->
    PassMs = util:unixtime(ms) - Started,
    case PassMs >= ?guild_arena_round_interval of
        true -> 0;
        _ -> ?guild_arena_round_interval - PassMs
    end;
timeout(stay, #state{started = Started}) ->
    PassMs = util:unixtime(ms) - Started,
    case PassMs >= ?guild_arena_stay_interval of
        true -> 0;
        _ -> ?guild_arena_stay_interval - PassMs
    end;
timeout(rest, #state{started = Started}) ->
    PassMs = util:unixtime(ms) - Started,
    case PassMs >= ?guild_arena_rest_interval of
        true -> 0;
        _ -> ?guild_arena_rest_interval - PassMs
    end;
timeout(finish, #state{started = Started}) ->
    PassMs = util:unixtime(ms) - Started,
    case PassMs >= ?guild_arena_stay_interval of
        true -> 0;
        _ -> ?guild_arena_stay_interval - PassMs
    end;
timeout(hide, _) ->
    100000;
timeout(_StateName, _) ->
    ?INFO("新帮战异常状态 ~p", [_StateName]),
    3000.

%% 向本进程获取状态（同步调用）
sync_call(Event) ->
    gen_fsm:sync_send_all_state_event({global, ?MODULE}, Event).

%% 指定进程获取状态（同步调用）
sync_call(Pid, Event) when is_pid(Pid) ->
    gen_fsm:sync_send_all_state_event(Pid, Event);
sync_call(_Pid, _Event) ->
    ?DEBUG("向无效的pid请求 ~w", [_Event]),
    ok.

%% 向本进程发送消息(异步)
async_call(Event) ->
    gen_fsm:send_all_state_event({global, ?MODULE}, Event).

%% 向指定进程请求
async_call(Pid, Event) when is_pid(Pid) ->
    gen_fsm:send_all_state_event(Pid, Event);
async_call(_Pid, _Event) ->
    ?DEBUG("向无效的pid请求 ~w", [_Event]),
    ok.

%% 根据积分排序帮派
%% 现在改为先按存活人数再按积分
sort_guild(score, Guilds) ->
    F = fun(#arena_guild{score = AScore}, #arena_guild{score = BScore}) ->
            AScore > BScore
    end,
    lists:sort(F, Guilds);

%% 根据总积分排序帮派
sort_guild(sum_score, Guilds) ->
    F = fun(#arena_guild{sum_score = ScoreA, join_num = JoinNumA, die = DieA}, #arena_guild{sum_score = ScoreB, join_num = JoinNumB, die = DieB}) ->
            case  JoinNumA > DieA of
                %% 生存的话，如果积分比对方高或对方阵亡都比他排前
                true when ScoreA > ScoreB orelse (DieB >= JoinNumB andalso ScoreA > 0) -> true;
                %% 大家都阵亡的话就看谁积分高
                _ when DieB >= JoinNumB andalso ScoreA > ScoreB -> true;
                _ -> false
            end
    end,
    F2 = fun(#arena_guild{sum_score = ScoreA2}, #arena_guild{sum_score = ScoreB2}) ->
            ScoreA2 > ScoreB2
    end,
    case lists:sort(F, Guilds) of
        [No1 | Rest] ->
            [No1 | lists:sort(F2, Rest)];
        Other ->
            Other
    end;

%% 根据等级排名
sort_guild(lev, Guilds) ->
    F = fun(A, B) ->
            A#arena_guild.lev > B#arena_guild.lev
    end,
    lists:sort(F, Guilds);

%% 根据战斗力排序帮派
sort_guild(fc, Guilds) ->
    F = fun(A, B) ->
            A#arena_guild.fc > B#arena_guild.fc
    end,
    lists:sort(F, Guilds).

%% 根据积分排序玩家
sort_role(score, Roles) ->
    F = fun(A, B) ->
            A#guild_arena_role.score > B#guild_arena_role.score
    end,
    lists:sort(F, Roles);

%% 根据总积分排序玩家
sort_role(sum_score, Roles) ->
    F = fun(A, B) ->
            A#guild_arena_role.sum_score > B#guild_arena_role.sum_score
    end,
    lists:sort(F, Roles).

%% 找出战区胜利者，按积分排序
find_area_winner([], NewAreas, _, _) ->
    NewAreas;
%% 没有人的战区过滤掉
find_area_winner([#arena_area{winner = 0, gids = [], map = {MPid, _}} | T], NewAreas, Guilds, Round) ->
    map:stop(MPid),
    find_area_winner(T, NewAreas, Guilds, Round);
find_area_winner([H = #arena_area{winner = _Winner} | T], NewAreas, Guilds, Round) ->
    AreaGuilds = Guilds,
    %% 积分第一个就是他了
    SortGuilds = sort_guild(sum_score, AreaGuilds),
    %% 取排名最前一个就是他
    NewWinner = case SortGuilds of
            [No1 | _] ->
                No1#arena_guild.id;
            _ ->
                0
    end,
    RankList = rank_guild(SortGuilds, 1, []),
    ?DEBUG("rank ~w", [RankList]),
    find_area_winner(T, [H#arena_area{winner = NewWinner, guild_rank = RankList} | NewAreas], Guilds, Round).

%% 帮派排名处理
rank_guild([], _, RankList) ->
    lists:reverse(RankList);
rank_guild([#arena_guild{id = Id} | T], SortNum, RankList) ->
    rank_guild(T, SortNum + 1, [{Id, SortNum} | RankList]).

%% 根据玩家ID获取排名
get_rank(role, RankNum, _, []) ->
    RankNum;
get_rank(role, RankNum, Rid, [#guild_arena_role{id = Id} | T]) ->
    case Rid =:= Id of
        true -> RankNum;
        _ -> get_rank(role, RankNum + 1, Rid, T)
    end;
get_rank(role, RankNum, Rid, [#guild_arena_role_cross{id = Id} | T]) ->
    case Rid =:= Id of
        true -> RankNum;
        _ -> get_rank(role, RankNum + 1, Rid, T)
    end;

get_rank(guild, RankNum, _, []) ->
    RankNum;
get_rank(guild, RankNum, Gid, [#arena_guild{id = Id} | T]) ->
    case Gid =:= Id of
        true -> RankNum;
        _ -> get_rank(guild, RankNum + 1, Gid, T)
    end;
get_rank(guild, RankNum, Gid, [#guild_arena_guild_cross{id = Id} | T]) ->
    case Gid =:= Id of
        true -> RankNum;
        _ -> get_rank(guild, RankNum + 1, Gid, T)
    end.


%% 传送到准备区
send_role_to_map(#guild_arena_role{pid = Pid, aid = {_, Mid}, die = Die}) when is_pid(Pid) ->
    case is_process_alive(Pid) of
        true ->
            {{Tlx, Tly}, {Brx, Bry}} = ?guild_arena_ready_map_enter_point,
            {X, Y} = {util:rand(Tlx, Brx), util:rand(Tly, Bry)},
            EnterPoint = {Mid, X, Y},
            role:apply(async, Pid, {fun apply_enter_map/4, [EnterPoint, self(), Die]});
        _ -> 0
    end;
send_role_to_map(_R) ->
    ?DEBUG("帮战玩家无效参数~w", [_R]),
    0.
%% 处理帮战里的地图传送
%% 固定坐标
send_role_to_map(#guild_arena_role{pid = Pid, die = Die}, {Mid, X, Y}) when is_pid(Pid) ->
    case is_process_alive(Pid) of
        true ->
            role:apply(async, Pid, {fun apply_enter_map/4, [{Mid, X, Y}, self(), Die]});
        _ -> 0
    end;
%% 随机坐标
send_role_to_map(Role, [Area]) ->
    send_role_to_map(Role, Area);
send_role_to_map(#guild_arena_role{pid = Pid, gid = Gid, die = Die}, #arena_area{map = Map, id = Aid, guild_points = GuildPoints}) when is_pid(Pid) ->
    case is_process_alive(Pid) of
        true ->
            EnterPoint = get_enter_point(Map, Gid, GuildPoints),
            role:apply(async, Pid, {fun apply_enter_map/4, [EnterPoint, self(), Die]}),
            Aid;
        _ -> 0
    end;
send_role_to_map(_R, _A) ->
    0.

%% 把角色送出地图
send_role_off_map(#guild_arena_role{pid = Pid}) ->
    send_role_off_map(Pid);
send_role_off_map(Pid) ->
    role:apply(async, Pid, {fun apply_leave_map/2, [?leave_guild_arena_point]}).

%% 把角色踢出地图
kickout_map(#guild_arena_role{pid = Pid, offline = 0}) ->
    role:apply(async, Pid, {fun apply_kickout/2, [?leave_guild_arena_point]});
kickout_map(_R) ->
    ok.

%% 获取地图初始点
get_enter_point({_, Mid}, _Gid, _GuildPoints) ->
    N = util:rand(1, 100),
    {Brx, Bry} = case lists:nth(N, ?guild_arena_map_enter_point) of
        {Bx, By} -> {Bx, By};
        _ -> 
            [H | _] = ?guild_arena_map_enter_point,
            H
    end,
    ?DEBUG("bx ~p by ~p", [Brx, Bry]),
    {X, Y} = {util:rand(-30, 30) + Brx, util:rand(-30, 30) + Bry},
    {Mid, X, Y}.

%% 玩家进入地图
apply_enter_map(Role = #role{team_pid = TeamPid, team = Team, looks = Looks, hp_max = MaxHp, mp_max = MaxMp}, EnterPoint, WarPid, Die) ->
    NoRideRole1 = role_api:set_ride(Role, ?ride_no),
    {Mid, X, Y} = EnterPoint,
    %% 阵亡要换looks
    NewLooks = case Die >= ?guild_arena_role_max_die of
        true ->
            case lists:keyfind(?LOOKS_TYPE_ALPHA, 1, Looks) of
                false -> [{?LOOKS_TYPE_ALPHA, 0, ?LOOKS_VAL_ALPHA_ARENA} | Looks];
                _Other -> lists:keyreplace(?LOOKS_TYPE_ALPHA, 1, Looks, {?LOOKS_TYPE_ALPHA, 0, ?LOOKS_VAL_ALPHA_ARENA})
            end;
        false -> 
            lists:keydelete(?LOOKS_TYPE_ALPHA, 1, Looks)
    end,
    NoRideRole = NoRideRole1#role{looks = NewLooks, hp = MaxHp, mp = MaxMp},
    map:role_update(NoRideRole),
    %% 如果玩家还在队伍并且是跟随的话，就自动传到队长身边
    {NX, NY} = case [is_pid(TeamPid), Team] of
        [true, #role_team{is_leader = ?false}] ->
            case team:get_leader(TeamPid) of
                {ok, _, #team_member{pid = Lpid}} ->
                    case role_api:lookup(by_pid, Lpid, #role.pos) of
                        {ok, _N, #pos{map = Mid, x = Dx, y = Dy}} -> {Dx, Dy};
                        _ -> {X, Y}
                    end;
                _ -> {X, Y}
            end;
        _ -> {X, Y}
    end,
    case map:role_enter(Mid, NX, NY, NoRideRole#role{event = ?event_guild_arena}) of
        {false, _Reason} ->
            {ok};
        {ok, NewRole} ->
            campaign_task:listener(NewRole, guild_war, 1),
            {ok, NewRole#role{event_pid = WarPid}}
    end.

%% 角色离开帮战
apply_leave_map(Role = #role{team_pid = TeamPid, team = #role_team{is_leader = IsLeader, follow = Follow}, looks = Looks, event = Event}, {Mid, X, Y}) ->
    NewRole1 = Role#role{event = ?event_no},
    %% ?DEBUG("leave ~p", [Looks]),
    NewLooks = lists:keydelete(?LOOKS_TYPE_ALPHA, 1, Looks),
    NewRoleT = NewRole1#role{looks = NewLooks, cross_srv_id = <<>>},
    NewRole = role_api:push_attr(NewRoleT),
    map:role_update(NewRole),
    case is_pid(TeamPid) andalso IsLeader =:= ?false andalso Follow =:= ?true of
        true when Event =:= ?event_guild ->
            {ok, NewRole#role{event = ?event_guild}};
        true ->
            {ok, NewRole};
        false ->
            case guild_area:enter(arena_npc, NewRole) of
                {ok, Nr} -> {ok, Nr};
                {ok} -> {ok, NewRole};
                {false, _Reason} ->
                    case map:role_enter(Mid, X, Y, NewRole) of
                        {false, _Reason} ->
                            {ok};
                        {ok, NewRole2} ->
                            {ok, NewRole2#role{event_pid = 0}}
                    end;
                _ -> {ok}
            end
    end;
apply_leave_map(Role = #role{looks = Looks}, {Mid, X, Y}) ->
    NewRole1 = Role#role{event = ?event_no},
    %% ?DEBUG("leave ~p", [Looks]),
    NewLooks = lists:keydelete(?LOOKS_TYPE_ALPHA, 1, Looks),
    NewRoleT = NewRole1#role{looks = NewLooks, cross_srv_id = <<>>},
    NewRole = role_api:push_attr(NewRoleT),
    map:role_update(NewRole),
    case guild_area:enter(arena_npc, NewRole) of
        {ok, Nr} -> {ok, Nr};
        {ok} -> {ok, NewRole};
        {false, _Reason} ->
            case map:role_enter(Mid, X, Y, NewRole) of
                {false, _Reason} ->
                    {ok};
                {ok, NewRole2} ->
                    {ok, NewRole2#role{event_pid = 0}}
            end;
        _ -> {ok}
    end;
apply_leave_map(_R, _P) ->
    {ok}.

%% 增加一个专门用来踢人出去的方法
apply_kickout(Role = #role{event = ?event_guild_arena}, Pos) ->
    apply_leave_map(Role, Pos);
apply_kickout(_R, _P) ->
    {ok}.

role_apply(#guild_arena_role{pid = Pid}, CallBack) ->
    role:apply(async, Pid, CallBack);
role_apply(Pid, CallBack) when is_pid(Pid) ->
    role:apply(async, Pid, CallBack);
role_apply(_R, _C) ->
    ok.


%% 玩家进入地图
apply_leave_team(Role) ->
    team:stop(Role),
    {ok}.

%% 时间到所有还在折腾的战斗都应该终止
apply_combat_over(#role{combat_pid = ComPid}) ->
    case is_pid(ComPid) andalso is_process_alive(ComPid) of
        true ->
            ComPid ! stop,
            {ok};
        false ->
            {ok}
    end.

%% 从一系列玩家ID中检查是否有不符合战斗规则的
check_fighters([ARid, DRid], Roles, Areas) ->
    Now = util:unixtime(),
    case lists:keyfind(ARid, #guild_arena_role.id, Roles) of
        %% 死够了
        #guild_arena_role{die = ?guild_arena_role_max_die} -> 
            {false, ?L(<<"你重生次数已用完，不能发起战斗">>)};
        #guild_arena_role{aid = Aid} ->
            case lists:keyfind(DRid, #guild_arena_role.id, Roles) of
                %% 死够了
                #guild_arena_role{die = ?guild_arena_role_max_die} -> 
                    {false, ?L(<<"对方重生次数已用完，不能发起战斗">>)};
                #guild_arena_role{last_death = TheirDeath} when Now - TheirDeath < ?guild_arena_protect_time ->
                    {false, ?L(<<"对方还在保护时间内，不能发起战斗">>)};
                #guild_arena_role{aid = Aid, die = _Die} -> 
                    ?DEBUG("the die ~p", [_Die]),
                    %% 看看战区比赛是否已经结束
                    case lists:keyfind(Aid, #arena_area.id, Areas) of
                        #arena_area{winner = 0} -> {ok};
                        _ -> {false, ?L(<<"战区比赛已结束">>)}
                    end;
                _ -> {false, ?L(<<"对方不在战区，不能发起战斗">>)}
            end;
                %% 不在战场
        _ -> {false, ?L(<<"你不在战区，不能发起战斗">>)}
    end.

%% 把当前状态保存到数据库
save_db(#state{id = Id, lost_guilds = Guilds, lost_roles = Roles, guild_num = GuildNum, role_num = RoleNum, last_winner = LastWinner, round = Round}) ->
    guild_arena_dao:save(Id, Roles, RoleNum, Guilds, GuildNum, LastWinner, Round);
save_db(_S) ->
    ?DEBUG("无效状态数据结构~w", [_S]),
    ok.

%% 第一次转换到mysql要从DETS取出最后一次数据
init_db() ->
    FileName = "../var/guild_arena.dets",
    case dets:is_dets_file(FileName) of
        true ->
            ?DEBUG("还有这文件 ~s", [FileName]), 
            dets:open_file(guild_arena_states, [{file, FileName}, {keypos, #state.id}, {type, set}]),
            Res = case dets:first(guild_arena_states) of
                '$end_of_table' -> none;
                Id -> dets:lookup(guild_arena_states, Id)
            end,
            dets:close(guild_arena_states),
            file:delete(FileName),
            Res;
        _ ->
            none
    end.

%% 推送给所有在线玩家
push_to_onlines(state_time, {Id, StateName, Timeout}) ->
    StateId = state_to_integer(StateName),
    %% 加多5秒延迟
    Seconds = (Timeout div 1000) + ?guild_arena_push_time_late, 
    %% 区分跨服帮派和本服帮派
    CrossIds = guild_arena_mgr:get_cross_ids(),
    CenterReady = case center:is_connect() of
        {true, _} -> true;
        _ -> false
    end,
    Day = calendar:day_of_the_week(date()),
    ?DEBUG("可参加跨服的人 ~w", [CrossIds]),
    F = fun(Oid, Pid) ->
            case lists:member(Oid, CrossIds) of
                %% 周日全部打本服
                _ when Day =:= 7 orelse CenterReady =/= true ->
                    guild_arena_rpc:push(Pid, state_time, {Id, StateId, Seconds, 1});
                true ->
                    ok;
                _ ->
                    guild_arena_rpc:push(Pid, state_time, {Id, StateId, Seconds, 1})
            end
    end,
    [F(Rid, Rpid) || #role_online{id = Rid, pid = Rpid} <- ets:tab2list(role_online)];
push_to_onlines(guild_num, {Num}) ->
    [guild_arena_rpc:push(Pid, guild_num, {Num}) || #role_online{pid = Pid} <- ets:tab2list(role_online)];
push_to_onlines(_T, _A) ->
    ?DEBUG("无效参数 ~p ~p", [_T, _A]),
    ok.

%% 推送每一轮战斗结果和发放奖励
round_push_and_reward(_, _, [], Roles, Guilds) ->
    {Roles, Guilds};
round_push_and_reward(StateId, {Round, Type}, [#arena_area{guild_rank = GuildRank}], Roles, Guilds) ->
    %% 胜利方推送和失败方推送不一样，所以这里要筛选出来
    Mvps = sort_role(score, Roles),
    F = fun(R = #guild_arena_role{id = Id, pid = Pid, lev = Lev, gid = Gid, sum_score = RSumScore, die = Die}, {Rs, Gs}) ->
            [Mvp | _] = Mvps,
            Rank = case lists:keyfind(Gid, 1, GuildRank) of
                {Gid, RankNum} -> RankNum;
                _ -> 100
            end,
            campaign_listener:handle(guild_arena_rank, R, Rank),
            guild_arena_rpc:push(Pid, round, {Rank, Round, <<>>, Mvp}),

            %% 还在战斗的家伙要停止下
            NewRole = case R#guild_arena_role.is_fighting of
                1 -> 
                    role_apply(R, {fun apply_combat_over/1, []}),
                    R#guild_arena_role{is_fighting = 0};
                _ -> R
            end,

            Items = case RSumScore >= ?guild_arena_base_reward_score of
                true when Rank =:= 1 -> ?guild_arena_reward_role_no1; 
                true when Rank =:= 2 -> ?guild_arena_reward_role_no2; 
                true when Rank =:= 3 -> ?guild_arena_reward_role_no3; 
                true -> ?guild_arena_reward_role_join; 
                _ -> []
            end,

            NewRs = lists:keyreplace(Id, #guild_arena_role.id, Rs, NewRole),
            %% 发放个人奖励
            %% 经验=(积分^0.5)*15*等级^1.5
            %% 灵力=(积分^0.5)*15*等级^1.5/2
            %% 帮贡=积分/4
            Title = ?L(<<"帮战参与奖励">>), 
            %% 如果积分满足最低标准则发送奖励，否则告诉他为啥没奖励
            {Content, AssetInfo} = case RSumScore >= ?guild_arena_base_reward_score of
                true ->
                    Alive = ?guild_arena_role_max_die - Die,
                    AliveScore = Alive * ?guild_arena_alive_score,
                    GuildDevote = (RSumScore + AliveScore) div 4,
                    Exp = round(math:pow(RSumScore + AliveScore, 0.5) * 15 * math:pow(Lev, 1.5)),
                    %% Psychic = round(Exp / 2),
                    Format =  ?L(<<"在本次帮战中，您所在帮会获第 ~w 名。\n您个人获得 ~w 积分。折算成：\n  帮贡：~w \n 经验：~w  。\n剩余复活次数：~w 折算成积分：~w。">>),
                    {
                        util:fbin(Format, [Rank, RSumScore, GuildDevote, Exp, Alive, AliveScore]), 
                        [{?mail_exp, Exp}, {?mail_guild_war, RSumScore + AliveScore}, {?mail_guild_devote, GuildDevote}, {?mail_activity, 30}]
                    };
                _ -> {?L(<<"很遗憾，在本次帮战中，您的个人获得的总积分不够30分，不能获得任何奖励。">>), []}
            end,
            spawn(fun() -> mail:send_system(Id, {Title, Content, AssetInfo, Items}) end),
            {NewRs, Gs}
    end,
    {NewRoles, NewGuilds} = lists:foldl(F, {Roles, Guilds}, Roles),

    %%如果是最后一轮在这里给前三名帮派发奖励
    case Type of
        finish ->
            mvps_reward(StateId, Mvps, ?guild_arena_rank_role_reward, 1),
            add_guild_treasure(GuildRank, NewGuilds, 1);
        _ ->
            ok
    end,
    {NewRoles, NewGuilds}.

%% 给前三名，发奖励、聊天公告和帮主邮件
add_guild_treasure([], _, _) ->
    ok;
add_guild_treasure(_, _, Rank) when Rank > 3 ->
    ok;
add_guild_treasure([{Id, _} | T], Guilds, Rank) ->
    case lists:keyfind(Id, #arena_guild.id, Guilds) of
        #arena_guild{id = Id, chief = Chief, sum_score = Score, name = Name} ->
            Msg = lists:nth(Rank, [?L(<<"恭喜您们的帮会在本次帮会战中脱颖而出，成为本次帮会战的冠军！奖励已经发送到帮会宝库，请帮主及时分配。">>), ?L(<<"恭喜您们的帮会在本次帮会战中脱颖而出，成为本次帮会战的亚军！奖励已经发送到帮会宝库，请帮主及时分配。">>), ?L(<<"恭喜您们的帮会在本次帮会战中脱颖而出，成为本次帮会战的季军！奖励已经发送到帮会宝库，请帮主及时分配。">>)]),
            Reward = lists:nth(Rank, [?guild_arena_reward_guild_no1, ?guild_arena_reward_guild_no2, ?guild_arena_reward_guild_no3]),
            TvFormat = lists:nth(Rank, [?L(<<" 恭喜 <font color='#7cfc00'>~s</font> 帮会在本次帮战中表现优异，获得第<font color='#7cfc00'>一</font>名。成为本次帮战的<font color='#7cfc00'>冠军</font>帮会！">>), ?L(<<" 恭喜 <font color='#7cfc00'>~s</font> 帮会在本次帮战中表现优异，获得第<font color='#7cfc00'>二</font>名。成为本次帮战的<font color='#7cfc00'>亚军</font>帮会！">>), ?L(<<" 恭喜 <font color='#7cfc00'>~s</font> 帮会在本次帮战中表现优异，获得第<font color='#7cfc00'>三</font>名。成为本次帮战的<font color='#7cfc00'>季军</font>帮会！">>)]),
            notice:send(53, util:fbin(TvFormat, [Name])),
            guild_treasure:add(Id, ?guild_treasure_arean, Reward),
            guild:guild_chat(Id, Msg),
            Content = util:fbin(?L(<<"在本次帮战中，您所在帮会获得第 ~w 名。\n共获得 ~w 积分，增加 ~w 帮会资金。\n并获得相应奖励，请在帮会宝库里查收！">>), [Rank, Score, Score div 4]),
            spawn(fun() -> mail:send_system(Chief, {?L(<<"帮战奖励">>), Content, [], []}) end),
            add_guild_treasure(T, Guilds, Rank + 1);
        _ ->
            add_guild_treasure(T, Guilds, Rank + 1)
    end.

%% 开服前两场给前6名玩家发奖励
mvps_reward(Id, [#guild_arena_role{id = Rid, score = Score} | T], [IH | IT], Rank) when Id < 3 andalso Score >= ?guild_arena_base_reward_score andalso Rank < 7 ->
    Title = ?L(<<"帮战个人奖励">>), 
    Content = util:fbin(?L(<<"帮会战，开服前两场，获得个人积分前六名能额外获得此奖励！\n 你在本场帮战表现：\n获得积分~w。个人排名：~w \n 请查收！！">>), [Score, Rank]),
    AssetInfo = [],
    spawn(fun() -> mail:send_system(Rid, {Title, Content, AssetInfo, IH}) end),
    mvps_reward(Id, T, IT, Rank + 1);
mvps_reward(_, _, _, _) ->
    ok.




%% 推送给以进入战区的玩家
push_to_area(area_guilds, {Aid, Guilds, Roles}) ->
    NewGuilds = sort_guild(score, Guilds),
    Num = length(NewGuilds),
    PushData = get_page_list({Num, NewGuilds}, 1, ?guild_arena_panel_size),
    [guild_arena_rpc:push(Pid, area_guilds, PushData) || #guild_arena_role{pid = Pid, aid = PAid} <- Roles, Aid =:= PAid].

%% 推送给已参战帮派的成员
push_to_guilds(open_invite, Type, Guilds) ->
    [guild:pack_send(Gid, 15913, {Type}) || #arena_guild{id = Gid} <- Guilds].

%% 推送个人战绩
push_mine_info(Type, ArenaRole = #guild_arena_role{pid = Pid}, RoundScore, EnemyNames) ->
    guild_arena_rpc:push(Pid, mine, {Type, ArenaRole, RoundScore, EnemyNames}).

%% 把状态表示转成协议可用的整形数据
state_to_integer(idle) ->
    ?guild_arena_state_idle;
state_to_integer(sign) ->
    ?guild_arena_state_sign;
state_to_integer(ready) ->
    ?guild_arena_state_ready;
state_to_integer(stay) ->
    ?guild_arena_state_finish;
state_to_integer(round) ->
    ?guild_arena_state_round;
state_to_integer(rest) ->
    ?guild_arena_state_rest;
state_to_integer(finish) ->
    ?guild_arena_state_finish;
state_to_integer(_S) ->
    ?guild_arena_state_idle.

%% 获取分页列表
get_page_list({_N, []}, _P, _S) -> 
    {1, [], 0};
get_page_list({Num, List}, Page, Size) when is_integer(Num) andalso is_list(List) andalso is_integer(Page) ->
    NewPage = min(max(Page, 1), max(1, util:ceil(Num / Size))),
    StartId = (NewPage - 1) * Size + 1,
    %% ?DEBUG("page ~p size ~p", [NewPage, Size]),
    NewList = lists:sublist(List, StartId, Size),
    {NewPage, NewList, Num};
get_page_list(_Y, _P, _S) -> 
    {1, [], 0}.

%% 战斗结束后积分处理，和判断战区是否已经出结果
%% 首先处理失败方
calc_score({Rid, Res1, lost, _}, {Area, Rs, Gs, WName, LName}) ->
    case lists:keyfind(Rid, #guild_arena_role.id, Rs) of
        Role = #guild_arena_role{gid = Gid, score = RScore, die = RDie, lost = RLost, sum_lost = RSumLost, sum_score = RSumScore, is_camp_adm_time = IsCampAdmTime} ->
            Res = case IsCampAdmTime of
                true -> Res1 * 2;
                _ -> Res1
            end,
            Now = util:unixtime(),
            %% 达到重生次数用完了，对应帮派要检查下是否输掉了
            case lists:keyfind(Gid, #arena_guild.id, Gs) of
                %% 帮派最后一个人被干掉了,战区被干掉帮派数增加
                Guild = #arena_guild{score = GScore, die = MDie, join_num = JoinNum, lost = GLost, sum_lost = GSumLost, sum_score = GSumScore} when RDie + 1 =:= ?guild_arena_role_max_die andalso JoinNum =:= MDie + 1 ->
                    case Area of
                        #arena_area{guild_die = GuildDie} ->
                            NewArea = Area#arena_area{
                                guild_die = GuildDie + 1
                            },
                            NewGuild = Guild#arena_guild{
                                die = MDie + 1, 
                                score = GScore + Res, 
                                lost = GLost + 1,
                                sum_score = GSumScore + Res,
                                sum_lost = GSumLost + 1
                            },
                            NewRole = Role#guild_arena_role{
                                score = RScore + Res, 
                                die = ?guild_arena_role_max_die, 
                                lost = RLost + 1,
                                last_death = Now,
                                is_fighting = 0,
                                sum_score = RSumScore + Res,
                                sum_lost = RSumLost + 1
                            },
                            push_mine_info(2, NewRole, Res, WName),
                            send_role_to_map(NewRole, Area),
                            %% 用完重生机会的人要送出队伍
                            role_apply(Role, {fun apply_leave_team/1, []}),
                            
                            {
                                NewArea,
                                lists:keyreplace(Rid, #guild_arena_role.id, Rs, NewRole), 
                                lists:keyreplace(Gid, #arena_guild.id, Gs, NewGuild), 
                                WName,
                                LName
                            };
                        _ -> {Area, Rs, Gs, WName, LName}
                    end;
                %% 帮派被干掉人数增加
                Guild = #arena_guild{score = GScore, die = MDie, lost = GLost, sum_lost = GSumLost, sum_score = GSumScore} when RDie + 1 =:= ?guild_arena_role_max_die  ->
                    NewGuild = Guild#arena_guild{
                        die = MDie + 1, 
                        score = GScore + Res, 
                        lost = GLost + 1,
                        sum_score = GSumScore + Res,
                        sum_lost = GSumLost + 1
                    },
                    NewRole = Role#guild_arena_role{
                        score = RScore + Res, 
                        die = ?guild_arena_role_max_die, 
                        lost = RLost + 1,
                        is_fighting = 0,
                        last_death = Now,
                        sum_score = RSumScore + Res,
                        sum_lost = RSumLost + 1
                    },
                    push_mine_info(2, NewRole, Res, WName),
                    send_role_to_map(NewRole, Area),
                    %% 用完重生机会的人要送出队伍
                    role_apply(Role, {fun apply_leave_team/1, []}),
                    {
                        Area, 
                        lists:keyreplace(Rid, #guild_arena_role.id, Rs, NewRole), 
                        lists:keyreplace(Gid, #arena_guild.id, Gs, NewGuild), 
                        WName,
                        LName
                    };
                Guild = #arena_guild{score = GScore, lost = GLost, sum_lost = GSumLost, sum_score = GSumScore} ->
                    NewGuild = Guild#arena_guild{
                        score = GScore + Res, 
                        lost = GLost + 1,
                        sum_score = GSumScore + Res,
                        sum_lost = GSumLost + 1
                    },
                    NewRole = Role#guild_arena_role{
                        die = RDie + 1,
                        score = RScore + Res, 
                        lost = RLost + 1,
                        last_death = Now,
                        is_fighting = 0,
                        sum_score = RSumScore + Res,
                        sum_lost = RSumLost + 1
                    },
                    push_mine_info(2, NewRole, Res, WName),
                    send_role_to_map(NewRole, Area),
                    {
                        Area, 
                        lists:keyreplace(Rid, #guild_arena_role.id, Rs, NewRole), 
                        lists:keyreplace(Gid, #arena_guild.id, Gs, NewGuild), 
                        WName,
                        LName
                    };
                _ -> {Area, Rs, Gs, WName, LName}
            end;
        _ -> {Area, Rs, Gs, WName, LName}
    end;
%% 再看看胜利方（队伍应了，但自己挂了）
calc_score({Rid, Res1, win, ?true}, {Area, Rs, Gs, WName, LName}) ->
    case lists:keyfind(Rid, #guild_arena_role.id, Rs) of
        %% 胜利了就看看战区还有没有对手
        Role = #guild_arena_role{gid = Gid, score = RScore, kill = RKill, sum_kill = RSumKill, sum_score = RSumScore, die = Die, is_camp_adm_time = IsCampAdmTime} ->
            Res = case IsCampAdmTime of
                true -> Res1 * 2;
                _ -> Res1
            end,
            Now = util:unixtime(),
            case lists:keyfind(Gid, #arena_guild.id, Gs) of
                Guild = #arena_guild{score = GScore, aid = Aid, kill = GKill, sum_kill = GSumkill, sum_score = GSumScore, die = MDie} ->
                    NewArea = case Area of
                        %% 战区最后一个帮派被干掉了, 就把当前帮派标注为本战区胜利者
                        #arena_area{guild_num = GuildNum, guild_die = GuildDie, winner = 0} when GuildNum =:= GuildDie + 1 ->
                            %% 准备广播
                            area_over(Aid),
                            Area#arena_area{winner = Gid};
                        _ -> Area
                    end,

                    %% 看看是不是帮派损失一个人了
                    NewMDie = case Die + 1 of
                        ?guild_arena_role_max_die -> MDie + 1;
                        _ -> MDie
                    end,

                    NewGuild = Guild#arena_guild{
                        score = GScore + Res, 
                        kill = GKill + 1,
                        die = NewMDie,
                        sum_score = GSumScore + Res,
                        sum_kill = GSumkill + 1
                    },
                    NewRole = Role#guild_arena_role{
                        score = RScore + Res, 
                        kill = RKill + 1,
                        is_fighting = 0,
                        last_death = Now,
                        sum_score = RSumScore + Res,
                        die = Die + 1,
                        sum_kill = RSumKill + 1
                    },
                    send_role_to_map(NewRole, Area),
                    case Die + 1 of
                        ?guild_arena_role_max_die ->
                            %% 用完重生机会的人要送出队伍
                            role_apply(Role, {fun apply_leave_team/1, []});
                        _ -> ok
                    end,
                    push_mine_info(1, NewRole, Res, LName),
                    {
                        NewArea, 
                        lists:keyreplace(Rid, #guild_arena_role.id, Rs, NewRole),
                        lists:keyreplace(Gid, #arena_guild.id, Gs, NewGuild),
                        WName,
                        LName
                    };
                _ -> {Area, Rs, Gs, WName, LName}
            end;
        _ -> {Area, Rs, Gs, WName, LName}
    end;
%% 再看看胜利方
calc_score({Rid, Res1, win, _}, {Area, Rs, Gs, WName, LName}) ->
    case lists:keyfind(Rid, #guild_arena_role.id, Rs) of
        %% 胜利了就看看战区还有没有对手
        Role = #guild_arena_role{gid = Gid, score = RScore, kill = RKill, sum_kill = RSumKill, sum_score = RSumScore, is_camp_adm_time = IsCampAdmTime} ->
            Res = case IsCampAdmTime of
                true -> Res1 * 2;
                _ -> Res1
            end,
            case lists:keyfind(Gid, #arena_guild.id, Gs) of
                Guild = #arena_guild{score = GScore, aid = Aid, kill = GKill, sum_kill = GSumkill, sum_score = GSumScore} ->
                    NewArea = case Area of
                        %% 战区最后一个帮派被干掉了, 就把当前帮派标注为本战区胜利者
                        #arena_area{guild_num = GuildNum, guild_die = GuildDie, winner = 0} when GuildNum =:= GuildDie + 1 ->
                            %% 准备广播
                            area_over(Aid),
                            Area#arena_area{winner = Gid};
                        _ -> Area
                    end,
                    Now = util:unixtime(),
                    NewGuild = Guild#arena_guild{
                        score = GScore + Res, 
                        kill = GKill + 1,
                        sum_score = GSumScore + Res,
                        sum_kill = GSumkill + 1
                    },
                    NewRole = Role#guild_arena_role{
                        score = RScore + Res, 
                        kill = RKill + 1,
                        is_fighting = 0,
                        last_death = Now + ?guild_arena_win_protect_time,
                        sum_score = RSumScore + Res,
                        sum_kill = RSumKill + 1
                    },
                    push_mine_info(1, NewRole, Res, LName),
                    {
                        NewArea, 
                        lists:keyreplace(Rid, #guild_arena_role.id, Rs, NewRole),
                        lists:keyreplace(Gid, #arena_guild.id, Gs, NewGuild),
                        WName,
                        LName
                    };
                _ -> {Area, Rs, Gs, WName, LName}
            end;
        _ -> {Area, Rs, Gs, WName, LName}
    end;
calc_score(_, {Area, Rs, Gs, WName, LName}) ->
    {Area, Rs, Gs, WName, LName}.

get_camp_time() ->
    case util:platform(undefined) of
        "koramgame" -> 
            BeginTime = util:datetime_to_seconds({{2013, 1, 29},{0,0,1}}),
            EndTime = util:datetime_to_seconds({{2013, 2, 2},{23,59,59}}),
            {BeginTime, EndTime};
        _ ->
            BeginTime = util:datetime_to_seconds({{2013, 1, 29},{0,0,1}}),
            EndTime = util:datetime_to_seconds({{2013, 2, 2},{23,59,59}}),
            {BeginTime, EndTime}
    end.

%% 如果玩家吃了加积分的药，就给他加积分
calc_buff_score(BaseScore, GLflag) ->
    ?DEBUG("flag ~p", [GLflag]),
    Now = util:unixtime(),
    {Begin, End} = get_camp_time(),
    Ratio = case Now >= Begin andalso Now =< End of
        true -> 2;
        false -> 1
    end,
    case lists:keyfind(?guild_arena_score_buff, 1, GLflag) of
        {_, 1} -> round(BaseScore * 1.5 * Ratio);
        _ -> round(BaseScore * Ratio)
    end.

%% 处理帮战守护帮会buff
handle_buff(_, undefined) ->
    ok;
handle_buff(Type, Owner) ->
    case guild_mgr:lookup(by_id, Owner) of
        #guild{members = Members} ->
            handle_buff(role, Type, Members);
        _ ->
            ok
    end.

handle_buff(role, _, []) ->
    ok;
handle_buff(role, Type, [#guild_member{pid = Rpid} | T]) ->
    case guild_war_util:check([{is_pid_alive, Rpid}]) of
        ok ->
            role:apply(async, Rpid, {fun apply_handle_buff/2, [Type]}),
            handle_buff(role, Type, T);
        _ ->
            handle_buff(role, Type, T)
    end;
handle_buff(role, _, _) ->
    ok.

apply_handle_buff(Role = #role{looks = Looks}, del) ->
    case lists:keyfind(?LOOKS_TYPE_GUILD_WAR_HONOR, 1, Looks) of
        {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_WAR_CHIEF} ->
            {ok};
        {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_WAR_MEMBER} ->
            {ok};
        _ ->
            case buff:del_buff_by_label(Role, ?guild_arena_winner_buffer) of
                false ->
                    {ok};
                {ok, NewRole} ->
                    {ok, NewRole}
            end
    end;
apply_handle_buff(Role = #role{looks = Looks}, add) ->
    %% 如果有任何其他优先的buff，则不用增加
    case lists:keyfind(?LOOKS_TYPE_GUILD_WAR_HONOR, 1, Looks) of
        {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_WAR_CHIEF} ->
            {ok};
        {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_WAR_MEMBER} ->
            {ok};
        {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_ARENA_CROSS_WINNER} ->
            {ok};
        {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_ARENA_CROSS_WINNER_CHIEF} ->
            {ok};
        {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_ARENA_CROSS_JOIN} ->
            {ok};
        _ ->
            case buff:add(Role, ?guild_arena_winner_buffer) of
                {false, _Reason} ->
                    {ok};
                {ok, NewRole} ->
                    Nr2 = role_api:push_attr(NewRole),
                    {ok, Nr2}
            end
    end.

%% 处理称号
handle_honor(_Type, undefined) ->
    ok;
handle_honor(Type, Gid) ->
    case guild_mgr:lookup(by_id, Gid) of
        #guild{members = Members} ->
            handle_honor_guild(role, Type, Members);
        _ ->
            ok
    end.

handle_honor_guild(role, _Type, []) ->
    ok;
handle_honor_guild(role, Type, [#guild_member{pid = Rpid} | T]) ->
    case guild_war_util:check([{is_pid_alive, Rpid}]) of
        ok ->
            role:apply(async, Rpid, {fun apply_handle_honor/2, [Type]}),
            handle_honor_guild(role, Type, T);
        _ ->
            handle_honor_guild(role, Type, T)
    end;
handle_honor_guild(role, _, _) ->
    ok.

apply_handle_honor(Role = #role{looks = Looks}, del) ->
    case lists:keyfind(?LOOKS_TYPE_GUILD_WAR_HONOR, 1, Looks) of
        {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_WAR_CHIEF} ->
            {ok};
        {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_WAR_MEMBER} ->
            {ok};
        {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_ARENA_CROSS_WINNER} ->
            {ok};
        {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_ARENA_CROSS_WINNER_CHIEF} ->
            {ok};
        {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_ARENA_CROSS_JOIN} ->
            {ok};
        _ ->
            NewRole = Role#role{looks = lists:keydelete(?LOOKS_TYPE_GUILD_WAR_HONOR, 1, Looks)},
            map:role_update(NewRole),
            {ok, NewRole}
    end;
apply_handle_honor(Role = #role{guild = #role_guild{position = Pos}, looks = Looks}, add) ->
    Glooks = case Pos of
        ?guild_chief ->
            {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_ARENA_CHIEF};
        _ ->
            {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_ARENA_MEMBER}
    end,
    NewLooks = case lists:keyfind(?LOOKS_TYPE_GUILD_WAR_HONOR, 1, Looks) of
        false ->
            [Glooks | Looks];
        {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_WAR_CHIEF} ->
            Looks;
        {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_WAR_MEMBER} ->
            Looks;
        {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_ARENA_CROSS_WINNER} ->
            Looks;
        {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_ARENA_CROSS_WINNER_CHIEF} ->
            Looks;
        {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_ARENA_CROSS_JOIN} ->
            Looks;
        _ ->
            lists:keyreplace(?LOOKS_TYPE_GUILD_WAR_HONOR, 1, Looks, Glooks)
    end,
    NewRole = Role#role{looks = NewLooks},
    map:role_update(NewRole),
    {ok, NewRole}.

%% 登录时buff和称号处理
login_buff_honor(Role = #role{name = _Name, guild = #role_guild{gid = Gid, srv_id = GsrvId, position = Pos}, looks = Looks}, {Gid, GsrvId}) ->
    Glooks = case Pos of
        ?guild_chief ->
            {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_ARENA_CHIEF};
        _ ->
            {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_ARENA_MEMBER}
    end,
    %% 要区分下是否是阵营战的奖励如果是属于阵营战的，这里就不要处理
    NewLooks = case lists:keyfind(?LOOKS_TYPE_GUILD_WAR_HONOR, 1, Looks) of
        false ->
            [Glooks | Looks];
        {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_WAR_CHIEF} ->
            Looks;
        {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_WAR_MEMBER} ->
            Looks;
        {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_ARENA_CROSS_WINNER} ->
            Looks;
        {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_ARENA_CROSS_WINNER_CHIEF} ->
            Looks;
        {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_ARENA_CROSS_JOIN} ->
            Looks;
        _ ->
            lists:keyreplace(?LOOKS_TYPE_GUILD_WAR_HONOR, 1, Looks, Glooks)
    end,
    case apply_handle_buff(Role, add) of
        {ok, NewRole} ->
            NewRole#role{looks = NewLooks};
        _R2 ->
            Role#role{looks = NewLooks}
    end;
%% 如果是阵营战的奖励，就不需要处理了
login_buff_honor(Role = #role{name = _Name, looks = Looks}, _) ->
    case lists:keyfind(?LOOKS_TYPE_GUILD_WAR_HONOR, 1, Looks) of
        {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_ARENA_CROSS_WINNER} ->
            Role;
        {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_ARENA_CROSS_WINNER_CHIEF} ->
            Role;
        {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_WAR_CHIEF} ->
            Role;
        {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_WAR_MEMBER} ->
            Role;
        {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_ARENA_CROSS_JOIN} ->
            Role;
        _ ->
            NewLooks = lists:keydelete(?LOOKS_TYPE_GUILD_WAR_HONOR, 1, Looks),
            case apply_handle_buff(Role, del) of
                {ok, NewRole} ->
                    NewRole#role{looks = NewLooks};
                _R2 ->
                    Role#role{looks = NewLooks}
            end
    end.

%% 以下部分是关于机器人的处理
%% 初始化机器人
init_robot({_, MapId}, RoleNum) ->
    RobotNum = min(60, max(10, RoleNum div 3)),
    create_robot(?guild_arena_robot_id, MapId, RobotNum, []).

create_robot(_NpcList, _MapId, Num, Npcs) when Num < 1 -> 
    Npcs;
create_robot(NpcList, MapId, Num, Npcs) ->
    N = util:rand(1, 100),
    {Brx, Bry} = case lists:nth(N, ?guild_arena_map_enter_point) of
        {Bx, By} -> {Bx, By};
        _ -> 
            [H | _] = ?guild_arena_map_enter_point,
            H
    end,
    NewX = util:rand(Brx - 100, Brx + 100),
    NewY = util:rand(Bry - 100, Bry + 100),
    case npc_mgr:create(util:rand_list(NpcList), MapId, NewX, NewY) of
        {ok, NpcBaseId} ->
            create_robot(NpcList, MapId, Num - 1, [NpcBaseId | Npcs]);
        _Reason ->
            ?ERR("新帮战生成机器人失败:~w", [_Reason]),
            create_robot(NpcList, MapId, Num - 1, Npcs)
    end.

