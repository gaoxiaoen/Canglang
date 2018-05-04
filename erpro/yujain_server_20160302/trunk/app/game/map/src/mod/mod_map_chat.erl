%%-------------------------------------------------------------------
%% File              :mod_map_chat.erl
%% Author            :caochuncheng2002@gmail.com
%% Create Date       :2015-11-27
%% @doc
%%     地图模块处理聊天逻辑模块，主要处理当前频道聊天
%% @end
%%-------------------------------------------------------------------


-module(mod_map_chat).

-include("mgeem.hrl").

-export([handle/1,
         
         get_chat_channel_process_name/1,
         get_chat_channel_process_name/4,
         
         hook_map_init/4,
         hook_map_terminate/0,
         hook_role_online/2,
         hook_role_offline/2,
         hook_role_map_enter_confirm/1,
         hook_role_map_quit/1]).

handle({send_message,Info}) ->
    do_send_message(Info);

handle(Info) ->
    ?ERROR_MSG("receive unknown message,Info=~w",[Info]).

%% 发送当前频道消息，即地图消息
do_send_message({Module, Method, SendToc}) ->
    MapState = mgeem_map:get_map_state(),
    case get_chat_channel_process_name(MapState) of
        undefined ->
            ignore;
        ProcessName ->
            chat_misc:broadcast_to_map(ProcessName, Module, Method, SendToc)
    end,
    ok.

%% 获取聊天当前频道进程名
get_chat_channel_process_name(#r_map_state{map_id=MapId,
                                           map_type=MapType,
                                           fb_id=FbId,
                                           create_time=CreateTime}) ->
    get_chat_channel_process_name(MapId,MapType,FbId,CreateTime);
get_chat_channel_process_name(_) ->
    undefiend.

get_chat_channel_process_name(MapId,MapType,FbId,CreateTime) ->
    case MapType of
        ?MAP_TYPE_NORMAL ->
            erlang:list_to_atom(lists:concat(["channel_map_", MapId]));
        ?MAP_TYPE_FB ->
            erlang:list_to_atom(lists:concat(["channel_map_", FbId, "_", CreateTime]));
        _ ->
            undefiend
    end.

%% 地图进程创建，需要同时创建对应的聊天频道
hook_map_init(MapId,MapType,FbId,CreateTime) ->
    case get_chat_channel_process_name(MapId,MapType,FbId,CreateTime) of
        undefined ->
            ignore;
        ProcessName ->
            ExtendNum = cfg_chat:find({channel_map,MapId}),
            chat_misc:start_map_channel(ProcessName, ExtendNum)
    end,
    ok.

%% 地图进程销毁时，需要销毁对应的聊天频道
hook_map_terminate() ->
    MapState = mgeem_map:get_map_state(),
    case get_chat_channel_process_name(MapState) of
        undefined ->
            ignore;
        ProcessName ->
            chat_misc:kill_process_channel(ProcessName)
    end,
    ok.
%% 玩家上线，加入对应的地图频道
hook_role_online(RoleId,MapState) ->
    join_channel(RoleId,MapState),
    ok.
%% 玩家下线，离开对应的地图频道
hook_role_offline(RoleId,MapState) ->
    leave_channel(RoleId,MapState),
    ok.
%% 玩家进入地图，加入对应的地图频道
hook_role_map_enter_confirm(RoleId) ->
    join_channel(RoleId),
    ok.
%% 玩家退出地图，离开对应的地图频道
hook_role_map_quit(RoleId) ->
    leave_channel(RoleId),
    ok.

join_channel(RoleId) ->
    MapState = mgeem_map:get_map_state(),
    join_channel(RoleId,MapState).
join_channel(RoleId,MapState) ->
    case get_chat_channel_process_name(MapState) of
        undefined ->
            ignore;
        ProcessName ->
            GatewayPid = mod_map_role:get_role_gateway_pid(RoleId),
            chat_misc:join_channel(ProcessName, RoleId, GatewayPid)
    end,
    ok.
leave_channel(RoleId) ->
    MapState = mgeem_map:get_map_state(),
    leave_channel(RoleId,MapState).
leave_channel(RoleId,MapState) ->
    case get_chat_channel_process_name(MapState) of
        undefined ->
            ignore;
        ProcessName ->
            chat_misc:leave_channel(ProcessName, RoleId)
    end,
    ok.
