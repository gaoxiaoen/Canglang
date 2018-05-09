-behaviour([gen_server]).

-file("rabbit_node_monitor.erl", 1).



start_link() ->
    gen_server:start_link({local,rabbit_node_monitor},
                          rabbit_node_monitor,
                          [],
                          []).

init([]) ->
    ok = net_kernel:monitor_nodes(true),
    {ok,no_state}.

handle_call(_Request, _From, State) ->
    {noreply,State}.

handle_cast(_Msg, State) ->
    {noreply,State}.

handle_info({nodeup,Node}, State) ->
    rabbit_log:info("node ~p up", [Node]),
    {noreply,State};
handle_info({nodedown,Node}, State) ->
    rabbit_log:info("node ~p down", [Node]),
    ok = rabbit_networking:on_node_down(Node),
    ok = rabbit_amqqueue:on_node_down(Node),
    {noreply,State};
handle_info(_Info, State) ->
    {noreply,State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok,State}.

module_info() ->
    erlang:get_module_info(rabbit_node_monitor).

module_info(X) ->
    erlang:get_module_info(rabbit_node_monitor, X).

