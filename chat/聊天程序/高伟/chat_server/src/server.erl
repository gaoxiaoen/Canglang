%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 五月 2018 11:02
%%%-------------------------------------------------------------------
-module(server).
-author("Administrator").
-define(SERVERS_APPS, [sasl, chat_server_app]).

%% API
-export([chat_server_start/0, chat_server_stop/0]).

%%聊天服务器
chat_server_start() ->
  try
    ok = start_applications(?SERVERS_APPS)
  after
    timer:sleep(100)
  end.

%%停止聊天服务器
chat_server_stop() ->
  stop_applications(?SERVERS_APPS).


manage_applications(Iterate, Do, Undo, SkipError, ErrorTag, Apps) ->
  Iterate(fun (App, Acc) ->
                case Do(App) of
                  ok -> [App | Acc];
                  {error, {SkipError, _}} -> Acc;
                  {error, Reason} ->
                    lists:foreach(Undo, Acc),
                    throw({error, {ErrorTag, App, Reason}})
                end
          end, [], Apps),
  ok.

start_applications(Apps) ->
  manage_applications(fun lists:foldl/3,
                      fun application:start/1,
                      fun application:stop/1,
                      already_started,
                      cannot_start_application,
                      Apps).

stop_applications(Apps) ->
  manage_applications(fun lists:foldr/3,
                      fun application:stop/1,
                      fun application:start/1,
                      not_started,
                      cannot_stop_application,
                      Apps).