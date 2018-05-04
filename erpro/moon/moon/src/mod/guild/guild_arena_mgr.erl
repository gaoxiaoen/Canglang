%%----------------------------------------------------
%% @doc 新帮战和跨服帮战管理器
%% 
%% @author Jangee@qq.com
%% @end
%%----------------------------------------------------
-module(guild_arena_mgr).
-behaviour(gen_server).
%% 外部调用接口
-export([
        join/2
        ,get_info/1
        ,get_cross_ids/0
        ,is_cross_guild/1
        ,able_to_cross/1
        ,area_finish/6
        ,cross_start/1
        ,make_cross_king/1
        ,push_to_onlines/2
        ,invite_guilds/1
        ,handle_buff/2
        ,handle_honor/2
        ,adm_round/1
        ,adm_merge/2
        ,login/1
        ,async_login/2
    ]).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-record(state, {
        round = 1,             %% 表示本服是第几轮
        sign_guilds = [],   %% 已报名跨服的帮派
        cross_guilds = [],   %% 进入下一轮的帮派
        last_winner = 0,     %% 最后一轮总冠军
        last_join = [],     %% 上一场参加的帮派
        is_synced = 0,       %% 是否已经向中央服请求同步过数据
        sync_ref = 0        %% 同步倒计时引用
    }).

-include("common.hrl").
-include("role.hrl").
-include("looks.hrl").
-include("attr.hrl").
-include("team.hrl").
-include("guild.hrl").
-include("guild_war.hrl").
-include("guild_arena.hrl").
%%

-define(guild_arena_cross_lev, 30). %% 参加跨服帮战所需帮派等级

%% ---------- 外部接口部分 ----------

