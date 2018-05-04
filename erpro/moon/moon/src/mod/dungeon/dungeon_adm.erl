%% --------------------------------------------------------------------
%% 副本管理工具 用于后台管理
%% @author abu@jieyou.cn
%% --------------------------------------------------------------------
-module(dungeon_adm).

-export([
        get_online_maps/1
        ,get_map_status/0
        ,get_online_npcs/1
        ,get_all_dungeons/0
        ,get_dungeon_info/1
    ]).

-include("map.hrl").
-include("npc.hrl").

%% --------------------------------------------------------------------
%% API functions
%% --------------------------------------------------------------------

%% 获取在运行中的副本
get_all_dungeons() ->
    dungeon_mgr:get_all_dungeons().

%% @spec get_dungeon_info(Dpid) -> {ok, #dungeon{}} | {false, Reason} 
%% Dpid = pid()
%% Reason = term()
%% 获取副本的基本信息
get_dungeon_info(Dpid) ->
    dungeon:get_info(Dpid).

%% @spec show_all_maps(Pattern) -> [#map{} | .. ]
%% Pattern = tuple()
%% 根据Pattern获取地图
get_online_maps(Pattern) ->
    [Map || Map <- ets:match(map_info, Pattern)].

%% 获取地图的状态
get_map_status() ->
    [{BaseId, Pid, is_process_alive(Pid)} || [#map{base_id = BaseId, pid = Pid}] <- get_online_maps('$1')].

%% @spec get_online_npcs(Pattern) -> [#npc{} | ..]
%% Pattern = tuple()
%% 根据Pattern获取NPC
get_online_npcs(Pattern) ->
    [Npc || Npc <- ets:match(npc_online, Pattern)].


