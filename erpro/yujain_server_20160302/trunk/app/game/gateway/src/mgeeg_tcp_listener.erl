%%%-------------------------------------------------------------------
%%% File        :mgeeg_tcp_listener.erl
%%%-------------------------------------------------------------------

-module(mgeeg_tcp_listener).

-behaviour(gen_server).

-include("mgeeg.hrl").

-export([start_link/1]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-record(state, {sock, on_startup, on_shutdown}).

%%--------------------------------------------------------------------

start_link({Port, AcceptorCount, SocketOpts, AcceptorSup, OnStartup, OnShutdown}) ->
    Name = erlang:list_to_atom(lists:concat(["tcp_listener_",Port])),
    gen_server:start_link({local,Name},?MODULE, {Port, SocketOpts,AcceptorCount, AcceptorSup,OnStartup, OnShutdown}, []).

%%--------------------------------------------------------------------

init({Port, SocketOpts,AcceptorCount, AcceptorSup,{M,F,A} = OnStartup, OnShutdown}) ->
    erlang:process_flag(trap_exit, true),
    case gen_tcp:listen(Port, SocketOpts ++ [{active, false}]) of
        {ok, LSock} ->
            %% if listen successful ,we start several acceptor to accept it
            lists:foreach(
              fun (Index) ->
                       ProcessName = erlang:list_to_atom(lists:concat(["tcp_acceptor_",Port,"_",Index])),
                       NewId = 10000000 +  Port * 100 + Index,
                       ChildSpec = {NewId, {mgeeg_tcp_acceptor,start_link,[{ProcessName,Port,LSock}]},
                                    transient, brutal_kill, worker,[mgeeg_tcp_acceptor]},
                       {ok, APid} = supervisor:start_child(AcceptorSup, ChildSpec),
                       APid ! {event, start}
              end,lists:seq(1, AcceptorCount, 1)),
            apply(M, F, A ++ [Port]),
            {ok, #state{sock = LSock, on_startup = OnStartup, on_shutdown = OnShutdown}};
        {error, Reason} ->
            ?ERROR_MSG(
            "failed to start ~s on port:~w - ~w~n",
            [?MODULE, Port, Reason]),
            {stop, {cannot_listen, Port, Reason}}
    end.

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info({'EXIT', _, Reason}, State) ->
    ?ERROR_MSG("listener stop ~w ", [Reason]),
    {stop, normal, State};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(Reason, #state{sock=LSock, on_shutdown = {M,F,_A}}) ->
    {ok, {IPAddress, Port}} = inet:sockname(LSock),
    gen_tcp:close(LSock),
    ?INFO_MSG("stopped ~s on ~s:~w, reason:~w", [?MODULE, inet_parse:ntoa(IPAddress), Port, Reason]),
    apply(M, F, [IPAddress, Port]).

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
