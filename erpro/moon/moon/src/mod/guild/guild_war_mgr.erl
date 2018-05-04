%% --------------------------------------------------------------------
%% 帮战管理进程
%% @author abu@jieyou.cn
%% @end
%% --------------------------------------------------------------------
-module(guild_war_mgr).

-behaviour(gen_server).

%% export api functions
-export([
        start_link/0
        ,get_war_pid/0
        ,is_first_war/0
        ,last_war_info/3
        ,set_last_war_info/1
        ,start_war/0
        ,login/1
        ,logout/1
        ,sign_up/2
        ,sign_up_info/0
        ,owner_info/0
        ,status_changed/1
        ,info/0
        ,set_first/0
    ]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).

%% include file
-include("common.hrl").
-include("role.hrl").
-include("guild.hrl").
-include("guild_war.hrl").
%%
-include("pos.hrl").
-include("looks.hrl").

%% record
-record(state, {war_pid = 0, offline_roles = [], owner = undefined, guilds = [], is_first = ?false, last_war_state = undefined}).

-define(enter_point_map, 10003).
-define(enter_point_x, 2832).
-define(enter_point_y, 1002).

%% --------------------------------------------------------------------
%% API functions
%% --------------------------------------------------------------------

%% @spec start_link() -> {ok,Pid} | ignore | {error,Error}
%% Starts the server
start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

%% @spec is_first_war() -> 0 | 1
%% 是否为本服第一次帮战
is_first_war() ->
    gen_server:call({global, ?MODULE}, is_first_war).

%% @spec set_last_war_info(WarState) 
%% WarState = #guild_war{}
%% 设置上一场帮战的战斗状况
set_last_war_info(WarState) ->
    case global:whereis_name(?MODULE) of
        Pid when is_pid(Pid) ->
            Pid ! {set_last_war_info, WarState};
        _ ->
            ok
    end.

%% @spec last_war_info(Type, Page, Rid) ->
%% Type = role | guild | union
%% Page = integer()
%% rid = rid()
%% 帮战战况
last_war_info(Type, Page, Rid) ->
    gen_server:call({global, ?MODULE}, {last_war_info, Type, Page, Rid}).

%% @spec get_war_pid() -> pid() | 0
%% 获取帮战进程的pid
get_war_pid() ->
    gen_server:call({global, ?MODULE}, {get_war_pid}).

%% @spec start_war() -> {ok, Pid} | ignore | {error, Error}
%% Pid = pid()
%% Error = binary()
%% 开启帮战
start_war() ->
    gen_server:call({global, ?MODULE}, {start_war}).

