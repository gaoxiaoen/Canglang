%% --------------------------------------------------------------------
%% 大厅管理进程
%% @author abu
%% @end
%% --------------------------------------------------------------------
-module(hall_mgr).

-behaviour(gen_server).

%% export functions
-export([
        start_link/0
    ]).

-export([
        get_hall/2
        ,stop/1
        ,info/1
        ,create/1
        ,login/1
        ,logout/1
    ]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).

%% include
-include("common.hrl").
-include("role.hrl").
-include("hall.hrl").
-include("pos.hrl").

%% record
-record(state, {next_id = 10000}).

%% --------------------------------------------------------------------
%% API functions
%% --------------------------------------------------------------------

%% @spec start_link() -> {ok,Pid} | ignore | {error,Error}
%% 开启大厅
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% @spec get_hall(CrossSrvId, HallId) -> false | {ok, #hall{}}
%% CrossSrvId = bitstring()
%% HallId = integer()
%% 获取大厅, 支持跨服
get_hall(<<>>, HallId) ->
    info(HallId);
get_hall(<<"center">>, HallId) ->
    case center:call(hall_mgr, info, [HallId]) of
        {ok, Hall} -> {ok, Hall};
        false -> false;
        _ -> false
    end.

%% @spec info(HallId) -> false | {ok, #hall{}}
%% HallId = integer()
%% 从ets获取大厅信息
info(HallId) ->
    case ets:lookup(hall_info, HallId) of
        [Hall] ->
            {ok, Hall};
        _ ->
            false
    end.

%% @spec stop(HallId) ->
%% 关闭大厅
stop(HallId) ->
    case info(HallId) of
        {ok, #hall{pid = Pid}} ->
            hall:stop(Pid);
        _ ->
            ok
    end.

%% @spec create(Hall) -> {Id, Pid} | {false, Reason}
%% Hall = #hall{}
%% Id = integer()
%% Pid = pid()
%% 创建大厅
create(Hall) ->
    Id = gen_server:call(?MODULE, fetch_id),
    case hall:start_link(Hall#hall{id = Id}) of
        {ok, Pid} ->
            {ok, Id, Pid};
        {error, Reason} ->
            {false, Reason};
        Result ->
            {false, Result}
    end.

%% @spec login(Role) -> NewRole
%% Role = NewRole = #role{}
%% 玩家在大厅状态中登录
login(Role = #role{event = ?event_hall, hall = HallRole = #role_hall{id = HallId}, cross_srv_id = CrossSrvId}) ->
    case get_hall(CrossSrvId, HallId) of
        {ok, #hall{pid = Hpid}} ->
            case hall:role_login(Hpid, Role) of
                {ok} ->
                    Role#role{hall = HallRole#role_hall{pid = Hpid}};
                _ ->
                    Role#role{event = ?event_no, event_pid = 0, hall = #role_hall{}}
            end;
        _ ->
            Role#role{event = ?event_no, event_pid = 0, hall = #role_hall{}}
    end;
login(Role) ->
    Role.

%% @spec logout(Role) -> NewRole
%% Role = NewRole = #role{}
%% 在大厅中下线
logout(Role = #role{event = ?event_hall, hall = #role_hall{pid = HallPid}}) ->
    hall:role_logout(HallPid, Role),
    Role;
logout(Role) ->
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
    ?INFO("[~w] 正在启动...", [?MODULE]),
    process_flag(trap_exit, true),
    ets:new(hall_info, [set, named_table, public, {keypos, #hall.id}]),
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, #state{}}.

%% @spec: handle_call(Request, From, State) -> {reply, Reply, State} |
%%                                      {reply, Reply, State, Timeout} |
%%                                      {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, Reply, State} |
%%                                      {stop, Reason, State}
%% Description: Handling call messages

%% 申请一个地图ID
handle_call(fetch_id, _From, State = #state{next_id = Id}) ->
    {reply, Id, State#state{next_id = Id + 1}};

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


