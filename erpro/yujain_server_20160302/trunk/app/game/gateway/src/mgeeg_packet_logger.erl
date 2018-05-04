%% Author: Haiming Li
%% Created: 2013-3-4
%% Description: 玩家消息包日志模块
-module(mgeeg_packet_logger).
-include("mgeeg.hrl").

%%
%% Exported Functions
%%
-export([log/2,
         statistic/3]).

%%
%% API Functions
%%

log(RoleId, {Module, Method, Record,ByteSize}) ->
    do_log(RoleId, {Module, Method, Record,ByteSize});
log(RoleId, Data) ->
    ?ERROR_MSG("unknown log info: ~w ~w", [RoleId, Data]).

%%
%% Local Functions
%%

%% 跟踪玩家发送的数据包
do_log(undefined, {Module, Method, #m_auth_key_tos{role_id=RoleId}=Record, ByteSize}) ->
    do_log(RoleId, {Module, Method, Record, ByteSize});
do_log(undefined, {Module, Method, #m_auth_quick_tos{role_id=RoleId}=Record, ByteSize}) ->
    do_log(RoleId, {Module, Method, Record, ByteSize});
do_log(undefined, {_Module, _Method, _Record, _ByteSize}) ->
    ignore;
do_log(RoleId, {Module, Method, Record, ByteSize}) ->
    case cfg_packet_log:track(RoleId, Module, Method) of
        true ->
            erlang:send(mgeew_packet_logger, {packet, {RoleId, Module, Method, Record, ByteSize}});
        _ -> 
            ignore
    end.

%% 统计玩家接收的包
statistic(0,_Method,_ByteSize) ->
    ok;
statistic(RoleId,Method,ByteSize) ->
    case cfg_packet_log:is_statistics() of
        true ->
            ?TRY_CATCH(erlang:send(mgeew_packet_logger, {statistic,{RoleId,Method,ByteSize}}),ErrPacketLogger);
        _ -> 
            ignore
    end,
    ok.