%% @spec login(Role) -> NewRole
%% Role = NewRole = #role{}
%% 登录处理
login(Role = #role{guild = #role_guild{gid = 0}}) ->
    inwar_login(Role);
login(Role = #role{guild = #role_guild{gid = GuildId, srv_id = SrvId}}) ->
    NewRole = case util:is_merge() of
        true -> %% 有合服
            case global:whereis_name(?MODULE) of
                Pid when is_pid(Pid) ->
                    case gen_server:call(Pid, {owner_buff}) of
                        Owner when Owner =:= {GuildId, SrvId} andalso Owner =/= undefined ->
                            do_login(true, [buff, honor], Role);
                        _ ->
                            do_login(false, [buff, honor], Role)
                    end;
                _ ->
                    Role
            end;
        _ ->
            Role
    end,
    inwar_login(NewRole);
login(Role) ->
    inwar_login(Role).

do_login(_, [], Role) ->
    Role;
do_login(true, [buff | T], Role) ->
    ?debug_log([add_buff, {}]),
    case buff:add(Role, ?guild_war_winner_buffer) of
        {ok, Nr2} ->
            do_login(true, T, Nr2);
        _ ->
            do_login(true, T, Role)
    end;
do_login(false, [buff | T], Role) ->
    ?debug_log([del_buff, {}]),
    case buff:del_buff_by_label_no_push(Role, ?guild_war_winner_buffer) of
        {ok, Nr1} ->
            do_login(false, T, Nr1);
        _ ->
            do_login(false, T, Role)
    end;
do_login(true, [honor | T], Role = #role{looks = Looks, guild = #role_guild{position = Pos}}) ->
    ?debug_log([add_honor_looks, {}]),
    Glooks = case Pos of
        ?guild_chief ->
            [];
        _ ->
            [{?LOOKS_TYPE_GUILD_WAR_HONOR, 0, ?LOOKS_GUILD_WAR_MEMBER}]
    end,
    NewRole = Role#role{looks = Looks ++ Glooks},
    do_login(true, T, NewRole);
do_login(Type, [_ | T], Role) ->
    do_login(Type, T, Role).

inwar_login(Role = #role{event = ?event_guild_war, id = Rid, pid = Rpid, pos = Pos}) ->
    case global:whereis_name(?MODULE) of
        Pid when is_pid(Pid) ->
            case gen_server:call(Pid, {login, Rid, Rpid}) of
                WarPid when is_pid(WarPid) ->
                    Role#role{event_pid = WarPid};
                _ ->
                    Role#role{event = ?event_no, event_pid = 0, pos = Pos#pos{map = ?enter_point_map, x = ?enter_point_x, y = ?enter_point_y}}
            end;
        _ ->
            Role#role{event = ?event_no, event_pid = 0, pos = Pos#pos{map = ?enter_point_map, x = ?enter_point_x, y = ?enter_point_y}}
    end;
inwar_login(Role) ->
    Role.

%% @spec logout(Role) -> NewRole
%% Role = NewRole = #role{}
%% 掉线处理
logout(Role = #role{event = ?event_guild_war, id = Rid}) ->
    case global:whereis_name(?MODULE) of
        Pid when is_pid(Pid) ->
            Pid ! {logout, Rid};
        _ ->
            ok
    end,
    Role;
logout(Role) ->
    Role.

%% @spec sign_up(Role, Union) -> {ok} | {false, Reason}
%% Pid = pid()
%% Role = #role{}
%% Union = integer()
%% Reason = bitstring()
%% 帮战报名
sign_up(_Role = #role{id = _Rid, guild = #role_guild{authority = Auth, gid = GuildId, srv_id = SrvId}}, Union) ->
    case Auth =:= ?chief_op orelse Auth =:= ?elder_op of
        true ->
            case global:whereis_name(?MODULE) of
                Pid when is_pid(Pid) ->
                    case guild_mgr:lookup(by_id, {GuildId, SrvId}) of
                        Guild = #guild{} ->
                            gen_server:call(Pid, {sign_up, guild_war_util:to_guild_war_guild(Guild, Union)});
                        _ ->
                            {false, ?L(<<"目前状态下，不能完成圣地之争报名">>)}
                    end;
                _ ->
                    {false, ?L(<<"目前状态下，不能完成圣地之争报名">>)}
            end;
        false ->
            ?debug_log([sign_up_noright, _Rid]),
            {false, ?L(<<"只有帮主或者长老才能报名">>)}
    end.

%% @spec sign_up_info() -> {}
%% 报名帮战的帮会
sign_up_info() ->
    gen_server:call({global, ?MODULE}, sign_up_info).

%% @spec owner_info() -> {}
%% 当前守护帮会
owner_info() ->
    gen_server:call({global, ?MODULE}, owner_info).

%% @spec status_changed(Status) 
%% Status = integer()
%% 状态改变
status_changed(Status) ->
    case global:whereis_name(?MODULE) of
        Pid when is_pid(Pid) ->
            Pid ! {status_changed, Status};
        _ ->
            ok
    end.

%% 打印帮战管理进程的信息
info() ->
    case global:whereis_name(?MODULE) of
        Pid when is_pid(Pid) ->
            Pid ! {print_war_info};
        _ ->
            ok
    end.

%% 设置帮战是否为第一次
set_first() ->
    case global:whereis_name(?MODULE) of
        Pid when is_pid(Pid) ->
            Pid ! {set_first};
        _ ->
            ok
    end.

%% --------------------------------------------------------------------
%% gen_server callback functions
%% --------------------------------------------------------------------

%% @spec init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    process_flag(trap_exit, true),
    
    case guild_war_flow:start_link() of
        {ok, _Pid} ->
            ?INFO("启动帮战flow进程成功"),
            ok;
        _Error ->
            ?INFO("启动帮战flow进程失败: ~w", [_Error])
    end,

    LastWar = case catch guild_war_dao:load_last_war() of
        undefined ->
            undefined;
        WarInfo when is_record(WarInfo, guild_war) ->
            WarInfo;
        _Other ->
            ?INFO("读取帮战信息出错:~w", [_Other]),
            undefined
    end,

    {IsFirst, Owner, Guilds} = case guild_war_dao:load_war_mgr() of
        false ->
            {?true, undefined, []};
        {Flag, Ogid, Gids} ->
            {Flag, Ogid, get_guilds(Gids, LastWar)}
    end,

    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, #state{is_first = IsFirst, guilds = Guilds, owner = Owner, last_war_state = LastWar}}.

%% @spec: %% handle_call(Request, From, State) -> {reply, Reply, State} |
%%                                      {reply, Reply, State, Timeout} |
%%                                      {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, Reply, State} |
%%                                      {stop, Reason, State}
%% Description: Handling call messages
%% 启动帮战进程
handle_call({start_war}, _From, State = #state{war_pid = WarPid, guilds = Guilds, is_first = IsFirst, owner = Owner}) ->
    ?DEBUG("~w", [Guilds]),
    case is_pid(WarPid) andalso is_process_alive(WarPid) of
        true ->
            ?ELOG("启动帮战失败： 已启动"),
            {reply, {error, already_started}, State};
        false ->
            case length(Guilds) < 2 of
                true ->
                    case Guilds of
                        [#guild_war_guild{id = Gid}] ->
                            spawn(fun() -> guild:guild_mail(Gid, {?L(<<"圣地之争开启失败通知">>), ?L(<<"很遗憾，本次圣地之争只有贵帮一个帮派报名参加。由于圣地之争会分为白方和红方进行争夺。贵帮只有一个帮会，所以，本次圣地之争开启失败。欢迎贵帮下次继续参加，并可邀请其他符合条件的帮会报名。圣地之争中，表现出色的帮会，有很大机会获得紫色护符和其他宝物哦！">>)}) end);
                        _ ->
                            ok
                    end,
                    {reply, {error, less_guilds}, State};
                false ->
                    case guild_war:start_link(IsFirst, Guilds, Owner) of
                        {ok, Pid} ->
                            {reply, {ok, Pid}, State#state{war_pid = Pid}};
                        Other ->
                            ?ELOG("启动帮战进程失败: ~w", [Other]),
                            {reply, Other, State}
                    end
            end
    end;

%% 获取帮战进程的Pid
handle_call({get_war_pid}, _From, State = #state{war_pid = WarPid}) ->
    {reply, WarPid, State};

%% 帮战报名
handle_call({sign_up, Guild = #guild_war_guild{id = Gid}}, _From, State = #state{guilds = Guilds, owner = Owner, war_pid = WarPid, is_first = IsFirst, last_war_state = Lstate}) ->
    NewGuild = Guild#guild_war_guild{last_credit = get_last_credit(Gid, Lstate)},
    ?debug_log([sign_up, {}]),
    case is_pid(WarPid) andalso is_process_alive(WarPid) of
        true ->
            {reply, {false, ?L(<<"很遗憾，您错过了帮战报名时间">>)}, State};
        false ->
            case do_sign_up(NewGuild, Guilds, IsFirst) of
                {false, Reason} ->
                    {reply, {false, Reason}, State};
                NewGuilds ->
                    guild_war_dao:save_war_mgr(IsFirst, Owner, NewGuilds),
                    {reply, {ok}, State#state{guilds = NewGuilds}}
            end
    end;

%% 报名帮战的帮会
handle_call(sign_up_info, _From, State = #state{guilds = Guilds}) ->
    {reply, Guilds, State};

%% 守护帮会buff, 两场帮战时间之间为守护帮会的成员加buff
handle_call({owner_buff}, _From, State = #state{owner = Owner, war_pid = Wpid}) ->
    Reply = case guild_war_util:check([{is_pid_alive, Wpid}]) of
        ok ->
            undefined;
        _ ->
            Owner
    end,
    {reply, Reply, State};

%% 当前守护帮会
handle_call(owner_info, _From, State = #state{owner = Owner}) ->
    {reply, Owner, State};

%% 玩家上线
handle_call({login, Rid, Pid}, _From, State = #state{offline_roles = Oroles, war_pid = Wpid}) ->
    ?debug_log([login, {Rid, Pid}]),
    case lists:member(Rid, Oroles) of
        true ->
            Reply = case is_pid(Wpid) of
                true ->
                    guild_war:login(Wpid, Rid, Pid),
                    Wpid;
                false ->
                    ?ELOG("玩家~w 在帮战掉线列表中", [Rid]),
                    false
            end,
            {reply, Reply, State#state{offline_roles = lists:delete(Rid, Oroles)}};
        false ->
            {reply, false, State}
    end;

%% 是否为第一次帮战
handle_call(is_first_war, _From, State = #state{is_first = IsFirst}) ->
    {reply, IsFirst, State};

%% 上一场帮战的战况
handle_call({last_war_info, _Type, _Page, _Rid}, _From, State = #state{last_war_state = Lwar}) when Lwar =:= undefined ->
    {reply, {false, ?L(<<"还没有进行过圣地之争，不存在上一场的圣地之争战况">>)}, State};
handle_call({last_war_info, guild, Page, _Rid}, _From, State = #state{last_war_state = #guild_war{guilds = Guilds}}) ->
    GuildList = page(Guilds, Page),
    GuildInfo = [{Name, Croles, Ccombat, Cstone, Ccompete, Csword, Tcredit, Union, Realm} || #guild_war_guild{name = Name, credit_combat = Ccombat, credit_compete = Ccompete, credit_stone = Cstone, credit_sword = Csword, credit = Tcredit, roles_count = Croles, union = Union, realm = Realm} <- GuildList],
    {reply, {length(Guilds), GuildInfo}, State};

handle_call({last_war_info, role, Page, _Rid}, _From, State = #state{last_war_state = #guild_war{roles = Roles}}) ->
    RoleList = page(Roles, Page),
    RoleInfo = [{Name, GuildName, Ccombat, Cstone, Ccompete, Csword, Tcredit, Union, Realm} || #guild_war_role{name = Name, credit = Tcredit, credit_combat = Ccombat, credit_stone = Cstone, credit_compete = Ccompete, credit_sword = Csword, guild_name = GuildName, union = Union, realm = Realm} <- RoleList],
    {reply, {length(Roles), RoleInfo}, State};

handle_call({last_war_info, union, _Page, _Rid}, _From, State = #state{last_war_state = #guild_war{attack_union = AtkUnion, defend_union = DfdUnion}}) ->
    #guild_war_union{guild_count = Gcount, credit_combat = Ccombat, credit_compete = Ccompete, credit = Credit, hold_time = HoldTime, realm = Realm} = DfdUnion,
    #guild_war_union{guild_count = Gcount2, credit_combat = Ccombat2, credit_compete = Ccompete2, credit = Credit2, hold_time = HoldTime2, realm = Realm2} = AtkUnion,
    DfdInfo = {?guild_war_union_defend, Gcount, Ccombat, Ccompete, HoldTime, Credit, Realm},
    AtkInfo = {?guild_war_union_attack, Gcount2, Ccombat2, Ccompete2, HoldTime2, Credit2, Realm2},
    {reply, {2, [DfdInfo, AtkInfo]}, State};

%% 获取指定帮会的所有成员战绩(帮会宝库)
handle_call({last_war_info, guild_member_war_info, _Page, Gid}, _From, State = #state{last_war_state = #guild_war{roles = Roles}}) ->
    Reply = lists:filter(fun(#guild_war_role{guild_id = Gid2}) -> Gid =:= Gid2 end, Roles),
    {reply, Reply, State};

%% 获取指定帮会战绩
handle_call({last_war_info, guild_war_info, _Page, Gid}, _From, State = #state{last_war_state = #guild_war{guilds = Guilds}}) ->
    Reply = lists:keyfind(Gid, #guild_war_guild.id, Guilds),
    {reply, Reply, State};


handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

%% @spec: handle_cast(Msg, State) -> {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, State}
%% Description: Handling cast messages
handle_cast(_Msg, State) ->
    {noreply, State}.

%% @spec: handle_info(Info, State) -> {noreply, State} |
%%                                       {noreply, State, Timeout} |
%%                                       {stop, Reason, State}
%% Description: Handling all non call/cast messages
handle_info({logout, Rid}, State = #state{offline_roles = Oroles, war_pid = WarPid}) ->
    ?debug_log([logout, Rid]),
    case is_pid(WarPid) andalso is_process_alive(WarPid) of
        true ->
            case lists:member(Rid, Oroles) of
                true ->
                    guild_war:logout(WarPid, Rid),
                    {noreply, State};
                false ->
                    guild_war:logout(WarPid, Rid),
                    {noreply, State#state{offline_roles = [Rid | Oroles]}}
            end;
        false ->
            {noreply, State}
    end;

%% 处理状态改变
handle_info({status_changed, ?guild_war_status_sign}, State) ->
    self() ! {send_sign_notice, 4},
    {noreply, State};
handle_info({status_changed, ?guild_war_status_over}, State) ->
    ?debug_log([status_changed, ?guild_war_status_over]),
    {noreply, State};
handle_info({status_changed, _Status}, State) ->
    {noreply, State};

%% 报名提示
handle_info({send_sign_notice, 0}, State) ->
    {noreply, State};
handle_info({send_sign_notice, Count}, State) ->
    notice:send(54, ?L(<<"圣地之争即将开启，各帮帮主请报名参加！">>)),
    erlang:send_after(5 * 60 * 1000, self(), {send_sign_notice, Count - 1}),
    {noreply, State};

%% 设置上场帮战战况
handle_info({set_last_war_info, WarState = #guild_war{winner_guild = Wgid}}, State) ->
    ?debug_log([set_last_war_info, {Wgid}]),
    Guilds = get_guilds([{Wgid, ?guild_war_union_defend}], WarState),
    guild_war_dao:save_war_mgr(?false, Wgid, Guilds),
    guild_war_dao:save_war(WarState),
    {noreply, State#state{last_war_state = WarState, owner = Wgid, guilds = Guilds, offline_roles = [], war_pid = 0, is_first = ?false}};

%% 打印帮战管理进程的信息
handle_info({print_war_info}, State) ->
    ?DEBUG("guild_war_mgr: ~w", [?record_to_list(state, State)]),
    {noreply, State};
handle_info({set_first}, State = #state{is_first = IsFirst}) ->
    First = case IsFirst of
        ?true ->
            ?false;
        ?false ->
            ?true
    end,
    {noreply, State#state{is_first = First, owner = undefined}};

handle_info(_Info, State) ->
    {noreply, State}.

%% @spec: terminate(Reason, State) -> void()
%% Description: This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any necessary
%% cleaning up. When it returns, the gen_server terminates with Reason.
%% The return value is ignored.
terminate(_Reason, _State) ->
    ok.

%% @spec: code_change(OldVsn, State, Extra) -> {ok, NewState}
%% Description: Convert process state when code is changed
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%--------------------------------------------------------------------
%%% Internal functions
%%--------------------------------------------------------------------
%% 根据gid查找帮会
get_guilds(Grids, WarState) ->
    get_guilds(Grids, [], WarState).
get_guilds([], Back, _) ->
    Back;
get_guilds([{undefined, _} | T], Back, WarState) ->
    get_guilds(T, Back, WarState);
get_guilds([{Gid, Union} | T], Back, WarState) ->
    case guild_mgr:lookup(by_id, Gid) of
        false ->
            ?DEBUG("not found: gid = ~w", [Gid]),
            get_guilds(T, Back, WarState);
        Guild = #guild{} ->
            Gguild = guild_war_util:to_guild_war_guild(Guild, Union),
            Gguild2 = case WarState of
                #guild_war{guilds = Guilds} ->
                    case lists:keyfind(Gid, #guild_war_guild.id, Guilds) of
                        #guild_war_guild{credit = Credit} ->
                            Gguild#guild_war_guild{last_credit = Credit};
                        _ ->
                            Gguild
                    end;
                _ ->
                    Gguild
            end,
            get_guilds(T, [Gguild2 | Back], WarState)
    end.

%% 取得已排序列表的页数列表
page(List, Page) ->
    PageSize = 10,
    PageList = case length(List) >= Page * PageSize + 1 of
        true ->
            lists:sublist(List, Page * PageSize + 1, PageSize);
        false ->
            []
    end,
    PageList.

%% 从上一场战况中取得某个帮会的得分
get_last_credit(Gid, #guild_war{guilds = Guilds}) ->
    case lists:keyfind(Gid, #guild_war_guild.id, Guilds) of
        false ->
            0;
        #guild_war_guild{credit = Credit} ->
            Credit
    end;
get_last_credit(_Gid, _Lstate) ->
    0.

%% 帮会报名
do_sign_up(Guild = #guild_war_guild{id = Gid, union = Union}, Guilds, _IsFirst) ->
    case lists:keyfind(Gid, #guild_war_guild.id, Guilds) of
        false -> 
            case do_sign_up_before(Guild) of
                true ->
                    {Title, Content} = case Union of
                    ?guild_war_union_attack ->
                        {?L(<<"圣地之争报名通知">>), ?L(<<"我帮已经报名参加圣地之争，请大家准时回到帮会领地，在“帮战NPC”处可进入圣地！\n 夺取圣地后，会有丰厚的帮会奖励哦！一起努力，打造一个强大的帮会！！！">>)};
                    ?guild_war_union_defend ->
                        {?L(<<"圣地之争报名通知">>), ?L(<<"我们帮已经报名参加圣地之争，请大家准时回到帮会领地，在“帮战NPC”处可进入圣地！\n 夺取圣地后，会有丰厚的帮会奖励哦！一起努力，打造一个强大的帮会！！！">>)}
                    end,
                    spawn(fun() -> guild:guild_mail(Gid, {Title, Content}) end),
                    [Guild | Guilds];
                _ ->
                    {false, ?L(<<"帮会资金不足200">>)}
            end;
        #guild_war_guild{} ->
            {false, ?L(<<"你的帮会已报名">>)}
    end.

do_sign_up_before(#guild_war_guild{pid = Pid}) ->
    guild:guild_loss(Pid, ?guild_war_sign_fund).


