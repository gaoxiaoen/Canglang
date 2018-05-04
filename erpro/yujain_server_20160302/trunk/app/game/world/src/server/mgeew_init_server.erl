%%-------------------------------------------------------------------
%% File              :mgeew_init_server.erl
%% Author            :caochuncheng2002@gmail.com
%% Create Date       :2015-10-22
%% @doc
%%     Add description
%% @end
%%-------------------------------------------------------------------


-module(mgeew_init_server).
-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).


%% ====================================================================
%% Include files
%% ====================================================================
-include("mgeew.hrl").

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/0]).

%% 启动函数
-spec start() -> Result when
          Result :: {ok,Pid} 
                  | {error,Error}
                  | ignore,
          Pid    :: pid(),
          Error  :: {already_started,Pid} | term().
start()  ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [],[]).

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


do_handle_info({func, Fun, Args}) ->
    Ret = (catch apply(Fun,Args)),
    ?ERROR_MSG("~w",[Ret]),
    ok;

do_handle_info(Info)->
    ?ERROR_MSG("receive unknown message,Info=~w",[Info]),
    ignore.


%% 初始化操作
do_init() ->
    case catch do_init_pet_counter_p() of
        {ok} ->
            next;
        {error,Reason} ->
            erlang:throw({error,Reason})
    end,
    {ok}.

do_init_pet_counter_p() ->
    case common_config_dyn:find_common(is_merged) of
        [false] ->
            next;
        _ ->
            erlang:throw({ok})
    end,
    case db_api:transaction(
           fun() -> 
                   [ServerId] = common_config_dyn:find_common(server_id),
                   case db_api:read(?DB_PET_COUNTER, ServerId, write) of
                       [] ->
                           InitKeyId = common_misc:get_init_pet_key_id(),
                           db_api:write(?DB_PET_COUNTER, #r_counter{key=ServerId, last_id=InitKeyId}, write);
                       _ ->
                           ignore
                   end,
                   {ok}
           end) of
    {atomic, {ok}} ->
        {ok};
    {aborted, Reason} ->
        ?ERROR_MSG("~ts,Reason=~w", [?_LANG_LOCAL_033, Reason]),
        erlang:throw({error,Reason})
    end.
