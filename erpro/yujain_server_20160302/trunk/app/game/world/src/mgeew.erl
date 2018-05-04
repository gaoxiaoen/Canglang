%%%-------------------------------------------------------------------
%%% File        :mgeew.erl
%%% @doc
%%%     游戏启动入口
%%% @end
%%%-------------------------------------------------------------------

-module(mgeew).

-behaviour(application).
-include("mgeew.hrl").

-export([
		 start/2,
		 stop/1,
		 start/0,
		 stop/0
		]).

-define(APPS, [sasl, mgeew]).

%% --------------------------------------------------------------------
 
start() ->
    main_exec:do_status_log(?START_SERVER_STATUS_1),
    ok = common_misc:start_applications(?APPS),
    ok.

stop() ->
    ok = common_misc:stop_applications(?APPS).


%% --------------------------------------------------------------------
start(normal, []) ->
    case catch do_start() of
        {ok, PId} ->
            main_exec:do_status_log(?START_SERVER_STATUS_0),
            {ok, PId};
        Error ->
            main_exec:do_status_log(?START_SERVER_STATUS_99),
            erlang:throw(Error)
    end.
do_start() ->
    {ok, WSupPid} = mgeew_sup:start_link(), 
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
       {"Start Inets Server",
        fun() -> 
                inets:start() 
        end},
       {"World Logger Init",
        fun() ->
                error_logger:add_report_handler(common_logger_h, ""),
                common_loglevel:set(3),
                common_config_dyn:reload(common),
                common_loglevel:set(common_config:get_log_level())
        end},
       {"Init Global ETS",
        fun() -> 
                common_role:init_global_ets()
        end},
       {"Init System Log Server",
        fun() -> 
                logger_sender:start(),
                logger_connector:start(),
                main_exec:do_status_log(?START_SERVER_STATUS_8)
        end},
       %% db 节点
       {"Start DB Server",
        fun() -> 
                db_sup:start_link(),
                db_migration_server:start(),
                db_mnesia:init(),
                main_exec:do_status_log(?START_SERVER_STATUS_2)
        end},
       
       %% behavior节点
       {"Start Behavior Server",
        fun() ->
                {ok, _BSupPid} = mgeeb_sup:start_link(),
                behavior_serverlog:start()
        end},
      
       %% mgeeweb节点
       {"Start MOCHIWEB Server",
        fun() ->
                mgeeweb_deps:ensure(),
                {ok, _WebSupPid} = mgeeweb_sup:start_link(),
                main_exec:do_status_log(?START_SERVER_STATUS_7)
        end},
       
       {"Start Login Server",
        fun() ->
                mgeew_account_server:start(),
                mgeew_line_server:start(),
                main_exec:do_status_log(?START_SERVER_STATUS_9)
        end},
       
       %% chat 节点
       {"Start Chat Server",
        fun() ->
                {ok, _CSupPId} = chat_sup:start_link(),
                chat_channel_sup:start(),
                chat_misc:start_common_channel(),
                chat_goods_cache_server:start(),
                main_exec:do_status_log(?START_SERVER_STATUS_3)
        end},
        
       %% world节点
       {"Start World Business Server",
        fun() ->
                mgeew_init_server:start(),
                mgeew_role_sup:start(),
                mgeew_pay_server:start(),
				
                mgeew_letter_server:start(),
                
                family_sup:start_link(),
                family_manager_server:start(),
                
                mgeew_broadcast_server:start(),
				mgeew_ranking_server:start(),
				mgeew_memory_server:start(),
				main_exec:do_status_log(?START_SERVER_STATUS_4)
        end},
       %% mgeem 节点
       {"Start Map Server",
        fun() ->
                {ok, _SupPid} = mgeem_sup:start_link(),
                mgeem_map_sup:start(),
                case catch mod_map:init_game_maps() of
                    init_map_error ->
                        main_exec:do_status_log(?START_SERVER_STATUS_10),
                        erlang:throw(init_map_error);
                    _ ->
                        next
                end,
                main_exec:do_status_log(?START_SERVER_STATUS_5)
        end},
       {"Start Player SocketData Logger",
        fun() ->
                mgeew_packet_logger:start()
        end},
       %% gateway 节点
       {"Start Gateway Server",
        fun() ->
                {ok, _SupPid} = mgeeg_sup:start_link(),
                [[{_IntranetIP,ExternalIP,PortList}|_]] = common_config_dyn:find_common(gateway),
                mgeeg_global_server:start(),
                mgeeg_role_sock_map:start(),
                mgeeg_networking:start_tcp_listener_sup(),
                mgeeg_networking:start_tcp_acceptor_sup(),
                [begin 
                     mgeeg_unicast:start(Port), 
                     catch erlang:send(mgeew_line_server,{init_gateway_port,ExternalIP,Port}),
                     ok = mgeeg_networking:start_tcp_listener(Port,30),
                     ok
                 end|| Port <- PortList],
                main_exec:do_status_log(?START_SERVER_STATUS_6)
        end},
       {"Start Monitor Server",
        fun() ->
                mgeew_monitor_server:start_link(),
                common_monitor_agent:start_link([]),
                common_monitor_agent:set_monitor_line_msg(true),
                common_monitor_agent:set_monitor_alert(true),
                common_monitor_agent:set_monitor_sys(true),
                common_monitor_agent:set_monitor_mnesia(true)
        end},
       {"Init Server Data",
        fun() ->
				common_misc:gen_system_config_beam(),
                common_misc:gen_limit_account_beam(),
                common_misc:gen_limit_ip_beam(),
				common_misc:gen_limit_device_id_beam(),
                main_exec:do_status_log(?START_SERVER_STATUS_11)
        end}
      ]
     ),
    {ok, WSupPid}.

%% --------------------------------------------------------------------
stop(_State) ->
    ok.

