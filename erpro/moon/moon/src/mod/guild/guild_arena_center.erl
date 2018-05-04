%%----------------------------------------------------
%% @doc 跨服帮战战区处理 round（战斗回合）
%%
%% @author Jangee@qq.com
%% @end
%%----------------------------------------------------
-module(guild_arena_center).
-behaviour(gen_fsm).
%% 外部调用接口
-export(
    [
        combat_start/1,
        combat_over/3,
        stop_collect/1,
        area_over/2,
        get_info/2,
        get_score_buff/1,
        adm_next/0,
        adm_restart/0,
        adm_stop/0,
        adm_hide/0,
        adm_id/1,
        async_reward/3
    ]).


%% 各状态处理
-export([round/2, finish/2, hide/2]).
%% otp apis
-export([start_link/3]).
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

%% 战区状态数据
-record(state, 
    {
        id = 0,         %% 第几届
        roles = [],     %% 参战玩家
        guilds = [],     %% 参战帮派
        area = #arena_area{},      %% 战区
        role_num = 0,
        guild_num = 0,
        last_winner = 0, %% 上届冠军
        round = 0,       %% 当前是第几轮
        started = 0,     %% 当前状态开启时间
        round_ready = 0, %% 战区是否准备好了
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
%% 战胜机器人固定积分
-define(guild_arena_robot_score, 20).
%% 开服前两场积分前六名玩家奖励
-define(guild_arena_rank_role_reward, [{29110, 1, 1}, {29110, 1, 1}, {29110, 1, 1}, {29110, 1, 1}, {29110, 1, 1}, {29110, 1, 1}]).
%% 战区进要比主进程延后一点再结束
-define(guild_arena_finish_interval, 120000).

%% 第一轮奖励
-define(guild_arena_reward_guild_no1_cross1, [{29114, 1, 5}, {25022, 1, 5}]).
-define(guild_arena_reward_guild_no2_cross1, [{29114, 1, 3}, {25022, 1, 3}]).
-define(guild_arena_reward_guild_no3_cross1, [{29115, 1, 3}, {25022, 1, 2}]).
-define(guild_arena_reward_guild_no4_cross1, [{29115, 1, 2}, {25022, 1, 1}]).
%% 第二轮奖励
-define(guild_arena_reward_guild_no1_cross2, [{29114, 1, 5}, {25022, 1, 5}]).
-define(guild_arena_reward_guild_no2_cross2, [{29114, 1, 3}, {25022, 1, 3}]).
-define(guild_arena_reward_guild_no3_cross2, [{29115, 1, 3}, {25022, 1, 2}]).
-define(guild_arena_reward_guild_no4_cross2, [{29115, 1, 2}, {25022, 1, 1}]).
%% 第三轮奖励
-define(guild_arena_reward_guild_no1_cross3, [{29114, 1, 5}, {25022, 1, 5}, {33113, 1, 8}]).
-define(guild_arena_reward_guild_no2_cross3, [{29114, 1, 3}, {25022, 1, 3}, {33113, 1, 5}]).
-define(guild_arena_reward_guild_no3_cross3, [{29115, 1, 3}, {25022, 1, 2}, {33113, 1, 4}]).
-define(guild_arena_reward_guild_no4_cross3, [{29115, 1, 2}, {25022, 1, 1}, {33113, 1, 3}]).

%% ---------- 外部接口部分 ----------
%% @spec get_info(all) -> Result
%% Result = record(state)
%% @doc 获取帮战所有状态信息
get_info(EventPid, all) ->
    sync_call(EventPid, {info, all});

%% @spec get_info(guild_num) -> Result
%% Result = integer()
%% @doc 获取帮战报名帮派总数
get_info(EventPid, guild_num) ->
    sync_call(EventPid, {info, guild_num});

%% @spec get_info(state_time) -> {Id, StateName, Timeout}
%% Rid = tuple() 玩家ID
%% Id = integer() 当前是第几届
%% StateName = atom() 状态名称
%% Timeout = integer() 距离下个状态还有多少毫秒
%% @doc 获取帮战的当前状态名称和距离下个状态的超时
get_info(EventPid, {state_time, Rid}) ->
    sync_call(EventPid, {info, state_time, Rid});


%% @spec get_info({guilds, Page}) -> {NewPage, Guilds, GuildNum}
%% Page = integer() 要查看的页码
%% NewPage = integer() 实际有效的页码
%% Guilds = list() 对应页的帮派列表
%% GuildNum = integer() 总帮派数
%% @doc 获取参战帮派信息（分页）
get_info(EventPid, {guilds, Page}) when is_integer(Page) ->
    get_page_list(sync_call(EventPid, {info, guilds}), Page, ?guild_arena_list_size);

%% @spec get_info({sign_guilds, Page}) -> {NewPage, Guilds, GuildNum}
%% Page = integer() 要查看的页码
%% NewPage = integer() 实际有效的页码
%% Guilds = list() 对应页的帮派列表
%% GuildNum = integer() 总帮派数
%% @doc 获取参战帮派信息按等级排名（分页）
get_info(EventPid, {sign_guilds, Page}) when is_integer(Page) ->
    get_page_list(sync_call(EventPid, {info, sign_guilds}), Page, ?guild_arena_list_size);

%% @spec get_info({area_guilds, Page, Rid}) -> {NewPage, Guilds, GuildNum}
%% Page = integer() 要查看的页码
%% Rid = tuple() = {integer(), string()} 玩家ID
%% NewPage = integer() 实际有效的页码
%% Guilds = list() 对应页的帮派列表
%% GuildNum = integer() 总帮派数
%% @doc 获取战区帮派信息（分页）
get_info(EventPid, {area_guilds, Page, Rid}) when is_integer(Page) ->
    get_page_list(sync_call(EventPid, {info, guilds, Rid}), Page, ?guild_arena_panel_size);

%% @spec get_info({roles, Page}) -> {NewPage, Roles, RoleNum}
%% Page = integer() 要查看的页码
%% NewPage = integer() 实际有效的页码
%% Roles = list() 对应页的玩家列表
%% RoleNum = integer() 总参战人数
%% @doc 获取参战玩家信息（分页）
get_info(EventPid, {roles, Page}) when is_integer(Page) ->
    sync_call(EventPid, {info, roles, Page});

%% @spec get_info({area_roles, Page, Rid}) -> {NewPage, Guilds, GuildNum}
%% Page = integer() 要查看的页码
%% Rid = tuple() = {integer(), string()} 玩家ID
%% NewPage = integer() 实际有效的页码
%% Guilds = list() 对应页的帮派列表
%% GuildNum = integer() 总帮派数
%% @doc 获取战区玩家信息（分页）
get_info(EventPid, {area_roles, Page, Rid}) when is_integer(Page) ->
    sync_call(EventPid, {info, roles, Rid, Page});

%% @spec get_info({my_rank, Rid}) -> {NewPage, Guilds, GuildNum}
%% Rid = tuple() = {integer(), string()} 玩家ID
%% NewPage = integer() 实际有效的页码
%% Roles = list() 对应页的玩家列表
%% RoleNum = integer() 总帮派数
%% @doc 获取玩家排名所在的页
get_info(EventPid, {my_rank, Rid}) ->
    sync_call(EventPid, {info, my_rank, Rid});

%% @spec get_info({my_guild_rank, Gid}) -> {NewPage, Guilds, GuildNum}
%% Gid = tuple() = {integer(), string()} 帮派ID
%% NewPage = integer() 实际有效的页码
%% Guilds = list() 对应页的帮派列表
%% GuildNum = integer() 总帮派数
%% @doc 获取战区玩家信息（分页）
get_info(EventPid, {my_guild_rank, Gid}) ->
    {GuildNum, Guilds} = sync_call(EventPid, {info, guilds}),
    RankNum = get_rank(guild, 1, Gid, Guilds),
    Page = util:ceil(RankNum / ?guild_arena_list_size),
    get_page_list({GuildNum, Guilds}, Page, ?guild_arena_list_size);

%% @spec get_info({mine, Id}) -> {ArenaRole}
%% Id = tuple() 玩家ID
%% ArenaRole = record(guild_arena_role)
%% @doc 获取个人战绩
get_info(EventPid, {mine, Id}) ->
    sync_call(EventPid, {info, mine, Id});

get_info(_E, _Type) ->
    ?DEBUG("无效参数 ~p", [_Type]).

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


%% @spec combat_start(FighterIds) -> ok
%% FighterIds = list() = [Id | _]
%% Id = tuple() = {integer(), string()} 玩家ID
%% @doc 开战前要处理的一些东西
combat_start(Fighters) ->
    async_call({combat_start, Fighters}).

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
combat_over(_P, Winner, Loser) ->
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

%% @spec stop_collect(Role) -> ok
%% Role = record(role)
%% @doc 取消一个玩家的采集运动
stop_collect(_) ->
    ok.

%% @spec area_over(Rid) -> ok
%% Rid = tuple() = {integer(), string()} 玩家ID
%% @doc 一个战区的比赛结束，该评选优胜者
area_over(EventPid, Aid) ->
    async_call(EventPid, {area_over, Aid}).

%% ----- otp接口部分 ------

start_link(Area, Roles, Round)->
    gen_fsm:start_link(?MODULE, [Area, Roles, Round], []).

%% 启动初始化后立即进入空闲状态吧
init([Area = #arena_area{map = Map}, Roles, Round])->
    RoleNum = length(Roles),
    Robots = init_robot(Map, 10),
    State = #state{
        started = util:unixtime(ms),
        area = Area#arena_area{gids = []},
        guilds = Area#arena_area.gids,
        round = Round,
        roles = Roles,
        role_num = RoleNum,
        guild_num = Area#arena_area.guild_num,
        robots = Robots,
        robot_relive = length(Robots)
    },
    ?DEBUG("战区进程启动"),
    erlang:send_after(30000, self(), make_sort),
    {ok, round, State, ?guild_arena_round_interval}.

%% GM命令进入下个状态
handle_event(admin, StateName, State) ->
    ?MODULE:StateName(timeout, State);

%% GM命令帮战终止
handle_event(admin_stop, _, State) ->
    finish(timeout, State);

%% GM命令把帮战隐藏起来
handle_event(admin_hide, _, State) ->
    hide(timeout, State);

%% GM命令更改当前帮战届次
handle_event({admin_id, Id}, StateName, State) ->
    {next_state, StateName, State#state{id = Id}, timeout(StateName, State)};

%% GM命令更改当前帮战轮次
handle_event({admin_round, Round}, StateName, State) when is_integer(Round) ->
    {next_state, StateName, State#state{round = Round}, timeout(StateName, State)};

%% 玩家退出帮战,对应帮派总战斗力减少,参战总人数减少
%% 只在战斗期间和准备期间要处理下数据，其他阶段忽略
handle_event({off, _Id}, sign, State) ->
    {next_state, sign, State, timeout(sign, State)};
%% 退出帮战如果不是已阵亡的人退出帮战要看看他的帮派是否已阵亡
handle_event({off, Id}, StateName, State = #state{roles = Roles, guilds = Guilds, role_num = RoleNum, area = Area}) ->
    {NewRoles, NewGuilds, NewRoleNum, NewArea2} = case lists:keyfind(Id, #guild_arena_role.id, Roles) of
        %% 要确定下个人是否已经参战
        ArenaRole = #guild_arena_role{gid = Gid} ->
            %% 帮派要参战才有继续处理的必要
            {ArenaGuilds, NewArea1} = case lists:keyfind(Gid, #arena_guild.id, Guilds) of
                ArenaGuild = #arena_guild{id = Gid} ->
                    {NewArenaGuild, NewArea} = role_off(StateName, ArenaGuild, ArenaRole, Area),
                    {
                        lists:keyreplace(Gid, #arena_guild.id, Guilds, NewArenaGuild),
                        NewArea
                    };
                _ -> {Guilds, Area}
            end,
            %% 确保下两组返回值个数统一吧
            {
                lists:keyreplace(Id, #guild_arena_role.id, Roles, ArenaRole#guild_arena_role{offline = 1}),
                ArenaGuilds, 
                RoleNum, 
                NewArea1
            };
        _ -> {Roles, Guilds, RoleNum, Area}
    end,
    NewState = State#state{
        roles = NewRoles, 
        guilds = NewGuilds, 
        area = NewArea2,
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
handle_event({combat_over, Winner, Loser, WinnerNames, LoserNames}, round, State = #state{area = Area, roles = Roles, guilds = Guilds}) ->
    _StMs = util:unixtime(ms),
    %% 全部写在一句里是有点坑爹，这里其实是先处理好失败者在处理胜利者
    {NewArenaArea, NewRoles, NewArenaGuilds, _W, _L} = lists:foldl(fun calc_score/2, lists:foldl(fun calc_score/2, {Area, Roles, Guilds, WinnerNames, LoserNames}, Loser), Winner),
    %% 在这里通知战区刷新下数据
    PushData = sort_guild(score, NewArenaGuilds),
    push_to_area(area_guilds, {Area#arena_area.id, PushData, NewRoles}),
    ?DEBUG("time used ~p", [util:unixtime(ms) - _StMs]),
    {next_state, round, State#state{area = NewArenaArea, roles = NewRoles, guilds = NewArenaGuilds}, timeout(round, State)};
handle_event({combat_over, _, _, _, _}, StateName, State) ->
    {next_state, StateName, State, timeout(StateName, State)};

%% 机器人阵亡后的处理
handle_event({combat_robot_over, NpcId}, round, State = #state{robot_relive = RobotRelive, robots = Robots, area = #arena_area{map = {_, MapId}}}) ->
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
handle_event({area_over, _Aid}, round, State = #state{id = Id, area = Area, roles = Roles, round = Round, guilds = Guilds, round_ready = 1}) ->
    Timeout = ?guild_arena_finish_interval,
    Started = util:unixtime(ms),
    %% 每一轮结束到这里要找出胜利者
    NewArea = find_area_winner(Area, Guilds),
    ?DEBUG("新帮战提前进入 ~p 状态", [finish]),
    % push_to_onlines(state_time, {Id, idle, ?guild_arena_rest_interval}),
    Winner = case NewArea of
        #arena_area{winner = WinGid} -> WinGid;
        _ -> 0
    end,
    case {Winner, Round} of
        {0, _} -> ok;
        {_, 3} -> make_cross_king(Winner);
        _ -> ok
    end,
    {NewRoles, NewGuilds} = round_push_and_reward(Id, {Round, finish}, NewArea, Roles, Guilds),
    NewState = State#state{
        started = Started, 
        area = NewArea, 
        last_winner = Winner, 
        roles = NewRoles, 
        guilds = NewGuilds
    },
    guild_arena_center_mgr:area_finish(NewArea, NewRoles, NewGuilds, Round),
    {next_state, finish, NewState, Timeout};

%% 重新登录时要注册下
handle_event({login, _Rid, Pid, _Gid, _Map}, StateName, State) when StateName =:= idle orelse StateName =:= sign orelse StateName =:= finish ->
    role:apply(async, Pid, {guild_arena, async_login, [wrong_time]}),
    {next_state, StateName, State, timeout(StateName, State)};
handle_event({login, Rid, Pid, Gid, Map}, StateName, State = #state{guilds = Guilds, roles = Roles, area = Area}) ->
    %% 先看看帮派有没参战
    {Reply, NewRoles, NewGuilds, NewArea2} = case lists:keyfind(Gid, #arena_guild.id, Guilds) of
        false -> 
            {guild_not_join, Roles, Guilds, Area};
        %% 再看看自己是否已经参战
        ArenaGuild = #arena_guild{die = MDie, join_num = JoinNum} -> 
            case lists:keyfind(Rid, #guild_arena_role.id, Roles) of
                %% 已经阵亡的话，就不需要处理什么，否则就阵亡人数减一
                ArenaRole = #guild_arena_role{die = RDie, aid = Aid} ->
                    {Res, NewMDie, NewArea1, NewAid} = case RDie >= ?guild_arena_role_max_die of
                        true -> 
                            {dead, MDie, Area, Aid};
                        _ -> 
                            %% 如果之前的帮派被判断为阵亡的话要让他复活
                            NewArea = case MDie >= JoinNum of
                                true ->
                                    case Area of
                                        #arena_area{guild_die = GuildDead} ->
                                            Area#arena_area{guild_die = GuildDead - 1};
                                        _ -> 
                                            Area
                                    end;
                                _ ->
                                    Area
                            end,
                            %% 防止已经开战了重新登录的玩家还在准备区，这里返回状态给调用方对比
                            case NewArea of
                                #arena_area{id = AreaId} ->
                                    {ok, max(0, MDie - 1), NewArea, AreaId};
                                _ ->
                                    {ok, max(0, MDie - 1), NewArea, Aid}
                            end
                    end,
                    NewArenaRole = ArenaRole#guild_arena_role{pid = Pid, offline = 0, aid = NewAid},
                    NewArenaGuild = ArenaGuild#arena_guild{die = NewMDie},
                    {
                        Res, 
                        lists:keyreplace(Rid, #guild_arena_role.id, Roles, NewArenaRole), 
                        lists:keyreplace(Gid, #arena_guild.id, Guilds, NewArenaGuild), 
                        NewArea1
                    };
                _ -> {not_in, Roles, Guilds, Area}
            end
    end,
    NewReply = case Reply of
        ok -> [ok, round, Map, self()];
        dead -> [dead, self()];
        _ -> Reply
    end,
    role:apply(async, Pid, {guild_arena, async_login, [NewReply]}),
    {next_state, StateName, State#state{roles = NewRoles, guilds = NewGuilds, area = NewArea2}, timeout(StateName, State)};

handle_event({area_over, _}, StateName, State) ->
    {next_state, StateName, State, timeout(StateName, State)};

handle_event(_Event, StateName, State) ->
    ?DEBUG("unkown event ~w ~w ~n", [_Event, StateName]),
    {next_state, StateName, State, timeout(StateName, State)}.

%% 正式开战阶段个人进入战场
handle_sync_event({to_war_area, Rids}, _From, round, State = #state{area = #arena_area{id = Aid, map = Map}, roles = Roles}) ->
    %% 预设一个随机点
    EnterPoint = get_enter_point(Map),
    ?DEBUG("战区进程 ~w", [EnterPoint]),
    F = fun ({Rid, Pid}, {Res, Rs}) ->
            case lists:keyfind(Rid, #guild_arena_role.id, Rs) of
                %% 如果已经在帮战里面就要区分下是否离线吧
                ArenaRole = #guild_arena_role{id = Rid, offline = 0} ->
                    NewArenaRole = ArenaRole#guild_arena_role{aid = Aid, pid = Pid, offline = 0},
                    send_role_to_map(NewArenaRole, EnterPoint),
                    {Res, lists:keyreplace(Rid, #guild_arena_role.id, Rs, NewArenaRole)};
                %% 只能从准备区进入
                _ ->
                    ?DEBUG("匹配错误"),
                    {Res, Rs}
            end
    end,
    {Reply, NewRoles} = lists:foldl(F, {ok, Roles}, Rids),
    {reply, Reply, round, State#state{roles = NewRoles}, timeout(round, State)};
handle_sync_event({to_war_area, _Rids}, _From, StateName, State) ->
    {reply, wrong_time, StateName, State, timeout(StateName, State)};



%% 检查是否可以开战
handle_sync_event({combat_check, FighterIds}, _From, round, State = #state{roles = Roles, area = Area}) ->
    Reply = check_fighters(FighterIds, Roles, Area),
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
                #guild_arena_role{die = Die} when Die >= ?guild_arena_role_max_die ->
                    {false, ?L(<<"对方已经用完重生次数，不能再次参与组队">>)};
                #guild_arena_role{gid = Gid, aid = Aid} -> 
                    ok;
                _ -> {false, ?L(<<"组队失败，你们不是同一个帮会的">>)}
            end;
        _ -> {false, ?L(<<"组队失败，你没有参加帮战">>)}
    end,
    {reply, Reply, StateName, State, timeout(StateName, State)};

%% 获取帮战的当前状态名称和距离下个状态的超时
handle_sync_event({info, state_time, Rid}, _From, round, State = #state{id= Id, roles = Roles, area = Area}) ->
    %% 已经清场的战区要特殊处理
    Type = case lists:keyfind(Rid, #guild_arena_role.id, Roles) of
        #guild_arena_role{gid = Gid} ->
            case Area of
                %% 战区已经出胜负了，只有胜利帮派是收到进入下一阶段倒计时
                #arena_area{winner = Winner} when Winner =:= Gid -> finish;
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

%% 获取当前战区id和轮数
handle_sync_event(get_area_and_round, _From, StateName, State = #state{round = Round, area = #arena_area{id = AreaId}}) ->
    Timeout = timeout(StateName, State),
    ?DEBUG("战区结束 ~w", [Timeout]),
    {reply, {Round, AreaId}, StateName, State, Timeout};

%% 获取帮战所有状态信息
handle_sync_event({info, all}, _From, StateName, State) ->
    {reply, State, StateName, State, timeout(StateName, State)};

%% 获取帮战所有报名帮派总数
handle_sync_event({info, guild_num}, _From, StateName, State = #state{guild_num = GuildNum}) ->
    {reply, GuildNum, StateName, State, timeout(StateName, State)};

%% 获取参战帮派信息
handle_sync_event({info, guilds}, _From, StateName, State = #state{guilds = Guilds, guild_num = GuildNum}) ->
    Reply = {GuildNum, Guilds},
    {reply, Reply, StateName, State, timeout(StateName, State)};

%% 获取参战帮派信息按等级排名
handle_sync_event({info, sign_guilds}, _From, StateName, State = #state{guild_num = GuildNum, guilds = Guilds}) ->
    Reply = {GuildNum, Guilds},
    {reply, Reply, StateName, State, timeout(StateName, State)};

%% 获取参战玩家信息
handle_sync_event({info, roles}, _From, StateName, State = #state{roles = Roles, role_num = RoleNum}) ->
    Reply = {RoleNum, Roles},
    {reply, Reply, StateName, State, timeout(StateName, State)};

%% 返回已经分页的信息
handle_sync_event({info, roles, Page}, _From, StateName, State = #state{roles = Roles, role_num = RoleNum}) when is_integer(Page) ->
    Reply = get_page_list({RoleNum, Roles}, Page, ?guild_arena_list_size),
    {reply, Reply, StateName, State, timeout(StateName, State)};

%% 获取当前战区帮派信息
handle_sync_event({info, guilds, _Rid}, _From, StateName, State = #state{guilds = Guilds, guild_num = GuildNum}) ->
    Timeout = timeout(StateName, State),
    Reply = {GuildNum, Guilds},
    {reply, Reply, StateName, State, Timeout};

%% 获取当前战区玩家信息
handle_sync_event({info, roles, Rid}, _From, StateName, State = #state{roles = Roles, role_num = RoleNum}) ->
    Timeout = timeout(StateName, State),
    %% 如果还没被淘汰则看看现在战区的
    case lists:keyfind(Rid, #guild_arena_role.id, Roles) of
        #guild_arena_role{aid = Aid} when Aid =/=0 ->
            Reply = {RoleNum, Roles},
            {reply, Reply, StateName, State, Timeout};
        _ ->
            {reply, {0, []}, StateName, State, Timeout}
    end;

%% 战区里返回已经分页的信息
handle_sync_event({info, roles, Rid, Page}, _From, StateName, State = #state{roles = Roles, role_num = RoleNum}) ->
    Timeout = timeout(StateName, State),
    %% 如果还没被淘汰则看看现在战区的
    SubData = case lists:keyfind(Rid, #guild_arena_role.id, Roles) of
        #guild_arena_role{aid = Aid} when Aid =/=0 ->
            {RoleNum, Roles};
        _ ->
            {0, []}
    end,
    Reply = get_page_list(SubData, Page, ?guild_arena_panel_size),
    {reply, Reply, StateName, State, Timeout};

%% 战区里返回已经分页的信息
handle_sync_event({info, my_rank, Rid}, _From, StateName, State = #state{roles = Roles, role_num = RoleNum}) ->
    Timeout = timeout(StateName, State),
    %% 如果还没被淘汰则看看现在战区的
    SubData = case lists:keyfind(Rid, #guild_arena_role.id, Roles) of
        #guild_arena_role{aid = Aid} when Aid =/=0 ->
            {RoleNum, Roles};
        _ ->
            {0, []}
    end,
    RankNum = get_rank(role, 1, Rid, Roles),
    Page = util:ceil(RankNum / ?guild_arena_list_size),
    Reply = get_page_list(SubData, Page, ?guild_arena_list_size),
    {reply, Reply, StateName, State, Timeout};

%% 获取个人战绩
handle_sync_event({info, mine, Rid}, _From, StateName, State = #state{roles = Roles}) ->
    Timeout = timeout(StateName, State),
    case lists:keyfind(Rid, #guild_arena_role.id, Roles) of
        ArenaRole = #guild_arena_role{} ->
            {reply, ArenaRole, StateName, State, Timeout};
        _ ->
            {reply, {}, StateName, State, Timeout}
    end;

handle_sync_event(_Event, _From, StateName, State) ->
    ?DEBUG("invailid event ~p ~n", [_Event]),
    {reply, unkown, StateName, State, timeout(StateName, State)}.

%% 时间到所有在场的人要都去开打
handle_info(all_go_fight, round, State = #state{area = Area = #arena_area{id = Aid, guild_num = GuildNum}, roles = Roles, guilds = Guilds}) ->
    ?DEBUG("战区数据 ~w", [Area]),
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
        round_ready = 1,
        roles = NewRoles, 
        area = Area#arena_area{guild_die = GuildDead}
    },
    ?DEBUG("全体出战 ~w, ~w", [GuildNum, GuildDead]),
    %% 如果不够两个帮派的话就提前结束吧
    case GuildNum - GuildDead > 1 of
        true ->
            {next_state, round, NewState, timeout(round, State)};
        _ ->
            round(timeout, NewState)
    end;

%% 定时整理帮派和个人的排序
handle_info(make_sort, StateName, State = #state{guilds = Guilds, roles = Roles}) ->
    NewGuilds = sort_guild(sum_score, Guilds),
    NewRoles = sort_role(sum_score, Roles),
    erlang:send_after(15000, self(), make_sort),
    {next_state, StateName, State#state{guilds = NewGuilds, roles = NewRoles}, timeout(StateName, State)};

%% 结束
handle_info(stop, finish, State) ->
    finish(timeout, State),
    {stop, normal, State};
handle_info(stop, _, State) ->
    {stop, normal, State};

handle_info(_Info, StateName, State) ->
    {next_state, StateName, State, timeout(StateName, State)}.

terminate(_Reason, _StateName, #state{guilds = Guilds}) ->
    %% 活动异常所有报名帮派解锁
    F2 = fun(#arena_guild{id = {_, SrvId} = UnlockId, map = {GMpid, _}}) ->
            map:stop(GMpid),
            ?CENTER_NCAST(SrvId, guild_mem, limit_member_manage, [UnlockId, able]);
        (_A) ->
            ?DEBUG("未知参数 ~p", [_A])
    end,
    [F2(G) || G <- Guilds],
    ok.

code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.

%%------- 各种状态处理 --------

%% 每一轮结束后要再这里,评估胜利者并进入中场休息阶段
round(timeout, State = #state{id = Id, round = Round, guilds = Guilds, area = Area, roles = Roles}) ->
    %% ?DEBUG("round ~p areas ~p", [Round, Areas]),
    Started = util:unixtime(ms),
    %% 终止所有采集活动
    %% guild_arena_area:stop_areas(),
    %% 每一轮结束到这里要找出胜利者
    NewArea = find_area_winner(Area, Guilds),
    %% 如果是最后一轮则进入结束阶段，否则进入中场休息
    ?DEBUG("新帮战提前进入 ~p 状态", [finish]),
    %% push_to_onlines(state_time, {Id, idle, ?guild_arena_rest_interval}),
    %% ?DEBUG("winners ~p", [Winners]),
    Winner = case NewArea of
        #arena_area{winner = WinGid} -> WinGid;
        _ -> 0
    end,
    case {Winner, Round} of
        {0, _} -> ok;
        {_, 3} -> make_cross_king(Winner);
        _ -> ok
    end,
    {NewRoles, NewGuilds} = round_push_and_reward(Id, {Round, finish}, NewArea, Roles, Guilds),
    NewState = State#state{
        started = Started, 
        area = NewArea, 
        last_winner = Winner, 
        roles = NewRoles, 
        guilds = NewGuilds
    },
    guild_arena_center_mgr:area_finish(NewArea, NewRoles, NewGuilds, Round),
    {next_state, finish, NewState, ?guild_arena_finish_interval};
round(_Else, State) ->
    {next_state, round, State, timeout(round, State)}.


%% 结束阶段：系统评选出冠军
finish(timeout, State = #state{area = Area, roles = Roles, guilds = Guilds, robots = Robots}) ->
    ?DEBUG("新帮战进入 ~p 状态", [idle]),
    %% 所有人都送出去吧送出去吧
    [kickout_map(R) || R <- Roles],
    %% 清掉原来战区的地图进程
    case Area of
        #arena_area{map = {MPid, _}} when is_pid(MPid) ->
            map:stop(MPid);
        _ ->
            ok
    end,
    %% 清掉所有机器人
    [npc_mgr:remove(RobotId) || RobotId <- Robots],

    %% 活动结束所有报名帮派解锁
    F2 = fun(#arena_guild{map = {GMpid, _}}) ->
            map:stop(GMpid);
        (_A) ->
            ?DEBUG("未知参数 ~p", [_A])
    end,
    [F2(G) || G <- Guilds],
    %% 这里保存一下当届的结果
    {next_state, hide, State};
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
role_off(_, Guild, #guild_arena_role{die = RDie}, Area) when RDie >= ?guild_arena_role_max_die ->
    {Guild, Area};
%% 已经出结果了也不需要再处理什么
role_off(finish, Guild, _, Area) ->
    {Guild, Area};
%% 否则要看看帮派是否全部阵亡
role_off(round, Guild = #arena_guild{die = GDie, join_num = JoinNum}, #guild_arena_role{aid = Aid}, Area) when GDie + 1 >= JoinNum ->
    case Area of
        %% 如果战区只剩两个帮派了，那就把剩余一个标注为胜利
        #arena_area{id = Aid, guild_die = GuildDie, guild_num = AreaGuildNum} when GuildDie + 2 >= AreaGuildNum ->
            %% 接下来要通知下该战区要结束了
            area_over(self(), Aid),
            {
                Guild#arena_guild{
                    die = GDie + 1
                }, 
                Area#arena_area{guild_die = GuildDie + 1}
            };
        %% 还有多个帮派的情况下就阵亡帮派加一
        #arena_area{id = Aid, guild_die = GuildDie} ->
            {
                Guild#arena_guild{
                    die = GDie + 1
                }, 
                Area#arena_area{guild_die = GuildDie + 1}
            };
        _A ->
            ?DEBUG("未知的战区数据 ~w", [_A]),
            {Guild#arena_guild{die = GDie + 1}, Area}
    end;
%% 未阵亡玩家在还没出结果前离开对应帮派阵亡人数都要+1
role_off(_, Guild = #arena_guild{die = GDie}, #guild_arena_role{id = _Id}, Area) ->
    {Guild#arena_guild{die = GDie + 1}, Area}.

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
    case PassMs >= ?guild_arena_finish_interval of
        true -> 0;
        _ -> ?guild_arena_finish_interval - PassMs
    end;
timeout(hide, _) ->
    100000;
timeout(_StateName, _) ->
    ?INFO("新帮战异常状态 ~p", [_StateName]),
    3000.

%% 指定进程获取状态（同步调用）
sync_call(Pid, Event) when is_pid(Pid) ->
    gen_fsm:sync_send_all_state_event(Pid, Event);
sync_call(_Pid, _Event) ->
    ?DEBUG("向无效的pid请求 ~w", [_Event]),
    ok.

%% 向本进程发送消息(异步)
async_call(Event) ->
    gen_fsm:send_all_state_event(?MODULE, Event).

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
find_area_winner(H = #arena_area{winner = _Winner}, Guilds) ->
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
    H#arena_area{winner = NewWinner, guild_rank = RankList}.

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

get_rank(guild, RankNum, _, []) ->
    RankNum;
get_rank(guild, RankNum, Gid, [#arena_guild{id = Id} | T]) ->
    case Gid =:= Id of
        true -> RankNum;
        _ -> get_rank(guild, RankNum + 1, Gid, T)
    end.

%% 处理帮战里的地图传送
%% 固定坐标
send_role_to_map(#guild_arena_role{pid = Pid, die = Die}, {Mid, X, Y}) when is_pid(Pid) ->
    role:apply(async, Pid, {fun apply_enter_map/4, [{Mid, X, Y}, self(), Die]});
%% 随机坐标
send_role_to_map(Role, [Area]) ->
    send_role_to_map(Role, Area);
send_role_to_map(#guild_arena_role{pid = Pid, die = Die}, #arena_area{map = Map, id = Aid}) when is_pid(Pid) ->
    EnterPoint = get_enter_point(Map),
    role:apply(async, Pid, {fun apply_enter_map/4, [EnterPoint, self(), Die]}),
    Aid;
send_role_to_map(_R, _A) ->
    0.

%% 把角色踢出地图
kickout_map(#guild_arena_role{pid = Pid, offline = 0}) ->
    role:apply(async, Pid, {fun apply_kickout/2, [?leave_guild_arena_point]});
kickout_map(_R) ->
    ok.

%% 获取地图初始点
get_enter_point({_, Mid}) ->
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

role_apply(#guild_arena_role{pid = Pid}, CallBack) when is_pid(Pid) ->
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
apply_combat_over(#role{combat_pid = ComPid}) when is_pid(ComPid) ->
    ComPid ! stop,
    {ok};
apply_combat_over(_) ->
    {ok}.


%% 从一系列玩家ID中检查是否有不符合战斗规则的
check_fighters([ARid, DRid], Roles, Area) ->
    Now = util:unixtime(),
    case lists:keyfind(ARid, #guild_arena_role.id, Roles) of
        %% 死够了
        #guild_arena_role{die = YourDie} when YourDie >= ?guild_arena_role_max_die -> 
            {false, ?L(<<"你重生次数已用完，不能发起战斗">>)};
        #guild_arena_role{aid = Aid} ->
            case lists:keyfind(DRid, #guild_arena_role.id, Roles) of
                %% 死够了
                #guild_arena_role{die = TheirDie} when TheirDie >= ?guild_arena_role_max_die -> 
                    {false, ?L(<<"对方重生次数已用完，不能发起战斗">>)};
                #guild_arena_role{last_death = TheirDeath} when Now - TheirDeath < ?guild_arena_protect_time ->
                    {false, ?L(<<"对方还在保护时间内，不能发起战斗">>)};
                #guild_arena_role{aid = Aid, die = _Die} -> 
                    ?DEBUG("the die ~p", [_Die]),
                    %% 看看战区比赛是否已经结束
                    case Area of
                        #arena_area{id = Aid, winner = 0} -> {ok};
                        _ -> {false, ?L(<<"战区比赛已结束">>)}
                    end;
                _ -> {false, ?L(<<"对方不在战区，不能发起战斗">>)}
            end;
                %% 不在战场
        _ -> {false, ?L(<<"你不在战区，不能发起战斗">>)}
    end.

%% 推送每一轮战斗结果和发放奖励
round_push_and_reward(_StateId, {Round, Type}, #arena_area{id = AreaId, guild_rank = GuildRank}, Roles, Guilds) ->
    %% 胜利方推送和失败方推送不一样，所以这里要筛选出来
    Mvps = sort_role(score, Roles),
    F = fun(R = #guild_arena_role{id = Id = {_, SrvId}, pid = Pid, gid = Gid}, {Rs, Gs}) ->
            [Mvp | _] = Mvps,
            Rank = case lists:keyfind(Gid, 1, GuildRank) of
                {Gid, RankNum} -> RankNum;
                _ -> 100
            end,
            guild_arena_rpc:push(Pid, round, {Rank, Round, <<>>, Mvp}),

            %% 还在战斗的家伙要停止下
            NewRole = case R#guild_arena_role.is_fighting of
                1 -> 
                    role_apply(R, {fun apply_combat_over/1, []}),
                    R#guild_arena_role{is_fighting = 0};
                _ -> R
            end,
            NewRs = lists:keyreplace(Id, #guild_arena_role.id, Rs, NewRole),
            ?CENTER_NCAST(SrvId, guild_arena_center, async_reward, [R, Rank, Round]),
            {NewRs, Gs}
    end,
    {NewRoles, NewGuilds} = lists:foldl(F, {Roles, Guilds}, Roles),

    %%如果是最后一轮在这里给前三名帮派发奖励
    case Type of
        finish ->
            add_guild_treasure(GuildRank, NewGuilds, 1, Round, AreaId);
        _ ->
            ok
    end,
    {NewRoles, NewGuilds}.

%% 异步到本服发放奖励
async_reward(R = #guild_arena_role{id = {Rid, SrvId}, lev = Lev, name = RoleName, sum_score = RSumScore, die = Die}, Rank, Round) ->
    %% 发放个人奖励
    %% 经验=(积分^0.5)*15*等级^1.5
    %% 灵力=(积分^0.5)*15*等级^1.5/2
    %% 帮贡=积分/4
    Items = get_role_reward(Rank, Round, RSumScore),
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
    mail_mgr:deliver({Rid, SrvId, RoleName}, {Title, Content, AssetInfo, Items}),
    campaign_reward:handle(doing, {Rid, SrvId, RoleName}, cross_guild_arena),
    campaign_listener:handle(guild_arena_rank, R, Rank);
async_reward(_R, _Rank, _Round) ->
    ?ERR("帮战奖励非法帮战角色数据:~w", [_R]),
    ok.

%% 给前三名，发奖励、聊天公告和帮主邮件
add_guild_treasure([], _, _, _, _) ->
    ok;
%% 第一轮前三名以外的帮派
add_guild_treasure([{Id, _} | T], Guilds, Rank, 1, AreaId) when Rank > 3 ->
    case lists:keyfind(Id, #arena_guild.id, Guilds) of
        #arena_guild{id = Id = {_, SrvId}, chief = Chief, sum_score = Score, name = Name} ->
            Msg = util:fbin(?L(<<"恭喜你们帮会获得跨服帮战第 ~w 轮第 ~w 战区第 ~w 名。奖励已发到帮会宝库，请尽快分配！">>), [1, AreaId, Rank]),
            Reward = ?guild_arena_reward_guild_no4_cross1,
            TvFormat = ?L(<<"本服的<font color='#7cfc00'>【~s】</font>帮会，在本次跨服帮战第~w轮第~w战区中，获得第 <font color='#7cfc00'>~w</font> 名。很遗憾没有晋级下一轮跨服帮战。">>),
            ?CENTER_NCAST(SrvId, notice, send, [53, util:fbin(TvFormat, [Name, 1, AreaId, Rank])]),
            ?CENTER_NCAST(SrvId, guild_treasure, add, [Id, ?guild_treasure_arean, Reward]),
            ?CENTER_NCAST(SrvId, guild, guild_chat, [Id, Msg]),
            Content = util:fbin(?L(<<"在本次帮战中，您所在帮会获得第 ~w 名。\n共获得 ~w 积分，增加 ~w 帮会资金。\n并获得相应奖励，请在帮会宝库里查收！">>), [Rank, Score, Score div 4]),
            ?CENTER_NCAST(SrvId, mail, send_system, [Chief, {?L(<<"帮战奖励">>), Content, [], []}]),
            add_guild_treasure(T, Guilds, Rank + 1, 1, AreaId);
        _ ->
            add_guild_treasure(T, Guilds, Rank + 1, 1, AreaId)
    end;
%% 第二轮前三名以外的帮派
add_guild_treasure([{Id, _} | T], Guilds, Rank, 2, AreaId) when Rank > 3 ->
    case lists:keyfind(Id, #arena_guild.id, Guilds) of
        #arena_guild{id = Id = {_, SrvId}, chief = Chief, sum_score = Score, name = Name} ->
            Msg = util:fbin(?L(<<"恭喜你们帮会获得跨服帮战第 ~w 轮第 ~w 战区第 ~w 名。奖励已发到帮会宝库，请尽快分配！">>), [2, AreaId, Rank]),
            Reward = ?guild_arena_reward_guild_no4_cross2,
            TvFormat = ?L(<<"本服的<font color='#7cfc00'>【~s】</font>帮会，在本次跨服帮战第~w轮第~w战区中，获得第 <font color='#7cfc00'>~w</font> 名。很遗憾没有晋级下一轮跨服帮战。">>),
            ?CENTER_NCAST(SrvId, notice, send, [53, util:fbin(TvFormat, [Name, 2, AreaId, Rank])]),
            ?CENTER_NCAST(SrvId, guild_treasure, add, [Id, ?guild_treasure_arean, Reward]),
            ?CENTER_NCAST(SrvId, guild, guild_chat, [Id, Msg]),
            Content = util:fbin(?L(<<"在本次帮战中，您所在帮会获得第 ~w 名。\n共获得 ~w 积分，增加 ~w 帮会资金。\n并获得相应奖励，请在帮会宝库里查收！">>), [Rank, Score, Score div 4]),
            ?CENTER_NCAST(SrvId, mail, send_system, [Chief, {?L(<<"帮战奖励">>), Content, [], []}]),
            add_guild_treasure(T, Guilds, Rank + 1, 2, AreaId);
        _ ->
            add_guild_treasure(T, Guilds, Rank + 1, 2, AreaId)
    end;
%% 最后一轮前三名以外的帮派
add_guild_treasure([{Id, _} | T], Guilds, Rank, 3, AreaId) when Rank > 2 ->
    case lists:keyfind(Id, #arena_guild.id, Guilds) of
        #arena_guild{id = Id = {_, SrvId}, chief = Chief, sum_score = Score, name = Name} ->
            Msg = util:fbin(?L(<<"恭喜你们帮会获得跨服帮战总决赛获得第 ~w 名。奖励已发到帮会宝库，请尽快分配！">>), [Rank]),
            Reward = ?guild_arena_reward_guild_no4_cross3,
            TvFormat = ?L(<<"恭喜本服的<font color='#7cfc00'>【~s】</font>帮会，在本次跨服帮战总决赛中，获得第 <font color='#7cfc00'>~w</font> 名。">>),
            ?CENTER_NCAST(SrvId, notice, send, [53, util:fbin(TvFormat, [Name, Rank])]),
            ?CENTER_NCAST(SrvId, guild_treasure, add, [Id, ?guild_treasure_arean, Reward]),
            ?CENTER_NCAST(SrvId, guild, guild_chat, [Id, Msg]),
            Content = util:fbin(?L(<<"在本次帮战中，您所在帮会获得第 ~w 名。\n共获得 ~w 积分，增加 ~w 帮会资金。\n并获得相应奖励，请在帮会宝库里查收！">>), [Rank, Score, Score div 4]),
            ?CENTER_NCAST(SrvId, mail, send_system, [Chief, {?L(<<"帮战奖励">>), Content, [], []}]),
            add_guild_treasure(T, Guilds, Rank + 1, 3, AreaId);
        _ ->
            add_guild_treasure(T, Guilds, Rank + 1, 3, AreaId)
    end;
add_guild_treasure([{Id, _} | T], Guilds, Rank, 1, AreaId) ->
    case lists:keyfind(Id, #arena_guild.id, Guilds) of
        #arena_guild{id = Id = {_, SrvId}, chief = Chief, sum_score = Score, name = Name} ->
            Msg = util:fbin(?L(<<"恭喜你们帮会获得跨服帮战第 ~w 轮第 ~w 战区第 ~w 名。奖励已发到帮会宝库，请尽快分配！">>), [1, AreaId, Rank]),
            Reward = lists:nth(Rank, [?guild_arena_reward_guild_no1_cross1, ?guild_arena_reward_guild_no2_cross1, ?guild_arena_reward_guild_no3_cross1]),
            TvFormat = lists:nth(Rank, [?L(<<"本服的<font color='#7cfc00'>【~s】</font>帮会表现优异，在本次跨服帮战第~w轮第~w战区中勇挫强敌，获得第 <font color='#7cfc00'>~w</font> 名。获得下一轮轮比赛的参赛资格！">>), ?L(<<"本服的<font color='#7cfc00'>【~s】</font>帮会表现优异，在本次跨服帮战第~w轮第~w战区中勇挫强敌，获得第 <font color='#7cfc00'>~w</font> 名。获得下一轮轮比赛的参赛资格！">>), ?L(<<"本服的<font color='#7cfc00'>【~s】</font>帮会，在本次跨服帮战第~w轮第~w战区中，获得第 <font color='#7cfc00'>~w</font> 名。很遗憾没有晋级下一轮跨服帮战。">>)]),
            ?CENTER_NCAST(SrvId, notice, send, [53, util:fbin(TvFormat, [Name, 1, AreaId, Rank])]),
            ?CENTER_NCAST(SrvId, guild_treasure, add, [Id, ?guild_treasure_arean, Reward]),
            ?CENTER_NCAST(SrvId, guild, guild_chat, [Id, Msg]),
            Content = util:fbin(?L(<<"在本次帮战中，您所在帮会获得第 ~w 名。\n共获得 ~w 积分，增加 ~w 帮会资金。\n并获得相应奖励，请在帮会宝库里查收！">>), [Rank, Score, Score div 4]),
            ?CENTER_NCAST(SrvId, mail, send_system, [Chief, {?L(<<"帮战奖励">>), Content, [], []}]),
            add_guild_treasure(T, Guilds, Rank + 1, 1, AreaId);
        _ ->
            add_guild_treasure(T, Guilds, Rank + 1, 1, AreaId)
    end;
add_guild_treasure([{Id, _} | T], Guilds, Rank, 2, AreaId) ->
    case lists:keyfind(Id, #arena_guild.id, Guilds) of
        #arena_guild{id = Id = {_, SrvId}, chief = Chief, sum_score = Score, name = Name} ->
            Msg = util:fbin(?L(<<"恭喜你们帮会获得跨服帮战第 ~w 轮第 ~w 战区第 ~w 名。奖励已发到帮会宝库，请尽快分配！">>), [2, AreaId, Rank]),
            Reward = lists:nth(Rank, [?guild_arena_reward_guild_no1_cross2, ?guild_arena_reward_guild_no2_cross2, ?guild_arena_reward_guild_no3_cross2]),
            TvFormat = lists:nth(Rank, [?L(<<"本服的<font color='#7cfc00'>【~s】</font>帮会表现优异，在本次跨服帮战第~w轮第~w战区中勇挫强敌，获得第 <font color='#7cfc00'>~w</font> 名。获得下一轮轮比赛的参赛资格！">>), ?L(<<"本服的<font color='#7cfc00'>【~s】</font>帮会，在本次跨服帮战第~w轮第~w战区中，获得第 <font color='#7cfc00'>~w</font> 名。很遗憾没有晋级下一轮跨服帮战。">>), ?L(<<"本服的<font color='#7cfc00'>【~s】</font>帮会，在本次跨服帮战第~w轮第~w战区中，获得第 <font color='#7cfc00'>~w</font> 名。很遗憾没有晋级下一轮跨服帮战。">>)]),
            ?CENTER_NCAST(SrvId, notice, send, [53, util:fbin(TvFormat, [Name, 2, AreaId, Rank])]),
            ?CENTER_NCAST(SrvId, guild_treasure, add, [Id, ?guild_treasure_arean, Reward]),
            ?CENTER_NCAST(SrvId, guild, guild_chat, [Id, Msg]),
            Content = util:fbin(?L(<<"在本次帮战中，您所在帮会获得第 ~w 名。\n共获得 ~w 积分，增加 ~w 帮会资金。\n并获得相应奖励，请在帮会宝库里查收！">>), [Rank, Score, Score div 4]),
            ?CENTER_NCAST(SrvId, mail, send_system, [Chief, {?L(<<"帮战奖励">>), Content, [], []}]),
            add_guild_treasure(T, Guilds, Rank + 1, 2, AreaId);
        _ ->
            add_guild_treasure(T, Guilds, Rank + 1, 2, AreaId)
    end;
add_guild_treasure([{Id, _} | T], Guilds, Rank, 3, AreaId) ->
    case lists:keyfind(Id, #arena_guild.id, Guilds) of
        #arena_guild{id = Id = {_, SrvId}, chief = Chief, sum_score = Score, name = Name} ->
            Msg = lists:nth(Rank, [?L(<<"恭喜你们帮会获得跨服帮战总决赛第一名，成为本届跨服帮战中的最强帮会。号令天下，唯我帮独尊。奖励已发到帮会宝库，请尽快分配">>), ?L(<<"恭喜你们帮会获得跨服帮战总决赛第二名，成为本届跨服帮战中的亚军帮会。奖励已发到帮会宝库，请尽快分配">>), ?L(<<"恭喜你们帮会获得跨服帮战总决赛第三名，成为本届跨服帮战中的季军帮会。奖励已发到帮会宝库，请尽快分配">>)]),
            Reward = lists:nth(Rank, [?guild_arena_reward_guild_no1_cross3, ?guild_arena_reward_guild_no2_cross3, ?guild_arena_reward_guild_no3_cross3]),
            TvFormat = lists:nth(Rank, [?L(<<"恭喜<font color='#7cfc00'> ~s-~w服的【~s】</font>帮会在本次帮战中表现优异，在天下第一帮会争夺赛中，脱颖而出，获得第一名，成为本次跨服帮战的最强帮会！">>), ?L(<<"恭喜<font color='#7cfc00'> ~s-~w服的【~s】</font>帮会在本次帮战中表现优异，在天下第一帮会争夺赛中，脱颖而出，获得第二名，成为本次跨服帮战的亚军">>), ?L(<<"恭喜<font color='#7cfc00'> ~s-~w服的【~s】</font>帮会在本次帮战中表现优异，在天下第一帮会争夺赛中，脱颖而出，获得第三名，成为本次跨服帮战的季军">>)]),
            ?CENTER_CAST_ALL(notice, send, [53, util:fbin(TvFormat, [srv_id_mapping:platform(SrvId), srv_id_mapping:srv_sn(SrvId), Name])]),
            ?CENTER_NCAST(SrvId, guild_treasure, add, [Id, ?guild_treasure_arean, Reward]),
            ?CENTER_NCAST(SrvId, guild, guild_chat, [Id, Msg]),
            Content = util:fbin(?L(<<"在本次帮战中，您所在帮会获得第 ~w 名。\n共获得 ~w 积分，增加 ~w 帮会资金。\n并获得相应奖励，请在帮会宝库里查收！">>), [Rank, Score, Score div 4]),
            ?CENTER_NCAST(SrvId, mail, send_system, [Chief, {?L(<<"帮战奖励">>), Content, [], []}]),
            add_guild_treasure(T, Guilds, Rank + 1, 3, AreaId);
        _ ->
            add_guild_treasure(T, Guilds, Rank + 1, 3, AreaId)
    end.

%% 推送给以进入战区的玩家
push_to_area(area_guilds, {Aid, Guilds, Roles}) ->
    NewGuilds = sort_guild(score, Guilds),
    Num = length(NewGuilds),
    PushData = get_page_list({Num, NewGuilds}, 1, ?guild_arena_panel_size),
    [guild_arena_rpc:push(Pid, area_guilds, PushData) || #guild_arena_role{pid = Pid, aid = PAid} <- Roles, Aid =:= PAid].

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
                            area_over(self(), Aid),
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
                            area_over(self(), Aid),
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

%% 如果玩家吃了加积分的药，就给他加积分
calc_buff_score(BaseScore, GLflag) ->
    ?DEBUG("flag ~p", [GLflag]),
    case lists:keyfind(?guild_arena_score_buff, 1, GLflag) of
        {_, 1} -> round(BaseScore * 1.5);
        _ -> BaseScore
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

%% get_role_reward(Rank, Round, Score) -> list()
%% 获取个人奖励
get_role_reward(_, _, Score) when Score < ?guild_arena_base_reward_score ->
    [];
get_role_reward(1, 3, _) ->
    [{29118, 1, 8}, {25026, 1, 3}];
get_role_reward(2, 3, _) ->
    [{29118, 1, 6}, {25026, 1, 2}];
get_role_reward(3, 3, _) ->
    [{29118, 1, 4}, {25026, 1, 1}];
get_role_reward(_, 3, _) ->
    [{29118, 1, 3}, {25026, 1, 1}];
get_role_reward(1, _, _) ->
    [{29118, 1, 5}, {25026, 1, 2}];
get_role_reward(2, _, _) ->
    [{29118, 1, 4}, {25026, 1, 1}];
get_role_reward(3, _, _) ->
    [{29118, 1, 3}, {25026, 1, 1}];
get_role_reward(_, _, _) ->
    [{29118, 1, 2}, {25026, 1, 1}].

%% 发放总冠军
make_cross_king({Id, SrvId}) ->
    guild_arena_center_mgr:make_cross_king({Id, SrvId});
make_cross_king(_) ->
    ok.
