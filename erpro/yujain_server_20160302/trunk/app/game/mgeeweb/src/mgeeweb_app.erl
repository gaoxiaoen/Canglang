%% @author author <author@example.com>
%% @copyright YYYY author.

%% @doc Callbacks for the mgeeweb application.

-module(mgeeweb_app).
-author('author <author@example.com>').

-behaviour(application).
-export([start/2, stop/1]).


%% @spec start(_Type, _StartArgs) -> ServerRet
%% @doc application start callback for mgeeweb.
start(_Type, _StartArgs) ->
    mgeeweb_deps:ensure(),
    {ok, SupPid} = mgeeweb_sup:start_link(),
    lists:foreach(
      fun ({Msg, Thunk}) ->
               io:format("starting ~-32s ...", [Msg]),
               Thunk(),
               io:format("done~n");
         ({Msg, M, F, A}) ->
              io:format("starting ~-20s ...", [Msg]),
              apply(M, F, A),
              io:format("done~n")
      end,
      [
       {"mgeeweb - Logger",
        fun() ->
                error_logger:add_report_handler(common_logger_h, ""),
                common_config_dyn:reload(common),
                common_loglevel:set(common_config:get_log_level())
        end},
       {"Common Config init",
        fun() ->
                common_config_dyn:init(common)
        end}
      ]), 
    {ok, SupPid}.

%% @spec stop(_State) -> ServerRet
%% @doc application stop callback for mgeeweb.
stop(_State) ->
    ok.


%%
%% Tests
%%
-include_lib("eunit/include/eunit.hrl").
-ifdef(TEST).
-endif.
