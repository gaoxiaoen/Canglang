%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 唯一key服务
%%% @end
%%% Created : 13. 一月 2017 上午11:38
%%%-------------------------------------------------------------------
-module(keygen).
-author("fancy").
-behaviour(gen_server).
-include("common.hrl").

%% API
-export([start_link/0, gen_key/1, get_player_key/0, get_auto_key/0, get_unique_key/0]).

%% gen_server callbacks
-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).

-define(SERVER, ?MODULE).

-record(state, {
    unique_key_list = [],
    auto_id = 0
}).

-record(key, {sn = 0, unique_id = 0, player_id = 0}).

%%获取进程PID
get_server_pid() ->
    case get(?MODULE) of
        Pid when is_pid(Pid) ->
            Pid;
        _ ->
            case misc:whereis_name(local, ?MODULE) of
                Pid when is_pid(Pid) ->
                    put(?MODULE, Pid),
                    Pid;
                _ ->
                    undefined
            end
    end.

gen_key(Len) ->
    case ?CALL(get_server_pid(), {apply, ?MODULE, priv_gen_key, [Len]}) of
        [] ->
            priv_gen_key(Len);
        Key -> Key
    end.

%%获取唯一id
get_unique_key() ->
    case ?CALL(get_server_pid(), get_unique_key) of
        [] ->
            priv_gen_key(15);
        Key -> Key
    end.


%%获取玩家key
get_player_key() ->
    case ?CALL(get_server_pid(), get_player_key) of
        [] ->
            priv_gen_key(10);
        Key -> Key
    end.

%%系统自增id,怪物,NPC场景数据用
get_auto_key() ->
    case ?CALL(get_server_pid(), get_auto_key) of
        [] ->
            priv_gen_key(10);
        Key -> Key
    end.

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @end
%%--------------------------------------------------------------------
-spec(start_link() ->
    {ok, Pid :: pid()} | ignore | {error, Reason :: term()}).
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
-spec(init(Args :: term()) ->
    {ok, State :: #state{}} | {ok, State :: #state{}, timeout() | hibernate} |
    {stop, Reason :: term()} | ignore).
init([]) ->
    process_flag(trap_exit, true),
    State = init_server_key(),
%%    Ref = erlang:send_after(30 * 1000, self(), timer),
%%    put(timer, Ref),
    {ok, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @end
%%--------------------------------------------------------------------
-spec(handle_call(Request :: term(), From :: {pid(), Tag :: term()},
        State :: #state{}) ->
    {reply, Reply :: term(), NewState :: #state{}} |
    {reply, Reply :: term(), NewState :: #state{}, timeout() | hibernate} |
    {noreply, NewState :: #state{}} |
    {noreply, NewState :: #state{}, timeout() | hibernate} |
    {stop, Reason :: term(), Reply :: term(), NewState :: #state{}} |
    {stop, Reason :: term(), NewState :: #state{}}).

handle_call(get_unique_key, _From, State) ->
    {Key, List} = priv_unique_key(State#state.unique_key_list),
    {reply, Key, State#state{unique_key_list = List}};
handle_call(get_player_key, _From, State) ->
    {Key, List} = priv_player_key(State#state.unique_key_list),
    {reply, Key, State#state{unique_key_list = List}};
handle_call(get_auto_key, _From, State) ->
    {reply, State#state.auto_id + 1, State#state{auto_id = State#state.auto_id + 1}};
handle_call({apply, Module, Method, Args}, _From, State) ->
    Reply = apply(Module, Method, Args),
    {reply, Reply, State};
handle_call(_Request, _From, State) ->
    {reply, ok, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @end
%%--------------------------------------------------------------------
-spec(handle_cast(Request :: term(), State :: #state{}) ->
    {noreply, NewState :: #state{}} |
    {noreply, NewState :: #state{}, timeout() | hibernate} |
    {stop, Reason :: term(), NewState :: #state{}}).
handle_cast(_Request, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
-spec(handle_info(Info :: timeout() | term(), State :: #state{}) ->
    {noreply, NewState :: #state{}} |
    {noreply, NewState :: #state{}, timeout() | hibernate} |
    {stop, Reason :: term(), NewState :: #state{}}).

%%handle_info(timer, State) ->
%%    Ref = erlang:send_after(30 * 1000, self(), timer),
%%    put(timer, Ref),
%%    case config:is_debug() andalso config:is_center_node() of
%%        true -> ok;
%%        false ->
%%            F = fun(Key) -> replace_server_key(Key) end,
%%            lists:foreach(F, State#state.unique_key_list)
%%    end,
%%    {noreply, State};

handle_info(_Info, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
-spec(terminate(Reason :: (normal | shutdown | {shutdown, term()} | term()),
        State :: #state{}) -> term()).
terminate(_Reason, _State) ->
%%    case config:is_debug() andalso config:is_center_node() of
%%        true -> ok;
%%        false ->
%%            F = fun(Key) -> replace_server_key(Key) end,
%%            lists:foreach(F, _State#state.unique_key_list)
%%    end,
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
-spec(code_change(OldVsn :: term() | {down, term()}, State :: #state{},
        Extra :: term()) ->
    {ok, NewState :: #state{}} | {error, Reason :: term()}).
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

priv_gen_key(Len) ->
    Sn = config:get_server_num(),
    T1 = dyc_cross_platform:system_time(),
    T2 = dyc_cross_platform:system_time(),
    T3 = dyc_cross_platform:system_time(),
    T4 = string:sub_string(util:to_list(T1 + T2 + T3), 3, Len),
    util:to_integer(lists:concat([10000 + Sn, T4])).

priv_unique_key(KeyList) ->
    [Key | L] = lists:keysort(#key.unique_id, KeyList),
    NewKey = Key#key{unique_id = Key#key.unique_id + 1},
    replace_server_key(NewKey),
    Id = Key#key.sn * 10000000000000 + Key#key.unique_id + 1,
    {Id, [NewKey | L]}.

priv_player_key(KeyList) ->
    [Key | L] = lists:keysort(#key.player_id, KeyList),
    case config:is_debug() of
        true ->
            Id = Key#key.sn * 10000 + Key#key.player_id + 1;
        false ->
            Id = Key#key.sn * 100000 + Key#key.player_id + 1
    end,
    NewKey = Key#key{player_id = Key#key.player_id + 1},
    replace_server_key(NewKey),
    {Id, [NewKey | L]}.

init_server_key() ->
    case config:is_center_node() of
        true ->
            Key = #key{sn = config:get_server_num()},
            #state{unique_key_list = [Key]};
        false ->
            case db:get_all("select sn,unique_id,player_id from server_key") of
                [] ->
                    Key = #key{sn = config:get_server_num()},
                    replace_server_key(Key),
                    #state{unique_key_list = [Key]};
                Data ->
                    KeyList = [#key{sn = Sn, unique_id = UniqueId, player_id = PlayerId} || [Sn, UniqueId, PlayerId] <- Data],
                    #state{unique_key_list = KeyList}
            end
    end.


replace_server_key(Key) ->
    case config:is_debug() andalso config:is_center_node() of
        true -> ok;
        false ->
            Sql = io_lib:format("replace into server_key set sn=~p,unique_id=~p,player_id=~p", [Key#key.sn, Key#key.unique_id, Key#key.player_id]),
            db:execute(Sql)
    end.