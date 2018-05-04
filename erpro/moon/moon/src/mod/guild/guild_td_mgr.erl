%% --------------------------------------------------------------------
%% 帮会塔防管理器 
%% @author shawn 
%% --------------------------------------------------------------------
-module(guild_td_mgr).

-behaviour(gen_server).

%% 头文件
-include("common.hrl").
-include("role.hrl").
-include("pos.hrl").
-include("guild_td.hrl").
-include("guild.hrl").
-include("npc.hrl").
%%

%% api funs
-export([
        start_link/0 
        ,get_guild_td/1
        ,role_login/1
        ,role_logout/1
        ,guild_td_stop/3
        ,guild_td_start/3
        ,get_all_guild_td/0
        ,stop_guild_td/1
        ,kill_npc/3
        ,set_conf/3
        ,get_time/1
        ,sign_guild_td/2
        ,get_today_run_state/1 %% 获取今天是否已玩
    ]).

%% adm funs
-export([
        gm_start/1
        ,reload/0 %% 重新加载所有帮会开启列表
        ,get_start_list/0
        ,guild_destroy/2
        ,adm_fix/0 %% 修复不存在开启列表
        ,gm_day_check/0
    ]
).


%% gen_server callback
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% state 里面 flag 取值
-define(NO_RUN, 0). %% 今天还没玩军团副本
-define(HAS_RUN, 1). %% 已玩

%% record
-record(state, {
        td_lists = [] %% 正在运行的副本
        ,offline_roles = [] %% 副本中下线的角色
        ,start_list = [] %% 帮会开启时间列表 {{Gid, GsrvId}, today_mode, tmr_mode, start_lev, flag} 
    }
).

%% timer
-record(start_timer, {
        ref         %% 定时器引用
        ,timeout    %% 超时
    }).

%% --------------------------------------------------------------------
%% API functions
%% --------------------------------------------------------------------

%% @spec start_link() -> {ok,Pid} | ignore | {error,Error}
%% Starts the server
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 获取本帮开启的副本 
get_guild_td({Gid, Gsrvid}) ->
    gen_server:call(?MODULE, {get_guild_td, {Gid, Gsrvid}}).