%% @spec join(guild, Role) -> ok | {false, Why}
%% Role = record(role)
%% Why = atom() = not_in_guild 不在帮派 | no_permission 没有权限 | wrong_level 帮派等级不够 | already_join 已经参加 | wrong_time 不是报名时间
%% @doc 帮主或长老代表帮派参加帮战
join(guild, #role{guild = #role_guild{gid = 0}}) ->
    {false, not_in_guild};
join(guild, #role{guild = #role_guild{authority = Auth}}) when Auth =/= ?chief_op andalso Auth =/= ?elder_op ->
    {false, no_permission};
join(guild, Role = #role{guild = #role_guild{gid = Gid, srv_id = SrvId}}) ->
    case guild_mgr:lookup(by_id, {Gid, SrvId}) of
        #guild{lev = Lev} when Lev < ?guild_arena_level ->
            {false, wrong_level};
        #guild{name = Name, lev = Lev, chief = Chief, num = Num, members = Members} ->
            CrossAble = able_to_cross(Role),
            case length([Pid || #guild_member{pid = Pid} <- Members, is_pid(Pid)]) of
                ONum when ONum < ?guild_arena_member_need ->
                    {false, member_not_enough};
                %% 等级足够的就参加跨服帮战
                _ when Lev >= ?guild_arena_cross_lev andalso CrossAble ->
                    case ?CENTER_CALL(guild_arena_center_mgr, join, [guild, {Gid, SrvId, Name, Lev, Chief, Num}]) of
                        ok ->
                            gen_server:cast(?MODULE, {guild_sign, {Gid, SrvId}}),
                            %% 报名成功就通知兄弟们做准备
                            spawn(fun() -> guild:guild_mail({Gid, SrvId}, {?L(<<"跨服帮战报名成功">>), ?L(<<"我帮已经报名参加本次的跨服帮战，帮战将在20:00准时开始，请准备好！\n参加帮战，可获得大量积分奖励。积分可兑换紫色护符！\n表现优异的帮会，更能获得神秘宝箱奖励，有概率直接开出对应等级的紫色护符！">>)}) end),
                            %% 已报名帮派要锁定一下管理操作
                            guild_mem:limit_member_manage({Gid, SrvId}, unable),
                            ok;
                        Why -> {false, Why}
                    end;
                _ ->
                    case guild_arena:join(guild, {Gid, SrvId, Name, Lev, Chief, Num}) of
                        ok -> 
                            %% 报名成功就通知兄弟们做准备
                            spawn(fun() -> guild:guild_mail({Gid, SrvId}, {?L(<<"帮战报名成功">>), ?L(<<"我帮已经报名参加本次的帮战，帮战将在20:00准时开始，请准备好！\n参加帮战，可获得大量积分奖励。积分可兑换紫色护符！\n表现优异的帮会，更能获得神秘宝箱奖励，有概率直接开出对应等级的紫色护符！">>)}) end),
                            %% 已报名帮派要锁定一下管理操作
                            guild_mem:limit_member_manage({Gid, SrvId}, unable),
                            ok;
                        Why -> {false, Why}
                    end
            end;
        _Else -> 
            ?DEBUG("无效帮会数据 ~p", [_Else]),
            {false, wrong_guild}
    end;

%% @spec join(role, Role) -> ok | {false, Why}
%% Role = record(role)
%% Why = atom() = wrong_time 无效时间 | not_in_guild 还没进帮派 | already_join 已经参加 | in_team 组队中 | guild_not_join 帮派没有参战 | wrong_event 参与其他事件中 | flying 飞行中
%% @doc 个人进入准备区
join(role, #role{team_pid = TeamPid}) when is_pid(TeamPid) ->
    {false, in_team};
join(role, #role{ride = ?ride_fly}) ->
    {false, flying};
join(role, #role{event = Event}) when Event =/= ?event_no andalso Event =/= ?event_guild_arena andalso Event =/= ?event_guild ->
    {false, wrong_event};
join(role, #role{status = Status}) when Status =/= ?status_normal ->
    {false, wrong_event};
join(role, #role{cross_srv_id = CrossSrvId}) when CrossSrvId =/= <<>> ->
    {false, cross_srv};
join(role, Role = #role{id = Id, pid = Pid, lev = Lev, name = Name, attr = Attr, guild = #role_guild{gid = Gid, srv_id = SrvId, name = GuildName, position = Position}, career = Career}) ->
    FC = case Attr of 
        #attr{fight_capacity = Fc} -> Fc;
        _ -> 0
    end,
    case is_cross_guild(Role)of
        true  ->
            case ?CENTER_CALL(guild_arena_center_mgr, join, [role, {Id, Pid, Lev, Name, FC, {Gid, SrvId}, GuildName, Position, Career}]) of
                ok -> apply_task(Role);
                Error -> {false, Error}
            end;
        _ ->
            case guild_arena:join(role, {Id, Pid, Lev, Name, FC, {Gid, SrvId}, GuildName, Position}) of
                ok -> apply_task(Role);
                Error -> {false, Error}
            end
    end;

%% @spec join(to_war_area, Role) -> ok | {false, Why}
%% Role = record(role)
%% Why = atom() = wrong_time 无效时间 | not_in_guild 还没进帮派 | already_join 已经参加 | guild_not_join 帮派没有参战 | wrong_event 参与其他事件中
%% @doc 个人正式战区
join(to_war_area, #role{ride = ?ride_fly}) ->
    {false, flying};
%% 非队长不能操作
join(to_war_area, #role{team = #role_team{follow = ?true, is_leader = ?false}}) ->
    {false, follow_team};
join(to_war_area, #role{id = Id, pid = Pid, team_pid = TeamPid, event = ?event_guild_arena, cross_srv_id = CrossSrvId}) when is_pid(TeamPid) ->
    %% 如果有组队还要找出跟随的队员一起传送
    Rids = case team:get_team_info(TeamPid) of
        {ok, #team{member = [#team_member{id = Mid, pid = MPid, mode = ?MODE_NORMAL}]}} ->
            [{Id, Pid}, {Mid, MPid}];
        _ ->
            [{Id, Pid}]
    end,
    case CrossSrvId of
        <<"center">> ->
            case ?CENTER_CALL(guild_arena_center_mgr, join, [to_war_area, Rids]) of
                ok -> ok;
                Error -> {false, Error}
            end;
        _ ->
            case guild_arena:join(to_war_area, Rids) of
                ok -> ok;
                Error -> {false, Error}
            end
    end;
join(to_war_area, #role{id = Id, pid = Pid, event = ?event_guild_arena, cross_srv_id = CrossSrvId}) ->
    Rids = [{Id, Pid}],
    case CrossSrvId of
        <<"center">> ->
            case ?CENTER_CALL(guild_arena_center_mgr, join, [to_war_area, Rids]) of
                ok -> ok;
                Error -> {false, Error}
            end;
        _ ->
            case guild_arena:join(to_war_area, Rids) of
                ok -> ok;
                Error -> {false, Error}
            end
    end;
join(to_war_area, _) ->
    {false, wrong_event}.

%% @spec area_finish(Area, Roles, Guilds) -> ok
%% Area = #arena_area{}
%% Roles = list(#guild_arena_role{})
%% Guilds = list(#arena_guild{})
%% @doc 战区进程通过这接口把战果
area_finish(Area, Roles, Guilds, Round, GuildCross, RoleCross) ->
    ets:insert(ets_guild_arena_area_cross, {Area#arena_area.id, Roles, Guilds, Area#arena_area.guild_rank, Area#arena_area.guild_num}),
    [ets:insert(ets_guild_arena_role_cross, R) || R <- Roles],
    [ets:insert(ets_guild_arena_guild_cross, G) || G <- Guilds],
    [ets:insert(ets_guild_arena_guild_all_cross, Gc) || Gc <- GuildCross],
    [ets:insert(ets_guild_arena_role_all_cross, Rc) || Rc <- RoleCross],
    case ets:lookup(ets_guild_arena_area_all_cross, Round) of
        [{_, AreaData}] ->
            ets:insert(ets_guild_arena_area_all_cross, {Round, [{Area#arena_area.id, GuildCross, RoleCross} | AreaData]});
        _ ->
            ets:insert(ets_guild_arena_area_all_cross, {Round, [{Area#arena_area.id, GuildCross, RoleCross}]})
    end.

%% 每次开启新的跨服帮战时前一场数据清掉
cross_start(Round) ->
    ets:delete_all_objects(ets_guild_arena_area_cross),
    ets:delete_all_objects(ets_guild_arena_role_cross),
    ets:delete_all_objects(ets_guild_arena_guild_cross),
    case Round of
        1 -> ets:delete_all_objects(ets_guild_arena_area_all_cross);
        _ -> ok
    end,
    gen_server:cast(?MODULE, {cross_start, Round}).

%% 邀请进入正式区或准备区
invite_guilds(Type) ->
    Timeout = util:rand(1, 15) * 1000,
    erlang:send_after(Timeout, ?MODULE, {sign_guild_push, Type}).

%% 设定新的王者帮派
make_cross_king({Id, SrvId}) ->
    gen_server:cast(?MODULE, {make_cross_king, {Id, SrvId}});
make_cross_king(_) ->
    ok.

%% 获取有资格参加跨服帮战的玩家id
get_cross_ids() ->
    case calendar:day_of_the_week(date()) of
        1 ->
            Guilds = [Members || #guild{lev = Lev, members = Members} <- guild_mgr:list(), Lev >= ?guild_arena_cross_lev],
            make_guild_member_ids(Guilds, []);
        _ ->
            case gen_server:call(?MODULE, get_cross_ids) of
                {1, _} ->
                    Guilds = [Members || #guild{lev = Lev, members = Members} <- guild_mgr:list(), Lev >= ?guild_arena_cross_lev],
                    make_guild_member_ids(Guilds, []);
                {_, []} ->
                    [];
                {_, Gids} ->
                    F = fun(Gid) ->
                            case guild_mgr:lookup(by_id, Gid) of
                                #guild{members = Members} -> Members;
                                _ -> []
                            end
                    end,
                    make_guild_member_ids([F(Id) || Id <- Gids], [])
            end
    end.

%% 这里其实是推送给有资格参加跨服帮战的玩家
push_to_onlines(Type, Data) ->
    case calendar:day_of_the_week(date()) of
        1 ->
            [guild:pack_send(Id, Type, Data) || #guild{id = Id, lev = Lev} <- guild_mgr:list(), Lev >= ?guild_arena_cross_lev];
        _ ->
            case gen_server:call(?MODULE, get_cross_ids) of
                {1, _} ->
                    [guild:pack_send(Id, Type, Data) || #guild{id = Id, lev = Lev} <- guild_mgr:list(), Lev >= ?guild_arena_cross_lev];
                {_, []} -> 
                    ok;
                {_, Gids} ->
                    [guild:pack_send(Id, Type, Data) || Id <- Gids]
            end
    end.

%% 判断一个帮派是否是已经参加跨服战
is_cross_guild(#role{guild = #role_guild{gid = Gid, srv_id = SrvId}}) ->
    case center:is_connect() of
        {true, _} ->
            gen_server:call(?MODULE, {is_cross_guild, {Gid, SrvId}});
        _ -> false
    end;
is_cross_guild(_) ->
    false.

%% 判断一个帮派是否可以参加跨服战
able_to_cross(#role{guild = #role_guild{gid = Gid, srv_id = SrvId}}) ->
    case center:is_connect() of
        {true, _} ->
            case guild_mgr:lookup(by_id, {Gid, SrvId}) of
                #guild{lev = Lev} when Lev < ?guild_arena_cross_lev ->
                    false;
                _ ->
                    gen_server:call(?MODULE, {able_to_cross, {Gid, SrvId}})
            end;
        _ -> false
    end;
able_to_cross(_) ->
    false.

%% 玩家登录处理
login(Role =  #role{lev = Lev}) when Lev < ?join_lev_limit ->
    Role;
login(Role =  #role{guild = #role_guild{gid = 0}}) ->
    Role;
login(Role = #role{pid = Pid, guild = #role_guild{gid = Gid, srv_id = SrvId}}) ->
    gen_server:cast(?MODULE, {login, Pid, {Gid, SrvId}}),
    Role.

%% 登录异步处理
async_login(Role, Win) ->
    {ok, login_buff_honor(Role, Win)}.

%% @spec adm_round(Id) -> ok
%% @doc GM命令设定当前帮战是第几轮
adm_round(Round) when is_integer(Round) andalso Round < 4 andalso Round > 0 ->
    case gen_server:cast(?MODULE, {admin_round, Round}) of
        ok ->
            ?INFO("跨服帮战成功设置为第 ~w", [Round]);
        _R ->
            ?INFO("跨服帮战设置失败 ~w", [_R])
    end;
adm_round(_Id) ->
    ?DEBUG("无效参数 ~p", [_Id]).

%% @spec adm_merge(State1, State2) -> NewState
%% State1 = State2 = NewState = #state{}
%% @doc 合服处理
adm_merge(S = #state{cross_guilds = CrossGuilds1, last_join = LastJoin1}, #state{cross_guilds = CrossGuilds2, last_join = LastJoin2}) ->
    S#state{
        cross_guilds = CrossGuilds1 ++ CrossGuilds2,
        last_join = LastJoin1 ++ LastJoin2
    };
adm_merge(S = #state{}, _) -> S;
adm_merge(_, S = #state{}) -> S;
adm_merge(_, _) ->
    #state{}.

%% @spec get_info({guilds, Page}) -> {NewPage, Guilds, GuildNum}
%% Page = integer() 要查看的页码
%% NewPage = integer() 实际有效的页码
%% Guilds = list() 对应页的帮派列表
%% GuildNum = integer() 总帮派数
%% @doc 获取参战帮派信息（分页）
get_info({area_guilds, Page, Id}) when is_integer(Page) ->
    case ets:lookup(ets_guild_arena_role_cross, Id) of
        [#guild_arena_role{aid = Aid}] ->
            case ets:lookup(ets_guild_arena_area_cross, Aid) of
                [{_, _, Guilds, _, GuildNum}] ->
                    get_page_list({GuildNum, guild_arena:sort_guild(sum_score, Guilds)}, Page, ?guild_arena_panel_size);
                _ ->
                    {1, [], 0}
            end;
        _ ->
            guild_arena:get_info({area_guilds, Page, Id})
    end;
get_info({guilds, Page, Id}) when is_integer(Page) ->
    case ets:lookup(ets_guild_arena_role_cross, Id) of
        [#guild_arena_role{aid = Aid}] ->
            case ets:lookup(ets_guild_arena_area_cross, Aid) of
                [{_, _, Guilds, _, GuildNum}] ->
                    get_page_list({GuildNum, guild_arena:sort_guild(sum_score, Guilds)}, Page, ?guild_arena_list_size);
                _ ->
                    {1, [], 0}
            end;
        _ ->
            guild_arena:get_info({guilds, Page})
    end;

%% 跨服某轮某战区列表
get_info({guilds_round, Round, AreaId, Page}) when is_integer(Round) andalso is_integer(AreaId) andalso is_integer(Page) ->
        case ets:lookup(ets_guild_arena_area_all_cross, Round) of
            [{_, RoundData}] ->
                Areas = [Aid || {Aid, _, _} <- RoundData],
                case lists:keyfind(AreaId, 1, RoundData) of
                    {_, Guilds, _} ->
                        [Areas, get_page_list({length(Guilds), sort(guild_round, Guilds)}, Page, ?guild_arena_list_size)];
                    _ ->
                        [Areas, {1, [], 0}]
                end;
            _ ->
                [[], {1, [], 0}]
        end;
%% 跨服某轮自己帮派所在页
get_info({guilds_round_my_rank, Round, Id}) when is_integer(Round) ->
        case ets:lookup(ets_guild_arena_area_all_cross, Round) of
            [{_, RoundData}] ->
                Areas = [Aid || {Aid, _, _} <- RoundData],
                [Areas, find_my_guild(Areas, RoundData, Id)];
            _ ->
                [[], {1, [], 0}]
        end;

%% 查看我的帮派在战区排行所在页(强制自动切换跨服或本服)
get_info({my_guild_rank, Id, Gid}) ->
    case ets:lookup(ets_guild_arena_role_cross, Id) of
        %% 跨服
        [#guild_arena_role{aid = Aid}] ->
            case ets:lookup(ets_guild_arena_area_cross, Aid) of
                [{_, _, Guilds, _, GuildNum}] ->
                    RankNum = guild_arena:get_rank(guild, 1, Gid, Guilds),
                    Page = util:ceil(RankNum / ?guild_arena_list_size),
                    get_page_list({GuildNum, Guilds}, Page, ?guild_arena_list_size);
                _ ->
                    {1, [], 0}
            end;
        _ ->
            %% 本服
            guild_arena:get_info({my_guild_rank, Gid})
    end;

%% 跨服历届帮派总排名
get_info({guilds_cross, Page}) when is_integer(Page) ->
    case ets:tab2list(ets_guild_arena_guild_all_cross) of
        [] ->
            {1, [], 0};
        Guilds ->
            GuildNum = ets:info(ets_guild_arena_guild_all_cross, size),
            get_page_list({GuildNum, sort(guild_total, Guilds)}, Page, ?guild_arena_list_size)
    end;

%% 跨服历届帮派总排名(个人帮派所在页)
get_info({guilds_cross_my_rank, Gid}) ->
    case ets:lookup(ets_guild_arena_guild_all_cross, Gid) of
        [] ->
            {1, [], 0};
        _ ->
            case ets:tab2list(ets_guild_arena_guild_all_cross) of
                [] ->
                    {1, [], 0};
                Guilds ->
                    GuildNum = ets:info(ets_guild_arena_guild_all_cross, size),
                    NewGuilds = sort(guild_total, Guilds),
                    RankNum = guild_arena:get_rank(guild, 1, Gid, NewGuilds),
                    Page = util:ceil(RankNum / ?guild_arena_list_size),
                    get_page_list({GuildNum, NewGuilds}, Page, ?guild_arena_list_size)
            end
    end;

%% 战区个人战况
get_info({area_roles, Page, Id}) when is_integer(Page) ->
    case ets:lookup(ets_guild_arena_role_cross, Id) of
        [#guild_arena_role{aid = Aid}] ->
            case ets:lookup(ets_guild_arena_area_cross, Aid) of
                [{_, Roles, _, _, _}] ->
                    get_page_list({length(Roles), guild_arena:sort_role(sum_score, Roles)}, Page, ?guild_arena_panel_size);
                _ ->
                    {1, [], 0}
            end;
        _ ->
            guild_arena:get_info({area_roles, Page, Id})
    end;
%% 总战况
get_info({roles, Page, Id}) when is_integer(Page) ->
    case ets:lookup(ets_guild_arena_role_cross, Id) of
        [#guild_arena_role{aid = Aid}] ->
            case ets:lookup(ets_guild_arena_area_cross, Aid) of
                [{_, Roles, _, _, _}] ->
                    get_page_list({length(Roles), guild_arena:sort_role(sum_score, Roles)}, Page, ?guild_arena_list_size);
                _ ->
                    {1, [], 0}
            end;
        _ ->
            guild_arena:get_info({roles, Page})
    end;

%% 查看个人在战区的排名所在页(强制自动切换跨服和本服)
get_info({my_rank, Id}) ->
    case ets:lookup(ets_guild_arena_role_cross, Id) of
        [#guild_arena_role{aid = Aid}] ->
            case ets:lookup(ets_guild_arena_area_cross, Aid) of
                [{_, Roles, _, _, _}] ->
                    RankNum = guild_arena:get_rank(role, 1, Id, guild_arena:sort_role(sum_score, Roles)),
                    Page = util:ceil(RankNum / ?guild_arena_list_size),
                    get_page_list({length(Roles), Roles}, Page, ?guild_arena_list_size);
                _ ->
                    {1, [], 0}
            end;
        _ ->
            guild_arena:get_info({my_rank, Id})
    end;

%% 跨服某轮某战区列表
get_info({roles_round, Round, AreaId, Page}) when is_integer(Round) andalso is_integer(AreaId) andalso is_integer(Page) ->
        case ets:lookup(ets_guild_arena_area_all_cross, Round) of
            [{_, RoundData}] ->
                Areas = [Aid || {Aid, _, _} <- RoundData],
                case lists:keyfind(AreaId, 1, RoundData) of
                    {_, _, Roles} ->
                        [Areas, get_page_list({length(Roles), sort(role_round, Roles)}, Page, ?guild_arena_list_size)];
                    _ ->
                        [Areas, {1, [], 0}]
                end;
            _ ->
                [[], {1, [], 0}]
        end;

%% 跨服某轮自己帮派所在页
get_info({roles_round_my_rank, Round, Id}) when is_integer(Round) ->
        case ets:lookup(ets_guild_arena_area_all_cross, Round) of
            [{_, RoundData}] ->
                Areas = [Aid || {Aid, _, _} <- RoundData],
                [Areas, find_myself(Areas, RoundData, Id)];
            _ ->
                [[], {1, [], 0}]
        end;

%% 跨服历届玩家总排名
get_info({roles_cross, Page}) when is_integer(Page) ->
    case ets:tab2list(ets_guild_arena_role_all_cross) of
        [] ->
            {1, [], 0};
        Roles ->
            RoleNum = ets:info(ets_guild_arena_role_all_cross, size),
            get_page_list({RoleNum, sort(role_total, Roles)}, Page, ?guild_arena_list_size)
    end;

%% 跨服历届玩家总排名(自己所在)
get_info({roles_cross_my_rank, Id}) ->
    case ets:lookup(ets_guild_arena_role_all_cross, Id) of
        [] ->
            {1, [], 0};
        _ ->
            case ets:tab2list(ets_guild_arena_role_all_cross) of
                [] ->
                    {1, [], 0};
                Roles ->
                    RoleNum = ets:info(ets_guild_arena_role_all_cross, size),
                    NewRoles= sort(role_total, Roles),
                    RankNum = guild_arena:get_rank(role, 1, Id, NewRoles),
                    Page = util:ceil(RankNum / ?guild_arena_list_size),
                    get_page_list({RoleNum, NewRoles}, Page, ?guild_arena_list_size)
            end
    end;

%% 获取进程状态
get_info(all) ->
    gen_server:call(?MODULE, {info, all}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    ets:new(ets_guild_arena_role_cross, [set, named_table, public, {keypos, #guild_arena_role.id}]),
    ets:new(ets_guild_arena_guild_cross, [set, named_table, public, {keypos, #arena_guild.id}]),
    ets:new(ets_guild_arena_role_all_cross, [set, named_table, public, {keypos, #guild_arena_role_cross.id}]),
    ets:new(ets_guild_arena_guild_all_cross, [set, named_table, public, {keypos, #guild_arena_guild_cross.id}]),
    ets:new(ets_guild_arena_area_cross, [set, named_table, public, {keypos, 1}]),
    ets:new(ets_guild_arena_area_all_cross, [set, named_table, public, {keypos, 1}]),
    NewRef = erlang:send_after(65000, self(), cross_sync),
    NewState = case sys_env:get(guild_arena_mgr_state) of
        State = #state{} ->
            State#state{sync_ref = NewRef};
        _R ->
            ?DEBUG("还没有旧数据 ~w", [_R]),
            #state{sync_ref = NewRef}
    end,
    {ok, NewState}.

%% 判断玩家的帮派是否参加了跨服帮战
handle_call({is_cross_guild, Id}, _From, State = #state{sign_guilds = SignGuilds}) ->
    Reply = case calendar:day_of_the_week(date()) of
        7 -> false;
        _ -> lists:member(Id, SignGuilds)
    end,
    {reply, Reply, State};

%% 判断一个帮派是否够资格参加跨服帮战
handle_call({able_to_cross, GId}, _From, State = #state{round = Round, cross_guilds = Guilds}) ->
    Day = calendar:day_of_the_week(date()),
    Reply = case {calendar:day_of_the_week(date()), Round} of
        _ when Day =:= 7 -> false;
        {_, 1} -> true;
        _ -> lists:member(GId, Guilds)
    end,
    {reply, Reply, State};

%% 判断玩家的帮派是否参加了跨服帮战
handle_call(get_cross_ids, _From, State = #state{cross_guilds = Guilds, round = Round}) ->
    ?DEBUG("round ~w", [Round]),
    Reply = {Round, Guilds},
    {reply, Reply, State};

%% 获取上一场的王者帮派 
handle_call(get_last_winner, _From, State = #state{last_winner = LastWinner}) ->
    {reply, LastWinner, State};


%% 获取进程所有信息
handle_call({info, all}, _From, State) ->
    {reply, State, State};

handle_call(_Request, _From, State) ->
    {noreply, State}.

%% 报名了跨服帮战的帮派在这里记录下
handle_cast({guild_sign, Id}, State = #state{sign_guilds = SignGuilds}) ->
    NewSignGuilds = case lists:member(Id, SignGuilds) of
        true ->
            SignGuilds;
        _ ->
            [Id | SignGuilds]
    end,
    {noreply, State#state{sign_guilds = NewSignGuilds}};

%% 推送给报名跨服帮派所有成员
handle_cast({sign_guild_push, Type}, State = #state{sign_guilds = Guilds}) ->
    push_to_guilds(open_invite, Type, Guilds),
    {noreply, State};

%% 跨服帮战结束
handle_cast(finish, State = #state{sign_guilds = Guilds, last_join = LastJoin, sync_ref = Ref, last_winner = LastWinner}) ->
    [guild_mem:limit_member_manage(UnlockId, able) || UnlockId <- Guilds],
    case erlang:is_reference(Ref) of
        true -> erlang:cancel_timer(Ref);
        _ -> ok
    end,
    [handle_buff(del, Gid1) || Gid1 <- LastJoin],
    [handle_honor(del, Gid2) || Gid2 <- LastJoin],
    NewRef = erlang:send_after(util:rand(1, 20) * 1000, self(), cross_sync),
    JoinGuilds = lists:delete(LastWinner, Guilds),
    [handle_buff(add_join, Gid3) || Gid3 <- JoinGuilds],
    [handle_honor(add_join, Gid4) || Gid4 <- JoinGuilds],
    NewState = State#state{sign_guilds = [], last_join = Guilds, sync_ref = NewRef},
    sys_env:save(guild_arena_mgr_state, NewState#state{sync_ref = 0}),
    {noreply, NewState};

%% 新一轮跨服帮战开始
handle_cast({cross_start, Round}, State = #state{sync_ref = Ref}) ->
    case erlang:is_reference(Ref) of
        true -> erlang:cancel_timer(Ref);
        _ -> ok
    end,
    NewRef = erlang:send_after(3600 * 1000, self(), cross_sync),
    {noreply, State#state{round = Round, is_synced = 0, sync_ref = NewRef}};

%% 设定新的王者帮派
handle_cast({make_cross_king, Id}, State = #state{last_winner = LastWinner}) ->
    case LastWinner of
        0 -> ok;
        _ ->
            handle_buff(del, LastWinner),
            handle_honor(del, LastWinner)
    end,
    handle_buff(add, Id),
    handle_honor(add, Id),
    {noreply, State#state{last_winner = Id}};

%% 设定轮数
handle_cast({admin_round, Round}, State) ->
    {noreply, State#state{round = Round}};

%% 登录处理
handle_cast({login, Pid, GId}, State = #state{last_winner = LastWinner, last_join = LastJoin}) ->
    IsJoin = lists:member(GId, LastJoin),
    LoginData = [LastWinner, IsJoin],
    role:apply(async, Pid, {?MODULE, async_login, [LoginData]}),
    {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

%% 向中央服请求数据
handle_info(cross_sync, State = #state{sync_ref = Ref, round = Round}) ->
    case erlang:is_reference(Ref) of
        true -> erlang:cancel_timer(Ref);
        _ -> ok
    end,
    case center:is_connect() of
        false ->
            NewRef = erlang:send_after(120 * 1000, self(), cross_sync),
            {noreply, State#state{sync_ref = NewRef}};
        _ ->
            Areas = ?CENTER_CALL(ets, tab2list, [ets_guild_arena_area]),
            Guilds = ?CENTER_CALL(ets, tab2list, [ets_guild_arena_guild]),
            Roles = ?CENTER_CALL(ets, tab2list, [ets_guild_arena_role]),
            AreasAll = ?CENTER_CALL(ets, tab2list, [ets_guild_arena_area_all]),
            GuildsAll = ?CENTER_CALL(ets, tab2list, [ets_guild_arena_guild_all]),
            RolesAll = ?CENTER_CALL(ets, tab2list, [ets_guild_arena_role_all]),
            LastWinner = ?CENTER_CALL(guild_arena_center_mgr, get_last_winner, []),
            ets:delete_all_objects(ets_guild_arena_area_cross),
            [ets:insert(ets_guild_arena_area_cross, A) || A <- Areas],
            ets:delete_all_objects(ets_guild_arena_guild_cross),
            [ets:insert(ets_guild_arena_guild_cross, G) || G <- Guilds],
            ets:delete_all_objects(ets_guild_arena_role_cross),
            [ets:insert(ets_guild_arena_role_cross, R) || R <- Roles],
            ets:delete_all_objects(ets_guild_arena_area_all_cross),
            [ets:insert(ets_guild_arena_area_all_cross, Aa) || Aa <- AreasAll],
            ets:delete_all_objects(ets_guild_arena_guild_all_cross),
            [ets:insert(ets_guild_arena_guild_all_cross, Ga) || Ga <- GuildsAll],
            ets:delete_all_objects(ets_guild_arena_role_all_cross),
            [ets:insert(ets_guild_arena_role_all_cross, Ra) || Ra <- RolesAll],
            CrossGuilds = get_cross_guilds(Areas, Round, []),
            {noreply, State#state{sync_ref = 0, is_synced = 1, cross_guilds = CrossGuilds, last_winner = LastWinner}}
    end;

handle_info({sign_guild_push, Type}, State = #state{sign_guilds = Guilds}) ->
    push_to_guilds(open_invite, Type, Guilds),
    {noreply, State};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% --- 内部方法 ------------------------

%% 完成帮战任务
apply_task(Role) ->
    NewRole1 = role_listener:special_event(Role, {1023, finish}), 
    {ok, NewRole1}.

%% 推送给已参战帮派的成员
push_to_guilds(open_invite, Type, Guilds) ->
    [guild:pack_send(Gid, 15913, {Type}) || Gid <- Guilds].

%% 整理帮众id
make_guild_member_ids([], Ids) ->
    Ids;
make_guild_member_ids([Mbs | T], Ids) ->
    NewIds = Ids ++ [Id || #guild_member{id = Id} <- Mbs],
    make_guild_member_ids(T, NewIds).

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

%% 获取可以进入下一轮跨服帮战的帮派
get_cross_guilds([], _, Gids) ->
    Gids;
get_cross_guilds([{_, _, _, [], _} | T], Round, Gids) ->
    get_cross_guilds(T, Round, Gids);
%% 第一轮取前两名
get_cross_guilds([{_, _, _, [{No1, _}, {No2, _} | _], _} | T], 1, Gids) ->
    get_cross_guilds(T, 1, [No1, No2 | Gids]);
%% 其他情况去第一名
get_cross_guilds([{_, _, _, [{No1, _} | _], _} | T], Round, Gids) ->
    get_cross_guilds(T, Round, [No1 | Gids]).

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

apply_handle_buff(Role, del) ->
    NR = case buff:del_buff_by_label(Role, ?guild_arena_cross_winner_buffer) of
        false ->
            Role;
        {ok, NewRole} ->
            NewRole
    end,
    case buff:del_buff_by_label(NR, ?guild_arena_cross_join_buffer) of
        false ->
            {ok, NR};
        {ok, NewRole2} ->
            {ok, NewRole2}
    end;
apply_handle_buff(Role, add) ->
    NR1 = case buff:del_buff_by_label(Role, ?guild_arena_cross_join_buffer) of
        {ok, NR2} -> NR2;
        _ -> Role
    end,
    NR3 = case buff:del_buff_by_label(NR1, ?guild_war_winner_buffer) of
        {ok, NR4} -> NR4;
        _ -> NR1
    end,
    case buff:add(NR3, ?guild_arena_cross_winner_buffer) of
        {false, _Reason} ->
            {ok};
        {ok, NewRole} ->
            Nr2 = role_api:push_attr(NewRole),
            {ok, Nr2}
    end;
apply_handle_buff(Role, add_join) ->
    NR1 = case buff:del_buff_by_label(Role, ?guild_arena_cross_winner_buffer) of
        {ok, NR2} -> NR2;
        _ -> Role
    end,
    NR3 = case buff:del_buff_by_label(NR1, ?guild_war_winner_buffer) of
        {ok, NR4} -> NR4;
        _ -> NR1
    end,
    case buff:add(NR3, ?guild_arena_cross_join_buffer) of
        {false, _Reason} ->
            {ok};
        {ok, NewRole} ->
            Nr3 = role_api:push_attr(NewRole),
            {ok, Nr3}
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
        {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_ARENA_CROSS_WINNER} ->
            NewRole = Role#role{looks = lists:keydelete(?LOOKS_TYPE_GUILD_WAR_HONOR, 1, Looks)},
            map:role_update(NewRole),
            {ok, NewRole};
        {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_ARENA_CROSS_WINNER_CHIEF} ->
            NewRole = Role#role{looks = lists:keydelete(?LOOKS_TYPE_GUILD_WAR_HONOR, 1, Looks)},
            map:role_update(NewRole),
            {ok, NewRole};
        {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_ARENA_CROSS_JOIN} ->
            NewRole = Role#role{looks = lists:keydelete(?LOOKS_TYPE_GUILD_WAR_HONOR, 1, Looks)},
            map:role_update(NewRole),
            {ok, NewRole};
        _ ->
            {ok}
    end;
apply_handle_honor(Role = #role{looks = Looks, guild = #role_guild{position = Pos}}, add) ->
    Glooks = case Pos of
        ?guild_chief -> {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_ARENA_CROSS_WINNER_CHIEF};
        _ -> {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_ARENA_CROSS_WINNER}
    end,
    NewLooks = case lists:keyfind(?LOOKS_TYPE_GUILD_WAR_HONOR, 1, Looks) of
        false ->
            [Glooks | Looks];
        _ ->
            lists:keyreplace(?LOOKS_TYPE_GUILD_WAR_HONOR, 1, Looks, Glooks)
    end,
    NewRole = Role#role{looks = NewLooks},
    map:role_update(NewRole),
    {ok, NewRole};
apply_handle_honor(Role = #role{looks = Looks}, add_join) ->
    Glooks = {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_ARENA_CROSS_JOIN},
    NewLooks = case lists:keyfind(?LOOKS_TYPE_GUILD_WAR_HONOR, 1, Looks) of
        false ->
            [Glooks | Looks];
        _ ->
            lists:keyreplace(?LOOKS_TYPE_GUILD_WAR_HONOR, 1, Looks, Glooks)
    end,
    NewRole = Role#role{looks = NewLooks},
    map:role_update(NewRole),
    {ok, NewRole}.

%% 登录时buff和称号处理
login_buff_honor(Role = #role{name = _Name, guild = #role_guild{gid = Gid, srv_id = GsrvId, position = Pos}, looks = Looks}, [{Gid, GsrvId}, _]) ->
    Glooks = case Pos of
        ?guild_chief -> {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_ARENA_CROSS_WINNER_CHIEF};
        _ -> {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_ARENA_CROSS_WINNER}
    end,
    NewLooks = case lists:keyfind(?LOOKS_TYPE_GUILD_WAR_HONOR, 1, Looks) of
        false ->
            [Glooks | Looks];
        _ ->
            lists:keyreplace(?LOOKS_TYPE_GUILD_WAR_HONOR, 1, Looks, Glooks)
    end,
    ?DEBUG("Newglooks ~w", [NewLooks]),
    case apply_handle_buff(Role, add) of
        {ok, NewRole} ->
            NewRole#role{looks = NewLooks};
        _R2 ->
            Role#role{looks = NewLooks}
    end;
%% 参战者都有buff
login_buff_honor(Role = #role{name = _Name, looks = Looks}, [_, true]) ->
    Glooks = {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_ARENA_CROSS_JOIN},
    %% 要区分下是否是阵营战的奖励如果是属于阵营战的，这里就不要处理
    NewLooks = case lists:keyfind(?LOOKS_TYPE_GUILD_WAR_HONOR, 1, Looks) of
        false ->
            [Glooks | Looks];
        {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_ARENA_CROSS_JOIN} ->
            Looks;
        _ ->
            lists:keyreplace(?LOOKS_TYPE_GUILD_WAR_HONOR, 1, Looks, Glooks)
    end,
    ?DEBUG("Newglooks2 ~w", [NewLooks]),
    case apply_handle_buff(Role, add_join) of
        {ok, NewRole} ->
            NewRole#role{looks = NewLooks};
        _R2 ->
            Role#role{looks = NewLooks}
    end;
%% 其他情况要清掉
login_buff_honor(Role = #role{name = _Name, looks = Looks}, _R) ->
    ?DEBUG("头上的东东清了~w", [Looks]),
    NewLooks = case lists:keyfind(?LOOKS_TYPE_GUILD_WAR_HONOR, 1, Looks) of
        {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_ARENA_CROSS_WINNER} ->
            lists:keydelete(?LOOKS_TYPE_GUILD_WAR_HONOR, 1, Looks);
        {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_ARENA_CROSS_WINNER_CHIEF} ->
            lists:keydelete(?LOOKS_TYPE_GUILD_WAR_HONOR, 1, Looks);
        {?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_ARENA_CROSS_JOIN} ->
            lists:keydelete(?LOOKS_TYPE_GUILD_WAR_HONOR, 1, Looks);
        _ ->
            Looks
    end,
    case apply_handle_buff(Role, del) of
        {ok, NewRole} ->
            NewRole#role{looks = NewLooks};
        _R2 ->
            Role#role{looks = NewLooks}
    end.

%% 根据条件给数据排序
sort(guild_round, Guilds) ->
    F = fun(#guild_arena_guild_cross{current_score = ScoreA}, #guild_arena_guild_cross{current_score = ScoreB}) ->
            ScoreA > ScoreB
    end,
    lists:sort(F, Guilds);
sort(guild_total, Guilds) ->
    F = fun(#guild_arena_guild_cross{total_score = ScoreA}, #guild_arena_guild_cross{total_score = ScoreB}) ->
            ScoreA > ScoreB
    end,
    lists:sort(F, Guilds);
sort(role_round, Roles) ->
    F = fun(#guild_arena_role_cross{current_score = ScoreA}, #guild_arena_role_cross{current_score = ScoreB}) ->
            ScoreA > ScoreB
    end,
    lists:sort(F, Roles);
sort(role_total, Roles) ->
    F = fun(#guild_arena_role_cross{total_score = ScoreA}, #guild_arena_role_cross{total_score = ScoreB}) ->
            ScoreA > ScoreB
    end,
    lists:sort(F, Roles).

%% 查找自己帮派所在
find_my_guild([], _, _) ->
    {1, [], 0};
find_my_guild([AreaId | T], RoundData, Gid) ->
    case lists:keyfind(AreaId, 1, RoundData) of
        {_, Guilds, _} ->
            case lists:keyfind(Gid, #guild_arena_guild_cross.id, Guilds) of
                #guild_arena_guild_cross{id = Gid} ->
                    NewGuilds = sort(guild_round, Guilds),
                    RankNum = guild_arena:get_rank(guild, 1, Gid, NewGuilds),
                    Page = util:ceil(RankNum / ?guild_arena_list_size),
                    get_page_list({length(NewGuilds), NewGuilds}, Page, ?guild_arena_list_size);
                _ ->
                    find_my_guild(T, RoundData, Gid)
            end;
        _ ->
            find_my_guild(T, RoundData, Gid)
    end.

%% 查找自己所在
find_myself([], _, _) ->
    {1, [], 0};
find_myself([AreaId | T], RoundData, Id) ->
    case lists:keyfind(AreaId, 1, RoundData) of
        {_, _, Roles} ->
            case lists:keyfind(Id, #guild_arena_role_cross.id, Roles) of
                #guild_arena_role_cross{id = Id} ->
                    NewRoles = sort(role_round, Roles),
                    RankNum = guild_arena:get_rank(role, 1, Id, NewRoles),
                    Page = util:ceil(RankNum / ?guild_arena_list_size),
                    get_page_list({length(NewRoles), NewRoles}, Page, ?guild_arena_list_size);
                _ ->
                    find_myself(T, RoundData, Id)
            end;
        _ ->
            find_myself(T, RoundData, Id)
    end.
