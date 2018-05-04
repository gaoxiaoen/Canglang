%%%-------------------------------------------------------------------
%%% File        :common_reloader.erl
%%%-------------------------------------------------------------------
-module(common_reloader).

-include("common.hrl").
-include("common_server.hrl").
%% API
-export([
         reload_module/1,
         reload_config/1,
         reload_shop/0
        ]).

-export([
         stop_game/0,
         stop_game_kick_role/0
        ]).

reload_shop()->
    catch erlang:send(mgeew_shop_server, reset_shops).

reload_config(File) ->
    lists:foreach(fun(Node) -> rpc:call(Node, common_config_dyn, init, [File]) end, [node() |nodes()]).

reload_module(Module) ->
    lists:foreach(fun(Node) -> rpc:call(Node, c, l, [Module]) end, [node() |nodes()]).


%% 停服
stop_game() ->
    stop_game_pre_handle(),
    ?ERROR_MSG("~ts",["Kick all role start."]),
    Node = erlang:node(),
    rpc:call(Node, mgeeg_ctl, process, [["kick_all_role"]]),
    ?ERROR_MSG("~ts",["Kick all role completed."]),
    timer:sleep(3000),
    ?ERROR_MSG("~ts",["Game Database dump data start."]),
    rpc:call(Node, mnesia, dump_log, []),
    ?ERROR_MSG("~ts",["Game Database dump data completed."]),
    ok.
%% 停止游戏预处理
stop_game_pre_handle() ->
    file:write_file(common_config:get_server_dir() ++ "/platform.lock", ?_LANG_GAME_MAINTAIN, [binary]),
    file:write_file(common_config:get_server_dir() ++ "/platform.admin.lock", ?_LANG_GAME_MAINTAIN, [binary]),
    lists:foreach(
      fun(N) ->
              M = common_lang:get_format_lang_resources(common_config:get_stop_prepare_msg(), [common_tool:to_list(N)]),
              common_broadcast:bc_send_msg_world(?BC_MSG_TYPE_WORLD, ?BC_MSG_SUB_TYPE_NONE, M),
              timer:sleep(1000)
      end, lists:reverse(lists:seq(1, common_config:get_stop_prepare_second()))).

%% 踢人关入口
stop_game_kick_role() ->
    file:write_file(common_config:get_server_dir() ++ "/platform.lock", ?_LANG_GAME_MAINTAIN, [binary]),
    file:write_file(common_config:get_server_dir() ++ "/platform.admin.lock", ?_LANG_GAME_MAINTAIN, [binary]),
    lists:foreach(
      fun(N) ->
              M = common_lang:get_format_lang_resources(common_config:get_stop_prepare_msg(), [common_tool:to_list(N)]),
              common_broadcast:bc_send_msg_world(?BC_MSG_TYPE_WORLD, ?BC_MSG_SUB_TYPE_NONE, M),
              timer:sleep(1000)
      end, lists:reverse(lists:seq(1, common_config:get_stop_prepare_second()))),
    Node = erlang:node(),
    rpc:call(Node, mgeeg_ctl, process, [["kick_all_role"]]).

