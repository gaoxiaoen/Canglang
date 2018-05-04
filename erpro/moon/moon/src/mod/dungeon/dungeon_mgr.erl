%% --------------------------------------------------------------------
%% 副本管理器  abu@jieyou.cn
%% --------------------------------------------------------------------
-module(dungeon_mgr).

-behaviour(gen_server).

%% 头文件
-include("common.hrl").
-include("role.hrl").
-include("pos.hrl").
-include("dungeon.hrl").
-include("hall.hrl").
-include("map.hrl").

%% api funs
-export([
        start_link/0 
        ,role_login/1
        ,role_switch/1
        ,role_logout/1
        ,start_dungeon/1
        ,stop_dungeon/1
        ,dungeon_stoped/1
        ,dungeon_started/1
        ,get_all_dungeons/0
    ]).

%% gen_server callback
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% record
-record(state, {dungeons = [], offline_roles = []}).

-define(dungeon_tower_reward_interval, 60000 * 60 * 24 * 7). 

%% for test debug
%%-define(debug_log(P), ?DEBUG("type=~w, value=~w ", P)).
-define(debug_log(P), ok).

%% --------------------------------------------------------------------
%% API functions
%% --------------------------------------------------------------------

%% @spec start_link() -> {ok,Pid} | ignore | {error,Error}
%% Starts the server
start_link() ->
    case gen_server:start_link({local, ?MODULE}, ?MODULE, [], []) of
        {ok, Pid} ->
            Pid ! init,
            {ok, Pid};
        Other ->
            Other
    end.

