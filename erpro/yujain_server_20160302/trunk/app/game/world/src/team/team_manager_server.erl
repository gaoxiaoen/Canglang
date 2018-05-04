%% @filename team_manager_server.erl
%% @author caochuncheng2002@gmail.com
%% @create time  2016-02-15 
%% @doc 
%% 队伍管理进程.

-module(team_manager_server).
-behaviour(gen_server).

-include("mgeew.hrl").

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% ====================================================================
%% API functions
%% ====================================================================
-export([
         start/0,
         start_link/0
        ]).

start() ->
    {ok, _} = supervisor:start_child(team_sup, {?MODULE, {?MODULE, start_link, []}, permanent, 30000, worker, [?MODULE]}).
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% ====================================================================
%% Behavioural functions
%% ====================================================================
-record(state, {}).

%% init/1
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/gen_server.html#Module:init-1">gen_server:init/1</a>
-spec init(Args :: term()) -> Result when
	Result :: {ok, State}
			| {ok, State, Timeout}
			| {ok, State, hibernate}
			| {stop, Reason :: term()}
			| ignore,
	State :: term(),
	Timeout :: non_neg_integer() | infinity.
%% ====================================================================
init([]) ->
    init_team_id_counter(),
    {ok, #state{}}.


%% handle_call/3
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/gen_server.html#Module:handle_call-3">gen_server:handle_call/3</a>
-spec handle_call(Request :: term(), From :: {pid(), Tag :: term()}, State :: term()) -> Result when
	Result :: {reply, Reply, NewState}
			| {reply, Reply, NewState, Timeout}
			| {reply, Reply, NewState, hibernate}
			| {noreply, NewState}
			| {noreply, NewState, Timeout}
			| {noreply, NewState, hibernate}
			| {stop, Reason, Reply, NewState}
			| {stop, Reason, NewState},
	Reply :: term(),
	NewState :: term(),
	Timeout :: non_neg_integer() | infinity,
	Reason :: term().
%% ====================================================================
handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.


%% handle_cast/2
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/gen_server.html#Module:handle_cast-2">gen_server:handle_cast/2</a>
-spec handle_cast(Request :: term(), State :: term()) -> Result when
	Result :: {noreply, NewState}
			| {noreply, NewState, Timeout}
			| {noreply, NewState, hibernate}
			| {stop, Reason :: term(), NewState},
	NewState :: term(),
	Timeout :: non_neg_integer() | infinity.
%% ====================================================================
handle_cast(_Msg, State) ->
    {noreply, State}.


%% handle_info/2
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/gen_server.html#Module:handle_info-2">gen_server:handle_info/2</a>
-spec handle_info(Info :: timeout | term(), State :: term()) -> Result when
	Result :: {noreply, NewState}
			| {noreply, NewState, Timeout}
			| {noreply, NewState, hibernate}
			| {stop, Reason :: term(), NewState},
	NewState :: term(),
	Timeout :: non_neg_integer() | infinity.
%% ====================================================================
handle_info(Info, State) ->
    ?DO_HANDLE_INFO(Info, State),
    {noreply, State}.


%% terminate/2
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/gen_server.html#Module:terminate-2">gen_server:terminate/2</a>
-spec terminate(Reason, State :: term()) -> Any :: term() when
	Reason :: normal
			| shutdown
			| {shutdown, term()}
			| term().
%% ====================================================================
terminate(_Reason, _State) ->
    ok.


%% code_change/3
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/gen_server.html#Module:code_change-3">gen_server:code_change/3</a>
-spec code_change(OldVsn, State :: term(), Extra :: term()) -> Result when
	Result :: {ok, NewState :: term()} | {error, Reason :: term()},
	OldVsn :: Vsn | {down, Vsn},
	Vsn :: term().
%% ====================================================================
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


%% ====================================================================
%% Internal functions
%% ====================================================================
do_handle_info({team_create,Info}) ->
    do_team_create(Info);
do_handle_info({func, Fun, Args}) ->
    Ret = (catch apply(Fun,Args)),
    ?ERROR_MSG("~w",[Ret]),
    ok;
do_handle_info(Info) ->
    ?ERROR_MSG("receive unknown message,Info=~w",[Info]).

%% 初始化队伍id记数器
-spec init_team_id_counter() -> ok.
init_team_id_counter() ->
    erlang:put(team_id_counter,1),
    ok.
%% 获取可用的队伍id，每一次游戏重起会重置id,id值最大为2147483648
-spec get_team_id_counter() -> TeamId when TeamId :: integer().
get_team_id_counter() ->
    case erlang:get(team_id_counter) of
        undefined ->
            erlang:put(team_id_counter,2),
            1;
        CurTeamId ->
            erlang:put(team_id_counter,CurTeamId + 1),
            CurTeamId
    end.

%% 创建队伍进程
do_team_create({RoleId}) ->
    TeamId = get_team_id_counter(),
    TeamProcessName = team_misc:get_team_process_name(TeamId),
    TeamState={create,TeamId,TeamProcessName,RoleId},
    ChildSpec = {TeamId, {team_server,start_link,[TeamState]},temporary,60000,worker,[team_server]},
    case supervisor:start_child({local,team_sup}, ChildSpec) of
        {ok, _TeamPid} ->
            ok;
        Error ->
            ?ERROR_MSG("创建队伍进程失败 ~w",[Error]),
            ok
    end.

