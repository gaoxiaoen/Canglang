%%----------------------------------------------------
%% @doc 跨服帮战系统
%%      本活动一共分idle（闲置），sign（帮派报名），ready（个人进入战区），round（战斗回合），finish（活动结束）这5种状态
%%      idle -> sign -> ready -> round -> finish -> idle
%%
%% @author Jangee@qq.com
%% @end
%%----------------------------------------------------
-module(guild_arena_center_mgr).
-behaviour(gen_fsm).
%% 外部调用接口
-export(
    [
        join/2,
        login/1,
        team_check/3,
        combat_check/2,
        combat_start/1,
        combat_over/3,
        click_elem/2,
        get_info/1,
        can_join/2,
        make_cross_king/1,
        area_finish/4,
        get_last_winner/0,
        adm_next/0,
        adm_restart/0,
        adm_stop/0,
        adm_hide/0,
        adm_round/1,
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
%% 战胜机器人固定积分
-define(guild_arena_robot_score, 20).
%% 开服前两场积分前六名玩家奖励
-define(guild_arena_rank_role_reward, [{29110, 1, 1}, {29110, 1, 1}, {29110, 1, 1}, {29110, 1, 1}, {29110, 1, 1}, {29110, 1, 1}]).
-define(guild_arena_join_timeout_cross, 240000).      %% 角色加入战区只能在4两分钟内

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
join(role, {Id, Pid, Lev, Name, FC, {Gid, SrvId}, GuildName, Position, Career}) ->
    sync_call({role_join, Id, Pid, Lev, Name, FC, {Gid, SrvId}, GuildName, Position, Career, campaign_adm:is_camp_time(guild_arena)});

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

%% @spec get_info(adm_all) -> Result
%% Result = record(state)
%% @doc 获取帮战所有状态信息
get_info(adm_all) ->
    case sync_call({info, adm_all}) of
        A = {Id, Round, GuildNum, RoleNum, AreaNum, LastWinner, StateName, Timeout} ->
            ?INFO("跨服帮战信息: ~n, 届次 ~w, 当前轮 ~w, 参战帮派数 ~w, 参战人数 ~w, 当前战区数 ~w, 上届冠军 ~w, 目前状态 ~w, 距离下个状态还有 ~w 毫秒", [Id, Round, GuildNum, RoleNum, AreaNum, LastWinner, StateName, Timeout]),
            A;
        _ ->
            ?INFO("无法获取跨服帮战信息")
    end;

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
    sync_call({info, guild_member, Gid});

%% @doc 获取指定帮会战绩
get_info({guild, Gid}) ->
    sync_call({info, guild, Gid});

get_info(_Type) ->
    ?DEBUG("无效参数 ~p", [_Type]).

%% @spec get_info(can_join, Id) -> Result
%% Result = integer()
%% @doc 获取是否可以进入帮战战区
can_join(Rid, {Gid, SrvId}) ->
    sync_call({can_join, Rid, {Gid, SrvId}}).

%% @spec area_finish(Area, Roles, Guilds) -> ok
%% Area = #arena_area{}
%% Roles = list(#guild_arena_role{})
%% Guilds = list(#arena_guild{})
%% @doc 战区进程通过这接口把战果统一传回主进程
area_finish(Area, Roles, Guilds, _Round) ->
    ?DEBUG("战区数据回收"),
    ets:insert(ets_guild_arena_area, {Area#arena_area.id, Roles, Guilds, Area#arena_area.guild_rank, Area#arena_area.guild_num}),
    F1 = fun(R = #guild_arena_role{id = Id, gid = Gid, name = Name, guild_name = GName, score = Score, fc = Fc, career = Career, lev = Lev}) ->
            ets:insert(ets_guild_arena_role, R),
            case ets:lookup(ets_guild_arena_role_all, Id) of
                [Ra = #guild_arena_role_cross{round_score = RoundScore, total_score = TotalScore}] ->
                    NewRa = Ra#guild_arena_role_cross{
                        career = Career,
                        fc = Fc,
                        lev = Lev,
                        current_score = Score, 
                        round_score = RoundScore + Score,
                        total_score = TotalScore + Score
                    },
                    ets:insert(ets_guild_arena_role_all, NewRa),
                    NewRa;
                _ ->
                    NewRa = #guild_arena_role_cross{
                        id = Id,
                        gid = Gid,
                        name = Name,
                        lev = Lev,
                        fc = Fc,
                        career = Career,
                        guild_name = GName,
                        current_score = Score, 
                        round_score = Score,
                        total_score =  Score
                    },
                    ets:insert(ets_guild_arena_role_all, NewRa),
                    NewRa
            end
    end,
    RoleCross = [F1(R1) || R1 <- Roles],
    F2 = fun(G = #arena_guild{id = GGid, name = GGname, chief = GGchief, score = GGScore, member_num = Mnum, lev = Lev}) ->
            ets:insert(ets_guild_arena_guild, G),
            case ets:lookup(ets_guild_arena_guild_all, GGid) of
                [Ga = #guild_arena_guild_cross{round_score = GGroundScore, total_score = GGtotalScore}] ->
                    NewGa = Ga#guild_arena_guild_cross{
                        lev = Lev,
                        current_score = GGScore,
                        member_num = Mnum,
                        round_score = GGroundScore + GGScore,
                        total_score = GGtotalScore + GGScore
                    },
                    ets:insert(ets_guild_arena_guild_all, NewGa),
                    NewGa;
                _ ->
                    NewGa = #guild_arena_guild_cross{
                        id = GGid,
                        name = GGname,
                        chief = GGchief,
                        lev = Lev,
                        member_num = Mnum,
                        current_score = GGScore,
                        round_score = GGScore,
                        total_score = GGScore
                    },
                    ets:insert(ets_guild_arena_guild_all, NewGa),
                    NewGa
            end
    end,
    GuildCross = [F2(G1) || G1 <- Guilds],
    async_call({area_finish, Area, Roles, Guilds, GuildCross, RoleCross}).

%% 设定新的王者帮派
make_cross_king({Id, SrvId}) ->
    async_call({make_cross_king, {Id, SrvId}}),
    ?CENTER_CAST_ALL(guild_arena_mgr, make_cross_king, [{Id, SrvId}]);
make_cross_king(_) ->
    ok.

%% @spec get_last_winner() -> Gid
%% @doc GM命令进入下一状态
get_last_winner() ->
    sync_call(get_last_winner).

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

%% @spec adm_round(Id) -> ok
%% @doc GM命令设定当前帮战是第几轮
adm_round(Round) when is_integer(Round) andalso Round < 4 andalso Round > 0 ->
    case async_call({admin_round, Round}) of
        ok ->
            ?CENTER_CAST_ALL(guild_arena_mgr, adm_round, [Round]),
            ?INFO("跨服帮战成功设置为第 ~w", [Round]);
        _R ->
            ?INFO("跨服帮战设置失败 ~w", [_R])
    end;
adm_round(_Id) ->
    ?DEBUG("无效参数 ~p", [_Id]).

%% @spec login(Role) -> NewRole
%% Role = NewRole = record(role)
%% @doc 玩家登陆时做相关处理
login({Id, Pid, {Gid, SrvId}}) ->
    async_call({login, Id, Pid, {Gid, SrvId}}).

%% @spec team_check(Role, Rid) -> ok | {false, Why}
%% Attacker = record(role)
%% Why = string()
%% @doc 检查开战者是否可以和对方组队
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
combat_check(#role{event = ?event_guild_arena, id = ARid}, #role{event = ?event_guild_arena, id = DRid}) ->
    sync_call({combat_check, [ARid, DRid]});
%% 与机器打
combat_check({Id, SrvId}, NpcId) when is_integer(NpcId) ->
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

%% @spec click_elem(Role, MapElem) -> {ok} | {false, Why}
%% Role = record(role)
%% MapElem = record(map_elem)
%% 玩家开始采集仙石
click_elem(_Role, _MapElem) ->
    {false, ?L(<<"采集仙石失败">>)}.

%% ----- otp接口部分 ------

start_link()->
    gen_fsm:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 启动初始化后立即进入空闲状态吧
init([])->
    ?DEBUG("新帮战进入 ~p 状态", [idle]),
    ets:new(ets_guild_arena_role, [set, named_table, public, {keypos, #guild_arena_role.id}]),
    ets:new(ets_guild_arena_guild, [set, named_table, public, {keypos, #arena_guild.id}]),
    ets:new(ets_guild_arena_area, [set, named_table, public, {keypos, 1}]),
    ets:new(ets_guild_arena_area_all, [set, named_table, public, {keypos, 1}]),
    ets:new(ets_guild_arena_role_all, [set, named_table, public, {keypos, #guild_arena_role_cross.id}]),
    ets:new(ets_guild_arena_guild_all, [set, named_table, public, {keypos, #guild_arena_guild_cross.id}]),
    init_dets(),
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

%% 回收战区数据
handle_event({area_finish, Area, Roles, Guilds, GuildCross, RoleCross}, StateName, State = #state{lost_guilds = LostGuilds, lost_roles = LostRoles, pass_areas = PassAreas, round = Round}) ->
        NewState = State#state{
            pass_areas = [Area | PassAreas],
            lost_guilds = LostGuilds ++ Guilds,
            lost_roles = LostRoles ++ Roles
        },
        %% 每轮数据放在这里插入以免出现并发写ets问题
        case ets:lookup(ets_guild_arena_area_all, Round) of
            [{_, AreaData}] ->
                ets:insert(ets_guild_arena_area_all, {Round, [{Area#arena_area.id, GuildCross, RoleCross} | AreaData]});
            _ ->
                ets:insert(ets_guild_arena_area_all, {Round, [{Area#arena_area.id, GuildCross, RoleCross}]})
        end,
        %% 最后一轮要提早结束
        case Round of
            3 -> round(timeout, NewState);
            _ ->
                {next_state, StateName, NewState, timeout(StateName, State)}
        end;

%% 设定新的王者帮派
handle_event({make_cross_king, Id}, StateName, State) ->
        NewState = State#state{
            last_winner = Id
        },
    {next_state, StateName, NewState, timeout(StateName, State)};

handle_event({admin_round, Round}, StateName, State = #state{areas = Areas}) when is_integer(Round) ->
        [async_call(AreaPid, {admin_round, Round}) || #arena_area{area_pid = AreaPid} <- Areas, is_pid(AreaPid)],
    {next_state, StateName, State#state{round = Round}, timeout(StateName, State)};

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

%% 重新登录时要注册下
handle_event({login, _Rid, Pid, _Gid}, StateName, State) when StateName =:= idle orelse StateName =:= sign orelse StateName =:= finish ->
    role:apply(async, Pid, {guild_arena, async_login, [wrong_time]}),
    {next_state, StateName, State, timeout(StateName, State)};
%% 如果已经开战了就丢给战区进程处理
handle_event({login, Rid, Pid, Gid}, round, State = #state{guilds = Guilds, areas = Areas}) ->
    case lists:keyfind(Gid, #arena_guild.id, Guilds) of
        false -> 
            role:apply(async, Pid, {guild_arena, async_login, [guild_not_join]});
        #arena_guild{aid = Aid} ->
            case lists:keyfind(Aid, #arena_area.id, Areas) of
                #arena_area{area_pid = AreaPid, map = Map} ->
                    async_call(AreaPid, {login, Rid, Pid, Gid, Map});
                _ -> 
                    role:apply(async, Pid, {guild_arena, async_login, [not_in]})
            end
    end,
    {next_state, round, State, timeout(round, State)};

handle_event({login, Rid, Pid, Gid}, StateName, State = #state{guilds = Guilds, roles = Roles, areas = Areas}) ->
    %% 先看看帮派有没参战
    {Reply, NewRoles, NewGuilds, NewAreas2} = case lists:keyfind(Gid, #arena_guild.id, Guilds) of
        false -> 
            {guild_not_join, Roles, Guilds, Areas};
        %% 再看看自己是否已经参战
        ArenaGuild = #arena_guild{die = MDie, join_num = JoinNum} -> 
            case lists:keyfind(Rid, #guild_arena_role.id, Roles) of
                %% 已经阵亡的话，就不需要处理什么，否则就阵亡人数减一
                ArenaRole = #guild_arena_role{die = RDie, aid = Aid} ->
                    {Res, NewMDie, NewAreas, NewAid} = case RDie >= ?guild_arena_role_max_die of
                        true -> 
                            {dead, MDie, Areas, Aid};
                        _ -> 
                            %% 如果之前的帮派被判断为阵亡的话要让他复活
                            {NewAreas1, AreaId, Map} = case MDie >= JoinNum of
                                true ->
                                    case lists:keyfind(Aid, #arena_area.id, Areas) of
                                        Area = #arena_area{guild_die = GuildDead, map = Map1, id = AreaId1} ->
                                            {lists:keyreplace(Aid, #arena_area.id, Areas, Area#arena_area{guild_die = GuildDead - 1}), AreaId1, Map1};
                                        _ -> 
                                            {Areas, Aid, 0}
                                    end;
                                _ ->
                                    {Areas, Aid, 0}
                            end,
                            %% 防止已经开战了重新登录的玩家还在准备区，这里返回状态给调用方对比
                            {[ok, StateName, Map, self()], max(0, MDie - 1), NewAreas1, AreaId}
                    end,
                    NewArenaRole = ArenaRole#guild_arena_role{pid = Pid, offline = 0, aid = NewAid},
                    NewArenaGuild = ArenaGuild#arena_guild{die = NewMDie},
                    {
                        Res, 
                        lists:keyreplace(Rid, #guild_arena_role.id, Roles, NewArenaRole), 
                        lists:keyreplace(Gid, #arena_guild.id, Guilds, NewArenaGuild), 
                        NewAreas
                    };
                _ -> {not_in, Roles, Guilds, Areas}
            end
    end,
    role:apply(async, Pid, {guild_arena, async_login, [Reply]}),
    {next_state, StateName, State#state{roles = NewRoles, guilds = NewGuilds, areas = NewAreas2}, timeout(StateName, State)};

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
            ArenaGuild = #arena_guild{id = {Id, SrvId}, lev = Lev, name = Name, chief = Chief, member_num = Num, map = Map},
            {ok, [ArenaGuild | Guilds], GuildNum + 1};
        _ -> {already_join, Guilds, GuildNum}
    end,
    {reply, Reply, sign, State#state{guilds = NewGuilds, guild_num = NewGuildNum}, timeout(sign, State)};
%% 帮派只能在报名阶段进行报名
handle_sync_event({guild_join, _Id, _SrvId, _Name, _Lev, _Chief, _Num}, _From, StateName, State) ->
    {reply, wrong_time, StateName, State, timeout(StateName, State)};

%% 个人进入准备区,对应帮派战斗力增加,参战总人数增加
%% 准备阶段已报名帮派的玩家可以选择进入准备区
handle_sync_event({role_join, Rid, Pid, Lev, Name, FC, Gid, GuildName, Position, Career, IsCampAdmTime}, _From, ready, State = #state{guilds = Guilds, roles = Roles, role_num = RoleNum, lost_guilds = LostGuilds}) ->
    {Reply, NewRoles, NewGuilds, NewRoleNum} = case lists:keyfind(Gid, #arena_guild.id, Guilds) of
        %% 帮派已经报名了，这里就把人数给上了
        ArenaGuild = #arena_guild{fc = GuildFC, members = Members, join_num = JoinNum, map = Map, die = MDie} -> 
            case lists:keyfind(Rid, #guild_arena_role.id, Roles) of
                false ->
                    ArenaRole = #guild_arena_role{id = Rid, pid = Pid, lev = Lev, name = Name, gid = Gid, fc = FC, guild_name = GuildName, position = Position, aid = Map, career = Career, is_camp_adm_time = IsCampAdmTime},
                    send_role_to_map(ArenaRole),
                    NewArenaGuild = ArenaGuild#arena_guild{fc = GuildFC + FC, join_num = JoinNum + 1, members= [Rid | Members]},
                    {ok, [ArenaRole | Roles], lists:keyreplace(Gid, #arena_guild.id, Guilds, NewArenaGuild), RoleNum + 1};
                %% 如果已经在帮战里面就要区分下是否离线吧
                ArenaRole = #guild_arena_role{die = RDie} ->
                    NewArenaRole = ArenaRole#guild_arena_role{aid = Map, pid = Pid, offline = 0},
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
handle_sync_event({role_join, _Rid, _Pid, _Lev, _Name, _FC, _Gid, _GuildName, _Position, _Career, _IsCampAdmTime}, _From, StateName, State) ->
    {reply, wrong_time, StateName, State, timeout(StateName, State)};

%% 正式开战阶段个人进入战场
handle_sync_event({to_war_area, Rids}, _From, round, State = #state{areas = Areas, roles = Roles, guilds = Guilds}) ->
    ?DEBUG("进入战区 ~w", [Rids]),
    %% 预设一个随机点
    Reply = case Rids of
        [{Rid, _} | _] ->
            case lists:keyfind(Rid, #guild_arena_role.id, Roles) of
                %% 如果已经在帮战里面就要区分下是否离线吧
                #guild_arena_role{id = Rid, offline = 0, gid = Gid} ->
                    case lists:keyfind(Gid, #arena_guild.id, Guilds) of
                        #arena_guild{aid = Aid} ->
                            case lists:keyfind(Aid, #arena_area.id, Areas) of
                                #arena_area{area_pid = AreaPid} ->
                                    sync_call(AreaPid, {to_war_area, Rids});
                                _ ->
                                    ok
                            end;
                        _ ->
                            ok
                    end;
                %% 只能从准备区进入
                _ ->
                    ok
            end
    end,
    {reply, Reply, round, State, timeout(round, State)};
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

%% 获取当前战区id和轮数
handle_sync_event(get_area_and_round, _From, StateName, State) ->
    Timeout = timeout(StateName, State),
    {reply, {0, 0}, StateName, State, Timeout};

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

%% 获取冠军
handle_sync_event(get_last_winner, _From, StateName, State = #state{last_winner = LastWinner}) ->
    Timeout = timeout(StateName, State),
    {reply, LastWinner, StateName, State, Timeout};

%% 获取帮战所有状态信息
handle_sync_event({info, all}, _From, StateName, State) ->
    {reply, State, StateName, State, timeout(StateName, State)};

%% 查看帮战所有状态
handle_sync_event({info, adm_all}, _From, StateName, State = #state{id = Id, round = Round, guild_num = GuildNum, role_num = RoleNum, area_num = AreaNum, last_winner = LastWinner}) ->
    Timeout = timeout(StateName, State),
    {reply, {Id, Round, GuildNum, RoleNum, AreaNum, LastWinner, StateName, Timeout}, StateName, State, Timeout};

%% 获取帮战所有报名帮派总数
handle_sync_event({info, guild_num}, _From, StateName, State = #state{guild_num = GuildNum}) ->
    {reply, GuildNum, StateName, State, timeout(StateName, State)};

%% 获取参战帮派信息
handle_sync_event({info, guilds}, _From, StateName, State = #state{guilds = Guilds}) ->
    Reply = Guilds,
    {reply, Reply, StateName, State, timeout(StateName, State)};

%% 获取参战帮派信息按等级排名
handle_sync_event({info, sign_guilds}, _From, StateName, State = #state{guild_num = GuildNum, guilds = Guilds}) ->
    Reply = {GuildNum, Guilds},
    {reply, Reply, StateName, State, timeout(StateName, State)};

%% 获取参战玩家信息
handle_sync_event({info, roles}, _From, StateName, State = #state{roles = Roles}) ->
    Reply = {length(Roles), Roles},
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
handle_info(all_go_fight, round, State = #state{areas = Areas, guilds = Guilds, guild_num = GuildNum}) ->
    %% {NewGuilds, GuildNum, Gids} = find_empty_guilds(Guilds, {[], 0, []}),
    GuildDead = find_dead_guild_num(Guilds),
    F = fun(#arena_area{area_pid = AreaPid}) when is_pid(AreaPid) ->
            AreaPid ! all_go_fight;
        (_) ->
            ok
    end,
    [F(Area) || Area <- Areas],
    %% 如果不够两个帮派的话就提前结束吧
    case GuildNum - GuildDead > 1 of
        true ->
            {next_state, round, State, timeout(round, State)};
        _ ->
            round(timeout, State)
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
    close_dets(),
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
idle(timeout, #state{id = Id, last_winner = LastWinner, round = Round}) ->
    ?DEBUG("新帮战进入 ~p 状态", [sign]),
    NewRound = case {calendar:day_of_the_week(date()), Round} of
        %% {1, _} -> 1;
        {_, 0} -> 1;
        _ when Round < 3 -> Round + 1;
        _ -> 1
    end,
    Timeout = ?guild_arena_sign_timeout,
    StateId = state_to_integer(sign),
    ?CENTER_CAST_ALL(guild_arena_mgr, cross_start, [NewRound]),
    ?CENTER_CAST_ALL(guild_arena_mgr, push_to_onlines, [15906, {Id, StateId, Timeout div 1000, 2}]),
    ets:delete_all_objects(ets_guild_arena_area),
    ets:delete_all_objects(ets_guild_arena_role),
    ets:delete_all_objects(ets_guild_arena_guild),
    init_round_data(NewRound),
    %% 在这里要再次初始化一个比较干净的state
    {next_state, sign, #state{id = Id, last_winner = LastWinner, started = util:unixtime(ms), round = NewRound}, Timeout};
idle(_Else, State) ->
    {next_state, idle, State, timeout(idle, State)}.

%% 报名阶段完成后要在这里开始进行分区
%% 没有帮派报名直接结束
sign(timeout, State = #state{guilds = []}) ->
    {next_state, finish, State, 1};
%% 如果只有一个帮派报名则通知他启动失败
sign(timeout, State = #state{guilds = [#arena_guild{id = {Id, SrvId}}], guild_num = 1}) ->
    ?CENTER_NCAST(SrvId, guild, guild_mail, [{Id, SrvId}, {?L(<<"帮战开启失败通知">>), ?L(<<"很遗憾，本次帮战只有贵帮一个帮派报名参加，本次帮会战开启失败，无法发起帮会之间的对决！欢迎贵帮下次继续参加，并可邀请其他符合条件的帮会报名。帮战中，表现出色的帮会，有很大机会获得紫色护符和其他宝物哦！">>)}]),
    {next_state, finish, State, 1};
sign(timeout, State = #state{id = Id}) ->
    ?DEBUG("新帮战进入 ~p 状态", [ready]),
    Timeout = ?guild_arena_join_timeout_cross,
    StateId = state_to_integer(ready),
    %% 这里如果是已报名帮派顺便打开邀请界面
    ?CENTER_CAST_ALL(guild_arena_mgr, invite_guilds, [1]),
    ?CENTER_CAST_ALL(guild_arena_mgr, push_to_onlines, [15906, {Id, StateId, Timeout div 1000, 2}]),
    {next_state, ready, State#state{started = util:unixtime(ms)}, Timeout};
sign(_Else, State) ->
    {next_state, sign, State, timeout(sign, State)}.

%% 玩家在准备阶段进入帮会战区后开始进入开战阶段
ready(timeout, State = #state{id = Id, guilds = Guilds, roles = Roles, round = Round}) ->
    ?DEBUG("新帮战进入 ~p1 状态", [round]),
    {NewGuilds, GuildNum, _} = find_empty_guilds(Guilds, {[], 0, []}),
    %% 如果帮派数量不超过10个则直接进入总决赛
    NewRound = case ?guild_arena_area_guild_num >= GuildNum of
        true -> 3;
        _ -> Round
    end,
    {AreaNum2, NewAreas3, NewGuilds2} = case NewRound of
        %% 最后一轮则所有人放到一个战区
        3 ->
            Map = case map_mgr:create(?guild_arena_area_map) of 
                {ok, Pid, Mid} ->
                    {Pid, Mid};
                _ ->
                    ?ERR("启动新帮战战区失败：map_base_id = ~w", [?guild_arena_area_map]),
                    {0, 0}
            end,
            A = #arena_area{id = 1, map = Map},
            {NewAreas1, NewGuilds1} = fill_to_areas([A], [], NewGuilds, []),
            NewAreas2 = case NewAreas1 of
                [NewA] ->
                    {ok, APid} = guild_arena_center:start_link(NewA, Roles, NewRound),
                    [NewA#arena_area{area_pid = APid, gids = []}];
                _ -> NewAreas1
            end,
            {1, NewAreas2, NewGuilds1};
        %% 按等级分配
        _ ->
            {AreaNum, NewAreas, NewGuilds1} = dispatch_area(GuildNum, sort_guild(lev, NewGuilds), 1),
            Groups = group_roles(Roles, [], NewGuilds1),
            %% ?DEBUG("group_roles is ~w", [Groups]),
            F = fun(A = #arena_area{id = Aid}) ->
                    case lists:keyfind(Aid, 1, Groups) of
                        {_, Rs} ->
                            {ok, APid} = guild_arena_center:start_link(A, Rs, NewRound),
                            A#arena_area{area_pid = APid, gids = []};
                        _ ->
                            A#arena_area{gids = []}
                    end
            end,
            NewAreas2 = [F(Area) || Area <- NewAreas],
            {AreaNum, NewAreas2, NewGuilds1}
    end,
    StateId = state_to_integer(round),
    %% 设定一个时间如果玩家还不进入战场就强制送他进去
    erlang:send_after(?guild_arena_stay_interval + 10000, self(), all_go_fight),
    ?CENTER_CAST_ALL(guild_arena_mgr, invite_guilds, [2]),
    ?CENTER_CAST_ALL(guild_arena_mgr, push_to_onlines, [15906, {Id, StateId, ?guild_arena_round_interval div 1000, 2}]),
    {next_state, round, State#state{started = util:unixtime(ms), areas = NewAreas3, guild_num = GuildNum, guilds = NewGuilds2, area_num = AreaNum2, round = NewRound}, ?guild_arena_round_interval};
ready(_Else, State) ->
    {next_state, ready, State, timeout(ready, State)}.


%% 每一轮结束后要再这里,评估胜利者并进入中场休息阶段
round(timeout, State = #state{areas = Areas, id = Id}) ->
    %% 通知所有未结束的战区要结束一下
    [async_call(AreaPid, {area_over, Aid}) || #arena_area{id = Aid, area_pid = AreaPid} <- Areas],
    Started = util:unixtime(ms),
    NewState = State#state{
        started = Started
    },
    StateId = state_to_integer(idle),
    ?CENTER_CAST_ALL(guild_arena_mgr, push_to_onlines, [15906, {Id, StateId, ?guild_arena_rest_interval div 1000, 2}]),
    {next_state, finish, NewState, ?guild_arena_stay_interval};
round(_Else, State) ->
    {next_state, round, State, timeout(round, State)}.


%% 结束阶段：系统评选出冠军
finish(timeout, State = #state{id =Id, areas = Areas, lost_guilds = LostGuilds, lost_roles = LostRoles, robots = Robots, last_winner = LastWinner, round = Round}) ->
    ?DEBUG("新帮战进入 ~p 状态", [idle]),
    %% 所有人都送出去吧送出去吧
    %% [kickout_map(R) || R <- Roles],
    %% 清掉原来战区的地图进程
    [map:stop(MPid) || #arena_area{map = {MPid, _}} <- Areas, is_pid(MPid)],
    [AreaPid ! stop || #arena_area{area_pid = AreaPid} <- Areas, is_pid(AreaPid)],
    %% 清掉所有机器人
    [npc_mgr:remove(RobotId) || RobotId <- Robots],

    ?CENTER_CAST_ALL(gen_server, cast, [guild_arena_mgr, finish]),
    NewLostGuilds = sort_guild(sum_score, LostGuilds),
    %% 清掉准备区地图
    [map:stop(GMpid) || #arena_guild{map = {GMpid, _}} <- NewLostGuilds],
    %% 初始化一个新状态以防一些未知的问题
    NewState = #state{
        id =Id + 1, 
        round = Round,
        last_winner = LastWinner,
        lost_roles = LostRoles,
        lost_guilds = NewLostGuilds
    },
    %% 这里保存一下当届的结果
    save_db(NewState#state{id = Id}),
    save_dets(),
    {next_state, idle, NewState, timeout(idle, State)};
finish(_Else, State) ->
    {next_state, finish, State, timeout(finish, State)}.

%% 把整个活动隐藏掉但进程保留
hide(_Else, State) ->
    {next_state, hide, State}.

%% ----------- 内部函数 ------------------


%% 筛选出不为空的帮派
find_empty_guilds([], {NewGuilds, GuildNum, Gids}) ->
    {NewGuilds, GuildNum, Gids};
find_empty_guilds([#arena_guild{id = Id = {_, SrvId}, join_num = 0} | T], {NewGuilds, GuildNum, Gids}) ->
    ?CENTER_NCAST(SrvId, guild_mem, limit_member_manage, [Id, able]),
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
    %% 跨服帮战周日不开
    SunDayTime = case util:is_merge() of
        false ->  0;
        %% 3600 * 24;
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
    case PassMs >= ?guild_arena_join_timeout_cross of
        true -> 0;
        _ -> ?guild_arena_join_timeout_cross - PassMs
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
    gen_fsm:sync_send_all_state_event(?MODULE, Event).

%% 指定进程获取状态（同步调用）
sync_call(Pid, Event) when is_pid(Pid) ->
    catch gen_fsm:sync_send_all_state_event(Pid, Event);
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
                true when ScoreA > ScoreB orelse DieB >= JoinNumB -> true;
                %% 大家都阵亡的话就看谁积分高
                _ when DieB >= JoinNumB andalso ScoreA > ScoreB -> true;
                _ -> false
            end
    end,
    lists:sort(F, Guilds);

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


%% 传送到准备区
send_role_to_map(#guild_arena_role{pid = Pid, aid = {_, Mid}, die = Die}) when is_pid(Pid) ->
    {{Tlx, Tly}, {Brx, Bry}} = ?guild_arena_ready_map_enter_point,
    {X, Y} = {util:rand(Tlx, Brx), util:rand(Tly, Bry)},
    EnterPoint = {Mid, X, Y},
    role:apply(async, Pid, {fun apply_enter_map/4, [EnterPoint, self(), Die]});
send_role_to_map(_R) ->
    ?DEBUG("帮战玩家无效参数~w", [_R]),
    0.

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
    case map:role_enter(Mid, NX, NY, NoRideRole#role{event = ?event_guild_arena, cross_srv_id = <<"center">>}) of
        {false, _Reason} ->
            {ok};
        {ok, NewRole} ->
            campaign_task:listener(NewRole, guild_war, 1),
            {ok, NewRole#role{event_pid = WarPid}}
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


%% 如果玩家吃了加积分的药，就给他加积分
calc_buff_score(BaseScore, GLflag) ->
    ?DEBUG("flag ~p", [GLflag]),
    case lists:keyfind(?guild_arena_score_buff, 1, GLflag) of
        {_, 1} -> round(BaseScore * 1.5);
        _ -> BaseScore
    end.


%% 分派战区
dispatch_area(GuildNum, Guilds, IdSeed) ->
    AreaNum = case GuildNum rem ?guild_arena_area_guild_num of
        0 -> GuildNum div ?guild_arena_area_guild_num;
        _ -> GuildNum div ?guild_arena_area_guild_num + 1
    end,
    %% 创建战区场景
    F = fun(Id) ->
            Map = case map_mgr:create(?guild_arena_area_map) of 
                {ok, Pid, Mid} ->
                    {Pid, Mid};
                _ ->
                    ?ERR("启动新帮战战区失败：map_base_id = ~w", [?guild_arena_area_map]),
                    {0, 0}
            end,
            #arena_area{id = Id, map = Map}
    end,
    Areas = [A || A <- lists:map(F, lists:seq(IdSeed, AreaNum + IdSeed - 1)), A#arena_area.map =/= {0, 0}],
    {NewAreas, NewGuilds} = fill_to_areas(Areas, [], Guilds, []),
    {AreaNum, NewAreas, NewGuilds}.

%% 把帮派分配到战区
fill_to_areas(OldAreas, NewAreas, [], NewGuilds) ->
    {OldAreas ++ NewAreas, NewGuilds};
fill_to_areas([], NewAreas, OldGuilds, NewGuilds) ->
    fill_to_areas(NewAreas, [], OldGuilds, NewGuilds);
fill_to_areas([AH = #arena_area{id = Aid, gids = Gids, guild_num = AGuildNum} | AT], NewAreas, [GH = #arena_guild{aid = GAid} | GT], NewGuilds) ->
    %% 每一轮开始回合积分清零
    ArenaGuild = GH#arena_guild{
        aid = Aid,
        score = 0,
        stone = 0,
        lost = 0,
        kill = 0
    },
    %% 原有准备区统一清理掉
    case GAid of
        {GMpid, _} ->
            map:stop(GMpid);
        _ ->
            ok
    end,
    ArenaArea = AH#arena_area{gids = [ArenaGuild | Gids], guild_num = AGuildNum + 1},
    fill_to_areas(AT, [ArenaArea | NewAreas], GT, [ArenaGuild | NewGuilds]).

%% 按战区给玩家分组
group_roles([], Groups, _) ->
    Groups;
group_roles([H = #guild_arena_role{gid = Gid} | T], Groups, Guilds) ->
    case lists:keyfind(Gid, #arena_guild.id, Guilds) of
        #arena_guild{aid = Aid} ->
            case lists:keyfind(Aid, 1, Groups) of
                {Aid, Rs} ->
                    group_roles(T, lists:keyreplace(Aid, 1, Groups, {Aid, [H | Rs]}), Guilds);
                _ ->
                    group_roles(T, [{Aid, [H]} | Groups], Guilds)
            end;
        _ ->
            group_roles(T, Groups, Guilds)
    end.

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
%% 来到这里表示玩家还没进入战区
role_off(round, Guild = #arena_guild{aid = Aid}, #guild_arena_role{id = Id}, Areas) ->
    case lists:keyfind(Aid, #arena_area.id, Areas) of
        %% 如果战区只剩两个帮派了，那就把剩余一个标注为胜利
        #arena_area{area_pid = AreaPid} ->
            %% 接下来要通知下该战区要结束了
            async_call(AreaPid, {off, Id}),
            {Guild, Areas};
        _A ->
            ?DEBUG("未知的战区数据 ~w", [_A]),
            {Guild, Areas}
    end;
%% 未阵亡玩家在还没出结果前离开对应帮派阵亡人数都要+1
role_off(_, Guild = #arena_guild{die = GDie}, #guild_arena_role{id = _Id}, Areas) ->
    {Guild#arena_guild{die = GDie + 1}, Areas}.


%% 整理总战况数据
init_round_data(1) ->
    ets:delete_all_objects(ets_guild_arena_area_all),
    [ets:insert(ets_guild_arena_role_all, R#guild_arena_role_cross{round_score = 0, current_score = 0}) || R <- ets:tab2list(ets_guild_arena_role_all)],
    [ets:insert(ets_guild_arena_guild_all, R#guild_arena_guild_cross{round_score = 0, current_score = 0}) || R <- ets:tab2list(ets_guild_arena_guild_all)];
init_round_data(_) ->
    ok.

%% 初始化时从dets里取数据放到ets里面
init_dets() ->
    FileName1 = "../var/guild_arena_area.dets",
    FileName2 = "../var/guild_arena_role.dets",
    FileName3 = "../var/guild_arena_guild.dets",
    FileName4 = "../var/guild_arena_area_all.dets",
    FileName5 = "../var/guild_arena_guild_all.dets",
    FileName6 = "../var/guild_arena_role_all.dets",
    dets:open_file(dets_guild_arena_area, [{file, FileName1}, {keypos, 1}, {type, set}]),
    dets:to_ets(dets_guild_arena_area, ets_guild_arena_area),
    dets:open_file(dets_guild_arena_role, [{file, FileName2}, {keypos, #guild_arena_role.id}, {type, set}]),
    dets:to_ets(dets_guild_arena_role, ets_guild_arena_role),
    dets:open_file(dets_guild_arena_guild, [{file, FileName3}, {keypos, #arena_guild.id}, {type, set}]),
    dets:to_ets(dets_guild_arena_guild, ets_guild_arena_guild),
    dets:open_file(dets_guild_arena_area_all, [{file, FileName4}, {keypos, 1}, {type, set}]),
    dets:to_ets(dets_guild_arena_area_all, ets_guild_arena_area_all),
    dets:open_file(dets_guild_arena_role_all, [{file, FileName5}, {keypos, #guild_arena_role_cross.id}, {type, set}]),
    dets:to_ets(dets_guild_arena_role_all, ets_guild_arena_role_all),
    dets:open_file(dets_guild_arena_guild_all, [{file, FileName6}, {keypos, #guild_arena_guild_cross.id}, {type, set}]),
    dets:to_ets(dets_guild_arena_guild_all, ets_guild_arena_guild_all).

%% 保存数据
save_dets() ->
    ets:to_dets(ets_guild_arena_area, dets_guild_arena_area),
    ets:to_dets(ets_guild_arena_role, dets_guild_arena_role),
    ets:to_dets(ets_guild_arena_guild, dets_guild_arena_guild),
    ets:to_dets(ets_guild_arena_area_all, dets_guild_arena_area_all),
    ets:to_dets(ets_guild_arena_role_all, dets_guild_arena_role_all),
    ets:to_dets(ets_guild_arena_guild_all, dets_guild_arena_guild_all).

%% 关闭dets
close_dets() ->
    dets:close(dets_guild_arena_area),
    dets:close(dets_guild_arena_role),
    dets:close(dets_guild_arena_guild),
    dets:close(dets_guild_arena_area_all),
    dets:close(dets_guild_arena_role_all),
    dets:close(dets_guild_arena_guild_all).
