%%%-------------------------------------------------------------------
%%% File        :common_line.erl
%%%-------------------------------------------------------------------
-module(common_line).

-include("common.hrl").
-include("common_server.hrl").

%% API
-export([get_exit_info/1]).

get_exit_info(Key) ->
    ErrorList = [
                 {server_shutdown, {10001, ?_LANG_GATEWAY_001}},
                 {login_again, {10002, ?_LANG_GATEWAY_002}},
                 {not_valid_client, {10003, ?_LANG_GATEWAY_000}},
                 {error_auth_packet, {10004, ?_LANG_GATEWAY_003}},
                 {error_auth_key, {10005, ?_LANG_GATEWAY_004}},
                 {fcm_kick_off, {10006, ?_LANG_GATEWAY_005}},
                 {world_register_failed, {10007, ?_LANG_GATEWAY_001}},
                 {mgeem_router_not_found, {10008, ?_LANG_GATEWAY_001}},
                 {mgeew_role_register_not_run, {10009, ?_LANG_GATEWAY_001}},
                 {too_many_packet, {10010, ?_LANG_GATEWAY_006}},
                 {no_heartbeat, {10011, ?_LANG_GATEWAY_006}},
                 {tcp_error, {10012, ?_LANG_GATEWAY_006}},
                 {tcp_closed, {10013, ?_LANG_GATEWAY_001}},
                 {admin_kick, {10014, ?_LANG_GATEWAY_007}},
                 {tcp_send_error, {10015, ?_LANG_GATEWAY_006}},
                 {fcm_kick_off_not_enough_off_time, {10017, ?_LANG_GATEWAY_008}},
                 {enter_map_failed, {10016, ?_LANG_GATEWAY_001}},
                 {bag_data_error, {10018, ?_LANG_GATEWAY_009}},
                 {login_again_timeout, {10019, ?_LANG_GATEWAY_010}},
                 {login_again_error, {10020, ?_LANG_GATEWAY_011}},
                 {no_heartbeat, {10021, ?_LANG_GATEWAY_012}},
                 {first_enter_map_error, {10022, ?_LANG_GATEWAY_001}},
                 {enter_map_error, {10023, ?_LANG_GATEWAY_001}},
                 {platform_error, {10024, ?_LANG_GATEWAY_001}},
                 {platform_admin_error, {10025, ?_LANG_GATEWAY_001}},
                 {limit_account_error, {10026, ?_LANG_GATEWAY_013}},
                 {limit_ip_error, {10027, ?_LANG_GATEWAY_014}},
				 {limit_device_id_error, {10028, ?_LANG_GATEWAY_015}}
		],
    lists:keyfind(Key, 1, ErrorList).
