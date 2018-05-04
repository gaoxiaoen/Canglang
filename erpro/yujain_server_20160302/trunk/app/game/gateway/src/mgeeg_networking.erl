%%%-------------------------------------------------------------------
%%% File        :mgeeg_networking.erl
%%%-------------------------------------------------------------------

-module(mgeeg_networking).

-define(TCP_OPTS, [
                   binary, 
                   {packet, 0},
                   {reuseaddr, true}, 
                   {nodelay, true},   
                   {delay_send, true}, 
                   {active, false},
                   {backlog, 1024},
                   {exit_on_close, false},
                   {send_timeout, 15000}
                  ]).

-include("mgeeg.hrl").
-include_lib("kernel/include/inet.hrl").

-export([
         tcp_listener_started/2, 
         tcp_listener_stopped/2
        ]).

-export([
         start_tcp_listener_sup/0,
         start_tcp_acceptor_sup/0,
         start_tcp_listener/2
         ]).

start_tcp_listener_sup() ->
    {ok, _} = supervisor:start_child(mgeeg_sup, {mgeeg_tcp_listener_sup,
                                                 {mgeeg_tcp_listener_sup, start_link, []},
                                                 transient, infinity, supervisor,
                                                 [mgeeg_tcp_listener_sup]}).

start_tcp_acceptor_sup() ->
    {ok, _} = supervisor:start_child(mgeeg_tcp_listener_sup, {mgeeg_tcp_acceptor_sup,
                                                 {mgeeg_tcp_acceptor_sup, start_link, []},
                                                 transient, infinity, supervisor,
                                                 [mgeeg_tcp_acceptor_sup]}).

start_tcp_listener(Port,AcceptorNum) ->
    AcceptorSup = mgeeg_tcp_acceptor_sup,
    OnStartup = {?MODULE, tcp_listener_started, [localhost]}, 
    OnShutdown = {?MODULE, tcp_listener_stopped, [localhost]},
    Param = {Port,AcceptorNum,?TCP_OPTS,AcceptorSup,OnStartup,OnShutdown},
    {ok, _} = supervisor:start_child(mgeeg_tcp_listener_sup, {Port,
                                                 {mgeeg_tcp_listener, start_link, [Param]},
                                                 transient, 100, worker,
                                                 [mgeeg_tcp_listener]}),
    ok.

tcp_listener_started(Host, Port) ->
    ?INFO_MSG("Port start listening ~w:~w", [Host, Port]),
    ok.

tcp_listener_stopped(Host, Port) ->
    ?INFO_MSG("Stop listening port ~w:~w", [Host, Port]),
    ok.
