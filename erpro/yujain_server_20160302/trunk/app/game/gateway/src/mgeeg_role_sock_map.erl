%%%-------------------------------------------------------------------
%%% File        :mgeeg_role_sock_map.erl
%%%-------------------------------------------------------------------

-module(mgeeg_role_sock_map).

-behaviour(gen_server).

-include("mgeeg.hrl").

-export([start/0,start_link/0]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {}).

%% ====================================================================
start() -> 
    {ok, _} = supervisor:start_child(mgeeg_sup, 
                                     {mgeeg_role_sock_map,
                                      {mgeeg_role_sock_map, start_link, []},
                                      permanent, 1000, worker, 
                                      [mgeeg_role_sock_map]}).


start_link()->
    gen_server:start_link({local,?MODULE},?MODULE,[],[]).


%% --------------------------------------------------------------------
init([]) ->
    ets:new(mgeeg_role_sock_map, [set,protected,named_table]),
    {ok, #state{}}.

%% --------------------------------------------------------------------

handle_call(shutdown, _, State) ->
    do_shutdown(),
    {reply, ok, State};

handle_call(_, _, State) ->
    {reply, ok, State }.

%% --------------------------------------------------------------------
handle_cast(_Msg, State) ->
    {noreply, State}.

%% --------------------------------------------------------------------
handle_info({role, RoleId, PId}, State) ->
    case ets:info(mgeeg_role_sock_map) of
        undefined ->
            ets:new(mgeeg_role_sock_map, [set,protected,named_table]);
        _ ->
            nil
    end,
    ets:insert(mgeeg_role_sock_map, {RoleId,PId}),
    {noreply, State};


handle_info({erase,RoleId,_PId}, State) ->
    case ets:info(mgeeg_role_sock_map) of
        undefined ->
            ets:new(mgeeg_role_sock_map, [set,protected,named_table]);
        _ ->
            ets:delete(mgeeg_role_sock_map, RoleId)
    end,
    {noreply, State};
handle_info(_Info, State) ->
    {noreply, State}.

%% --------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%% --------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% --------------------------------------------------------------------

do_shutdown() ->
    List = ets:tab2list(mgeeg_role_sock_map),
    lists:foreach(
      fun({_RoleId, PId}) ->
              case erlang:is_pid(PId) of
                  true ->
                      erlang:monitor(process, PId),
                      PId ! {error_exit, server_shutdown},
                      receive
                          {'DOWN', _, process, _, _} ->
                              ok
                          after 
                              10000 ->
                              ?ERROR_MSG("Shutdown Timeout :~w", [erlang:process_info(PId)])
                      end;
                  false ->
                      ignore
              end
      end, List).
                      
