%%%-------------------------------------------------------------------
%%% File        :common_map.erl
%%%-------------------------------------------------------------------
-module(common_map).
-include("common.hrl").
-include("common_server.hrl").

%% API
-export([
         send_to_all_map/1,
         get_common_map_name/1,
         get_fb_map_name/1,
         get_fb_alive_map_name/1
        ]).
%% 向当时所有地图进程发送消息
send_to_all_map(Info) ->
    lists:foreach(
      fun(MapProcessName) -> 
              case common_tool:to_list(MapProcessName) of
                  "map_" ++ _ ->
                      case erlang:whereis(MapProcessName) of
                          undefined ->
                              ignore;
                          PId ->
                              PId ! Info
                      end;
                  _ ->
                      ignore
              end
      end,erlang:registered()).
%% 一般地图
get_common_map_name(MapId) ->
    erlang:list_to_atom(lists:concat(["map_common_", MapId])).

%% 副本地图
get_fb_map_name(FbId) ->
    erlang:list_to_atom(lists:concat(["map_fb_",FbId,"_",common_tool:now()])).

%% 副本地图，一直存在的地图
get_fb_alive_map_name(FbId) ->
    erlang:list_to_atom(lists:concat(["map_fb_",FbId])).
