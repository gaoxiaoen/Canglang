%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%% 区域跨服服务
%%% @end
%%% Created : 25. 四月 2016 下午5:20
%%%-------------------------------------------------------------------
-module(cross_area).
-author("fancy").

-behaviour(gen_server).

%% API
-export([start_link/0]).
-include("common.hrl").
-include("server.hrl").

%% gen_server callbacks
-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).

-export([
    apply/3,
    apply_call/3,
    get_pid/0,
    reset/0,
    cross_area_node/1,
    check_cross_area_state/0,
    get_node/0
]).

-export([
    war_apply/3,
    war_apply_call/3,
    cross_war_node/1,
    check_cross_war_state/0
]).

-export([http_get_node/1]).

-define(SERVER, ?MODULE).
-define(RTIME, 60000).
-record(state, {heartbeat = none, node = none, war_node = none, ctime = 0, sn = 0, sn_name = <<>>}).

%%%===================================================================
%%% API
%%%===================================================================

get_pid() ->
    case get(?MODULE) of
        undefined ->
            Pid = misc:whereis_name(local, ?MODULE),
            if
                is_pid(Pid) ->
                    put(?MODULE, Pid);
                true ->
                    skip
            end,
            Pid;
        Pid ->
            Pid
    end.

reset() ->
    get_pid() ! reset.

get_node() ->
    ?CALL(get_pid(), cross_area_node).


apply(Module, Method, Args) ->
    ?CAST(get_pid(), {apply_cast, Module, Method, Args}),
    ok.

apply_call(Module, Method, Args) ->
    Node = ?CALL(get_pid(), cross_area_node),
    if Node == [] orelse Node == none -> [];
        true ->
            rpc:call(Node, Module, Method, Args)
    end.


war_apply(Module, Method, Args) ->
    ?CAST(get_pid(), {war_apply_cast, Module, Method, Args}),
    ok.

war_apply_call(Module, Method, Args) ->
    Node = ?CALL(get_pid(), cross_war_node),
    if Node == [] orelse Node == none -> [];
        true ->
            rpc:call(Node, Module, Method, Args)
    end.

cross_area_node(Node) ->
    get_pid() ! {node, Node}.

cross_war_node(Node) ->
    get_pid() ! {war_node, Node}.

%%检查跨服区域是否开启
check_cross_area_state() ->
    case ?CALL(get_pid(), cross_area_node) of
        [] -> false;
        none -> false;
        _ -> true
    end.

