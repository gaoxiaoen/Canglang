%% @filename db_migration_server.erl
%% @author caochuncheng2002@gmail.com
%% @create time  2016-01-18 
%% @doc 
%% 数据迁移进程.

-module(db_migration_server).
-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("common_server.hrl").


%% ====================================================================
%% API functions
%% ====================================================================
-export([start/0,
         start_link/0]).

%% 启动函数
-spec start() -> Result when
          Result :: {ok,Pid} 
                  | {error,Error}
                  | ignore,
          Pid    :: pid(),
          Error  :: {already_started,Pid} | term().
start() ->
    {ok, _} = supervisor:start_child(db_sup, {?MODULE, {?MODULE, start_link, []},
                                              transient, brutal_kill, worker, 
                                              [db_migration_server]}).


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
    case catch do_init() of
        {ok} ->
            {ok, #state{}};
        {error,Reason} ->
            {stop,Reason}
    end.


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
    ?DO_HANDLE_INFO(Info,State),
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
-define(LOOP_MILLISECONDS,10000).

do_handle_info(loop_milliseconds) ->
    erlang:send_after(?LOOP_MILLISECONDS, erlang:self(), loop_milliseconds),
    loop();

do_handle_info({func, Fun, Args}) ->
    Ret = (catch apply(Fun,Args)),
    ?ERROR_MSG("~w",[Ret]),
    ok;

do_handle_info(Info)->
    ?ERROR_MSG("receive unknown message,Info=~w",[Info]),
    ignore.


%% 初始化操作
do_init() ->
    case cfg_mnesia:is_inactive_storage() of
        true ->
            MigrationTime = cfg_mnesia:find(migration_time),
            Date = erlang:date(),
            MigrationSeconds = common_tool:datetime_to_seconds({Date,MigrationTime}),
            NextMigrationSeconds = MigrationSeconds + 86400,
            set_migration_time(NextMigrationSeconds),
            erlang:send_after(?LOOP_MILLISECONDS, erlang:self(), loop_milliseconds);
        _ ->
            ignore
    end,
    {ok}.

get_migration_time() ->
    erlang:get(migration_time).
set_migration_time(MigrationSeconds) ->
    erlang:put(migration_time, MigrationSeconds).
    
loop() ->
    NowSeconds = common_tool:now(),
    MigrationSeconds = get_migration_time(),
    case NowSeconds > MigrationSeconds of
        true ->
            NextMigrationSeconds = MigrationSeconds + 86400,
            set_migration_time(NextMigrationSeconds),
            do_data_migration();
        _ ->
            ignore
    end.

do_data_migration() ->
    db_migration:move_inactive(),
    ok.

