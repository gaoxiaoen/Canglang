%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 五月 2018 14:23
%%%-------------------------------------------------------------------
-module(tcp_listener).
-author("Administrator").

-behaviour(gen_server).
-include("common.hrl").

%% API
-export([start_link/2]).

%% gen_server callbacks
-export([init/1,
  handle_call/3,
  handle_cast/2,
  handle_info/2,
  terminate/2,
  code_change/3]).

-define(SERVER, ?MODULE).

start_link(AcceptorCount, Port) ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [AcceptorCount, Port], []).

init([AcceptorCount, Port]) ->
  process_flag(trap_exit, true),
  case gen_tcp:listen(Port, ?TCP_OPTIONS) of
    {ok, LSock} ->
      lists:foreach(fun (_) ->
        {ok, _APid} = supervisor:start_child(
          tcp_acceptor_sup, [LSock])
                    end,
        lists:duplicate(AcceptorCount, dummy)),
      {ok, LSock};
    {error, Reason} ->
      {stop, {cannot_listen, Reason}}
  end.

handle_call(_Request, _From, State) ->
  {reply, ok, State}.

handle_cast(_Request, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  gen_tcp:close(_State),
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.