%%%-------------------------------------------------------------------
%%% File        :common_config.erl
%%%-------------------------------------------------------------------
-module(common_config).

-include("common.hrl").

%% API
-export([
         is_debug_sql/0,
         get_mysql_config/0,
         is_debug/0,
         get_open_day/0,
         get_opened_days/0,
         get_agent_name/0,
         get_agent_id/0,
         get_log_level/0,
         get_gateway_super_key/0,
         get_server_dir/0,
         get_logs_dir/0,
         get_server_id/0,
         get_server_name/0,
         get_db_node_name/0,
         get_stop_prepare_second/0,
         get_stop_prepare_msg/0,
         is_live_start/0,
         is_merge/0
        ]).

get_gateway_super_key() ->
    [Val] = common_config_dyn:find_common(gateway_super_key),
    Val.    

get_log_level() ->
    [Val] = common_config_dyn:find_common(log_level),
    Val.

%% 获取代理商名字    
get_agent_name() ->
    [Val] = common_config_dyn:find_common(agent_name),
    Val.

%% 获取游戏服ID
get_agent_id() ->
    [Val] = common_config_dyn:find_common(agent_id),
    Val.
get_server_id() ->
    [Val] = common_config_dyn:find_common(server_id),
    Val.
get_server_name() ->
    [Val] = common_config_dyn:find_common(server_name),
    Val.
%% 获得停止分线之前的广播时间，单位为秒
get_stop_prepare_second() ->
    [Val] = common_config_dyn:find(etc, stop_prepare_second),
    Val.

get_stop_prepare_msg() ->
    [Val] = common_config_dyn:find(etc, stop_prepare_msg),
    Val.
%% 获取开服日志 {{Year, Month, Day}, {Hour, Min, Sec}}
get_open_day() ->
    [Val] = common_config_dyn:find_common(server_start_datetime),
    Val.

%% 获得当前为开服第几天，如果今天是6月28日，开服日期为6月28日，则今天为开服第一天，返回1
get_opened_days() ->
    [{Date, _}] = common_config_dyn:find_common(server_start_datetime),
    {Date2, _} = erlang:localtime(),
    erlang:abs( calendar:date_to_gregorian_days(Date) - calendar:date_to_gregorian_days(Date2) ) + 1.
    
%%@doc 设置为true可以输出erlang的sql语句
is_debug_sql()->
    false.


is_debug() ->
    [Val] = common_config_dyn:find(common, is_debug),
    Val.


get_server_dir() ->
    {ok, [[ServerDir]]} = init:get_argument(server_dir),
    ServerDir.
get_logs_dir() ->
    {ok, [[LogsDir]]} = init:get_argument(logs_dir),
    LogsDir.


get_mysql_config() ->
    [Val] = common_config_dyn:find_common(mysql_config),
    Val.

get_db_node_name() ->
    [AgentName] = common_config_dyn:find_common(agent_name),
    [ServerName] = common_config_dyn:find_common(server_name),
    lists:foldl(
      fun(Node, Acc) ->
              Node2 = erlang:atom_to_list(Node),
              case string:str(Node2, lists:concat(["mgeew_",AgentName,"_",ServerName,"@"])) =:= 1 of
                  true ->
                      Node;
                  _ ->
                      Acc
              end
      end, erlang:node(), [erlang:node() | erlang:nodes()]).


is_live_start()->
    case init:get_argument(action) of
        {ok,[["live"]]}->
            true;
        Info->
            Info
    end.
%% 本服务器是否是合服后的服务器
is_merge() ->
    case common_config_dyn:find(common, is_merged) of
        [true] ->
            true;
        _ ->
            false
    end.