%% @spec role_login(Role) -> NewRole
%% Role = NewRole = #role{}
%% 用户登录处理
role_login(Role = #role{id = Rid, event = ?event_dungeon, cross_srv_id = CrossSrvId,
        pos = #pos{last = {MapId, X, Y}}, hall = #role_hall{id = HallId}}) ->
    ?debug_log([role_login, CrossSrvId]),
    LoginResult = case CrossSrvId of
        <<>> ->
            gen_server:call(?MODULE, {role_login, Rid});
        _ ->
            center:call(dungeon_mgr_center, role_login, [Rid])
    end,
    ?debug_log([login_result, LoginResult]),
    case is_in_dungeon(LoginResult) of
        {ok, Pid, Id, Type} ->
            dungeon:login(Pid, Role),
            Role#role{event_pid = Pid, dungeon_ext = #dungeon_ext{id = Id, type = Type}};
        _ ->
            %%退出大厅
            case HallId =/= 0 of
                true ->
                    hall:login_leave(HallId, Role);
                false ->
                    ignore
            end,
            Role#role{event = ?event_no, event_pid = 0, pos = #pos{map = MapId, x = X, y = Y}, hall = #role_hall{}}
    end;
role_login(Role = #role{pos = #pos{map_base_id = MapBaseId}}) ->
    case map_data:get(MapBaseId) of
        #map_data{type = ?map_type_dungeon} ->
            role_login(Role#role{event = ?event_dungeon});
        #map_data{type = ?map_type_expedition} ->
            role_login(Role#role{event = ?event_dungeon});
        _ ->
            Role
    end.

role_switch(Role = #role{event = ?event_dungeon, event_pid = DungeonPid}) ->
    dungeon:switch(DungeonPid, Role),
    Role;
role_switch(Role) ->
    Role.

%% @spec role_logout(Role) -> NewRole
%% Role = NewRole = #role{}
%% 用户掉线处理
role_logout(Role = #role{id = Rid, event = ?event_dungeon, event_pid = Dpid, cross_srv_id = CrossSrvId}) ->
    case CrossSrvId of
        <<>> ->
            ?MODULE ! {role_logout, Rid, Dpid},
            dungeon:logout(Dpid, Role),
            Role;
        _ ->
            center:call(dungeon_mgr_center, role_logout, [Rid, Dpid, dungeon:to_dungeon_role(Role)]),
            Role
    end;
role_logout(Role) ->
    Role.

%% @spec start_dungeon(DunBase) 
%% 暂时没有使用，目前使用dungeon_type 的方法启动
start_dungeon(_DunBase) ->
    ok.

%% @spec stop_dungeon(Dpid) -> 
%% Dpid = pid()
%% 强制关闭副本
stop_dungeon(Dpid) ->
    dungeon:stop(Dpid).

%% @spec get_all_dungeons() -> [Dpid | ...]
%% Dpid = pid()
%% 取得所有运行中的副本pid
get_all_dungeons() ->
    gen_server:call(?MODULE, {get_all_dungeons}).

%% @spec dungeon_stoped(Dpid) ->
%% Dpid = pid()
%% 副本退出时的回调
dungeon_stoped(Dpid) ->
    ?MODULE ! {dungeon_stoped, Dpid}.

%% @spec dungeon_started(Dpid) ->
%% Dpid = pid()
%% 副本创建时的回调
dungeon_started(Dpid) ->
    ?MODULE ! {dungeon_started, Dpid}.

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
    ets:new(ets_dungeon_score, [set, named_table, public, {keypos, 1}]),
    ?INFO("[~w] 启动完成", [?MODULE]),

    {ok, #state{}}.

%% @spec: %% handle_call(Request, From, State) -> {reply, Reply, State} |
%%                                      {reply, Reply, State, Timeout} |
%%                                      {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, Reply, State} |
%%                                      {stop, Reason, State}
%% Description: Handling call messages
handle_call({role_login, Rid}, _From, State = #state{offline_roles = Oroles}) ->
    ?debug_log([role_login, Rid]),
    ?debug_log([offline_roles, Oroles]),
    case lists:keyfind(Rid, 1, Oroles) of
        {_, Dpid} ->
            case is_pid(Dpid) of
                true ->
                    {reply, {ok, Dpid}, State#state{offline_roles = lists:keydelete(Rid, 1, Oroles)}};
                false ->
                    {reply, false, State}
            end;
        false ->
            {reply, false, State}
    end;
%% 取得所有副本
handle_call({get_all_dungeons}, _From, State = #state{dungeons = Duns}) ->
    {reply, Duns, State};

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
handle_info(init, State) ->
    {noreply, State};
%% 副本开启
handle_info({dungeon_started, Dpid}, State = #state{dungeons = Duns}) ->
    ?debug_log([dungeon_started, Dpid]),
    ?debug_log([dungeons, Duns]),
    {noreply, State#state{dungeons = [Dpid | Duns]}};
%% 副本关闭
handle_info({dungeon_stoped, Dpid}, State = #state{offline_roles = Oroles, dungeons = Duns}) ->
    ?debug_log([dungeons, Duns]),
    ?debug_log([offline_roles, Oroles]),
    ?debug_log([dungeon_stoped, Dpid]),
    NewOroles = [Item || Item = {_, Pid} <- Oroles, Pid =/= Dpid],
    ?debug_log([new_offline_roles, NewOroles]),
    {noreply, State#state{offline_roles = NewOroles, dungeons = lists:delete(Dpid, Duns)}};
%% 用户下线
handle_info({role_logout, Rid, Dpid}, State = #state{offline_roles = Oroles}) ->
    ?debug_log([offline_roles, Oroles]),
    ?debug_log([role_logout, {Rid, Dpid}]),
    case lists:keyfind(Rid, 1, Oroles) of 
        false ->
            {noreply, State#state{offline_roles = lists:append([{Rid, Dpid}], Oroles)}};
        _ ->
            {noreply, State#state{offline_roles = lists:keyreplace(Rid, 1, Oroles, {Rid, Dpid})}}
    end;
handle_info(_Info, State) ->
    ?DEBUG("invalid info: ~w", [_Info]),
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

is_in_dungeon({ok, Dpid}) when is_pid(Dpid) ->
    case dungeon:get_info(Dpid) of
        {ok, #dungeon{combat_status = lose}} ->
            %%战斗失败回到上一场景
            dungeon:stop(Dpid),
            false;
        {ok, #dungeon{id = Id, type = Type, extra = Extra}} ->
            %%已通关则直接回到上一场景
            case lists:keyfind(clear, 1, Extra) of
                false ->
                    {ok, Dpid, Id, Type};
                _ ->
                    dungeon:stop(Dpid),
                    false
            end;
        _ ->
            ?ERR("上线获取副本信息错误: ~w", [Dpid]),
            false
    end;
is_in_dungeon(Other) ->
    Other.