%% @spec role_login(Role) -> NewRole
%% Role = NewRole = #role{}
%% 用户登录处理
role_login(Role = #role{guild = #role_guild{gid = Gid, srv_id = GsrvId}, id = Rid, event = ?event_guild_td}) ->
    case gen_server:call(?MODULE, {role_login, Rid}) of
        {ok, Tdpid} ->
            case guild_td_api:get_status(Tdpid) of
                false -> 
                    {Pid, Event, MapId, X, Y} = case guild_td_api:get_guild_entrance({Gid, GsrvId}) of
                        false -> {0, ?event_no, ?GUILD_TD_EXIT_MAP_ID, ?GUILD_TD_EXIT_X, ?GUILD_TD_EXIT_Y};
                        {Epid, M, Lx, Ly} -> {Epid, ?event_no, M, Lx, Ly}
                    end,
                    Role#role{event = Event, event_pid = Pid, pos = #pos{map = MapId, x = X, y = Y}};
                true -> 
                    guild_td:login(Tdpid, Role),
                    Role#role{event_pid = Tdpid}
            end;
        _ ->
            {Pid, Event, MapId, X, Y} = case guild_td_api:get_guild_entrance({Gid, GsrvId}) of
                false -> {0, ?event_no, ?GUILD_TD_EXIT_MAP_ID, ?GUILD_TD_EXIT_X, ?GUILD_TD_EXIT_Y};
                {Epid, M, Lx, Ly} -> {Epid, ?event_no, M, Lx, Ly}
            end,
            Role#role{event = Event, event_pid = Pid, pos = #pos{map = MapId, x = X, y = Y}}
    end;
role_login(Role) -> Role.

%% @spec role_logout(Role) -> NewRole
%% Role = NewRole = #role{}
%% 用户掉线处理
role_logout(Role = #role{id = Rid, event = ?event_guild_td, event_pid = Tdpid}) ->
    gen_server:cast(?MODULE, {role_logout, Rid, Tdpid}),
    guild_td:logout(Tdpid, Role),
    Role;
role_logout(Role) ->
    Role.

%% 强制关闭副本
stop_guild_td(Tdpid) ->
    guild_td:stop(Tdpid).

%% @spec get_all_guild_td() -> [Tdpid | ...]
%% 取得所有运行中的副本pid
get_all_guild_td() ->
    gen_server:call(?MODULE, {get_all_guild_td}).

%% @spec get_start_list() -> [Tdpid | ...]
%% 取得开启列表
get_start_list() ->
    gen_server:call(?MODULE, {get_start_list}).

%% 副本关闭时的回调
guild_td_stop(Tdpid, Gid, TdLev) ->
    ?DEBUG("关闭副本回调"),
    ?MODULE ! {guild_td_stop, Tdpid, Gid, TdLev}.

%% 创建副本
gm_start({Gid, GsrvId}) ->
    case get_guild_td({Gid, GsrvId}) of
        pre_stop ->
            {false, ?L(<<"军团副本正在清理中, 请不要重复开启">>)};
        {false, _R} ->
            ?MODULE ! {start, {Gid, GsrvId}};
        {_, _} -> {false, ?L(<<"军团副本正在清理中, 请不要重复开启">>)}
    end.

%% 副本创建时的回调
guild_td_start(Tdpid, MapId, GuildId) ->
    ?MODULE ! {guild_td_start, Tdpid, MapId, GuildId}.

sign_guild_td(_GuildId, Lev) when Lev < 3 -> skip;
sign_guild_td(GuildId, _Lev) ->
    ?MODULE ! {sign_guild_td, GuildId}.

%% 获取今天是否已开过军团副本
get_today_run_state({Gid, GsrvId}) ->
    gen_server:call(?MODULE, {get_today_run_state, {Gid, GsrvId}}).

%% NPC怪物死亡时,通知进程 
kill_npc(Type, RoleList, #npc{base_id = BaseId, pos = #pos{ map = MapId}}) ->
    case Type of
        1 -> ok;
        0 -> skip
    end,
    gen_server:cast(?MODULE, {kill_npc, Type, BaseId, RoleList, MapId}).

%% 第一次开启,导入已经存在的帮会
reload() ->
    List = guild_mgr:list(),
    L = [{{Id, SrvId}, ?GUILD_TD_MODE_1, ?GUILD_TD_MODE_1, ?NO_RUN} || #guild{id = {Id, SrvId}} <- List],
    gen_server:cast(?MODULE, {reload, L}).

%% 修复丢失开启列表的帮会
adm_fix() ->
    List = guild_mgr:list(),
    L = [{{Id, SrvId}, ?GUILD_TD_MODE_1, ?GUILD_TD_MODE_1, ?NO_RUN} || #guild{id = {Id, SrvId}} <- List],
    gen_server:cast(?MODULE, {adm_fix, L}).

%% 测试隔天
gm_day_check() ->
    ?MODULE ! day_check.

%% 设置第二天开启时间
set_conf(GuildId, Mode, Lev) ->
    case gen_server:call(?MODULE, {set_conf, GuildId, Mode, Lev}) of
        {true, Day, Time} -> {ok, Day, Time, ?L(<<"设置开启时间成功">>)};
        {false, Reason} -> {false, Reason}
    end.

%% 获取开启时间
get_time(GuildId) ->
    case gen_server:call(?MODULE, {get_time, GuildId}) of
        false -> false;
        {Day, Time, Lev} ->
            {ok, Day, Time, Lev}
    end.

reload_start_list(Pid) ->
    List = case catch sys_env:get(guild_td_state) of
        StartList when is_list(StartList) ->
            ?DEBUG(" ============ 所有开启列表 ~w", [StartList]),
            start_list_parse(StartList, []);
        _ -> [] 
    end,
    reload_info(Pid, List),
    ?INFO("帮会副本开启帮会数:~w",[length(List)]),
    List.

start_list_parse([], NewList) -> NewList;
start_list_parse([{GuildId, NowMode, Tmr} | T], NewList) ->
    start_list_parse(T, [{GuildId, NowMode, Tmr, ?GUILD_TD_START_1} | NewList]);
start_list_parse([{GuildId, NowMode, Tmr, Wave} | T], NewList) ->
    start_list_parse(T, [{GuildId, NowMode, Tmr, Wave, ?NO_RUN} | NewList]);
start_list_parse(StartList = [{_GuildId, _NowMode, _Tmr, _StartLev, _Flag} | _T], _) -> StartList.

reload_info(_Pid, []) ->
    ?INFO("设置帮会副本开启列表完成"),
    ok;
reload_info(Pid, [{{Gid, GsrvId}, NowMode, _Tmr, _Start, _Flag} | T]) ->
    Today = util:unixtime(today) + NowMode,
    Now = util:unixtime(),
    case Now < Today of
        true ->
            %% erlang:send_after((Today - Now) * 1000, Pid, {start, {Gid, GsrvId}}),
            setup_timer({Gid, GsrvId}, Pid, Today - Now),
            reload_info(Pid, T);
        false ->
            reload_info(Pid, T)
    end.

%% GID = {Gid, GsrvId}
%% Pid = self()
%% Timeout = 时间间隔 秒
setup_timer(GID, Pid, Timeout) ->
    ?DEBUG("  当前军团定时器情况 ~w", [get()]),
    MSecond = Timeout * 1000,
    case get(GID) of
        undefined ->
            ?DEBUG(" 新加一个定时器  timeout ~w", [Timeout]),
            Ref = erlang:send_after(MSecond, Pid, {start, GID}),
            put(GID, #start_timer{ref = Ref, timeout = MSecond});
        #start_timer{ref = Ref} ->
            _Remain = case erlang:cancel_timer(Ref) of
                false -> 0;
                _Time -> _Time
            end,
            ?DEBUG(" 替换一个定时器  ~w  Remain: ~w", [Timeout, _Remain div 1000]),
            Ref1 = erlang:send_after(MSecond, Pid, {start, GID}),
            put(GID, #start_timer{ref = Ref1, timeout = MSecond})
    end.

get_str(?GUILD_TD_MODE_1) -> <<"10:00">>;
get_str(?GUILD_TD_MODE_2) -> <<"10:30">>;
get_str(?GUILD_TD_MODE_3) -> <<"11:00">>;
get_str(?GUILD_TD_MODE_4) -> <<"11:30">>;
get_str(?GUILD_TD_MODE_5) -> <<"12:00">>;
get_str(?GUILD_TD_MODE_6) -> <<"12:30">>;
get_str(?GUILD_TD_MODE_7) -> <<"13:00">>;
get_str(?GUILD_TD_MODE_8) -> <<"13:30">>;
get_str(?GUILD_TD_MODE_9) -> <<"14:00">>;
get_str(?GUILD_TD_MODE_10) -> <<"14:30">>;
get_str(?GUILD_TD_MODE_11) -> <<"15:00">>;
get_str(?GUILD_TD_MODE_12) -> <<"15:30">>;
get_str(?GUILD_TD_MODE_13) -> <<"16:00">>;
get_str(?GUILD_TD_MODE_14) -> <<"16:30">>;
get_str(?GUILD_TD_MODE_15) -> <<"17:00">>;
get_str(?GUILD_TD_MODE_16) -> <<"17:30">>;
get_str(?GUILD_TD_MODE_17) -> <<"18:00">>;
get_str(?GUILD_TD_MODE_18) -> <<"18:30">>;
get_str(?GUILD_TD_MODE_19) -> <<"19:00">>;
get_str(?GUILD_TD_MODE_20) -> <<"19:30">>;
get_str(?GUILD_TD_MODE_21) -> <<"20:00">>;
get_str(?GUILD_TD_MODE_22) -> <<"20:30">>;
get_str(?GUILD_TD_MODE_23) -> <<"21:00">>;
get_str(?GUILD_TD_MODE_24) -> <<"21:30">>.

%% @spec guild_destroy(Gid, GsrvId) ->
%% 帮会注销 
guild_destroy(_, Lev) when Lev < 3 -> skip;
guild_destroy({Gid, GsrvId}, _Lev) ->
    gen_server:cast(?MODULE, {destroy, {Gid, GsrvId}}).

%% 对比开启列表
campare_list([], _, AddList, NewStartList) -> {AddList, NewStartList};
campare_list([{Gid, Mode1, Mode2, StartLev} | T], OldList, AddList, NewStartList) ->
    case lists:keyfind(Gid, 1, OldList) of
        false ->
            campare_list(T, OldList, [{Gid, Mode1, Mode2, StartLev} | AddList], [{Gid, Mode1, Mode2, StartLev} | NewStartList]);
        {_, M1, M2, S} ->
            campare_list(T, OldList, AddList, [{Gid, M1, M2, S} | NewStartList])
    end.

%% --------------------------------------------------------------------
%% gen_server callback functions
%% --------------------------------------------------------------------

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    process_flag(trap_exit, true),
    StartList = reload_start_list(self()),
    %% 第二天设置开启列表检测
    erlang:send_after((util:unixtime(today) + 86420 - util:unixtime()) * 1000, self(), day_check),
    %% 保存开启列表检测
    erlang:send_after(60 * 60 * 1000, self(), save_state),
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, #state{start_list = StartList}}.

%% 设置第二天开启时间
handle_call({set_conf, GuildId, Time, Wave}, _From, State = #state{start_list = StartList}) ->
    ?DEBUG("  设置  Time: ~w 波数   ~w", [Time, Wave]),
    {{Today, _Tmr}, NewStartList} = case lists:keyfind(GuildId, 1, StartList) of
        false -> {{Time, Time}, [{GuildId, Time, Time, Wave, ?NO_RUN} | StartList]};
        {_, _Now, _, _OldWave, _F} -> {{Time, Time}, lists:keyreplace(GuildId, 1, StartList, {GuildId, Time, Time, Wave, ?NO_RUN})}
    end,

    Now = util:unixtime(),
    StartTime = util:unixtime(today) + Today,
    Eplase = StartTime - Now,
    ?DEBUG("  Now ~w", [Now]),
    ?DEBUG("  军团副本将于 ~w 秒后开启！！！Today ~w  StartTime ~w", [Eplase, Today, StartTime]),
    setup_timer(GuildId, self(), Eplase),
    {reply, {true, 1, Eplase}, State#state{start_list = NewStartList}};

%% 获取下一次开启时间，难度
handle_call({get_time, GuildId}, _From, State = #state{start_list = StartList}) ->
    case lists:keyfind(GuildId, 1, StartList) of
        false -> {reply, false, State};
        {_, Now, _Tmr, Wave, _F} ->
            {reply, {1, Now, guild_td_data:wave2lev(Wave)}, State}
    end;

%% 获取本帮开启的副本
handle_call({get_guild_td, {Gid, GsrvId}}, _From, State = #state{td_lists = TdList, start_list = StartList}) ->
    case lists:keyfind({Gid, GsrvId}, 3, TdList) of
        false ->
            Msg = case lists:keyfind({Gid, GsrvId}, 1, StartList) of
                false -> ?L(<<"军团3级之后才能开启军团副本">>);
                {_, Now, Tmr, _, _} ->
                    N = util:unixtime(),
                    case N > util:unixtime(today) + Now of
                        true -> util:fbin(?L(<<"军团副本将于明天~s开启">>),[get_str(Tmr)]);
                        false -> util:fbin(?L(<<"军团副本将于今天~s开启">>),[get_str(Now)])
                    end
            end,
            {reply, {false, Msg}, State};
        {TdPid, MapId, _} ->
            case guild_td_api:get_status(TdPid) of
                false ->
                    ?DEBUG("不可进入状态的副本"),
                    {reply, pre_stop, State};
                true ->
                    {reply, {TdPid, MapId}, State}
            end
    end;

%% 角色登陆回调
handle_call({role_login, Rid}, _From, State = #state{offline_roles = OffRole}) ->
    case lists:keyfind(Rid, 1, OffRole) of
        {_, Tdpid} ->
            case is_pid(Tdpid) andalso is_process_alive(Tdpid) of
                true -> {reply, {ok, Tdpid}, State#state{offline_roles = lists:keydelete(Rid, 1, OffRole)}};
                false -> {reply, false, State}
            end;
        false ->
            {reply, false, State}
    end;

%% 取得所有副本
handle_call({get_all_guild_td}, _From, State = #state{td_lists = TdList}) ->
    {reply, TdList, State};

%% 取得开启列表副本
handle_call({get_start_list}, _From, State = #state{start_list = StartList}) ->
    {reply, StartList, State};

handle_call({get_today_run_state, {Gid, GsrvId}}, _From, State = #state{start_list = StartList}) ->
    ?DEBUG("我的军团ID ~w  ~w", [Gid, GsrvId]),
    ?DEBUG("当前军团列表 ~w", [StartList]),
    case lists:keyfind({Gid, GsrvId}, 1, StartList) of
        false ->
            {reply, {?HAS_RUN}, State};
        {_, _, _, _, Flag} ->
            {reply, {Flag}, State}
    end;

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

%% 注销帮会
handle_cast({destroy, {Gid, GsrvId}}, State = #state{start_list = StartList}) ->
    ?DEBUG("帮会id:~w,Srvid:~s,注销了",[Gid, GsrvId]),
    NewStartList = case lists:keyfind({Gid, GsrvId}, 1, StartList) of
        false -> StartList;
        _ -> lists:keydelete({Gid, GsrvId}, 1, StartList)
    end,
    {noreply, State#state{start_list = NewStartList}};

%% 重载开启列表
handle_cast({reload, StartList}, State) ->
    NewState = State#state{start_list = StartList},
    reload_info(self(), StartList),
    ?INFO("重载帮会副本开启列表完成,共有~w个帮会开启降魔除妖",[length(StartList)]),
    {noreply, NewState};

%% 重载开启列表
handle_cast({adm_fix, StartList}, State = #state{start_list = OldStartList}) ->
    {AddList, NewStartList} = campare_list(StartList, OldStartList, [], []),
    NewState = State#state{start_list = NewStartList},
    reload_info(self(), AddList),
    ?INFO("修复帮会副本开启列表完成,共有~w个帮会新增降魔除妖",[length(AddList)]),
    {noreply, NewState};

handle_cast({kill_npc, Type, NpcBaseId, [], MapId}, State = #state{td_lists = TdLists}) ->
    case lists:keyfind(MapId, 2, TdLists) of
        false -> {noreply, State};
        {TdPid, MapId, _} ->
            TdPid ! {loss_npc, Type, NpcBaseId},
            {noreply, State}
    end;

handle_cast({kill_npc, Type, NpcBaseId, RoleList, MapId}, State = #state{td_lists = TdLists}) ->
    ?DEBUG(">>>>>>>>>>>>>>>> 杀死怪 ....."),
    case lists:keyfind(MapId, 2, TdLists) of
        false -> {noreply, State};
        {TdPid, MapId, _} ->
            TdPid ! {result, Type, NpcBaseId, RoleList},
            {noreply, State}
    end;

%% 角色下线
handle_cast({role_logout, Rid, Tdpid}, State = #state{offline_roles = OffRole}) ->
    case lists:keyfind(Rid, 1, OffRole) of 
        false -> {noreply, State#state{offline_roles = [{Rid, Tdpid} | OffRole]}};
        _ -> {noreply, State#state{offline_roles = lists:keyreplace(Rid, 1, OffRole, {Rid, Tdpid})}}
    end;

handle_cast(_Msg, State) ->
    {noreply, State}.

%% 第一次报名帮会副本
handle_info({sign_guild_td, GuildId}, State = #state{start_list = StartList}) ->
    Now = util:unixtime(),
    Today = util:unixtime(today) + ?GUILD_TD_MODE_4,
    NewStartList = case lists:keyfind(GuildId, 1, StartList) of
        false ->
            case Now > Today of
                true -> 
                    guild:guild_mail(GuildId, {?L(<<"参加帮会降妖">>),
                            ?L(<<"帮会等级到达3级,已经报名帮会降妖活动,活动将在明天15点开启,请帮会成员准时参加">>)});
                false ->
                    guild:guild_mail(GuildId, {?L(<<"参加帮会降妖">>),
                            ?L(<<"帮会等级到达3级,已经报名帮会降妖活动,活动将在明天15点开启,请帮会成员准时参加">>)}),
                    erlang:send_after((Today - Now) * 1000, self(), {start, GuildId})
            end,
            [{GuildId, ?GUILD_TD_MODE_4, ?GUILD_TD_MODE_4, ?GUILD_TD_START_1, ?NO_RUN} | StartList];
        _ -> StartList 
    end,
    case sys_env:save(guild_td_state, NewStartList) of
        ok -> ?DEBUG("帮会副本开启列表保存成功");
        _E -> ?ERR("帮会副本开启列表保存失败:~w", [_E])
    end,
    {noreply, State#state{start_list = NewStartList}};

%% 开启帮会副本
handle_info({start, {Gid, GsrvId}}, State = #state{td_lists = TdList, start_list = StartList}) ->
    case lists:keyfind({Gid, GsrvId}, 3, TdList) of
        {_, _, _} ->
            ?ERR("帮会副本还在开启中:Gid:~w,GsrvId:~s",[Gid, GsrvId]),
            {noreply, State};
        false -> 
            StartLev = case lists:keyfind({Gid, GsrvId}, 1, StartList) of
                false -> 10001;%%?GUILD_TD_START_1;
                {_, _, _, Lev, _Flag} ->  Lev
            end,
            case guild_td_api:start_guild({Gid, GsrvId}, StartLev) of
                {?GUILD_TD_NOT_EXIST, _R} -> 
                    ?ERR("不存在的帮会Gid:~w,GsrvId:~s",[Gid, GsrvId]),
                    {noreply, State#state{start_list = lists:keydelete({Gid, GsrvId}, 1, StartList)}};
                {false, _Reason} ->
                    ?ERR("开启帮会副本出错:Gid:~w,GsrvId:~s,Reason:~w",[Gid,GsrvId, _Reason]),
                    {noreply, State};
                {ok, _} -> {noreply, State}
            end
    end;

%% 隔天检查, 对今天将要开启的副本设置定时器,并且重置开启列表
handle_info(day_check, State = #state{start_list = StartList}) ->
    NewStartList = day_check(self(), StartList, []),
    ?INFO("跨天检查,设置今天开启帮会副本列表,共有~w个",[length(NewStartList)]),
    case sys_env:save(guild_td_state, NewStartList) of
        ok -> ?DEBUG("帮会副本开启列表保存成功");
        _E -> ?ERR("帮会副本开启列表保存失败:~w", [_E])
    end,
    erlang:send_after(86410 * 1000, self(), day_check),
    {noreply, State#state{start_list = NewStartList}};

%% 创建塔防
handle_info({guild_td_start, Tdpid, MapId, GuildId}, State = #state{td_lists = TdList}) ->
    {noreply, State#state{td_lists = [{Tdpid, MapId, GuildId} | TdList]}};

%% 终止塔防副本
handle_info({guild_td_stop, Tdpid, Gid, TdLev}, State = #state{offline_roles = OffRole, td_lists = TdList, start_list = StartList}) ->
    NewStartList = case lists:keyfind(Gid, 1, StartList) of
        false -> StartList;
        {_, Now, Tmr, StartLev, _Flag} ->
            lists:keyreplace(Gid, 1, StartList, {Gid, Now, Tmr, up_start_lev(StartLev, TdLev, Gid), ?HAS_RUN})
    end,
    NewOffRole = [Info || Info = {_, Pid} <- OffRole, Pid =/= Tdpid],
    {noreply, State#state{offline_roles = NewOffRole, td_lists = lists:keydelete(Tdpid, 1, TdList), start_list = NewStartList}};

%% 保存信息
handle_info(save_state, State) ->
    case sys_env:save(guild_td_state, State#state.start_list) of
        ok -> ?DEBUG("帮会副本开启列表保存成功");
        _E -> ?ERR("帮会副本开启列表保存失败:~w", [_E])
    end,
    erlang:send_after(60*60 * 1000, self(), save_state),
    {noreply, State};

handle_info(_Info, State) ->
    {noreply, State}.

%% @spec: terminate(Reason, State) -> void()
%% Description: This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any necessary
%% cleaning up. When it returns, the gen_server terminates with Reason.
%% The return value is ignored.
terminate(_Reason, #state{start_list = StartList}) ->
    case sys_env:save(guild_td_state, StartList) of
        ok -> ?DEBUG("帮会副本开启列表信息成功");
        _E -> ?ERR("帮会副本开启列表信息失败:~w", [_E])
    end,
    ok.

%% @spec: code_change(OldVsn, State, Extra) -> {ok, NewState}
%% Description: Convert process state when code is changed
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ----------------------
%% 内部函数
%% ----------------------
day_check(_Pid, [], NewStartList) -> NewStartList;
day_check(Pid, [{GID = {Gid, GsrvId}, _DayMode, _TmrMode, StartLev, _Flag} | T], NewStartList) ->
    case guild_td_api:get_guild({Gid, GsrvId}) of
        false ->
            erase(GID),
            day_check(Pid, T, NewStartList);
        _ ->
            DayMode1 = ?GUILD_TD_MODE_24, 
            Now = util:unixtime(),
            Today = util:unixtime(today) + DayMode1,
            setup_timer(GID, Pid, Today - Now),
            day_check(Pid, T, [{{Gid, GsrvId}, DayMode1, _TmrMode, StartLev, ?NO_RUN} | NewStartList])
    end.

up_start_lev(?GUILD_TD_START_1, TdLev, Gid) when TdLev >= 20 ->
    guild:guild_chat(Gid, ?L(<<"在全体帮会成员的努力下。帮会在帮会降妖活动中，第一次成功守卫20波怪物的侵袭。\n下一次帮会降妖可从第5波开始守卫。\n且可获得1.2倍帮会贡献加成。">>)),
    ?GUILD_TD_START_5;
up_start_lev(?GUILD_TD_START_5, TdLev, Gid) when TdLev >= 20 ->
    guild:guild_chat(Gid, ?L(<<"在全体帮会成员的努力下。帮会在帮会降妖活动中，第二次成功守卫20波怪物的侵袭。\n下一次帮会降妖可从第10波开始守卫。\n且可获得1.5倍帮会贡献加成。">>)),
    ?GUILD_TD_START_10;
up_start_lev(Lev, _, _) -> Lev.
