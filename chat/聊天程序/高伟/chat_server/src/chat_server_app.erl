%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 五月 2018 10:55
%%%-------------------------------------------------------------------
-module(chat_server_app).
-author("Administrator").
-include("record.hrl").
-include("common.hrl").

-behaviour(application).

-export([start/2,
  stop/1]).

start(normal, [])  ->
  [Ip, Port, Sid] = init:get_plain_arguments(),
  {ok, SupPid} = server_sup:start_link(),
  start_client(),
  start_tcp(6666),
  ets:new(?ETS_ONLINE, [{keypos,#ets_online.id}, named_table, public, set]),
  {ok, SupPid}.

stop(_State) ->
  ok.

%%开启客户端监控树
start_client() ->
  {ok, _} = supervisor:start_child(
    server_sup,
    {tcp_reader_sup,
      {tcp_reader_sup, start_link, []},
      transient, infinity, supervisor, [tcp_reader_sup]}
  ).

%%开启TCP监控树
start_tcp(Port) ->
  {ok, _} = supervisor:start_child(
    server_sup,
    {tcp_listen_sup,
      {tcp_listener_sup, start_link, [Port]},
      transient, infinity, supervisor, [tcp_listener_sup]}
  ).