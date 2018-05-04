%% --------------------------------------------------------------------
%% 帮战主进程
%% @author abu@jieyou.cn
%% @end 
%% --------------------------------------------------------------------
-module(guild_war).
-behaviour(gen_server).

%% export functions
-export([
        start_link/3
        ,sign_compete/3
        ,cancel_sign_compete/2
        ,set_war_status/2
        ,enter_prepare_map/2
        ,enter_war_map/2
        ,leave_war/2
        ,login/3
        ,logout/2
        ,combat/2
        ,attend_compete/2
        ,finish_compete/2
        ,push_compete/2
        ,push_small_war_info/2
        ,click_elem/2
        ,disturb/1
        ,credit/3
        ,cast/2
        ,info/0
        ,war_info/4
        ,get_union/1
        ,create_robot/0
    ]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).

%% include file
-include("common.hrl").
-include("guild_war.hrl").
%%
-include("guild.hrl").
-include("role.hrl").
-include("attr.hrl").
-include("map.hrl").
-include("pos.hrl").
-include("looks.hrl").
-include("combat.hrl").
-include("mail.hrl").
-include("team.hrl").

-define(defend_prepare_map, 33001).
-define(attack_prepare_map, 33002).
-define(prepare_map_enter_point, {{1980, 2220}, {2820, 2720}}).
-define(war_map, 33003).
-define(war_map_enter_point_defend, {{5400, 1200}, {6000, 1500}}).
-define(war_map_enter_point_attack, [{540, 5670}, {480, 4950}, {1200, 4530}, {2700, 5280}, {1860, 5820}]).
-define(leave_guild_war_point, {10003, 2832, 1002}).

%% --------------------------------------------------------------------
%% API functions
%% --------------------------------------------------------------------

%% @spec start_link() -> {ok,Pid} | ignore | {error,Error}
%% Starts the server
start_link(IsFirst, Guilds, Owner) ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [IsFirst, Guilds, Owner], []).

%% @spec sign_compete(Pid, Role, TeamNo) -> {ok} | {false, Reason}
%% Pid = pid()
%% Role = #role{}
%% TeamNo = integer()
%% Reason = bitstring()
%% 报名主将赛
sign_compete(_Pid, _Role, TeamNo) when TeamNo > 4 ->
    {ok};
