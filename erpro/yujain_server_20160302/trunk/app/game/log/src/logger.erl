%% Author: markycai<tomarky.cai@gmail.com>
%% Created: 2013-10-16
%% Description: TODO: Add description to logger
-module(logger).

-behaviour(application).
-include("logger.hrl").
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Behavioural exports
%% --------------------------------------------------------------------
-export([
         start/2,
    	 stop/1,
         start/0,
         stop/0
        ]).


-define(APPS, [sasl, logger]).

start() ->
    main_exec:do_status_log(?START_SERVER_STATUS_1),
    ok = common_misc:start_applications(?APPS),
    ok.

stop() ->
    ok = common_misc:stop_applications(?APPS).


%% ====================================================================
%% Internal functions
%% ====================================================================

start(normal,[])->
    case catch do_start() of
        {ok, PId} ->
            main_exec:do_status_log(?START_SERVER_STATUS_0),
            {ok, PId};
        Error ->
            main_exec:do_status_log(?START_SERVER_STATUS_99),
            erlang:throw(Error)
    end.
do_start() ->
    {ok,LSupPid} = logger_sup:start_link(),
    lists:foreach(
      fun ({Msg, Thunk}) ->
               io:format("starting ~-32s ...", [Msg]),
               Thunk(),
               io:format("done~n");
         ({Msg, M, F, A}) ->
              io:format("starting ~-20s ...", [Msg]),
              apply(M, F, A),
              io:format("done~n")
      end,[{"Start Inets Server",
            fun() -> 
                    inets:start()
            end},
           {"Server Logger Init",
            fun() ->
                    error_logger:add_report_handler(common_logger_h, ""),
                    common_loglevel:set(3),
                    common_config_dyn:reload(common),
    				common_config_dyn:reload(logger),
                    common_loglevel:set(common_config:get_log_level())
            end},
			{"Start Behavior Server",
            fun() ->
                    {ok, _BSupPid} = mgeeb_sup:start_link(),
                    behavior_serverlog:start()
            end},
           {"Mysql Server Connect Pool Start",
            fun() ->
                    crypto:start(),
                    application:start(emysql),
                    main_exec:do_status_log(?START_SERVER_STATUS_12)
            end}, 
           {"Start Monitor Server",
            fun() ->
                    mgeew_monitor_server:start_link(),
                    common_monitor_agent:start_link([]),
                    common_monitor_agent:set_monitor_line_msg(true),
                    common_monitor_agent:set_monitor_alert(true),
                    common_monitor_agent:set_monitor_sys(true)
            end}]),
    
    {ok, LSupPid}.

stop(_State) ->
    ok.