%%城战跨服节点是否开启
check_cross_war_state() ->
    case ?CALL(get_pid(), cross_war_node) of
        [] -> false;
        none -> false;
        _ -> true
    end.

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
init([]) ->
    Hb = erlang:send_after(5000, self(), heartbeat),
    put(timer_node, erlang:send_after(1000, self(), timer_node)),
    Sn = config:get_server_num(),
    Name = config:get_server_name(Sn),
    {ok, #state{heartbeat = Hb, sn = Sn, sn_name = Name}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
handle_call(_Request, _From, State) ->
    case catch do_call(_Request, _From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("cross area call err ~p~n", [Reason]),
            {reply, ok, State}
    end.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
handle_cast(_Request, State) ->
    case catch do_cast(_Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("cross area cast err ~p~n", [Reason]),
            {noreply, State}
    end.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
handle_info(_Info, State) ->
    case catch do_info(_Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("cross area info err ~p~n", [Reason]),
            {noreply, Reason}
    end.

%%--------------------------------------------------------------------
%% @private
%% @doc
terminate(_Reason, _State) ->
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
%%call
do_call(cross_area_node, _From, State) ->
    {reply, State#state.node, State};
do_call(cross_war_node, _From, State) ->
    {reply, State#state.war_node, State};
do_call(_msg, _from, State) ->
    {reply, ok, State}.

%%cast
do_cast({apply_cast, Module, Method, Args}, State) ->
    ?DO_IF(State#state.node /= none, rpc:cast(State#state.node, Module, Method, Args)),
    {noreply, State};
do_cast({war_apply_cast, Module, Method, Args}, State) ->
    ?DO_IF(State#state.war_node /= none, rpc:cast(State#state.war_node, Module, Method, Args)),
    {noreply, State};
do_cast(_msg, State) ->
    {noreply, State}.

%%info
do_info(heartbeat, State) ->
    Hb = erlang:send_after(?RTIME, self(), heartbeat),
    State2 = heartbeat(State),
    State3 = war_heartbeat(State2),
    {noreply, State3#state{heartbeat = Hb}};

do_info({node, Node}, State) ->
    NewState = State#state{node = Node, ctime = util:unixtime()},
    if State#state.node /= Node ->
        disconnect(State#state.node, ?CROSS_NODE_TYPE_AREA),
        {noreply, heartbeat(NewState)};
        true ->
            {noreply, NewState}
    end;

do_info({war_node, Node}, State) ->
    NewState = State#state{war_node = Node},
    if State#state.war_node /= Node ->
        disconnect(State#state.war_node, ?CROSS_NODE_TYPE_WAR),
        {noreply, war_heartbeat(NewState)};
        true ->
            {noreply, NewState}
    end;

do_info(timer_node, State) ->
    misc:cancel_timer(timer_node),
    put(timer_node, erlang:send_after(?RTIME, self(), timer_node)),
    NewState =
        case http_get_node(State#state.sn) of
            [] ->
                case config:is_debug() of
                    true ->
                        {_, State1} = handle_info({node, 'center1@127.0.0.1'}, State),
                        {_, State2} = handle_info({war_node, 'center1@127.0.0.1'}, State1),
                        State2;
                    false ->
                        State
                end;
            {NodeArea, NodeWar} ->
                {_, State1} = handle_info({node, NodeArea}, State),
                {_, State2} = handle_info({war_node, NodeWar}, State1),
                State2
        end,
    {noreply, NewState};

do_info(reset, State) ->
    {noreply, State#state{node = none, war_node = none}};
do_info(_msg, State) ->
    {noreply, State}.




get_cross_cookie() ->
    'cl168arpg'.


heartbeat(State) ->
    case State#state.node of
        none -> State;
        _ ->
            Node = State#state.node,
            Sn = State#state.sn,
            SnName = State#state.sn_name,
            case net_adm:ping(Node) of
                pang ->
                    Cookie = get_cross_cookie(),
                    erlang:set_cookie(Node, Cookie),
                    case net_kernel:connect_node(Node) of
                        true ->
                            ?PRINT("connect cross_area ~p~n", [Node]),
                            WorldLv = rank:get_world_lv(),
                            MaxLv = rank:get_player_max_lv(),
                            SnList = cross_all:merge_sn_list(),
                            rpc:cast(Node, center, game_area_to_center, [Sn, SnName, node(), config:get_opening_time(), config:is_debug(), WorldLv, MaxLv, SnList]),
                            State;
                        _ERR ->
                            net_kernel:disconnect(Node),
                            State#state{node = none, ctime = 0}
                    end;
                pong ->
                    WorldLv = rank:get_world_lv(),
                    MaxLv = rank:get_player_max_lv(),
                    SnList = cross_all:merge_sn_list(),
                    rpc:cast(Node, center, game_area_to_center, [Sn, SnName, node(), config:get_opening_time(), config:is_debug(), WorldLv, MaxLv, SnList]),
                    State
            end
    end.



war_heartbeat(State) ->
    case State#state.war_node of
        none -> State;
        _ ->
            Node = State#state.war_node,
            Sn = config:get_server_num(),
            SnName = State#state.sn_name,
            case net_adm:ping(Node) of
                pang ->
                    Cookie = get_cross_cookie(),
                    erlang:set_cookie(Node, Cookie),
                    case net_kernel:connect_node(Node) of
                        true ->
                            ?PRINT("connect cross_war_node ~p~n", [Node]),
                            WorldLv = rank:get_world_lv(),
                            SnList = cross_all:merge_sn_list(),
                            rpc:cast(Node, center, game_war_to_center, [Sn, SnName, node(), config:get_opening_time(), config:is_debug(), WorldLv, SnList]),
                            State;
                        _ERR ->
                            net_kernel:disconnect(Node),
                            State#state{war_node = none, ctime = 0}
                    end;
                pong ->
                    WorldLv = rank:get_world_lv(),
                    SnList = cross_all:merge_sn_list(),
                    rpc:cast(Node, center, game_war_to_center, [Sn, SnName, node(), config:get_opening_time(), config:is_debug(), WorldLv, SnList]),
                    State
            end
    end.



disconnect(none, _Type) -> ok;
disconnect(Node, Type) ->
    case net_adm:ping(Node) of
        pang ->
            ok;
        pong ->
            case net_kernel:connect_node(Node) of
                true ->
                    rpc:cast(Node, center, center_del_node, [Node, Type]);
                _ERR ->
                    ok
            end
    end,
    net_kernel:disconnect(Node).

http_get_node(Sn) ->
    ApiUrl =
%%        "http://localhost",
    config:get_api_url(),
    Url = lists:concat([ApiUrl, "/cross_server.php"]),
    U0 = io_lib:format("?act=search&sid=~p", [Sn]),
    U = lists:concat([Url, U0]),
    Result = httpc:request(get, {U, []}, [{timeout,2000}], []),
    Ret =
    case Result of
        {ok, {_, _, Body}} ->
            case rfc4627:decode(Body) of
                {ok, {obj, Data}, _} ->
                    case lists:keyfind("data", 1, Data) of
                        {_, {obj, List}} ->
                            Node2 =
                                case lists:keyfind("node2", 1, List) of
                                    false -> none;
                                    {_, Val} ->
                                        util:to_atom(Val)
                                end,
                            Node3 =
                                case lists:keyfind("node3", 1, List) of
                                    false -> none;
                                    {_, Val1} ->
                                        util:to_atom(Val1)
                                end,
                            {Node2, Node3};
                        _ -> []
                    end;
                _ -> []
            end;
        _ ->
            []
    end,
    case Ret of
        [] ->
            case config:is_debug() of
                true ->
                    {'center1@127.0.0.1','center1@127.0.0.1'};
                _ ->
                    []
            end;
        _R ->
            Ret
    end.