sign_compete(Pid, Role = #role{id = Rid, pid = Rpid, team_pid = Tpid}, TeamNo) when is_pid(Pid) ->
    case guild_war_util:check([{is_pid_alive, Tpid}, {is_leader, Role}]) of
        {false, {is_pid_alive, _}} ->
            {false, ?L(<<"请先组队再报名">>)};
        {false, {is_leader, _}} ->
            {false, ?L(<<"只有队长才可操作">>)};
        ok ->
            Pid ! {sign_compete, Rid, Rpid, Tpid, TeamNo},
            {ok}
    end;
sign_compete(_Pid, _Role, _TeamNo) ->
    {ok}.

%% @spec cancel_sign_compete(Pid, Role) -> {ok} | {false, Reason}
%% Pid = pid()
%% Role = #role{}
%% Reason = bitstring()
%% 取消主将赛的报名
cancel_sign_compete(Pid, Role = #role{id = Rid, pid = Rpid, team_pid = Tpid}) ->
    case guild_war_util:check([{is_pid_alive, Tpid}, {is_leader, Role}]) of
        {false, {is_pid_alive, _}} ->
            {false, ?L(<<"您没有报名参加主将赛">>)};
        {false, {is_leader, _}} ->
            {false, ?L(<<"只有队长才可操作">>)};
        ok ->
            Pid ! {cancel_sign_compete, Rid, Rpid, Tpid},
            {ok}
    end.

%% @spec enter_prepare_map(Pid, Role) 
%% Pid = pid()
%% Role = #role{}
%% 进入准备区
enter_prepare_map(Pid, Role = #role{pid = Rpid}) ->
    case guild_war_util:check([{is_not_follow, Role}, {is_pid_alive, Pid}, {is_not_fly, Role}, {is_not_in_cross, Role}]) of
        ok ->
            role:apply(async, Rpid, {fun apply_role_listener/1, []}),
            Pid ! {enter_prepare_map, guild_war_util:to_guild_war_role(Role)};
        {false, {is_not_fly, _}} ->
            guild_war_util:send_notice(Rpid, ?L(<<"飞行中不能进入圣地之争">>), 2);
        {false, {is_not_in_cross, _}} ->
            guild_war_util:send_notice(Rpid, ?L(<<"跨服场景中不能进入圣地之争">>), 2);
        _ ->
            ok
    end.

apply_role_listener(Role) ->
    NewRole = role_listener:special_event(Role, {30003, 1}), %%活跃度
    {ok, NewRole}.

%% @spec enter_war_map(PId, Role)
%% Pid = pid()
%% Role = #role{}
%% 进入帮战场地
enter_war_map(Pid, Role) ->
    case guild_war_util:check([{is_not_follow, Role}, {is_pid_alive, Pid}]) of
        ok ->
            Pid ! {enter_war_map, guild_war_util:to_guild_war_role(Role)};
        _ ->
            ok
    end.


%% @spec leave_war(Pid, Role)
%% Pid = pid()
%% Role = #role{}
%% 退出帮战
leave_war(Pid, Role) ->
    case guild_war_util:check([{is_not_follow, Role}, {is_pid_alive, Pid}]) of
        ok ->
            Pid ! {leave_war, guild_war_util:to_guild_war_role(Role)};
        _ ->
            ok
    end.

%% @spec login(Pid, Rid) 
%% Pid = pid()
%% 处理登录
login(Pid, Rid, Rpid) ->
    case guild_war_util:check([{is_pid_alive, Pid}]) of
        ok ->
            Pid ! {login, Rid, Rpid};
        _ ->
            ok
    end.

%% @spec logout(Pid, Rid)
%% Pid = pid()
%% 处理退出
logout(Pid, Rid) ->
    case guild_war_util:check([{is_pid_alive, Pid}]) of
        ok ->
            Pid ! {logout, Rid};
        _ ->
            ok
    end.


%% @spec set_war_status(Pid, Status) 
%% Pid = pid()
%% Status = integer()
%% 改变帮战的状态
set_war_status(Pid, Status) ->
    ?debug_log([set_war_status, Status]),
    Pid ! {set_war_status, Status}.

%% @spec combat(Type, Data) -> {ok} | {false, Reason} 
%% Type = atom()
%% Data = term()
%% 帮战中的战斗处理
combat(combat_check, {WarPid, Attacker = #role{event = ?event_guild_war, combat_pid = AtkComPid}, Defender = #role{event = ?event_guild_war, combat_pid = DfdComPid}}) ->
    case is_pid(DfdComPid) andalso is_process_alive(DfdComPid) of
        true ->
            {false, ?L(<<"对方正在战斗中">>)};
        false ->
            case is_pid(AtkComPid) andalso is_process_alive(AtkComPid) of
                true ->
                    {false, ?L(<<"您正在战斗中">>)};
                false ->
                    catch gen_server:call(WarPid, {combat_check, guild_war_util:to_guild_war_role(Attacker), guild_war_util:to_guild_war_role(Defender)})
            end
    end;
combat(combat_robot_check, {WarPid, Rid, NpcFunType}) ->
    case catch gen_server:call(WarPid, {combat_robot_check, Rid, NpcFunType}) of
        {ok} ->
            {ok};
        {false, Reason} ->
            {false, Reason};
        _ ->
            {false, ?L(<<"发起战斗失败">>)}
    end;
combat(combat_check, _) ->
    {false, ?L(<<"发起战斗失败">>)};
combat(combat_start, {WarPid, Fighters}) ->
    ?debug_log([combat_start, Fighters]),
    WarPid ! {combat_start, Fighters};
combat(combat_over, {WarPid, Winner, Loser}) ->
    Fun = fun(#fighter{rid = Wrid, srv_id = WsrvId, is_die = WIsDie, type = ?fighter_type_role}) -> {Wrid, WsrvId, WIsDie};
                (_) -> {0, <<"">>, 0}
        end,
    WarPid ! {combat_over, lists:map(Fun, Winner), lists:map(Fun, Loser)},
    {ok};
combat(_, _) ->
    {false, ?L(<<"发起战斗失败">>)}. 

%% @spec attend_compete(Pid, Rids)
%% 参加主将赛
attend_compete(Pid, Rids) when is_pid(Pid) ->
    Pid ! {attend_compete, Rids};
attend_compete(_, _) ->
    ok.

%% @spec finish_compete(Pid, Rids)
%% 结束主将赛
finish_compete(Pid, Rids) when is_pid(Pid) ->
    Pid ! {finish_compete, Rids};
finish_compete(_, _) ->
    ok.

%% @spec push_compete(Pid, Rid)
%% 推送主将赛面板
push_compete(Pid, Rid) when is_pid(Pid) ->
    Pid ! {push_compete, Rid};
push_compete(_, _) ->
    ok.

%% 推送战况小面板
push_small_war_info(Pid, Rid) when is_pid(Pid) ->
    Pid ! {push_small_war_info, Rid};
push_small_war_info(_, _) ->
    ok.

%% @spec click_elem(Role, MapElem) ->
%% Role = #role{}
%% MapElem = #map_elem{}
%% 点击帮战地图里的帮战元素
click_elem(Role = #role{guild = #role_guild{position = Pos}}, #map_elem{id = 60226}) ->
    case Pos =:= ?guild_chief of
        true ->
            ?MODULE ! {click_elem, guild_war_util:to_guild_war_role(Role), 60226},
            ok;
        false ->
            {false, ?L(<<"只有帮主才可以取封印神剑">>)}
    end;

click_elem(Role = #role{event_pid = Epid}, #map_elem{id = Id}) ->
    case guild_war_util:check([{is_not_follow, Role}, {is_pid_alive, Epid}]) of
        ok ->
            ?MODULE ! {click_elem, guild_war_util:to_guild_war_role(Role), Id};
        _ ->
            ok
    end.

%% @spec disturb(Role) 
%% Pid = pid()
%% Role = #role{}
%% 打断 破坏晶石
disturb(_Role = #role{looks = Looks, id = Rid, event = ?event_guild_war, event_pid = Epid}) ->
    case guild_war_util:check([{is_pid_alive, Epid}]) of
        ok ->
            case lists:keyfind(?LOOKS_TYPE_GUILD_WAR, 1, Looks) of
                false ->
                    ok;
                _ ->
                    Epid ! {disturb, Rid}
            end;
        _ ->
            ok
    end;
disturb(_) ->
    ok.

%% @spec credit(Pid, Rid, Msg)
%% Rid = rid()
%% Pid = pid()
%% Msg = term()
%% 计算积分
credit(Pid, Rid, Msg) ->
    Pid ! {credit, Rid, Msg}.

%% @spec cast(Pid, Msg) ->
%% Pid = pid()
%% Msg = bitstring() | {bitstring(), bitstring()}
%% 向帮战中的用户广播消息
cast(Pid, Msg) when is_pid(Pid) ->
    Pid ! {cast, Msg};
cast(_Pid, _Msg) ->
    ok.

%% @spec print_war_info()
%% 输出参战的信息
info() ->
    ?MODULE ! {print_war_info}.

%% @spec war_info(Epid, Type, Page, Rid) ->
%% Epid = pid()
%% Type = role | guild | union
%% Page = integer()
%% rid = rid()
%% 帮战战况
war_info(Epid, Type, Page, Rid) ->
    case guild_war_util:check([{is_pid_alive, Epid}]) of
        ok ->
            catch gen_server:call(Epid, {war_info, Type, Page, Rid});
        {false, _} ->
            {false, ?L(<<"您不在圣地之争中，不能查看当前圣地之争战况">>)}
    end.

%% 取得玩家 当前是进攻还是防守
get_union(#role{id = Rid, pid = Pid, event_pid = Epid}) ->
    case guild_war_util:check([{is_pid_alive, Epid}]) of
        ok ->
            Epid ! {get_union, Rid, Pid};
        _ ->
            ok
    end.

%% 产生机器人
create_robot() ->
    ?MODULE ! {create_robot}.

%% --------------------------------------------------------------------
%% gen_server callback functions
%% --------------------------------------------------------------------

%% @spec init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
init([IsFirst, Guilds, Owner]) ->
    ?debug_log([guild_war_start, {}]),
    process_flag(trap_exit, true),
    {ok, #guild_war{status = ?guild_war_status_sign, guilds = Guilds, is_first = IsFirst, owner = Owner}}.

%% @spec: handle_call(Request, From, State) -> {reply, Reply, State} |
%%                                      {reply, Reply, State, Timeout} |
%%                                      {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, Reply, State} |
%%                                      {stop, Reason, State}
%% Description: Handling call messages
%% 帮战报名
handle_call(Request, From, State) ->
    case catch do_handle_call(Request, From, State) of 
        {reply, R1, Ns1} ->
            {reply, R1, Ns1};
        {reply, R2, Ns2, T2} ->
            {reply, R2, Ns2, T2};
        {noreply, Ns3} ->
            {noreply, Ns3};
        {noreply, Ns4, T4} ->
            {noreply, Ns4, T4};
        {stop, Reason5, R5, Ns5} ->
            {stop, Reason5, R5, Ns5};
        {stop, Reason6, Ns6} ->
            {stop, Reason6, Ns6};
        _Error ->
            ?ERR("guild_war handle_call出错: ~w", [_Error]),
            {reply, ok, State}
    end.

%% 发起战斗检查
do_handle_call({combat_check, _, _}, _From, State = #guild_war{status = ?guild_war_status_round_over}) ->
    {reply, {false, ?L(<<"当前攻守回合已结束，请等攻守互换后再发起战斗">>)}, State};
do_handle_call({combat_check, #guild_war_role{id = AtkRid}, #guild_war_role{id = DfdRid}}, _From, State = #guild_war{roles = Roles}) ->
    AtkUnion = case lists:keyfind(AtkRid, #guild_war_role.id, Roles) of 
        false ->
            0;
        #guild_war_role{union = U1} ->
            U1
    end,
    DfdUnion = case lists:keyfind(DfdRid, #guild_war_role.id, Roles) of
        false ->
            0;
        #guild_war_role{union = U2} ->
            U2
    end,
    case AtkUnion =:= DfdUnion of
        true ->
            {reply, {false, ?L(<<"相同联盟不能发起战斗">>)}, State};
        false ->
            {reply, {ok}, State}
    end;
do_handle_call({combat_robot_check, Rid, _FunType}, _From, State = #guild_war{roles = Roles}) ->
    Reply = case lists:keyfind(Rid, #guild_war_role.id, Roles) of
        #guild_war_role{union = ?guild_war_union_defend} ->
            {ok};
        #guild_war_role{} ->
            {false, ?L(<<"相同联盟不能发起战斗">>)};
        _ ->
            {false, ?L(<<"发起战斗失败">>)}
    end,
    {reply, Reply, State};
do_handle_call({sign_up, _, _}, _From, State) ->
    {reply, {false, ?L(<<"目前状态下，不能完成圣地之争报名">>)}, State};

%% 帮战战况
do_handle_call({war_info, guild, Page, _Rid}, _From, State = #guild_war{guilds = Guilds}) ->
    GuildList = page(Guilds, Page),
    GuildInfo = [{Name, Croles, Ccombat, Cstone, Ccompete, Csword, Tcredit, Union, Realm} || #guild_war_guild{name = Name, credit_combat = Ccombat, credit_compete = Ccompete, credit_stone = Cstone, credit_sword = Csword, credit = Tcredit, roles_count = Croles, union = Union, realm = Realm} <- GuildList],
    {reply, {length(Guilds), GuildInfo}, State};

do_handle_call({war_info, role, Page, _Rid}, _From, State = #guild_war{roles = Roles}) ->
    RoleList = page(Roles, Page),
    RoleInfo = [{Name, GuildName, Ccombat, Cstone, Ccompete, Csword, Tcredit, Union, Realm} || #guild_war_role{name = Name, credit = Tcredit, credit_combat = Ccombat, credit_stone = Cstone, credit_compete = Ccompete, credit_sword = Csword, guild_name = GuildName, union = Union, realm = Realm} <- RoleList],
    {reply, {length(Roles), RoleInfo}, State};

do_handle_call({war_info, union, _Page, _Rid}, _From, State = #guild_war{attack_union = AtkUnion, defend_union = DfdUnion}) ->
    #guild_war_union{guild_count = Gcount, credit_combat = Ccombat, credit_compete = Ccompete, credit = Credit, hold_time = HoldTime, realm = Realm} = DfdUnion,
    #guild_war_union{guild_count = Gcount2, credit_combat = Ccombat2, credit_compete = Ccompete2, credit = Credit2, hold_time = HoldTime2, realm = Realm2} = AtkUnion,
    DfdInfo = {?guild_war_union_defend, Gcount, Ccombat, Ccompete, HoldTime, Credit, Realm},
    AtkInfo = {?guild_war_union_attack, Gcount2, Ccombat2, Ccompete2, HoldTime2, Credit2, Realm2},
    {reply, {2, [DfdInfo, AtkInfo]}, State};

do_handle_call(_Request, _From, State) ->
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
%% 设置帮战的状态
handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, Ns} ->
            {noreply, Ns};
        {noreply, Ns2, Timeout} ->
            {noreply, Ns2, Timeout};
        {stop, Reason, Ns3} ->
            ?debug_log([stop, Reason]),
            {stop, Reason, Ns3};
        _Error ->
            ?ERR("guild_war进程错误: ~w", [_Error]),
            {noreply, State}
    end.
do_handle_info({set_war_status, ?guild_war_status_prepare}, State = #guild_war{status = ?guild_war_status_sign, guilds = Guilds, owner = Owner, attack_union = AtkUnion, defend_union = DfdUnion}) ->
    push_enter(Guilds),
    NewState = start_maps(State),
    guild_war_npc:start_link(NewState),
    notice:send(54, ?L(<<"圣地之争正式开启，请报名的帮会，迅速进入圣地,参与圣地争夺战！">>)),
    Cpid = case guild_war_compete:start_link(self()) of
        {ok, Pid} ->
            Pid;
        _ ->
            0
    end,
    OwnCount = guild_war_dao:get_own_count(Owner),
    ?debug_log([own_count, OwnCount]),
    NewGuilds = case util:is_merge() of
        false ->
            do_group(Owner, OwnCount, Guilds);   %% 分组
            %do_group_realm(Owner, Guilds);     %% using for test
        _ ->
            do_group_realm(Owner, Guilds)
    end,
    DfdRealm = get_defend_realm(Owner, Guilds),
    AtkRealm = get_attack_realm(DfdRealm),
    do_guild_forbidden(unable, NewGuilds),
    open_process(fun () -> guild_war_util:handle_buff(del, Owner) end), %% 去掉帮战buff
    {AtkGuildsCount, DfdGuildsCount} = get_atk_dfd_guild(NewGuilds),
    {noreply, NewState#guild_war{status = ?guild_war_status_prepare, guilds = NewGuilds, attack_union = AtkUnion#guild_war_union{guild_count = AtkGuildsCount, realm = AtkRealm}, defend_union = DfdUnion#guild_war_union{guild_count = DfdGuildsCount, realm = DfdRealm}, compete_pid = Cpid}};
do_handle_info({set_war_status, ?guild_war_status_war1}, State = #guild_war{start_time = Stime}) ->
    NewState = init_guild_war(State),
    cast_notice(war1, NewState),
    %guild_war_npc:create_npc(State),
    NewStime = case Stime of
        undefined ->
            erlang:send_after(30000, self(), calc_credit),
            erlang:send_after(60000, self(), sort_credit),
            util:unixtime();
        _ ->
            Stime
    end,
    {noreply, NewState#guild_war{status = ?guild_war_status_war1, start_time = NewStime, compete_teams = []}};
do_handle_info({set_war_status, ?guild_war_status_war2}, State) ->
    cast_notice(war2, State),
    %guild_war_npc:clear_npc(),
    {noreply, State#guild_war{status = ?guild_war_status_war2}};
do_handle_info({set_war_status, ?guild_war_status_round_over}, State = #guild_war{roles = Roles}) ->
    NewState = calc_round_over(State), 
    InwarRoles = guild_war_util:select_roles([in_war, not_in_compete], Roles, NewState),
    open_process(fun () -> do_round_combat_over(InwarRoles) end),
    erlang:send_after(1000, self(), {interchange}),
    cast_notice(roundover, NewState),
    {noreply, NewState#guild_war{status = ?guild_war_status_round_over}};
do_handle_info({set_war_status, ?guild_war_status_over}, State = #guild_war{roles = Roles, guilds = Guilds}) ->
    InwarRoles = guild_war_util:select_roles([in_war], Roles, State),
    open_process(fun () -> do_round_combat_over(InwarRoles) end),
    lists:foreach(fun(#guild_war_role{pid = Rpid}) -> role:apply(async, Rpid, {fun apply_do_leave/2, [?leave_guild_war_point]}) end, InwarRoles),
    NewState = calc_round_over(State),
    NewState2 = #guild_war{roles = NewRoles} = calc_over(NewState),
    open_process(fun () -> do_rewards(NewState2) end),
    open_process(fun() -> campaign_listener:handle(guild_war_rank, NewRoles, 1)  end),  %% 活动触发
    guild_war_mgr:set_last_war_info(NewState2),
    cast_notice(over, NewState2),
    do_guild_forbidden(able, Guilds),
    erlang:send_after(1000, self(), {stop}),
    {noreply, NewState2#guild_war{status = ?guild_war_status_over}};
do_handle_info({set_war_status, _Status}, State = #guild_war{status = _S}) ->
    ?debug_log([set_war_status_not_handle, {_S, _Status}]),
    {noreply, State};

%% 回合结束，攻守互换
do_handle_info({interchange}, State = #guild_war{status = ?guild_war_status_round_over, roles = Roles}) ->
    InwarRoles = guild_war_util:select_roles([in_war, not_in_compete], Roles, State),
    do_enter_map(prepare, InwarRoles, State),
    {noreply, State};

%% 结束帮战进程
do_handle_info({stop}, State = #guild_war{status = ?guild_war_status_over}) ->
    guild_war_util:handle_buff(add, State#guild_war.winner_guild), %% 添加帮战buff
    handle_honor(State#guild_war.owner, State#guild_war.winner_guild), %% 处理帮战称号
    {stop, normal, State};

%%报名主将赛
do_handle_info({sign_compete, Rid, Rpid, Tpid, TeamNo}, State = #guild_war{roles = Roles, compete_pid = Cpid, status = ?guild_war_status_prepare}) ->
    case lists:keyfind(Rid, #guild_war_role.id, Roles) of
        false ->
            guild_war_util:send_notice(Rpid, ?L(<<"您的队伍不能报名">>), 2),
            {noreply, State};
        #guild_war_role{union = Union} ->
            guild_war_compete:sign(Cpid, Union, TeamNo, Tpid, Rpid),
            {noreply, State}
    end;
do_handle_info({sign_compete, _, Rpid, _, _}, State) ->
    guild_war_util:send_notice(Rpid, ?L(<<"您的队伍不能报名">>), 2),
    {noreply, State};

%% 取消报名主将赛
do_handle_info({cancel_sign_compete, _Rid, Rpid, Tpid}, State = #guild_war{status = ?guild_war_status_prepare, compete_pid = Cpid}) ->
    guild_war_compete:cancel(Cpid, Tpid, Rpid),
    {noreply, State};
do_handle_info({cancel_sign_compete, _, _, _}, State) ->
    {noreply, State};

%% 进入准备区
do_handle_info({enter_prepare_map, #guild_war_role{pid = Pid}}, State = #guild_war{status = Status})when Status =:= ?guild_war_status_sign ->
    ?debug_log([enter_prepare_map_false, {Status}]),
    guild_war_util:send_notice(Pid, ?L(<<"圣地之争还没有开始">>), 2),
    {noreply, State};
do_handle_info({enter_prepare_map, #guild_war_role{id = Id, pid = Rpid}}, State = #guild_war{}) ->
    ?debug_log([enter_prepare_map, Id]),
    Roles = guild_war_util:get_team_roles(by_id, Id, 0),
    case do_enter_war_check(Roles, State) of
        {false, Reason} ->
            guild_war_util:send_notice(Rpid, Reason, 2),
            {noreply, State};
        {ok} ->
            NewState = do_enter_war(guild_war_util:get_team_roles(by_id, Id, 0), State),
            {noreply, NewState}
    end;
do_handle_info({enter_prepare_map, _}, State = #guild_war{status = _Status}) ->
    ?debug_log([enter_prepare_map_false, {_Status}]),
    {noreply, State};

%% 进入战区
do_handle_info({enter_war_map, Grole = #guild_war_role{pid = Pid, id = Rid}}, State = #guild_war{status = Status, dead_roles = Droles}) when Status =:= ?guild_war_status_war1 orelse Status =:= ?guild_war_status_war2 ->
    ?debug_log([enter_war_map, {}]),
    NewState = case lists:keyfind(Rid, 1, Droles) of
        {Rid, Dt} ->
            case util:unixtime() - Dt >= 15 of
                true ->
                    do_with_team2(Grole, State, fun do_enter_war_map/3);
                false ->
                    guild_war_util:send_notice(Pid, ?L(<<"被击杀后，需要等待15秒才能进入正式区">>), 2),
                    State
            end;
        _ ->
            do_with_team2(Grole, State, fun do_enter_war_map/3)
    end,
    {noreply, NewState};
do_handle_info({enter_war_map, #guild_war_role{pid = Rpid}}, State) ->
    guild_war_util:send_notice(Rpid, ?L(<<"还没有到帮战战斗时间">>), 2),
    {noreply, State};

%% 退出帮战
do_handle_info({leave_war, Grole}, State) ->
    ?debug_log([leave_war, {}]),
    NewState = do_with_team(Grole, State, fun do_leave/2),
    {noreply, NewState};

%% 在帮战中上线
do_handle_info({login, Rid, Pid}, State = #guild_war{roles = Roles}) ->
    ?debug_log([login, Rid]),
    NewRoles = case lists:keyfind(Rid, #guild_war_role.id, Roles) of
        false ->
            ?ERR("在帮战中玩家上线，而~w 不存在帮战中", [Rid]),
            Roles;
        GuildRole = #guild_war_role{union = Union} ->
            role:apply(async, Pid, {fun apply_do_enter/2, [Union]}),
            lists:keyreplace(Rid, #guild_war_role.id, Roles, GuildRole#guild_war_role{is_inwar = ?true, is_online = ?true, pid = Pid})
    end,
    {noreply, State#guild_war{roles = NewRoles}};

%% 在帮战中掉线
do_handle_info({logout, Rid}, State = #guild_war{roles = Roles, elem_pid = ElemPid}) ->
    ?debug_log([logout, Rid]),
    NewRoles = case lists:keyfind(Rid, #guild_war_role.id, Roles) of
        false ->
            ?ERR("在帮战中玩家掉线，而 ~w 不存在帮战中", [Rid]),
            Roles;
        GuildRole ->
            case guild_war_util:check([{is_pid_alive, ElemPid}]) of
                ok ->
                    guild_war_elem:disturb(ElemPid, [GuildRole]);
                _ ->
                    ok
            end,
            lists:keyreplace(Rid, #guild_war_role.id, Roles, GuildRole#guild_war_role{is_online = ?false, is_inwar = ?false})
    end,
    {noreply, State#guild_war{roles = NewRoles}};

%% 战斗发起后处理
do_handle_info({combat_start, Fighters}, State = #guild_war{elem_pid = Epid}) ->
    case is_pid(Epid) andalso is_process_alive(Epid) of
        true ->
            guild_war_elem:disturb(Epid, to_guild_war_role(Fighters, State)),
            {noreply, State};
        false ->
            {noreply, State}
    end;

%% 战斗结束处理
do_handle_info({combat_over, Wrids, Lrids}, State = #guild_war{status = Status}) when Status =:= ?guild_war_status_war1 orelse Status =:= ?guild_war_status_war2 ->
    ?debug_log([combat_over, {Wrids, Lrids}]),
    NewState = do_combat_over(win, Wrids, Lrids, State),
    NewState2 = do_combat_over(lose, Lrids, Wrids, NewState),
    Union = get_combat_union(Wrids, State),
    NewState3 = guild_war_credit:credit(combat_win_union, {Union, length(Lrids)}, NewState2),
    {noreply, NewState3};

%% 参加主将赛
do_handle_info({attend_compete, Rids}, State) ->
    NewState = do_attend_compete(?true, Rids, State),
    {noreply, NewState};
do_handle_info({finish_compete, Rids}, State) ->
    NewState = do_attend_compete(?false, Rids, State),
    {noreply, NewState};

%% 推送主将赛面板
do_handle_info({push_compete, Rid}, State = #guild_war{compete_pid = ComPid, roles = Roles}) ->
    case guild_war_util:check([{is_pid_alive, ComPid}]) of
        ok ->
            case lists:keyfind(Rid, #guild_war_role.id, Roles) of
                #guild_war_role{pid = Rpid, union = Union} ->
                    guild_war_compete:push_compete(ComPid, Rpid, Union);
                _ ->
                    ok
            end;
        _ ->
            ok
    end,
    {noreply, State};

%% 推送战况小面板
do_handle_info({push_small_war_info, Rid}, State = #guild_war{roles = Roles}) ->
    case lists:keyfind(Rid, #guild_war_role.id, Roles) of
        Grole = #guild_war_role{} ->
            push_union_info([Grole], State);
        _ ->
            ok
    end,
    {noreply, State};

%% 点击帮战元素
do_handle_info({click_elem, GuildRole = #guild_war_role{pid = Rpid}, _MapElemId = 60226}, State = #guild_war{status = Status}) when Status =/= ?guild_war_status_war2 ->
    ?debug_log([click_elem_invalid, {60226, Status}]),
    case is_attacker(GuildRole, State) of
        true ->
            guild_war_util:send_notice(Rpid, ?L(<<"请先破坏三个封印仙石，才能夺取封印神剑。">>), 2);
        false ->
            guild_war_util:send_notice(Rpid, ?L(<<"您是圣地守护方，请阻止敌方破坏">>), 2)
    end,
    {noreply, State};

do_handle_info({click_elem, #guild_war_role{}, _MapElemId}, State = #guild_war{status = Status}) when Status =/= ?guild_war_status_war2 andalso Status =/= ?guild_war_status_war1 ->
    ?debug_log([click_elem_invalid, {_MapElemId, Status}]),
    {noreply, State};

do_handle_info({click_elem, GuildRole = #guild_war_role{pid = Rpid}, MapElemId}, State = #guild_war{elem_pid = Epid}) ->
    ?debug_log([click_elem, MapElemId]),
    case is_attacker(GuildRole, State) of
        true ->
            guild_war_elem:click(Epid, GuildRole, MapElemId);
        false ->
            ?debug_log([click_elem, not_a_attacker]),
            guild_war_util:send_notice(Rpid, ?L(<<"您是圣地守护方，请阻止敌方破坏">>), 2)
    end,
    {noreply, State};

%% 打断破坏晶石行为
do_handle_info({disturb, Rid}, State = #guild_war{elem_pid = Epid, roles = Roles}) ->
    case lists:keyfind(Rid, #guild_war_role.id, Roles) of
        false ->
            ok;
        Grole ->
            guild_war_elem:disturb(Epid, Grole)
    end,
    {noreply, State};

%% 计算积分
do_handle_info({credit, Rid, Msg}, State) ->
    ?debug_log([credit, {Rid, Msg}]),
    {noreply, guild_war_credit:credit(Msg, Rid, State)};

%% 获取联盟方
do_handle_info({get_union, Rid, Pid}, State) ->
    case is_attacker(Rid, State) of
        false ->
            guild_war_rpc:push(Pid, get_union, {?guild_war_union_defend}),
            {noreply, State};
        true ->
            guild_war_rpc:push(Pid, get_union, {?guild_war_union_attack}),
            {noreply, State}
    end;

%% 计算和推送联盟积分
do_handle_info(calc_credit, State) ->
    erlang:send_after(30000, self(), calc_credit),
    NewState = calc_union_credit(State),
    push_union_info(NewState),
    {noreply, NewState};

%% 积分定时排序
do_handle_info(sort_credit, State = #guild_war{roles = Roles, guilds = Guilds}) ->
    erlang:send_after(60000, self(), sort_credit),
    NewRoles = lists:sort(fun sort_role/2, Roles),
    NewGuilds = lists:sort(fun sort_guild/2, Guilds),
    {noreply, State#guild_war{roles = NewRoles, guilds = NewGuilds}};

%% 广播消息
do_handle_info({cast, Msg}, State) ->
    cast_msg(Msg, State),
    {noreply, State};

%% 产生机器人
do_handle_info({create_robot}, State = #guild_war{status = ?guild_war_status_war1}) ->
    guild_war_npc:create_npc(State),
    {noreply, State};

%% 打印帮战信息
do_handle_info({print_war_info}, State = #guild_war{guilds = _Guilds, status = _Status, roles = _Roles, compete_teams = _Cteams, attack_union = _AtkUnion, defend_union = _DfdUnion, is_first = _IsFirst, owner = _Owner}) ->
    ?DEBUG("attack_union: ~w", [?record_to_list(guild_war_union, _AtkUnion)]),
    ?DEBUG("defend_union: ~w", [?record_to_list(guild_war_union, _DfdUnion)]),
    [?DEBUG("guild: ~w", [?record_to_list(guild_war_guild, _Guild)]) || _Guild <- _Guilds],
    [?DEBUG("role: ~w", [?record_to_list(guild_war_role, _Role)]) || _Role <- _Roles],
    ?debug_log([is_first, _IsFirst]),
    ?debug_log([owner, _Owner]),
    ?debug_log([compete_teams, _Cteams]),
    ?debug_log([status, _Status]),
    {noreply, State};

do_handle_info(_Info, State = #guild_war{status = _Status}) ->
    ?DEBUG("收到无效消息 status = ~w, msg = ~w", [_Status, _Info]),
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
to_guild_war_role(Rids, State) ->
    to_guild_war_role(Rids, State, []).
to_guild_war_role([], _State, Back) ->
    Back;
to_guild_war_role([H | T], State = #guild_war{roles = Roles}, Back) ->
    case lists:keyfind(H, #guild_war_role.id, Roles) of
        false ->
            to_guild_war_role(T, State, Back);
        Grole ->
            to_guild_war_role(T, State, [Grole | Back])
    end.

%% 启动地图
start_maps(State) ->
    DenPreMap = case map_mgr:create(?defend_prepare_map) of 
        {ok, Pid, Mid} ->
            {Pid, Mid};
        _ ->
            ?ERR("启动防守方准备区失败：map_base_id = ~w", [?defend_prepare_map]),
            {0, 0}
    end,
    AttPreMap = case map_mgr:create(?attack_prepare_map) of
        {ok, Pid2, Mid2} ->
            {Pid2, Mid2};
        _ ->
            ?ERR("启动进攻方准备区失败：map_base_id = ~w", [?attack_prepare_map]),
            {0, 0}
    end,
    WarMap = case map_mgr:create(?war_map) of
        {ok, Pid3, Mid3} ->
            {Pid3, Mid3};
        _ ->
            ?ERR("启动帮战地图失败：map_base_id = ~w", [?war_map]),
            {0, 0}
    end,
    State#guild_war{attack_prepare_map = AttPreMap, defend_prepare_map = DenPreMap, war_map = WarMap}.

%% 初始化帮战地图
init_guild_war(State = #guild_war{elem_pid = Epid, war_map = Wmap}) ->
    case is_pid(Epid) andalso is_process_alive(Epid) of
        true ->
            guild_war_elem:refresh(Epid),
            State;
        false ->
            case guild_war_elem:start_link(Wmap, self()) of
                {ok, Pid} ->
                    State#guild_war{elem_pid = Pid};
                _Other ->
                    ?ERR("启动帮战元素进程失败：~w", [_Other]),
                    State
            end
    end.

%% 回合结束后的处理
calc_round_over(State = #guild_war{status = Status, opp_flag = OppFlag}) when Status =:= ?guild_war_status_war1 orelse Status =:= ?guild_war_status_war2 ->
    NewOf = (OppFlag + 1) rem 2,
    NewState = calc_union_credit(State),
    NewState#guild_war{opp_flag = NewOf};
calc_round_over(State) ->
    State.

%% 计算联盟积分
calc_union_credit(State = #guild_war{opp_flag = OppFlag, start_time = Stime, attack_union = AtkUnion, defend_union = DfdUnion}) ->
    Now = util:unixtime(),
    T = Now - Stime,
    {NewAtkUnion, NewDfdUnion} = case OppFlag of 
        ?false ->
            {do_calc_union_credit(0, AtkUnion), do_calc_union_credit(T, DfdUnion)};
        ?true ->
            {do_calc_union_credit(T, AtkUnion), do_calc_union_credit(0, DfdUnion)}
    end,
    State#guild_war{start_time = Now, attack_union = NewAtkUnion, defend_union = NewDfdUnion};
calc_union_credit(State) ->
    State.
do_calc_union_credit(T, Gunion = #guild_war_union{hold_time = Htime, credit_combat = Ccombat, credit_compete = Ccompete}) ->
    NewHt = Htime + T,
    NewC = NewHt * ?guild_war_credit_hold + Ccombat * ?guild_war_credit_combat_union + Ccompete,
    Gunion#guild_war_union{hold_time = NewHt, credit = NewC}.

%% 推送联盟战况
push_union_info(State = #guild_war{roles = Roles}) ->
    push_union_info(Roles, State).
push_union_info(Roles, #guild_war{defend_union = #guild_war_union{hold_time = DfdTime, credit_combat = DfdCombat, credit = DfdCredit}, attack_union = #guild_war_union{hold_time = AtkTime, credit_combat = AtkCombat, credit = AtkCredit}}) ->
    UnionList = [{?guild_war_union_defend, util:floor(DfdCombat/?guild_war_credit_combat_union), DfdTime, DfdCredit}, {?guild_war_union_attack, util:floor(AtkCombat/?guild_war_credit_combat_union), AtkTime, AtkCredit}],
    do_push_union_info(Roles, UnionList).

do_push_union_info([], _) ->
    ok;
do_push_union_info([#guild_war_role{is_inwar = ?true, pid = Rpid, credit = Credit, credit_combat = Ccombat} | T], UnionList) ->
    {ok, Msg} = proto_146:pack(srv, 14624, {Credit, util:floor(Ccombat/?guild_war_credit_combat), UnionList}),
    Rpid ! {socket_proxy, Msg},
    do_push_union_info(T, UnionList);
do_push_union_info([_ | T], UnionList) ->
    do_push_union_info(T, UnionList).

%% 帮战结束处理
calc_over(State = #guild_war{attack_union = #guild_war_union{credit = AtkCredit}, defend_union = #guild_war_union{credit = DfdCredit}, roles = Roles, guilds = Guilds}) ->
    WinnerUnion = case DfdCredit >= AtkCredit of
        true ->
            ?guild_war_union_defend;
        _ ->
            ?guild_war_union_attack
    end,
    NewRoles = lists:sort(fun sort_role/2, Roles),
    NewGuilds = lists:sort(fun sort_guild/2, Guilds),
    Gid = get_top_guild(WinnerUnion, NewGuilds),
    ?debug_log([calc_over, {WinnerUnion, Gid}]),
    State#guild_war{winner_union = WinnerUnion, winner_guild = Gid, roles = NewRoles, guilds = NewGuilds}.

%% 处理奖励
do_rewards(State = #guild_war{winner_union = Wunion, winner_guild = Wgid, roles = Roles, guilds = Guilds}) ->
    Lunion = case Wunion of
        ?guild_war_union_defend ->
            ?guild_war_union_attack;
        _ ->
            ?guild_war_union_defend
    end,
    Lgid = get_top_guild(Lunion, Guilds),
    do_rewards_guild(true, Wgid, ?guild_war_reward_winGuild),
    do_rewards_guild(false, Lgid, ?guild_war_reward_lostGuild),
    do_rewards_honor(Wgid),
    do_rewards_role(Roles, State, 1, 0),
    campaign_listener:handle(guild_war_rank, Roles, 1),
    ok.

do_rewards_guild(WorL, {GuildId, SrvId}, ItemInfos) ->
    guild_treasure:add({GuildId, SrvId}, ?guild_treasure_war, ItemInfos),
    Msg = case WorL of
        true ->
            ?L(<<"恭喜你们联盟获得胜利，您的帮会在本次圣地之争中脱颖而出，成为本次圣地的守护帮会！奖励已经发送到帮会宝库，请帮主及时分配。">>);
        false ->
            ?L(<<"很遗憾，你们的联盟没有获得本次圣地之争的胜利。但您方作为失利联盟中积分最高的帮会，获得了相应奖励，奖励已经发送到帮会宝库，请帮主及时分配。">>)
    end,
    guild:guild_chat({GuildId, SrvId}, Msg),
    ok;
do_rewards_guild(_, _, _) ->
    ok.

do_rewards_role([], _, _, _) ->
    ok;
do_rewards_role([#guild_war_role{union = Union, id = Id, credit = Credit, lev = Lev} | T], State = #guild_war{winner_union = Wunion}, Rank, LastCredit) when Credit =/= 0 ->
    Exp = util:ceil(math:pow(Credit, 0.5) * 15 * math:pow(Lev, 1.5)),
    %Psychic = util:ceil(Exp/2),
    GuildDevote = util:ceil(Credit/5),
    {Title, Content, AssetInfo, ItemInfo} = case Union =:= Wunion of
        true ->
            {?L(<<"圣地之争胜方奖励">>), util:fbin(?L(<<"恭喜你们联盟成为本次圣地之争的胜方。获得本次圣地之争的胜方奖励！且你在本次圣地之争中表现突出。共获得:\n 帮战积分：~w  帮贡：~w\n 经验：~w">>), [Credit, GuildDevote, Exp]), [{?mail_exp, Exp}, {?mail_guild_war, Credit}, {?mail_guild_devote, GuildDevote}, {?mail_activity, 30}], ?guild_war_reward_winRole};
        false ->
            {?L(<<"圣地之争参与奖励">>), util:fbin(?L(<<"很遗憾，你们联盟没有在本次圣地之争中取得胜利。获得本次圣地之争的参与奖励！共获得:\n 帮战积分：~w  帮贡：~w \n 经验：~w">>), [Credit, GuildDevote, Exp]), [{?mail_exp, Exp}, {?mail_guild_war, Credit}, {?mail_guild_devote, GuildDevote}, {?mail_activity, 30}], ?guild_war_reward_lostRole}
    end,
    Items = make_rewards_items(ItemInfo),
    mail:send_system(Id, {Title, Content, AssetInfo, Items}),
    case Credit =:= LastCredit of
        true ->
            do_rewards_role(T, State, Rank, Credit);
        false ->
            do_rewards_role(T, State, Rank + 1, Credit)
    end;
do_rewards_role([_ | T], State, Rank, _) ->
    do_rewards_role(T, State, Rank + 1, 0).

do_rewards_honor(Gid) ->
    case guild_mgr:lookup(by_id, Gid) of
        #guild{members = Members} ->
            case guild_war_util:get_guild_leader(Members) of
                false ->
                    ok;
                InRid ->
                    honor_mgr:replace_honor_gainer(guild_war_honor, [{InRid, 60002}], 7 * 86400 + util:unixtime()),
                    ok
            end;
        false ->
            ok
    end.

%% 生成物品
make_rewards_items(ItemInfo) ->
    make_rewards_items(ItemInfo, []).
make_rewards_items([], Back) ->
    Back;
make_rewards_items([{BaseId, Bind, Q} | T], Back) ->
    case item:make(BaseId, Bind, Q) of
        {ok, Items} ->
            make_rewards_items(T, Items ++ Back);
        _ ->
            make_rewards_items(T, Back)
    end;
make_rewards_items([_ | T], Back) ->
    make_rewards_items(T, Back).

%% 处理帮战里的地图传送
do_enter_map(_Type, [], _State) ->
    ok;
do_enter_map(Type, [#guild_war_role{pid = Pid, union = Union} | T], State) ->
    EnterPoint = get_enter_point(Type, Union, State),
    role:apply(async, Pid, {fun apply_enter_map/3, [EnterPoint, self()]}),
    do_enter_map(Type, T, State).

%% 获取地图初始点
get_enter_point(prepare, Union, #guild_war{attack_prepare_map = {_, Amid}, defend_prepare_map = {_, Dmid}}) ->
    {{Tlx, Tly}, {Brx, Bry}} = ?prepare_map_enter_point,
    {X, Y} = {util:rand(Tlx, Brx), util:rand(Tly, Bry)},
    case Union of 
        ?guild_war_union_defend ->
            {Dmid, X, Y};
        ?guild_war_union_attack ->
            {Amid, X, Y}
    end;
get_enter_point(war, Union, #guild_war{opp_flag = OppFlag, war_map = {_, Mid}}) ->
    case {Union, OppFlag} of
         {?guild_war_union_defend, ?false} ->
            {{Tlx2, Tly2}, {Brx2, Bry2}} = ?war_map_enter_point_defend,
            {Dx, Dy} = {util:rand(Tlx2, Brx2), util:rand(Tly2, Bry2)},
            {Mid, Dx, Dy};
        {?guild_war_union_attack, ?false} ->
            {X, Y} = util:rand_list(?war_map_enter_point_attack),
            {Mid, X, Y};
        {?guild_war_union_defend, ?true} ->
            {X, Y} = util:rand_list(?war_map_enter_point_attack),
            {Mid, X, Y};
        {?guild_war_union_attack, ?true} ->
            {{Tlx2, Tly2}, {Brx2, Bry2}} = ?war_map_enter_point_defend,
            {Dx, Dy} = {util:rand(Tlx2, Brx2), util:rand(Tly2, Bry2)},
            {Mid, Dx, Dy}
    end;
get_enter_point({Mid, X, Y}, _, _) ->
    {Mid, X, Y};
get_enter_point(_, _, _) ->
    {0, 0, 0}.

%% 组队操作
do_with_team(#guild_war_role{id = Rid}, State, F) ->
    do_with_team(guild_war_util:get_team_rids(by_id, Rid), State, F);

do_with_team([], State, _F) ->
    State;
do_with_team([Rid | T], State = #guild_war{roles = Roles}, F) ->
    case lists:keyfind(Rid, #guild_war_role.id, Roles) of
        false ->
            NewState = F(false, State),
            do_with_team(T, NewState, F);
        GuildRole ->
            NewState = F(GuildRole, State),
            do_with_team(T, NewState, F)
    end.

do_with_team2(#guild_war_role{id = Rid}, State, F) ->
    do_with_team2(guild_war_util:get_team_rids(by_id, Rid), State, F, false).

do_with_team2([], State, _F, _) ->
    State;
do_with_team2([Rid | T], State = #guild_war{roles = Roles}, F, Acc) ->
    case lists:keyfind(Rid, #guild_war_role.id, Roles) of
        false ->
            NewState = F(false, State, Acc),
            do_with_team2(T, NewState, F, Acc);
        GuildRole ->
            case F(GuildRole, State, Acc) of
                {NewState, NewAcc} ->
                    do_with_team2(T, NewState, F, NewAcc);
                Ns2 ->
                    do_with_team2(T, Ns2, F, Acc)
            end
    end.


%% 进入战区
do_enter_war_map(false, State, _) ->
    State;
do_enter_war_map(Grole = #guild_war_role{id = Rid, union = Union}, State = #guild_war{dead_roles = Droles}, false) ->
    NewDroles = lists:keydelete(Rid, 1, Droles),
    EnterPoint = get_enter_point(war, Union, State),
    do_enter_map(EnterPoint, [Grole], State#guild_war{dead_roles = NewDroles}),
    {State#guild_war{dead_roles = NewDroles}, EnterPoint};
do_enter_war_map(Grole = #guild_war_role{id = Rid}, State = #guild_war{dead_roles = Droles}, EnterPoint) ->
    NewDroles = lists:keydelete(Rid, 1, Droles),
    do_enter_map(EnterPoint, [Grole], State#guild_war{dead_roles = NewDroles}),
    {State#guild_war{dead_roles = NewDroles}, EnterPoint}.


%% 离开帮战
do_leave(false, State) ->
    State;
do_leave(Grole = #guild_war_role{id = Rid, pid = Rpid}, State = #guild_war{roles = Roles}) ->
    role:apply(async, Rpid, {fun apply_do_leave/2, [?leave_guild_war_point]}),
    NewRoles = lists:keyreplace(Rid, #guild_war_role.id, Roles, Grole#guild_war_role{is_inwar = ?false}),
    State#guild_war{roles = NewRoles}.

%% 进入帮战准备区的判断
do_enter_war_check([], _State) ->
    {ok};
do_enter_war_check([#role{attr = #attr{fight_capacity = FC}} | _T], _State) when FC < ?guild_war_enter_fightlimit ->
    {false, ?L(<<"您的战斗力低于1800, 暂不能进入圣地">>)};
do_enter_war_check([H = #role{guild = #role_guild{gid = Gid, srv_id = SrvId}} | T], State = #guild_war{guilds = Guilds}) ->
    case lists:keyfind({Gid, SrvId}, #guild_war_guild.id, Guilds) of
        false ->
            ?debug_log([enter_prepare_map, {not_sign, Gid}]),
            {false, ?L(<<"您的帮会没有报名圣地之争">>)};
        G ->
            do_enter_war_check(T, G, State, H)
    end.

do_enter_war_check([], _Guild, _State, _Role) ->
    {ok};
do_enter_war_check([#role{name = Name, attr = #attr{fight_capacity = Fc}} | _T], _Guild, _State, _Role) when Fc < ?guild_war_enter_fightlimit ->
    {false, util:fbin(?L(<<"~s 的战斗力低于1800, 暂不能进入圣地">>), [Name])};
do_enter_war_check([#role{name = Name, guild = #role_guild{gid = Gid, srv_id = SrvId}} | T], Guild = #guild_war_guild{union = Union}, State = #guild_war{guilds = Guilds}, Role = #role{}) ->
    case lists:keyfind({Gid, SrvId}, #guild_war_guild.id, Guilds) of
        false ->
            {false, util:fbin(?L(<<"~s 所在的帮会没有报名圣地之争">>), [Name])};
        #guild_war_guild{union = U2} ->
            case Union =:= U2 of
                true ->
                    do_enter_war_check(T, Guild, State, Role);
                false ->
                    {false, util:fbin(?L(<<"~s 与您所在的联盟不一样">>), [Name])}
            end
    end.

%% 进入帮战准备区
do_enter_war([], State) ->
    State;
do_enter_war([H = #role{id = Rid, pid = Rpid, guild = #role_guild{gid = GuildId, srv_id = SrvId}} | T], State = #guild_war{guilds = Guilds, roles = Roles}) ->
    case lists:keyfind({GuildId, SrvId}, #guild_war_guild.id, Guilds) of
        false ->
            ?debug_log([enter_prepare_map, {not_sign, GuildId}]),
            State;
        Guild = #guild_war_guild{id = Gid, roles_count = InwarCount, union = Union} ->
            GuildRole = guild_war_util:to_guild_war_role(H),
            EnterRole = GuildRole#guild_war_role{union = Union, is_inwar = ?true, is_online = ?true},
            {NewRoles, NewGuild} = case lists:keyfind(Rid, #guild_war_role.id, Roles) of
                false ->
                    {Roles ++ [EnterRole], Guild#guild_war_guild{roles_count = InwarCount + 1}};
                ExistRole = #guild_war_role{} ->
                    {lists:keyreplace(Rid, #guild_war_role.id, Roles, ExistRole#guild_war_role{pid = Rpid, is_inwar = ?true, is_online = ?true}), Guild}
            end,
            NewState = State#guild_war{roles = NewRoles, guilds = lists:keyreplace(Gid, #guild_war_guild.id, Guilds, NewGuild)},
            role:apply(async, Rpid, {fun apply_do_enter/2, [Union]}),
            do_enter_map(prepare, [EnterRole], NewState),
            do_enter_war(T, NewState)
    end.

%% 处理战斗结果
do_combat_over(win, [], _Lrids, State) ->
    State;
do_combat_over(win, [{Rid, SrvId, IsDie} | T], Lrids, State = #guild_war{roles = Roles}) ->
    case lists:keyfind({Rid, SrvId}, #guild_war_role.id, Roles) of
        false ->
            do_combat_over(win, T, Lrids, State);
        R = #guild_war_role{} ->
            NewState = guild_war_credit:credit({combat_win, IsDie, length(Lrids)}, {Rid, SrvId}, State),
            case IsDie of
                ?true ->
                    do_enter_map(prepare, [R], NewState),
                    Ns2 = record_dead({Rid, SrvId}, NewState),
                    do_combat_over(win, T, Lrids, Ns2);
                _ ->
                    do_combat_over(win, T, Lrids, NewState)
            end
    end;

do_combat_over(lose, [], _, State) ->
    State;
do_combat_over(lose, [{Rid, SrvId, _} | T], Wrids, State = #guild_war{roles = Roles}) ->
    case lists:keyfind({Rid, SrvId}, #guild_war_role.id, Roles) of
        false ->
            do_combat_over(lose, T, Wrids, State);
        R = #guild_war_role{} ->
            NewState = guild_war_credit:credit(combat_lose, {Rid, SrvId}, State),
            do_enter_map(prepare, [R], NewState),
            Ns2 = record_dead({Rid, SrvId}, NewState),
            do_combat_over(lose, T, Wrids, Ns2)
    end.

%% 记录死亡
record_dead(Rid, State = #guild_war{dead_roles = Droles}) ->
    State#guild_war{dead_roles = [{Rid, util:unixtime()} | Droles]}.

%% 取得所在联盟
get_combat_union([], _State) ->
    ?guild_war_union_defend;
get_combat_union([{Rid, SrvId, _} | T], State = #guild_war{roles = Roles}) ->
    case lists:keyfind({Rid, SrvId}, #guild_war_role.id, Roles) of
        #guild_war_role{union = Union} ->
            Union;
        _ ->
            get_combat_union(T, State)
    end;
get_combat_union([{Rid, SrvId} | T], State = #guild_war{roles = Roles}) ->
    case lists:keyfind({Rid, SrvId}, #guild_war_role.id, Roles) of
        #guild_war_role{union = Union} ->
            Union;
        _ ->
            get_combat_union(T, State)
    end.

%% 角色离开帮战
apply_do_leave(Role = #role{looks = Looks, team_pid = TeamPid, team = #role_team{is_leader = IsLeader, follow = Follow}}, {Mid, X, Y}) ->
    NewLooks = lists:keydelete(?LOOKS_TYPE_ACT, 1, Looks),
    NewLooks2 = lists:keydelete(?LOOKS_TYPE_GUILD_WAR, 1, NewLooks),
    NewRole = Role#role{event = ?event_no, looks = NewLooks2},
    case is_pid(TeamPid) andalso IsLeader =:= ?false andalso Follow =:= ?true of
        true ->
            {ok, NewRole};
        false ->
            case guild_area:enter(war_npc, NewRole) of
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
apply_do_leave(Role = #role{looks = Looks}, {Mid, X, Y}) ->
    NewLooks = lists:keydelete(?LOOKS_TYPE_ACT, 1, Looks),
    NewLooks2 = lists:keydelete(?LOOKS_TYPE_GUILD_WAR, 1, NewLooks),
    NewRole = Role#role{event = ?event_no, looks = NewLooks2},
    case guild_area:enter(war_npc, NewRole) of
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
    end.


%% 角色进入帮战
apply_do_enter(Role = #role{looks = Looks}, Union) ->
    GuildWarLoos = case Union of
        ?guild_war_union_attack ->
            {?LOOKS_TYPE_ACT, 0, ?LOOKS_VAL_ACT_GUILDWAR_ATK};
        ?guild_war_union_defend ->
            {?LOOKS_TYPE_ACT, 0, ?LOOKS_VAL_ACT_GUILDWAR_DFD}
    end,
    NewLooks = case lists:keyfind(?LOOKS_TYPE_ACT, 1, Looks) of
        false ->
            [GuildWarLoos | Looks];
        _ ->
            lists:keyreplace(?LOOKS_TYPE_ACT, 1, Looks, GuildWarLoos)
    end,
    NewRole = guild_area:moved(Role#role{looks = NewLooks}), %% 去除帮会宝座状态
    {ok, NewRole}.

%% 玩家进入地图
apply_enter_map(Role, EnterPoint, WarPid) ->
    NoRideRole = role_api:set_ride(Role, ?ride_no),
    {Mid, X, Y} = EnterPoint,
    case map:role_enter(Mid, X, Y, NoRideRole#role{event = ?event_guild_war}) of
        {false, _Reason} ->
            {ok};
        {ok, NewRole} ->
            {ok, NewRole#role{event_pid = WarPid}}
    end.

%% 判断是否为攻击者
is_attacker(#guild_war_role{id = Rid}, State) ->
    is_attacker(Rid, State);
is_attacker(Rid, #guild_war{opp_flag = OppFlag, roles = Roles}) ->
    case lists:keyfind(Rid, #guild_war_role.id, Roles) of
        false ->
            false;
        #guild_war_role{union = ?guild_war_union_attack} when OppFlag =:= ?false ->
            true;
        #guild_war_role{union = ?guild_war_union_defend} when OppFlag =:= ?true ->
            true;
        _ ->
            false
    end.

%% 处理广播
cast_notice(war1, State) ->
    {ok, DfdMsg} = proto_109:pack(srv, 10931, {55, ?L(<<"阻止敌方破坏封印仙石！敌方破坏三块仙石前无法进入我方镇守的“圣地中心”！">>), []}),
    {ok, AtkMsg} = proto_109:pack(srv, 10931, {55, ?L(<<"兵分三路！前去破坏三块封印仙石。">>), []}),
    {AtkPids, DfdPids} = get_atk_dfd_pid(State),
    do_cast_notice(DfdMsg, DfdPids),
    do_cast_notice(AtkMsg, AtkPids);
cast_notice(war2, State) ->
    {ok, DfdMsg} = proto_109:pack(srv, 10931, {55, ?L(<<"敌方破坏了第一道防御，速回圣地中心阻止对方帮主夺取封印神剑！">>), []}),
    {ok, AtkMsg} = proto_109:pack(srv, 10931, {55, ?L(<<"速去圣地中心，保护帮主夺取封印神剑！">>), []}),
    {AtkPids, DfdPids} = get_atk_dfd_pid(State),
    do_cast_notice(DfdMsg, DfdPids),
    do_cast_notice(AtkMsg, AtkPids);
cast_notice(roundover, State) ->
    {ok, DfdTips} = proto_146:pack(srv, 14607, {2, ?L(<<"很遗憾，我方守护圣地失败，被敌方夺取了圣地控制权。是可忍，孰不可忍。大家一起努力，把圣地夺取回来吧！">>)}),
    {ok, AtkTips} = proto_146:pack(srv, 14607, {2, ?L(<<"我方已经成功夺取封印神剑。暂时占领了圣地。大家努力一起保护圣地吧！">>)}),
    {AtkPids, DfdPids} = get_atk_dfd_pid(State),
    do_cast_notice(DfdTips, AtkPids),
    do_cast_notice(AtkTips, DfdPids);
cast_notice(over, State = #guild_war{winner_union = WinnerUnion, winner_guild = WinnerGuild, guilds = Guilds}) ->
    WinnerGuildName = case lists:keyfind(WinnerGuild, #guild_war_guild.id, Guilds) of
        #guild_war_guild{name = Name} ->
            Name;
        _ ->
            <<"">>
    end,
    case WinnerUnion of
        ?guild_war_union_attack ->
            {ok, CastMsg} = proto_109:pack(srv, 10931, {55, util:fbin(?L(<<"白方联盟取得胜利, ~s 帮会获得圣地守护权，成为本圣地的守护帮会">>), [WinnerGuildName]), []}),
            do_cast_notice(CastMsg, State);
        ?guild_war_union_defend ->
            {ok, CastMsg} = proto_109:pack(srv, 10931, {55, util:fbin(?L(<<"红方联盟取得胜利, ~s 帮会获得圣地守护权，成为本圣地的守护帮会">>), [WinnerGuildName]), []}),
            do_cast_notice(CastMsg, State);
        _ ->
            ok
    end;
cast_notice(_, _) ->
    ok.

%% 广播推送
cast_msg({AtkMsg, DfdMsg}, State = #guild_war{opp_flag = ?false}) ->
    {AtkPids, DfdPids} = get_atk_dfd_pid(State),
    do_cast_notice(DfdMsg, DfdPids),
    do_cast_notice(AtkMsg, AtkPids);
cast_msg({AtkMsg, DfdMsg}, State) ->
    {AtkPids, DfdPids} = get_atk_dfd_pid(State),
    do_cast_notice(AtkMsg, DfdPids),
    do_cast_notice(DfdMsg, AtkPids);
cast_msg({Msg}, State) ->
    do_cast_notice(Msg, State);
cast_msg(_, _State) ->
    ok.

%% 广播
do_cast_notice(Msg, #guild_war{roles = Roles}) ->
    Foreach = fun(#guild_war_role{pid = Pid}) when is_pid(Pid) -> Pid ! {socket_proxy, Msg};
        (_) -> ok
    end,
    open_process(fun () -> lists:foreach(Foreach, Roles) end);

do_cast_notice(Msg, Pids) when is_list(Pids) ->
    Foreach = fun(Pid) when is_pid(Pid) -> Pid ! {socket_proxy, Msg};
        (_) -> ok
    end,
    open_process(fun () -> lists:foreach(Foreach, Pids) end).

%% 获取攻守双方玩家的pid
get_atk_dfd_pid(#guild_war{roles = Roles, opp_flag = OppFlag}) ->
    get_atk_dfd_pid(OppFlag, Roles, [], []).

get_atk_dfd_pid(_, [], Atks, Dfds) ->
    {Atks, Dfds};
get_atk_dfd_pid(OppFlag, [#guild_war_role{pid = Pid, is_inwar = ?true, union = Union} | T], Atks, Dfds) when is_pid(Pid) ->
    case ?is_attacker(Union, OppFlag) of
        true ->
            get_atk_dfd_pid(OppFlag, T, [Pid | Atks], Dfds);
        false ->
            get_atk_dfd_pid(OppFlag, T, Atks, [Pid | Dfds])
    end;
get_atk_dfd_pid(OppFlag, [_ | T], Atks, Dfds) ->
    get_atk_dfd_pid(OppFlag, T, Atks, Dfds).

%% 排序并按照页数取
page(List, Page) ->
    PageSize = 10,
    case length(List) >= Page * PageSize + 1 of
        true ->
            lists:sublist(List, Page * PageSize + 1, PageSize);
        false ->
            []
    end.

%% 获取胜利的帮会
get_top_guild(_, []) ->
    undefined;
get_top_guild(?guild_war_union_defend, [#guild_war_guild{id = Gid, union = ?guild_war_union_defend} | _T]) ->
    Gid;
get_top_guild(?guild_war_union_attack, [#guild_war_guild{id = Gid, union = ?guild_war_union_attack} | _T]) ->
    Gid;
get_top_guild(Union, [_ | T]) ->
    get_top_guild(Union, T).

%% 帮战回合结束，对帮战内的角色做一些清理工作
do_round_combat_over([]) ->
    ok;
do_round_combat_over([#guild_war_role{pid = Rpid} | T]) ->
    role:apply(async, Rpid, {fun apply_combat_over/1, []}),
    do_round_combat_over(T).

apply_combat_over(#role{combat_pid = ComPid}) ->
    case is_pid(ComPid) andalso is_process_alive(ComPid) of
        true ->
            ComPid ! stop,
            {ok};
        false ->
            {ok}
    end.

%% 取攻守双方的帮会数量
get_atk_dfd_guild(Guilds) ->
    get_atk_dfd_guild(Guilds, 0, 0).
get_atk_dfd_guild([], Atk, Dfd) ->
    {Atk, Dfd};
get_atk_dfd_guild([#guild_war_guild{union = ?guild_war_union_attack} | T], Atk, Dfd) ->
    get_atk_dfd_guild(T, Atk + 1, Dfd);
get_atk_dfd_guild([#guild_war_guild{union = ?guild_war_union_defend} | T], Atk, Dfd) ->
    get_atk_dfd_guild(T, Atk, Dfd + 1);
get_atk_dfd_guild([_ | T], Atk, Dfd) ->
    get_atk_dfd_guild(T, Atk, Dfd).

%% 推送是否直接进入帮战
push_enter([]) ->
    ok;
push_enter([#guild_war_guild{id = Gid} | T]) ->
    case guild_mgr:lookup(by_id, Gid) of
        #guild{members = Members} ->
            push_enter_member(Members);
        false ->
            ok
    end,
    push_enter(T).

push_enter_member([]) ->
    ok;
push_enter_member([#guild_member{pid = Pid} | T]) ->
    case guild_war_util:check([{is_pid_alive, Pid}]) of
        ok ->
            role:pack_send(Pid, 14607, {1, ?L(<<"您的帮会已经报名参加本次圣地之争！本次圣地之争即将展开争夺，是否立即参加本次圣地之争？">>)});
        _ ->
            ok
    end,
    push_enter_member(T);
push_enter_member([_ | T]) ->
    push_enter_member(T).

%% 分组
do_group(Owner, OwnCount, Guilds) ->
    do_group(Owner, OwnCount, length(Guilds), lists:sort(fun sort_by_last_credit/2, Guilds), [], 1, ?guild_war_union_defend).
do_group(_, _, _, [], Back, _Rank, _Lunion) ->
    Back;
do_group(Owner, OwnCount, Count, [H = #guild_war_guild{id = Id} | T], Back, Rank, _Lunion) when Owner =:= Id ->
    ?debug_log([Rank, owner]),
    do_group(Owner, OwnCount, Count, T, [H#guild_war_guild{union = ?guild_war_union_defend} | Back], Rank, ?guild_war_union_defend);
do_group(Owner, OwnCount, Count, [H | T], Back, Rank, _Lunion) when Rank =< 2 * (OwnCount + 1) andalso Count > 2 ->
    ?debug_log([Rank, attacker]),
    do_group(Owner, OwnCount, Count, T, [H#guild_war_guild{union = ?guild_war_union_attack} | Back], Rank + 1, ?guild_war_union_attack);
do_group(Owner, OwnCount, Count, [H | T], Back, Rank, Lunion) ->
    ?debug_log([Rank, {common, Lunion}]),
    Union = case Lunion of
        ?guild_war_union_attack ->
            ?guild_war_union_defend;
        ?guild_war_union_defend ->
            ?guild_war_union_attack;
        _ ->
            ?guild_war_union_attack
    end,
    do_group(Owner, OwnCount, Count, T, [H#guild_war_guild{union = Union} | Back], Rank + 1, Union).

%% 按联盟分组
do_group_realm(Owner, Guilds) ->
    DfdRealm = get_defend_realm(Owner, Guilds),
    case DfdRealm of
        0 ->
            do_group_realm(util:rand_list([?role_realm_a, ?role_realm_b]), undefined, Guilds, []);
        _ ->
            do_group_realm(DfdRealm, Owner, Guilds, [])
    end.

do_group_realm(_, _, [], Back) ->
    Back;
do_group_realm(DfdRealm, Owner, [H = #guild_war_guild{id = Id} | T], Back) when Id =:= Owner ->
    do_group_realm(DfdRealm, Owner, T, [H#guild_war_guild{union = ?guild_war_union_defend} | Back]);
do_group_realm(DfdRealm, Owner, [H = #guild_war_guild{realm = Realm} | T], Back) when DfdRealm =:= Realm ->
    do_group_realm(DfdRealm, Owner, T, [H#guild_war_guild{union = ?guild_war_union_defend} | Back]);
do_group_realm(DfdRealm, Owner, [H = #guild_war_guild{} | T], Back) ->
    do_group_realm(DfdRealm, Owner, T, [H#guild_war_guild{union = ?guild_war_union_attack} | Back]).

%% 获取防守联盟的阵营
get_defend_realm(undefined, _Guilds) ->
    ?role_realm_b;
get_defend_realm(Owner, Guilds) ->
    case lists:keyfind(Owner, #guild_war_guild.id, Guilds) of
        false ->
            0;
        #guild_war_guild{realm = Realm} ->
            Realm
    end.
%% 获取攻击方联盟的阵营
get_attack_realm(0) ->
    0;
get_attack_realm(?role_realm_a) ->
    ?role_realm_b;
get_attack_realm(?role_realm_b) ->
    ?role_realm_a;
get_attack_realm(_) ->
    0.

%% 通知帮会进程禁止或者解禁 帮会操作
do_guild_forbidden(_, []) ->
    ok;
do_guild_forbidden(Type, [#guild_war_guild{id = GuildID} | T]) ->
    guild_mem:limit_member_manage(GuildID, Type),
    do_guild_forbidden(Type, T);
do_guild_forbidden(Type, [_ | T]) ->
    do_guild_forbidden(Type, T).

%% 积分排序
sort_by_last_credit(#guild_war_guild{last_credit = Lc1}, #guild_war_guild{last_credit = Lc2}) ->
    Lc1 >= Lc2;
sort_by_last_credit(_, _) ->
    true.

%% 帮会积分排序
sort_guild(#guild_war_guild{credit = C1}, #guild_war_guild{credit = C2}) ->
    C1 >= C2.

%% 玩家积分序
sort_role(#guild_war_role{credit = C1}, #guild_war_role{credit = C2}) ->
    C1 >= C2.

%% 新开一个进程处理，避免帮战进程的繁忙
open_process(F) ->
    spawn(F).

%% 处理帮战外观
handle_honor(Owner, Wgid) when Owner =:= Wgid ->
    ok;
handle_honor(Owner, Wgid) ->
    ?debug_log([handle_honor, {Owner, Wgid}]),
    guild_war_util:handle_honor(del, Owner),
    guild_war_util:handle_honor(add, Wgid).

%% 参加主将赛
do_attend_compete(_, [], State) ->
    State;
do_attend_compete(Type, [Rid | T], State = #guild_war{roles = Roles}) ->
    NewRoles = case lists:keyfind(Rid, #guild_war_role.id, Roles) of
        Grole = #guild_war_role{} ->
            lists:keyreplace(Rid, #guild_war_role.id, Roles, Grole#guild_war_role{is_compete = Type});
        _ ->
            Roles
    end,
    do_attend_compete(Type, T, State#guild_war{roles = NewRoles}).


