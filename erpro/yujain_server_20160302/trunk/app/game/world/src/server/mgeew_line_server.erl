%%%-------------------------------------------------------------------
%%% File        :mgeew_line_server.erl
%%% @doc
%%%     如果游戏配置了多个网关端口，此服务即是处理角色登录那一个分线的管理
%%% @end
%%%-------------------------------------------------------------------
-module(mgeew_line_server).

-behaviour(gen_server).
-include("mgeew.hrl").



%% --------------------------------------------------------------------
-export([
         start/0, 
         start_link/0,
         get_line/0
        ]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {}).

%% --------------------------------------------------------------------

start() ->
    {ok, _} = supervisor:start_child(mgeew_sup, {?MODULE,
                                                 {?MODULE, start_link, []},
                                                 transient, brutal_kill, worker, 
                                                 [?MODULE]}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% --------------------------------------------------------------------


%%获得一条分线给客户端，通常是负载最低的
get_line() ->
    gen_server:call(?MODULE, {get_line}).

%% --------------------------------------------------------------------
init([]) ->
    {ok, #state{}}.


%% --------------------------------------------------------------------

%%处理分线注册，如果在配置表里面没有对应的分线，则本次注册失败
handle_call({get_line},_From, State) ->
    case erlang:get(gateway_port_list) of
        undefined ->
            GatewayConfig = undefined;
        [] ->
            GatewayConfig = undefined;
        GatewayList ->
            RandomIndex = common_tool:random(1, erlang:length(GatewayList)),
            GatewayConfig = lists:nth(RandomIndex, GatewayList)
    end,
    {reply, GatewayConfig, State};

handle_call(Request, From, State) ->
    ?ERROR_MSG("unexpected call ~w from ~w", [Request, From]),
    Reply = ok,
    {reply, Reply, State}.


handle_cast(Msg, State) ->
    ?INFO_MSG("unexpected cast ~w", [Msg]),
    {noreply, State}.


handle_info(Info, State) ->
    ?DO_HANDLE_INFO(Info, State),
    {noreply, State}.


terminate(Reason, State) ->
    ?INFO_MSG("~w terminate : ~w, ~w", [self(), Reason, State]),
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% --------------------------------------------------------------------
do_handle_info({init_gateway_port,Host,Port}) ->
    do_init_gateway_port(Host,Port);


do_handle_info(Info) ->
    ?ERROR_MSG("receive unknown message,Info=~w",[Info]).


do_init_gateway_port(Host,Port) ->
    case erlang:get(gateway_port_list) of
        undefined ->
            erlang:put(gateway_port_list,[{Host,Port}]);
        GatewayList ->
            case lists:member({Host,Port},GatewayList) of
                true ->
                    ignore;
                _ ->
                    erlang:put(gateway_port_list,[{Host,Port}|GatewayList])
            end
    end.
