%% Author: markycai<tomarky.cai@gmail.com>
%% Created: 2013-12-9
%% Description: TODO: Add description to chat_misc
-module(chat_misc).

%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
-export([
         start_common_channel/0,
         start_map_channel/2,
         kill_process_channel/1,
         
         get_channel_world_name/0,
         get_channel_system_name/0,
         get_channel_category_name/1,
         get_extend_name/2,
         
         join_channel/3,
         leave_channel/2,
         
         notice_join_channel/2,
         notice_leave_channel/2]).


-export([broadcast_to_system/3,
         broadcast_to_world/3,
         broadcast_to_category/4,
         broadcast_to_family/4,
         broadcast_to_team/4,
         broadcast_to_map/4]).

%%
%% API Functions
%%
broadcast_to_system(Module,Method,R) ->
    ProcessName = get_channel_system_name(),
    catch erlang:send(ProcessName, {broadcast,Module,Method,R}).

broadcast_to_world(Module,Method,R)->
    ProcessName = get_channel_world_name(),
    catch erlang:send(ProcessName, {broadcast,Module,Method,R}).

broadcast_to_category(Category,Module,Method,R)->
    ProcessName = get_channel_category_name(Category),
    catch erlang:send(ProcessName, {broadcast,Module,Method,R}).
    
broadcast_to_family(FamilyId,Module,Method,R)->
    ProcessName = common_family:get_family_process_name(FamilyId),
    catch erlang:send(ProcessName,{mod,mod_chat,{broadcast_family,Module,Method,R}}).

broadcast_to_team(_TeamId,_Module,_Method,_R)->
    %%TODO
    ignore.

broadcast_to_map(ProcessName,Module,Method,R) ->
    catch erlang:send(ProcessName, {broadcast,Module,Method,R}).

%%
%% Local Functions
%%

start_common_channel()->
    supervisor:start_child(chat_channel_sup, [?CHANNEL_TYPE_WORLD,get_channel_world_name()]),
    supervisor:start_child(chat_channel_sup, [?CHANNEL_TYPE_SYSTEM,get_channel_system_name()]),
    supervisor:start_child(chat_channel_sup, [?CHANNEL_TYPE_CATEGORY,get_channel_category_name(?CATEGORY_1)]),
    supervisor:start_child(chat_channel_sup, [?CHANNEL_TYPE_CATEGORY,get_channel_category_name(?CATEGORY_2)]),
    supervisor:start_child(chat_channel_sup, [?CHANNEL_TYPE_CATEGORY,get_channel_category_name(?CATEGORY_3)]),
    supervisor:start_child(chat_channel_sup, [?CHANNEL_TYPE_CATEGORY,get_channel_category_name(?CATEGORY_4)]),
    supervisor:start_child(chat_channel_sup, [?CHANNEL_TYPE_CATEGORY,get_channel_category_name(?CATEGORY_5)]),
    supervisor:start_child(chat_channel_sup, [?CHANNEL_TYPE_CATEGORY,get_channel_category_name(?CATEGORY_6)]),
    ok.
start_map_channel(ChannelProcessName,ExtendNum) ->
    supervisor:start_child(chat_channel_sup, [?CHANNEL_TYPE_MAP,ChannelProcessName,ExtendNum]),
    ok.

kill_process_channel(ChannelProcessName) ->
    catch erlang:send(ChannelProcessName,{kill_process}).

%% 获取世界频道进程名
get_channel_world_name()->
    channel_world.

%% 获取系统频道进程名
get_channel_system_name() ->
    channel_system.

%% 获取门派频道进程名
-spec 
get_channel_category_name(Category) -> ChannelProcessName when
    Category :: category_type(),
    ChannelProcessName :: atom().
get_channel_category_name(Category) ->
    erlang:list_to_atom(lists:concat(["channel_category_", Category])).

%% 获取扩展频道进程名
-spec 
get_extend_name(ChannelName,ExtendId) -> ChannelProcessName when
    ChannelName :: channel_name,
    ExtendId ::integer(),
    ChannelProcessName :: atom().
get_extend_name(ChannelName,ExtendId)->
    erlang:list_to_atom(lists:concat([ChannelName,"_",ExtendId])).


notice_join_channel(RoleId,ChannelType)->
    R = #m_chat_join_channel_toc{channel_type=ChannelType},
    common_misc:unicast({role,RoleId},?CHAT,?CHAT_JOIN_CHANNEL,R).

notice_leave_channel(RoleId,ChannelType)->
    R = #m_chat_leave_channel_toc{channel_type=ChannelType},
    common_misc:unicast({role,RoleId},?CHAT,?CHAT_LEAVE_CHANNEL,R).

join_channel(_ProcessName,_RoleId,undefined)->
    ignroe;
join_channel(ProcessName,RoleId,GatewayPid)->
    catch erlang:send(ProcessName,{join_channel,RoleId,GatewayPid}).

leave_channel(ProcessName,RoleId)->
    catch erlang:send(ProcessName,{leave_channel,RoleId}).