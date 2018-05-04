%%%-------------------------------------------------------------------
%%% File        :mgeeg_tcp_acceptor.erl
%%%-------------------------------------------------------------------
-module(mgeeg_tcp_acceptor).

-include("mgeeg.hrl").

-behaviour(gen_server).

-export([start_link/1]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).


-define(CROSS_DOMAIN_FLAG, <<60,112,111,108,105,99,121,45,102,105,108,101,45,114,101,113,117,101,115,116,47,62,0>>).


-define(CROSS_FILE, "<?xml version=\"1.0\"?>\n<!DOCTYPE cross-domain-policy SYSTEM "
        ++"\"http://www.adobe.com/xml/dtds/cross-domain-policy.dtd\">\n"
        ++"<cross-domain-policy>\n"
        ++"<allow-access-from domain=\"*\" to-ports=\"*\"/>\n"
        ++"</cross-domain-policy>\n\0").

-record(state, {port = 0,listen_socket, ref}).

%%--------------------------------------------------------------------

start_link({ProcessName,Port, LSock}) ->
    gen_server:start_link({local,ProcessName},?MODULE, {Port, LSock}, []).

%%--------------------------------------------------------------------

init({Port, LSock}) ->
    erlang:process_flag(trap_exit, true),
    {ok, #state{listen_socket=LSock,port = Port}}.

handle_info({event, start}, State) ->
    accept(State);

handle_info({inet_async, LSock, Ref, {ok, Sock}}, #state{listen_socket=LSock, ref=Ref, port=Gateway} = State) ->
    %% patch up the socket so it looks like one we got from
    %% gen_tcp:accept/1
    {ok, Mod} = inet_db:lookup_socket(LSock),
    inet_db:register_socket(Sock, Mod),
    try        
        %% report
        {ok, {Address, Port}} = inet:sockname(LSock),
        {ok, {PeerAddress, PeerPort}} = inet:peername(Sock),
        ?DEBUG("accepted TCP connection on ~s:~p from ~s:~p~n",
                    [inet_parse:ntoa(Address), Port,
                     inet_parse:ntoa(PeerAddress), PeerPort]),
        spawn_socket_controller(Sock,Gateway)
    catch Error:Reason ->
            gen_tcp:close(Sock),
            ?ERROR_MSG("unable to accept TCP connection: ~p ~p~n", [Error, Reason])
    end,
    accept(State);
handle_info({inet_async, LSock, Ref, {error, closed}}, #state{listen_socket=LSock, ref=Ref} = State) ->
    %% It would be wrong to attempt to restart the acceptor when we
    %% know this will fail.
    {stop, normal, State};

handle_info({'EXIT', _, shutdown}, State) ->    
    {stop, normal, State};
handle_info({'EIXT', _, _Reason}, State) ->
    {stop, normal, State};


handle_info(Info, State) ->
    ?ERROR_MSG("receive unknown message,Info=~w",[Info]),
    {noreply, State}.


handle_call(_Request, _From, State) ->
    {noreply, State}.


handle_cast(Msg, State) ->
    ?INFO_MSG("get msg from handle_case/2 ~w ~w", [Msg, State]),
    {noreply, State}.


terminate(Reason, _State) ->
    ?DEBUG("acceptor process terminate.:~w", [Reason]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


send_cross_domain_policy(ClientSock) -> 
    Data = list_to_binary(?CROSS_FILE),
    gen_tcp:send(ClientSock, Data),
    gen_tcp:close(ClientSock).

spawn_socket_controller(ClientSock,Port) ->
    case common_config_dyn:find_common(agent_name) of
        ["qq"]->
            Len = 0;
        _->
            Len=25
    end,
    case gen_tcp:recv(ClientSock, Len, 30000) of
        {ok, ?CROSS_DOMAIN_FLAG} ->
            send_cross_domain_policy(ClientSock);
        {ok, _Bin} ->
            mgeeg_tcp_client:start(ClientSock, Port);
        Other ->
            ?ERROR_MSG("recv packet error:~w", [Other]),
            catch gen_tcp:close(ClientSock)
    end.

accept(#state{listen_socket=LSock} = State) ->
    case prim_inet:async_accept(LSock, -1) of
        {ok, Ref} -> 
            {noreply, State#state{ref=Ref}};
        Error -> 
            {stop, {cannot_accept, Error}, State}
    end.
