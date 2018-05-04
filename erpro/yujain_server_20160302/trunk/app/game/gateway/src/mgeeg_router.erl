%%%-------------------------------------------------------------------
%%% File        :mgeeg_router.erl
%%%-------------------------------------------------------------------

-module(mgeeg_router).

-include("mgeeg.hrl").
-export([
         router/1,
         test_router/2
        ]).

%% 消息路由处理
router({Module, Method, DataRecord, RoleID, PID, Line}) ->
    case mm_map:method(Method) of
        undefined ->
            ?ERROR_MSG("data packet format error,Info=~w",[{Module, Method, DataRecord, RoleID}]);
        Module_Method ->
            case cfg_proto:check(Module, Method) of
                {?_RC_SUCC,_} ->
                    DataRecordAtom = common_tool:list_to_atom(lists:concat([m_, Module_Method, "_tos"])),
                    case erlang:is_record(DataRecord, DataRecordAtom) of
                        true ->
                            case cfg_router:find(Module_Method) of
                                {map,Mod}->
                                    rount_to_map(Mod,{Module, Method, DataRecord, RoleID, PID, Line});
                                {role,Mod}->
                                    rount_to_role(Mod,{Module, Method, DataRecord, RoleID, PID, Line});
                                {process,ProcessName}->
                                    erlang:send(ProcessName, {Module, Method, DataRecord, RoleID, PID, Line});
                                _->
                                    router2({Module, Method, DataRecord, RoleID, PID, Line})
                            end;
                        _ ->
                            ?ERROR_MSG("data packet format error,Info=~w",[{Module, Method, DataRecord, RoleID}])
                    end;
                {OpCode,OpReason} ->
                    R = #m_system_message_toc{op_code=OpCode,op_reason=OpReason},
                    Socket = erlang:get(socket),
                    mgeeg_packet:send(Socket, ?SYSTEM, ?SYSTEM_MESSAGE, R)
            end
    end.

rount_to_map(Module,Info)->
    case erlang:get(map_pid) of
        undefined ->
            self() ! {error_exit,role_map_process_not_found};
        PID ->
            PID ! {mod,Module,Info}
    end.

rount_to_role(Module,Info)->
    case erlang:get(role_world_pid) of
        undefined ->
            self() ! {error_exit,mgeew_role_register_not_run};
        RoleWorldPId ->
            RoleWorldPId ! {mod,Module,Info}
    end.


%% 心跳包
router2({?SYSTEM, ?SYSTEM_HEARTBEAT, DataRecord, _RoleID, _Pid, _Line}) ->
    #m_system_heartbeat_tos{time=Time} = DataRecord,
    R = #m_system_heartbeat_toc{time=Time, server_time=common_tool:now2()},
    Socket = erlang:get(socket),
    mgeeg_packet:send(Socket, ?SYSTEM, ?SYSTEM_HEARTBEAT, R);

%% 防沉迷
router2({?SYSTEM, ?SYSTEM_SET_FCM, DataRecord, _RoleID, _PID, _Line}) ->
    #m_system_set_fcm_tos{name=Realname, card=Card} = DataRecord,
	{ok,Url} = common_fcm:get_fcm_url(Realname, Card),
    %% 向平台发起请求，异步请求
    httpc:request(get, {Url, []}, [], [{sync, false}]),
    ok.

%% 测试接口
test_router(DataRecord, RoleId)->
    RecordName=erlang:element(1,DataRecord),
    StrRecordName = erlang:atom_to_list(RecordName),
    StrMethodName=string:substr(StrRecordName, 3, erlang:length(StrRecordName)-6),
    MethodName = erlang:list_to_atom(StrMethodName),
    Method = mm_map:method_name(MethodName),
    Module = Method div 100,
    case erlang:whereis(common_misc:get_role_gateway_process_name(RoleId)) of
        undefined ->
            PId = undefined;
        PId ->
            next
    end,
    Line = undefined,
    Info = {Module, Method, DataRecord, RoleId, PId, Line},
    case cfg_router:find(MethodName) of
        {map,Mod}->
            common_misc:send_to_role_map(RoleId, {mod,Mod,Info});
        {role,Mod}->
            erlang:send(common_misc:get_role_world_process_name(RoleId), {mod,Mod,Info});
        {process,ProcessName}->
            erlang:send(ProcessName, Info)
    end.