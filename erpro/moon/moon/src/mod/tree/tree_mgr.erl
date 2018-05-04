%%----------------------------------------------------
%% 世界树管理进程
%%
%% @author mobin
%%----------------------------------------------------
-module(tree_mgr).
-behaviour(gen_server).

%% api funs
-export([
        start_link/0
        ,login/1
        ,push_status/1
        ,role_logout/1
    ]).

%% gen_server callback
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("tree.hrl").
-include("role.hrl").
-include("link.hrl").
-include("unlock_lev.hrl").

%% record
-record(state, {}).

%% --------------------------------------------------------------------
%% API functions
%% --------------------------------------------------------------------
%% @spec start_link() -> {ok,Pid} | ignore | {error,Error}
%% Starts the server
start_link() ->
    case gen_server:start_link({local, ?MODULE}, ?MODULE, [], []) of
        {ok, Pid} ->
            {ok, Pid};
        Other ->
            Other
    end.

%% @spec role_logout(Role) -> NewRole
%% Role = NewRole = #role{}
%% 用户上线处理
login(Role) ->
    push_status(Role).

%% @spec role_logout(Role) -> NewRole
%% Role = NewRole = #role{}
%% 用户上线处理
push_status(Role = #role{id = Rid, lev = Lev, link = #link{conn_pid = ConnPid}}) ->
    UnlockLev = ?tree_unlock_lev,
    case Lev < UnlockLev of 
        true ->
            ignore;
        false ->
            #tree_role{is_lose = IsLose} = tree_api:get_tree_role(Rid),
            Reply = case IsLose of
                ?true ->
                    0;
                _ ->
                    1
            end,
            sys_conn:pack_send(ConnPid, 13609, {Reply})
    end,
    Role.

%% @spec role_logout(Role) -> NewRole
%% Role = NewRole = #role{}
%% 用户掉线处理
role_logout(Role = #role{}) ->
    case get(tree_role) of
        undefined ->
            ok;
        TreeRole ->
            ?MODULE ! {save_tree_role, TreeRole}
    end,
    Role.
    
%% --------------------------------------------------------------------
%% gen_server callback functions
%% --------------------------------------------------------------------
%% @spec init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
init([]) ->
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, #state{}}.

%% @spec: %% handle_call(Request, From, State) -> {reply, Reply, State} |
%%                                      {reply, Reply, State, Timeout} |
%%                                      {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, Reply, State} |
%%                                      {stop, Reason, State}
%% Description: Handling call messages
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
handle_info({save_tree_role, TreeRole}, State = #state{}) ->
    save_tree_role(TreeRole),
    {noreply, State};

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
save_tree_role(#tree_role{rid = {RoleId, SrvId}, floor = Floor, status = Status, stage = Stage, exp = Exp, coin = Coin,
        material = Material, strange = Strange, material_items = MaterialItems, strange_items = StrangeItems, 
        is_clear = IsClear, last = Last, best_stage = BestStage, is_lose = IsLose}) ->
    Sql = "replace into sys_tree values(~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)",
    case db:execute(Sql, [RoleId, SrvId, Floor, Status, Stage, Exp, Coin, Material, Strange,
                util:term_to_bitstring(MaterialItems), util:term_to_bitstring(StrangeItems),
                IsClear, Last, BestStage, IsLose]) of
        {error, Why} ->
            ?ERR("save_tree_role时发生异常: ~s", [Why]),
            false;
        {ok, _X} ->
            ok
    end.
