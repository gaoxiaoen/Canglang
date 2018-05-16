%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%% 全跨域服务
%%% @end
%%% Created : 25. 四月 2016 下午5:21
%%%-------------------------------------------------------------------
-module(cross_all).
-author("fancy").

-behaviour(gen_server).

%% API
-export([start_link/0]).
-include("server.hrl").
-include("common.hrl").

%% gen_server callbacks
-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).

-export([apply/3, apply_call/3, get_pid/0, check_cross_all_state/0, reset/0, get_node/0]).
-export([merge_sn_list/0]).

-define(SERVER, ?MODULE).
-define(RTIME, 10000).
-record(state, {heartbeat = none, node = none, ctime = 0, sn = 0, sn_name = <<>>, open_time = 0}).

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

apply(Module, Method, Args) ->
    ?CAST(get_pid(), {apply_cast, Module, Method, Args}),
    ok.

apply_call(Module, Method, Args) ->
    Node = ?CALL(get_pid(), cross_all_node),
    if Node == [] orelse Node == none -> [];
        true ->
            rpc:call(Node, Module, Method, Args)
    end.


%%检查 全跨服是否开启
check_cross_all_state() ->
    case ?CALL(get_pid(), cross_all_node) of
        [] -> false;
        none -> false;
        _ -> true
    end.

%%
get_node() ->
    ?CALL(get_pid(), cross_all_node).


reset() -> get_pid() ! reset.
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
    {ok, #state{heartbeat = Hb}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
handle_call(cross_all_node, _From, State) ->
    {reply, State#state.node, State};
handle_call(_Request, _From, State) ->
    {reply, ok, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
handle_cast({apply_cast, Module, Method, Args}, State) ->
    ?DO_IF(State#state.node /= none, rpc:cast(State#state.node, Module, Method, Args)),
    {noreply, State};
handle_cast(_Request, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages


handle_info(_Info, State) ->
    case catch do_info(_Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("cross all info err ~p~n", [Reason]),
            {noreply, State}
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
do_info(heartbeat, State) ->
    Hb = erlang:send_after(?RTIME, self(), heartbeat),
    Sn = ?IF_ELSE(State#state.sn == 0, config:get_server_num(), State#state.sn),
    SnName = ?IF_ELSE(State#state.sn_name == <<>>, config:get_server_name(Sn), State#state.sn_name),
    OpenTime = config:get_opening_time(),
    State2 = heartbeat(State#state{sn = Sn, sn_name = SnName, open_time = OpenTime}),
    {noreply, State2#state{heartbeat = Hb}};

do_info(reset, State) ->
    {noreply, State#state{node = none}};

do_info(_msg, State) ->
    {noreply, State}.



get_cross_cookie() ->
    'cl168arpg'.


heartbeat(State) ->
    Sn = State#state.sn,
    SnName = State#state.sn_name,
    Now = util:unixtime(),
    Node = cross_node:cross_all_node(),
    if Now > State#state.open_time ->
        case config:is_debug() of
            true ->
                case lists:member(Sn, server_list()) of
                    false ->
                        State;
                    true ->
                        check_connect(State, Node, Sn, SnName, Now)
                end;
            false ->
                check_connect(State, Node, Sn, SnName, Now)
        end;
        true -> State
    end.

%%版本开发服列表
server_list() ->
    case version:get_lan_config() of
        chn ->
            [20001, 30001, 30010, 30009, 30098, 30100, 20005, 20185, 30066, 30099, 39410, 1, 50001, 50002, 30004, 30050];
        fanti -> [30015];
        korea -> [30024, 30025, 31000, 30033];
        vietnam -> [30030];
        bt -> [30031, 30051, 30034, 30040, 30052, 30041];
        _ -> []
    end.

%%检查连接
check_connect(State, Node, Sn, SnName, Now) ->
    case net_adm:ping(Node) of
        pang ->
            Cookie = get_cross_cookie(),
            erlang:set_cookie(Node, Cookie),
            case net_kernel:connect_node(Node) of
                true ->
                    WorldLv = rank:get_world_lv(),
                    {AccLogin, Cbp} = cron_login:get_cron_login(),
                    SnList = merge_sn_list(),
                    OpenTime = config:get_opening_time(),
                    IsDebug = config:is_debug(),
                    rpc:cast(Node, center, game_all_to_center, [Sn, SnName, node(), OpenTime, IsDebug, WorldLv, SnList, Cbp, AccLogin]),
                    State#state{node = Node, ctime = Now};
                _ERR ->
                    net_kernel:disconnect(Node),
                    State#state{node = none, ctime = 0}
            end;
        pong ->
            WorldLv = rank:get_world_lv(),
            {AccLogin, Cbp} = cron_login:get_cron_login(),
            SnList = merge_sn_list(),
            OpenTime = config:get_opening_time(),
            IsDebug = config:is_debug(),
            rpc:cast(Node, center, game_all_to_center, [Sn, SnName, node(), OpenTime, IsDebug, WorldLv, SnList, Cbp, AccLogin]),
            State#state{node = Node, ctime = Now}
    end.


merge_sn_list() ->
    F = fun(Ets) -> Ets#merge_sn.sn end,
    lists:map(F, ets:tab2list(?ETS_MERGE_SN)).

