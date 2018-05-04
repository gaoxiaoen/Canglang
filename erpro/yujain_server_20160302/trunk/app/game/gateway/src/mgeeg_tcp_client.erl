%%%-------------------------------------------------------------------
%%% File        :mgeeg_tcp_client.erl
%%% @doc
%%%     玩家网关进程
%%% @end
%%%-------------------------------------------------------------------

-module(mgeeg_tcp_client).

%% API
-export([
         start/2,
         get_role_id/0,
         get_now/0
        ]).

-include("mgeeg.hrl"). 

-define(state_waiting_for_auth, waiting_for_auth).

-define(state_waiting_for_enter_map, waiting_for_enter_map).

-define(state_normal_game, normal_game).

-define(state_waiting_for_get_detail, waiting_for_get_detail).

-define(state_waiting_for_create_role, waiting_for_create_role).

-define(state_waiting_for_sure_enter_map, waiting_for_sure_enter_map).

-define(LOOP_TICKET, 1000).

-define(offline_code_tcp_closed, 10000).

%%%===================================================================
%%% API
%%%===================================================================
start(ClientSocket, Line) ->
    %% 获取玩家IP地址
    case inet:peername(ClientSocket) of
        {ok, {IP, _}} ->
            PId = erlang:spawn(fun() -> do_start(ClientSocket, Line, IP) end),
            inet:setopts(ClientSocket, [binary,
                                        {packet_size, 65536},
                                        {delay_send, true}]),
            gen_tcp:controlling_process(ClientSocket, PId),
            PId ! work;
        {error, Reason} ->
            ?ERROR_MSG("~ts:~w", [?_LANG_TCP_CLIENT_000, Reason]),
            catch erlang:port_close(ClientSocket)
    end.

do_start(ClientSocket, Line, IP) ->
    set_ip(IP),
    set_socket(ClientSocket),
    set_gateway(Line),
    Now = common_tool:now(),
    set_now(Now),
    set_start_process_time(Now),
    clear_enter_map_status(),
    set_per_packet_time(Now),
    set_total_packet_number(0),
    %% 等待开始指令
    receive
        work ->
            init_state(),
            %% 异步接收数据包
%%             ?ERROR_MSG("Soket Opts=~w",[inet:getopts(ClientSocket, [recbuf,sndbuf,packet,packet_size,keepalive,
%%                                                                     nodelay,delay_send,active,buffer,reuseaddr])]),
            do_async_recv_packet_header(ClientSocket),
            %% 玩家进入游戏的过程：
            %% 验证游戏入口状态 -> 验证合法性 -> 创建角色 -> 初始化数据 -> 进入地图 -> 正常的消息循环
            %% 这个期间理论上只有socket消息和管理消息
            do_login_register_loop();
        Any ->
            ?ERROR_MSG("~ts:~w", [?_LANG_TCP_CLIENT_001, Any]),
            catch erlang:port_close(ClientSocket)
    after 3000 ->
            ?ERROR_MSG("~ts", [?_LANG_TCP_CLIENT_002]),
            catch erlang:port_close(ClientSocket)
    end.

%% 下一次接收包长度
-spec do_async_recv_packet_header(Socket) -> ok when Socket :: erlang:port().
do_async_recv_packet_header(Socket) ->
    prim_inet:async_recv(Socket, ?PACKET_LENGTH, -1),
    set_async_recv_type(1),
    ok.

%% 下一次接收包的数据
%% Length 接收数据的长度
-spec do_async_recv_data(Socket,Length) -> ok when Socket :: erlang:port(),Length :: integer().
do_async_recv_data(Socket,Length) ->
    prim_inet:async_recv(Socket, Length, -1),
    set_async_recv_type(0),
    ok.

%% 设置当前接收协议类型
%% type=0数据
%% type=1数据长度
-spec set_async_recv_type(Type) -> Type when Type :: 0|1.
set_async_recv_type(Type) ->
    erlang:put(async_recv_type, Type).
%% 判断当前是不是接收协议包长度
-spec is_async_recv_data() -> true | false.
is_async_recv_data() ->
    erlang:get(async_recv_type) == 0.

%% 玩家socket进程开始接收客户端消息
%% 进入场景后用的是 do_normal_loop
do_login_register_loop() ->
    try
        begin 
            receive
                {inet_async, ClientSocket, _Ref, {ok, Data}} -> %% 直接取缓冲区的所有数据
                    case is_async_recv_data() of
                        true ->
                            do_async_recv_packet_header(ClientSocket),
                            {Module, Method, Record} = mgeeg_packet:unpack(Data),
%%                             ?ERROR_MSG("tcp client receive data=~w", [{Module, Method, Record}]),
                            ?TRY_CATCH(mgeeg_packet_logger:log(get_role_id(), {Module, Method, Record, erlang:byte_size(Data)}), Err),
                            do_socket_data(Module, Method, Record, get_state());
                        _ ->
                            <<Len:32>>=Data,
                            do_async_recv_data(ClientSocket,Len)
                    end,
                    do_login_register_loop();
                {inet_async, _ClientSocket, _Ref, {error, closed}} ->
                    do_notify_exit(tcp_closed),
                    do_login_register_loop();
                {inet_async, _ClientSocket, _Ref, {error, Reason}} ->
                    do_notify_exit(Reason),
                    do_login_register_loop();
                {inet_reply, _Sock, ok} ->
                    do_login_register_loop();
                {inet_reply, _Sock, Result} ->
                    do_notify_exit(Result),
                    do_login_register_loop();
                %% 退出消息
                {error_exit, Reason} ->
                    do_terminate(Reason);
                %% 确定进入地图
                {sure_enter_map, MapPId} ->
                    do_sure_enter_map(MapPId),
                    do_normal_loop();
                %% 进入地图失败
                {enter_map_failed, _} ->
                    do_notify_exit(enter_map_failed),
                    do_login_register_loop()
            after 30000 -> %% 30秒
                    do_terminate(no_heartbeat)
            end
        end
    catch E:E2 ->
            ?ERROR_MSG("~ts:~w ~w ~w", [?_LANG_TCP_CLIENT_003, E, E2, erlang:get_stacktrace()])
    end.

%% 确认玩家进入地图
do_sure_enter_map(MapPId) ->
    case erlang:get(map_pid) of
        undefined -> %% 第一次进入地图，确认玩家进入地图返回OK
            ?TRY_CATCH(erlang:send(mgeeg_global_server, {set_role_status,get_role_id(),role_login_game, erlang:self()}),RoleLoginGameError),
            erlang:put(map_pid, MapPId),
            case common_config:is_debug() of
                true ->
                    set_last_heartbeat_time(common_tool:now2()),
                    erlang:send_after(?LOOP_TICKET, self(), loop);
                false ->
                    set_last_heartbeat_time(common_tool:now2()),
                    erlang:send_after(?LOOP_TICKET, self(), loop)
            end;
        _ ->
            erlang:put(map_pid, MapPId),
            ignore
    end,
    clear_enter_map_status(),
    set_state(?state_normal_game).

%% 进入游戏后的正常循环
do_normal_loop() ->
    receive
        {inet_async, ClientSocket, _Ref, {ok, Data}} ->
            case is_async_recv_data() of
                true ->
                    do_async_recv_packet_header(ClientSocket),
                    {Module, Method, Record} = mgeeg_packet:unpack(Data),
%%                     ?ERROR_MSG("tcp client receive data=~w", [{Module, Method, Record}]),
                    ?TRY_CATCH(mgeeg_packet_logger:log(get_role_id(), {Module, Method, Record, erlang:byte_size(Data)}), Err),
                    do_normal_socket_data(Module, Method, Record);
                _ ->
                    <<Len:32>> = Data,
                    do_async_recv_data(ClientSocket,Len)
            end,
            do_normal_loop();
        {inet_async, _ClientSocket, _Ref, {error, closed}} ->
            erlang:put(offline_status, true),
            erlang:send_after(10 * 1000, erlang:self(), real_offline),
            do_normal_loop();
        {inet_async, _ClientSocket, _Ref, {error, Reason}} ->
            do_notify_exit(Reason),
            do_normal_loop();
        {inet_reply, _Sock, ok} ->
            do_normal_loop();
        {message, DataRecord} ->
            do_send_message(DataRecord),
            do_normal_loop();
        {message, Module, Method, DataRecord} ->
            do_send_message(Module, Method, DataRecord),
            do_normal_loop();
        {messages,MessageList} ->
            do_send_messages(MessageList),
            do_normal_loop();
        {binary, Bin} ->
            do_send_binary(Bin),
            do_normal_loop();
        {binaries, Bins} ->
            do_send_binaries(Bins),
            do_normal_loop();
        loop ->
            do_loop(),
            do_normal_loop();
        {router_to_map, Msg} ->
            do_router_to_map(Msg),
            do_normal_loop();
        login_again ->
            do_terminate(login_again);
        kick_by_admin ->
            do_kick_by_admin(),
            do_normal_loop();
        {enter_map_failed, _} ->
            do_notify_exit(enter_map_failed),
            do_normal_loop();
        {http, {_, FcmHttpResult}} ->
            do_fcm_result(FcmHttpResult),
            do_normal_loop();
        real_offline ->
            do_real_offline(),
            do_normal_loop();
        fcm_kick_time ->
            do_fcm_kick(),
            do_normal_loop();
        pass_fcm ->
            do_pass_fcm(),
            do_normal_loop();
        {need_fcm_notify, TotalOnlineTime} ->
            do_need_fcm_notify(TotalOnlineTime),
            do_normal_loop();
        {notify_fcm, TotalOnlineTime} ->
            do_notify_fcm(TotalOnlineTime),
            do_normal_loop();
        {inet_reply, _Sock, Result} ->
            do_notify_exit(Result),
            do_normal_loop();
        {error_exit, Reason} ->
            do_terminate(Reason);
        {sure_enter_map, MapPId} ->
            do_sure_enter_map(MapPId),
            do_normal_loop();
        enter_fb_map_fail ->
            clear_enter_map_status(),
            do_normal_loop();
        {func, Fun, Args} ->
            do_func(Fun,Args),
            do_normal_loop()
    end.

do_func(Fun,Args) ->
    Ret = (catch apply(Fun,Args)),
    ?ERROR_MSG("~w",[Ret]),
    ok.

do_kick_by_admin() ->
    do_notify_exit(admin_kick),
    ok.

do_router_to_map(Msg) ->
    case erlang:get(map_pid) of
        undefined ->
            ignore;
        PId ->
            PId ! Msg
    end.   

do_send_binary(Bin) ->
    case erlang:get(offline_status) of
        true ->
            ignore;
        _ ->
            Socket = get_socket(),
            case erlang:is_port(Socket) of
                true ->
                    catch erlang:port_command(Socket, Bin,[force]);
                false ->
                    do_notify_exit(tcp_error)
            end
    end,
    ok.

do_send_binaries(Bins) ->
    case erlang:get(offline_status) of
        true ->
            ignore;
        _ ->
            Socket = get_socket(),
            case erlang:is_port(Socket) of
                true ->
                    [catch erlang:port_command(Socket, Bin,[force]) || Bin <- Bins ];
                false ->
                    do_notify_exit(tcp_error)
            end
    end,
    ok.

do_send_message(DataRecord) ->
    case mgeeg_packet:get_method(erlang:element(1, DataRecord)) of
        undefined ->
            ignore;
        Method ->
            Module = Method div 100,
            do_send_message(Module, Method, DataRecord)
    end.
do_send_message(Module, Method, DataRecord) ->
    case erlang:get(offline_status) of
        true ->
            ignore;
        _ ->
            mgeeg_packet:send(get_socket(), Module, Method, DataRecord)
    end,
    ok.

do_send_messages(MessageList) ->
    case erlang:get(offline_status) of
        true ->
            ignore;
        _ ->
            do_send_messages2(MessageList,get_socket(),<<>>,0)
    end.
do_send_messages2([],_Socket,<<>>,0) ->
    ok;
do_send_messages2([],Socket,Bin,_Len) ->
    mgeeg_packet:send(Socket, Bin);
do_send_messages2([H|MessageList],Socket,Bin,Len) ->
    case H of
        {r_unicast,0, 0, _RoleId, DataRecord} ->
            Method =  mgeeg_packet:get_method(erlang:element(1, DataRecord));
		{r_unicast,_Module, Method, _RoleId, DataRecord} ->
			next;
        {_Module, Method, DataRecord} ->
            next;
        _ ->
            Method = undefiend, DataRecord = undefined,
            ?ERROR_MSG("~ts,Msg=~w",[?_LANG_TCP_CLIENT_004,H])
    end,
    case Method of
        undefined -> 
            do_send_messages2(MessageList,Socket,Bin,Len);
        _ ->
            PacketBin = mgeeg_packet:packet(Method, DataRecord),
            PacketLen = erlang:byte_size(PacketBin),
            if PacketLen + Len > 1460 ->
                   mgeeg_packet:send(Socket, Bin),
                   do_send_messages2(MessageList,Socket,PacketBin,PacketLen);
               PacketLen + Len == 1460 ->
                   mgeeg_packet:send(Socket, <<Bin/binary,PacketBin/binary>>),
                   do_send_messages2(MessageList,Socket,<<>>,0);
               true ->
                   do_send_messages2(MessageList,Socket,<<Bin/binary,PacketBin/binary>>,PacketLen + Len)
            end
    end.

get_now() ->
    erlang:get(milliseconds_1000).
set_now(NowSeconds) ->
    erlang:put(milliseconds_1000, NowSeconds).

do_loop() ->
    erlang:send_after(?LOOP_TICKET, erlang:self(), loop),
    Now = common_tool:now(),
    set_now(Now),
    Milliseconds = common_tool:now2(),
    %% 检查心跳
    do_check_heartbeat(Milliseconds),
    %% 检查发包是否正常
    do_check_packet(Now),
    %% 更新防沉迷在线信息
    do_update_fcm_info(),
    ok.

do_check_heartbeat(Milliseconds) ->
    LastHeartBeatTime = get_last_heartbeat_time(),
    %% 180秒没有心跳包，直接断了连接
    case Milliseconds - LastHeartBeatTime > 180000 of 
        true ->
            do_notify_exit(no_heartbeat);
        false ->
            ignore
    end.

do_check_packet(Now) ->
    PerPacketTime = get_per_packet_time(),
    TotalPacketNumber = get_total_packet_number(),
    DifTime = Now - PerPacketTime,
    case DifTime > 10 of %% 10秒
        true ->
            %%检查玩家平均发包速度
            case TotalPacketNumber / DifTime > 18 of %% 平均包大于18个
                true ->
                    ?ERROR_MSG("too many packet Now=~w,PerPacketTime=~w,TotalPacketNumber=~w",[Now,PerPacketTime,TotalPacketNumber]),
                    do_notify_exit(too_many_packet);
                false ->
                    set_total_packet_number(0),
                    set_per_packet_time(Now)
            end;
        _ ->
            ignore
    end.

do_update_fcm_info() ->
    case get_role_fcm_info() of
        undefined ->
            ignore;
        RoleFcmInfo ->
            #r_fcm_data{total_online_time=TotalOnlineTime, passed=Passed} = RoleFcmInfo,
            case Passed of
                true ->
                    ignore;
                false ->
                    set_role_fcm_info(RoleFcmInfo#r_fcm_data{total_online_time=TotalOnlineTime+1})
            end
    end.

do_fcm_kick() ->    
    case get_role_fcm_info() of
        undefined ->
            ignore;
        RoleFcmInfo ->
            #r_fcm_data{passed=Passed} = RoleFcmInfo,
            case Passed andalso common_misc:is_fcm_open() of
                true ->
                    ignore;
                false ->
                    do_notify_exit(fcm_kick_off)
            end
    end,
    ok.

do_need_fcm_notify(TotalOnlineTime) ->
    case get_role_fcm_info() of
        undefined ->
            ignore;
        RoleFcmInfo ->
            case RoleFcmInfo#r_fcm_data.passed of
                true ->
                    ignore;  
                _ ->       
                    [NotifyIntervalTime] = common_config_dyn:find(etc, notify_fcm_interval_time),
                    erlang:send_after(NotifyIntervalTime * 1000, erlang:self(), {need_fcm_notify, TotalOnlineTime + NotifyIntervalTime}),
                    DataRecord = #m_system_need_fcm_toc{remain_time=TotalOnlineTime},
                    mgeeg_packet:send(get_socket(), ?SYSTEM, ?SYSTEM_NEED_FCM, DataRecord)
            end
    end,
    ok.

do_notify_fcm(TotalOnlineTime) ->
    case get_role_fcm_info() of
        undefined ->
            ignore;
        RoleFcmInfo ->
            case RoleFcmInfo#r_fcm_data.passed of
                true ->
                    ignore; 
                _ ->
                    [NotifyIntervalTime] = common_config_dyn:find(etc, notify_fcm_interval_time),
                    [FcmKickTime]= common_config_dyn:find(etc,fcm_kick_time),
                    erlang:send_after(NotifyIntervalTime * 1000, erlang:self(), {notify_fcm, TotalOnlineTime + NotifyIntervalTime}),
                    DataRecord = #m_system_fcm_toc{total_time=TotalOnlineTime, info="", remain_time=FcmKickTime-TotalOnlineTime},
                    mgeeg_packet:send(get_socket(), ?SYSTEM,?SYSTEM_FCM, DataRecord)
            end
    end,
    ok.

%% 通过防沉迷
do_pass_fcm() ->
    case get_role_fcm_info() of
        undefined ->
            ignore;
        RoleFcmInfo ->
            set_role_fcm_info(RoleFcmInfo#r_fcm_data{passed = true}),
            R = #m_system_set_fcm_toc{succ=true},
            mgeeg_packet:send(get_socket(), ?SYSTEM,?SYSTEM_SET_FCM, R)
    end.
            
do_real_offline() ->
    do_notify_exit(tcp_closed),
    ok.

do_fcm_result(FcmHttpResult) ->
    case FcmHttpResult of
        {Succ, _, Result} ->
            case Succ of
                {_, 200, "OK"} ->
                    case Result of
                        <<"ERROR">> ->
                            Result2 = 2;
                        <<"SUCCESS">> ->
                            Result2 = 1;
                        _ ->
                            Result2 = common_tool:to_integer(Result)
                    end,
                    case common_fcm:get_fcm_validation_tip(Result2) of
                        true ->
                            %%通知客户端结果
                            R = #m_system_set_fcm_toc{succ=true},
                            case get_role_fcm_info() of
                                undefined ->
                                    next;
                                RoleFcmInfo ->
                                    set_role_fcm_info(RoleFcmInfo#r_fcm_data{passed = true})
                            end,
                            ok;
                        {false, Reason} ->
                            R = #m_system_set_fcm_toc{succ=false, reason=Reason}
                    end,
                    mgeeg_packet:send(get_socket(), ?SYSTEM,?SYSTEM_SET_FCM, R),
                    ok;
                _ ->
                    ?ERROR_MSG("~ts:~p", [?_LANG_TCP_CLIENT_005, Succ]),
                    R = #m_system_set_fcm_toc{succ=false, reason=common_lang:get_lang(100201)},
                    mgeeg_packet:send(get_socket(), ?SYSTEM,?SYSTEM_SET_FCM, R)
            end;
        _ ->
            R = #m_system_set_fcm_toc{succ=false, reason=common_lang:get_lang(100201)},
            mgeeg_packet:send(get_socket(), ?SYSTEM,?SYSTEM_SET_FCM, R)
    end,
    ok.

do_normal_socket_data(Module, Method, Record) ->
    set_last_heartbeat_time(common_tool:now2()),
    TotalNumber = get_total_packet_number(),
    set_total_packet_number(TotalNumber + 1),
    if Method =:= ?MAP_ENTER
       orelse Method =:= ?FB_ENTER
       orelse Method =:= ?FB_QUIT ->
           case is_enter_map_status() of
               true ->
                   ignore;
               false->
                   set_enter_map_status(),
                   mgeeg_router:router({Module, Method, Record, get_role_id(), erlang:self(), get_gateway()})
           end;
       true ->
           mgeeg_router:router({Module, Method, Record, get_role_id(), erlang:self(), get_gateway()})
    end,
    ok.

do_terminate(Reason) ->
    Now = common_tool:now(),
    ?DEBUG("~ts:NowSeconds=~w,Reason=~w", [?_LANG_TCP_CLIENT_006,Now,Reason]),
    AccountName = get_account_name(),
    RoleId = get_role_id(),
    ?ERROR_MSG("RoleId=~w,AccountName=~w,StartTime=~w,EndTime=~w,Socket Stat Info =~w",[RoleId,AccountName,get_start_process_time(),Now,inet:getstat(get_socket())]),
    %% 持久化玩家防沉迷数据
    case get_role_fcm_info() of
        undefined ->
            RoleFcmInfo = undefined,
            ignore;
        RoleFcmInfoT ->
            RoleFcmInfo = RoleFcmInfoT#r_fcm_data{offline_time = Now},
            db_api:dirty_write(?DB_FCM_DATA,RoleFcmInfo),
            erase_role_fcm_info(),
            ok
    end,
    case AccountName of
        undefined ->
            ignore;
        _ ->
            %% 玩家逻辑进程
            case get_role_world_pid() of
                RoleWorldPId when erlang:is_pid(RoleWorldPId) ->
                    RoleWorldPId ! {role_offline,Reason},
                    ok;
                _ ->
                    ignore
            end,
            %% 玩家所在地图进程
            case erlang:get(map_pid) of
                undefined ->
                    ignroe;
                MapPId ->
                    MapPId ! {role_offline, RoleId, erlang:self(), Reason}
            end,
            case Reason =:= tcp_closed of
                true ->
                    next;
                false ->
                    case common_line:get_exit_info(Reason) of
                        {_, {ErrorNo, ErrorInfo}} ->
                            case ErrorNo of
                                10017 ->
                                    case RoleFcmInfo of
                                        undefined ->
                                            ErrorInfo2 = ErrorInfo;
                                        _ ->
                                            #r_fcm_data{offline_time=OffLineTime} = RoleFcmInfo,
                                            OffLineTimeTotal = Now - OffLineTime,
                                            NeedTime = 5 * 3600 - OffLineTimeTotal,
                                            Hour = NeedTime div 3600,
                                            Min = (NeedTime rem 3600) div 60,
                                            ErrorInfo2 = io_lib:format(?_LANG_FCM_006, [Hour, Min])
                                    end;
                                _ ->
                                    ErrorInfo2 = ErrorInfo
                            end,
                            %% 通知客户端退出的原因
                            kick_role(ErrorNo, ErrorInfo2),
                            next;
                        false ->
                            ?ERROR_MSG("~ts:~p ~w", [?_LANG_TCP_CLIENT_008, Reason, erlang:get_stacktrace()])
                    end            
            end
    end,       
    %% 等待1秒钟，尽可能的让socket中的数据发送完成，socket不用关闭了，本进程退出后会自动关闭
    timer:sleep(1000),
    %% 移出在线列表
    remove_online(RoleId),
    case get_state() of 
        ?state_normal_game ->
            catch erlang:send(common_misc:get_unicast_server_name(get_gateway()),  {erase, RoleId, self()}),
            mgeeg_role_sock_map ! {erase, RoleId, self()},
            ignore;
        ?state_waiting_for_auth ->
            ?ERROR_MSG("~ts ClientIP=~w,Reason=~w", [?_LANG_TCP_CLIENT_009, get_ip(),Reason]),
            ok;
        ?state_waiting_for_enter_map ->
            ?ERROR_MSG("~ts,RoleId=~w,ClientIP=~w,Reason=~w", [?_LANG_TCP_CLIENT_010,get_role_id(),get_ip(),Reason]),
            ok;
        ?state_waiting_for_create_role ->
            ?ERROR_MSG("~ts,Reason=~w", [?_LANG_TCP_CLIENT_011,Reason]),
            ok;
        ?state_waiting_for_sure_enter_map ->
            ?ERROR_MSG("~ts ~s,Reason=~w", [?_LANG_TCP_CLIENT_012, get_account_name(),Reason])
    end,
    ok.


kick_role(ErrorNo, ErrorInfo) ->
    Socket = get_socket(),
    case erlang:is_port(Socket) of
        true ->
            R = #m_system_error_toc{error_info=lists:flatten(ErrorInfo), error_no=ErrorNo},
            mgeeg_packet:send(Socket, ?SYSTEM, ?SYSTEM_ERROR, R);
        false ->
            ignore
    end.

do_notify_exit(Reason) ->
    erlang:self() ! {error_exit, Reason}.    

do_socket_data(?AUTH, ?AUTH_KEY, Record, ?state_waiting_for_auth) ->
    do_auth(Record);
do_socket_data(?AUTH, ?AUTH_QUICK, Record, ?state_waiting_for_auth) ->
    do_quick_auth(Record);
do_socket_data(?ROLE, ?ROLE_CREATE, Record, ?state_waiting_for_create_role) ->
    do_create_role(Record);
do_socket_data(?MAP, ?MAP_ENTER, Record, ?state_waiting_for_enter_map) -> 
    do_enter_map(Record);
do_socket_data(Module, Method, Record, UnknowState) ->
    ?ERROR_MSG("~ts:~w ~w", [?_LANG_TCP_CLIENT_013, {Module, Method, Record}, UnknowState]),
    ok.

do_enter_map(DataRecord) ->      
    RoleId = get_role_id(),
    ClientIP = get_ip(),
    Gateway = get_gateway(),
    RolePId = erlang:self(),
    %% 统计玩家进入游戏窗口
    %% 注册玩家进程
    UnicastProcessName = common_misc:get_unicast_server_name(Gateway),
    case erlang:whereis(UnicastProcessName) of
        undefined ->
            ignore;
        UnicastProcessPId ->
            UnicastProcessPId ! {role, RoleId, RolePId}
    end,  
    mgeeg_role_sock_map ! {role, RoleId, RolePId},
    do_enter_map2(DataRecord, RoleId, RolePId, ClientIP, Gateway).
do_enter_map2(DataRecord, RoleId, RolePId, ClientIP, Gateway) -> 
    case gen_server:call(get_role_world_pid(), {init_role_info_first_enter,{RoleId,RolePId,ClientIP,Gateway}}, 30000) of
        {ok,RoleMapParam,RoleOnlineInfo} ->
            do_enter_map3(DataRecord, RoleId, RolePId, ClientIP, Gateway,RoleMapParam,RoleOnlineInfo);
        {error,Reason} ->
            do_terminate(Reason)
    end.
do_enter_map3(_DataRecord, RoleId, RolePId, ClientIP, Gateway,RoleMapParam,RoleOnlineInfo) ->
    #r_map_param{faction_id = FactionId} = RoleMapParam,
    %% 加入在线列表 
    %% TODO 需要优化
    add_online(RoleOnlineInfo),
    %% 第一次进入地图
    MapName = erase_map_process_name(),
    EnterMapInfo = {mod,mod_map_role,{role_first_map_enter, {RoleId,RolePId,Gateway,RoleMapParam,ClientIP}}},
    case erlang:whereis(MapName) of
        MapPId when is_pid(MapPId)->
            MapPId ! EnterMapInfo;
        undefined->
            ?ERROR_MSG("~ts,FactionId=~w,MapName:~w",[?_LANG_TCP_CLIENT_014,FactionId,MapName]),
            MapId = common_misc:get_newer_mapid(FactionId),
            HomeCityMapName = common_map:get_common_map_name(MapId),
            erlang:send(HomeCityMapName, EnterMapInfo)
    end,
    set_state(?state_waiting_for_sure_enter_map),
    ok.
%% 加入在线列表
add_online(RoleOnline) ->
    case db_api:transaction(
           fun() ->
                   db_api:write(?DB_ROLE_ONLINE, RoleOnline, write)
           end)
        of
        {atomic, _} ->
            ok;
        {aborted, Error} ->
            ?ERROR_MSG("add_online, error: ~w", [Error])
    end.
%% 移出在线列表
remove_online(RoleId) ->
    case db_api:transaction(
           fun() ->
                   db_api:delete(?DB_ROLE_ONLINE, RoleId, write)
           end)
    of
        {atomic, _} ->
            ok;
        {aborted, Error} ->
            ?ERROR_MSG("remove_online, error: ~w", [Error])
    end.
%% 创建角色
do_create_role(DataRecord) ->
    case do_create_role2(DataRecord) of
        {error,OpCode,Reason} ->
            do_create_role_error(OpCode, Reason);
        {ok} ->
            do_create_role3(DataRecord)
    end.
do_create_role2(DataRecord) ->
    #m_role_create_tos{server_id = ServerId} = DataRecord,
    case common_config_dyn:find_common({can_login_id,ServerId}) of
        [true] ->
            next;
        _ ->
            erlang:throw({error,?_RC_ROLE_CREATE_009,""})
    end,
    case common_misc:get_system_config(is_create_role) of
        {ok,#r_system_config{key = is_create_role,value = "true"}} ->
            next;
        _ ->
            erlang:throw({error,?_RC_ROLE_CREATE_016,""})
    end,
    {ok}.
do_create_role3(DataRecord) ->
    #m_role_create_tos{role_name=RoleName,
                       account_via=AccountVia,
                       account_type = AccountType,
                       sex=RoleSex,
                       fashion_id=FashionId,
                       faction_id=FactionId,
                       category=Category,
                       server_id = ServerId} = DataRecord,
    AccountName = get_account_name(),
    Request = {add_role, {AccountName, AccountVia, AccountType,ServerId,
               RoleName, RoleSex, FactionId, FashionId, Category, 
               get_fcm(), common_tool:ip_to_str(get_ip())}},
    case gen_server:call(mgeew_account_server, Request) of
        {ok, RoleId} ->
            %% 记录日志
            LogRoleFollow = #r_log_role_follow{account_name = AccountName,account_via = AccountVia,
                                               role_id = RoleId,role_name = RoleName,
                                               mtime = common_tool:now(),step = ?ROLE_FOLLOW_STEP_3,
                                               ip = common_tool:ip_to_str(get_ip())},
            common_log:insert_log(role_follow,LogRoleFollow),
            %% 通知客户端并设置状态位
            set_role_id(RoleId),
            RegName = common_misc:get_role_gateway_process_name(RoleId),
            SendSelf = #m_role_create_toc{},
            mgeeg_packet:send(get_socket(), ?ROLE, ?ROLE_CREATE, SendSelf),
            do_auth4(RegName, AccountName, RoleId),
            ok;
        {error, OpCode,Reason} ->
            ?ERROR_MSG("~ts,Error=~w,AccountName=~s,AccountVia=~w",[?_LANG_TCP_CLIENT_015,Reason,AccountName,AccountVia]),
            do_create_role_error(OpCode, Reason);
        {'EXIT', {noproc, _}} ->
            do_create_role_error(?_RC_ROLE_CREATE_001,"");
        {'EXIT', {timeout, _}} ->
            do_create_role_error(?_RC_ROLE_CREATE_002,"")
    end.
do_create_role_error(OpCode,Reason) ->
    SendSelf = #m_role_create_toc{op_code=OpCode,op_reason=Reason},
    mgeeg_packet:send(get_socket(), ?ROLE, ?ROLE_CREATE, SendSelf).

%% 验证通过后玩家无角色，需要创建角色
do_need_create_role() ->
    SendSelf = #m_auth_key_toc{is_create_role=true},
    mgeeg_packet:send(get_socket(), ?AUTH, ?AUTH_KEY, SendSelf),
    set_state(?state_waiting_for_create_role).

%% 验证登陆
do_auth(DataRecord) ->
    case catch do_auth1(DataRecord) of
        {error,Reason} ->
            do_notify_exit(Reason);
        {ok} ->
            #m_auth_key_tos{account_name=AccountName, key=Key, time=GatewayTime, role_id=RoleId} = DataRecord,
            NewAccountName = common_tool:to_binary(AccountName),
            do_auth2(DataRecord, Key, NewAccountName, GatewayTime, RoleId)
    end.
do_auth1(DataRecord) ->
    #m_auth_key_tos{account_name=AccountName,account_via = AccountVia, 
					time=GatewayTime,device_id=DeviceId} = DataRecord,
    case common_config:is_debug() of
        true ->
            %% debug模式下不验证key，直接通过登录
            erlang:throw({ok});
        false ->
            next
    end,
    %% 验证key是否超时
    NowSeconds = common_tool:now(),
    [GatewayKeyTimeout] = common_config_dyn:find(etc,gateway_key_timeout),
    case NowSeconds - GatewayTime < GatewayKeyTimeout of
        true ->
            next;
        false ->
            erlang:throw({error,auth_key_timeout})
    end,
    %% 验证游戏入口状态
    case common_misc:is_platform_state() =:= true andalso AccountVia =/= ?ACCOUNT_VIA_ADMIN of
        true ->
            erlang:throw({error,platform_error});
        _ ->
            next
    end,
    %% 验证管理平台游戏入口状态
    case common_misc:is_platform_admin_state() of
        true ->
            erlang:throw({error,platform_admin_error});
        _ ->
            next
    end,
    %% 封禁玩家
    case common_config_dyn:find(limit_account,AccountName) of
        [#r_limit_account{limit_time = AccountLimitTime}] ->
            case AccountLimitTime =:= 0 orelse AccountLimitTime > NowSeconds of
                true ->
                    erlang:throw({error,limit_account_error});
                _ ->
                    next
            end;
        _ ->
            next
    end,
	%% 封禁IP
	case common_config_dyn:find(limit_ip,common_tool:ip_to_str(get_ip())) of
		[#r_limit_ip{limit_time = IPLimitTime}] ->
			case IPLimitTime =:= 0 orelse IPLimitTime > NowSeconds of
				true ->
					erlang:throw({error,limit_ip_error});
				_ ->
					next
			end;
		_ ->
			next
	end,
	%% 封禁设备Id
	case DeviceId =/= "" andalso DeviceId =/= [] 
			 andalso common_config_dyn:find(limit_device_id, DeviceId) of
		[#r_limit_device_id{limit_time=DeviceIdLimitTime}] ->
			case DeviceIdLimitTime =:= 0 orelse DeviceIdLimitTime > NowSeconds of
				true ->
					erlang:throw({error,limit_device_id_error});
				_ ->
					next
			end;
		_ ->
			next
	end,
    {ok}.
do_auth2(DataRecord, Key, AccountName, GatewayTime, RoleId) ->
    #m_auth_key_tos{fcm=FCM,server_id=ServerId,device_id=DeviceId} = DataRecord,
    GatewayKey = common_misc:get_gateway_key({AccountName, GatewayTime, FCM}),
    case string:to_lower(GatewayKey) =:= string:to_lower(Key) 
        orelse string:to_lower(Key) =:= common_config:get_gateway_super_key()
        orelse common_config:is_debug() =:= true of
        true ->
            set_account_name(AccountName),
            set_fcm(FCM),
			set_device_id(DeviceId),
            %% 检查是否需要创建角色
            case common_misc:is_has_role(AccountName, ServerId) of
                {error,HasRoleError} ->
                    ?ERROR_MSG("~ts:AccountName=~s,ServerId=~w,HasRoleError=~w", [?_LANG_TCP_CLIENT_016, AccountName,ServerId,HasRoleError]),
                    do_need_create_role();
                _ ->
                    set_role_id(RoleId),
                    RegName = common_misc:get_role_gateway_process_name(RoleId),
                    do_auth3(RegName, AccountName, RoleId)
            end;
        Any ->
            ?ERROR_MSG("~ts,Error=~w",[?_LANG_TCP_CLIENT_017,Any]),
            do_notify_exit(auth_key_wrong_ticket)
    end.
do_auth3(RegName, AccountName, RoleId) ->
    %% 重复登录检查
    case erlang:whereis(RegName) of
        undefined ->
            do_auth4(RegName, AccountName, RoleId);
        OldPId -> %% T掉已经登录的角色
            ?ERROR_MSG("~ts,RoleId=~w,AccountName=~w",[?_LANG_TCP_CLIENT_021,RoleId,AccountName]),
            OldPId ! login_again,
            case wait_old_gateway_process_exit(1,RegName) of
                ok ->
                    do_auth4(RegName, AccountName, RoleId);
                _ ->
                    do_notify_exit(login_again_error)
            end
    end.
do_auth4(RegName, AccountName, RoleId) ->
    case erlang:register(RegName, self()) of
        true ->                
            set_register_name(RegName),
            do_auth5(RegName, AccountName, RoleId);
        _ ->
            do_notify_exit(register_global_name_failed)
    end.
do_auth5(RegName, AccountName, RoleId) ->
    case init_fcm(AccountName, get_fcm()) of
        ok ->
            do_auth6(RegName, AccountName, RoleId);
        {error, fcm_kick_off_not_enough_off_time} ->
            do_notify_exit(fcm_kick_off_not_enough_off_time);
        {ok,need_fcm, TotalOnlineTime} ->
             %% 版署服特殊处理，即玩家没有通过防沉迷，登录游戏即立即提示
            %% erlang:send_after(1000, erlang:self(), {need_fcm_notify, -99999999}),
            %% 第一次防沉迷弹出时间
            %% 进入游戏后多久弹出第一次防沉迷时间
            [FirstNotifyFcmTime] = common_config_dyn:find(etc, first_notify_fcm_time),
            %% 在线多就之后被防沉迷， 被防沉迷后多就才能重新上线
            [FcmKickTime] = common_config_dyn:find(etc, fcm_kick_time),
            erlang:send_after(FirstNotifyFcmTime * 1000, erlang:self(), {notify_fcm, TotalOnlineTime + FirstNotifyFcmTime}),
            %% 满三个小时就干掉这个号
            erlang:send_after((FcmKickTime-TotalOnlineTime) * 1000, erlang:self(), fcm_kick_time),
            do_auth6(RegName, AccountName, RoleId)
    end.
%% 创建玩家逻辑进程
do_auth6(RegName,AccountName,RoleId) ->
    %% 玩家进程是否存在
    RoleWorldProcessName = common_misc:get_role_world_process_name(RoleId),
    case erlang:whereis(RoleWorldProcessName) of
        undefined ->
            WorldRoleInfo = {AccountName},
            case supervisor:start_child(mgeew_role_sup,[{erlang:self(), get_gateway(),get_ip(),RoleId, WorldRoleInfo}]) of
                {ok, RoleWorldPId} ->
                    set_role_world_pid(RoleWorldPId),
                    case gen_server:call(RoleWorldPId, {init_role_info_auth,{AccountName, RoleId, get_ip(),get_device_id()}}, 60000) of
                        {ok,{RoleInfo,MapId,MapProcessName,Level,Now,QuickKey}} ->
                            do_auth7(RegName,AccountName,RoleId,RoleInfo,MapId,MapProcessName,Level,Now,QuickKey);
                        {error,Reason} ->
                            do_notify_exit(Reason);
                        Error ->
                            ?ERROR_MSG("~ts,Error=~w",[?_LANG_TCP_CLIENT_019,Error]),
                            do_notify_exit(login_timeout)
                    end;
                _ ->
                    do_notify_exit(world_register_failed)
            end;
        RoleWorldPId ->
            set_role_world_pid(RoleWorldPId),
            case gen_server:call(RoleWorldPId, {get_auth_key_data,{AccountName,RoleId,erlang:self(),get_gateway(),get_ip()}}, 10000) of
                {ok,{RoleInfo,MapId,MapProcessName,Level,Now,QuickKey}} ->
                    do_auth7(RegName,AccountName,RoleId,RoleInfo,MapId,MapProcessName,Level,Now,QuickKey);
                {error,Reason} ->
                    do_notify_exit(Reason);
                Error ->
                    ?ERROR_MSG("~ts,Error=~w",[?_LANG_TCP_CLIENT_019,Error]),
                    do_notify_exit(login_timeout)
            end
    end.
%%帐号认证成功之后发给客户端的信息
do_auth7(_RegName,_AccountName,_RoleId,RoleInfo,MapId,MapProcessName,_Level,_Now,QuickKey) ->
    DataRecord= #m_auth_key_toc{
                                op_code = 0,
                                server_time = common_tool:now2(),
                                is_create_role = false,
                                role_info = RoleInfo,
                                map_id = MapId,
								attr_list = common_misc:get_game_config_list(),
                                quick_key = QuickKey
                               },
    mgeeg_packet:send(get_socket(), ?AUTH, ?AUTH_KEY, DataRecord),
    set_map_process_name(MapProcessName),
    set_state(?state_waiting_for_enter_map),
    ok.


%% 快速登录验证
-spec
do_quick_auth(DataRecord) -> ok when
    DataRecord :: #m_auth_quick_tos{}.
do_quick_auth(DataRecord) ->
    case catch do_quick_auth2(DataRecord) of
        {error,OpCode} ->
            SendSelf = #m_auth_quick_toc{op_code=OpCode},
            mgeeg_packet:send(get_socket(), ?AUTH, ?AUTH_QUICK, SendSelf),
            timer:sleep(1000),
            erlang:self() ! {error_exit, auth_quick_key};
        ok ->
            ok;
        Error ->
            ?ERROR_MSG("do quick auth error.DataRecord=~w,Error=~w",[DataRecord,Error])
    end.
do_quick_auth2(DataRecord) ->
    #m_auth_quick_tos{account_name=AccountName,
                      role_id=RoleId,
                      quick_key=QuickKey} = DataRecord,
    %% 参数验证
    case QuickKey of
        "" ->
            erlang:throw({error,?_RC_AUTH_QUICK_008});
        _ ->
            next
    end,
    %% 玩家进程是否存在
    RoleWorldProcessName = common_misc:get_role_world_process_name(RoleId),
    case erlang:whereis(RoleWorldProcessName) of
        undefined ->
            RoleWorldPId = undefined,
            erlang:throw({error,?_RC_AUTH_QUICK_006});
        RoleWorldPId ->
            next
    end,
    %% 当前网关进程是否存在
    RegName = common_misc:get_role_gateway_process_name(RoleId),
    case erlang:whereis(RegName) of
        undefined ->
            next;
        OldGatewayPId ->
            OldGatewayPId ! login_again,
            case wait_old_gateway_process_exit(1,RegName) of
                ok ->
                    next;
                _ ->
                    erlang:throw({error,?_RC_AUTH_QUICK_011})
            end
    end,
    %% 验证当前quick key是否合法
    case gen_server:call(RoleWorldPId, {auth_quick_key,{AccountName,RoleId,erlang:self(),get_gateway(),QuickKey,get_ip()}}, 10000) of
        {ok,{RoleInfo,MapId,MapProcessName,Level,Now,NewQuickKey}} ->
            case wait_old_gateway_process_exit(1,RegName) of
                ok ->
                    set_role_world_pid(RoleWorldPId),
                    do_quick_auth3(DataRecord,RoleInfo,MapId,MapProcessName,Level,Now,NewQuickKey,RegName);
                _ ->
                    %% 快速登录失败，立即关闭玩家进程
                    RoleWorldPId ! {now_close,auth_quick_fail},
                    erlang:throw({error,?_RC_AUTH_QUICK_000})
            end;
        Error ->
            ?ERROR_MSG("check quick key invalid,Record=~w,Error=~w",[DataRecord,Error]),
            %% 快速登录失败，立即关闭玩家进程
            RoleWorldPId ! {now_close,auth_quick_fail},
            erlang:throw({error,?_RC_AUTH_QUICK_007})
    end.
%% 快速登录发现旧的玩家网关进程未关闭，等待10，如果还未关闭，即本次快速登录失败处理
wait_old_gateway_process_exit(0,_RegName) ->
    ok;
wait_old_gateway_process_exit(30,RegName) ->
    case erlang:whereis(RegName) of
        undefined -> ok;
        _ -> error
    end;
wait_old_gateway_process_exit(Index,RegName) ->
    case erlang:whereis(RegName) of
        undefined ->
            wait_old_gateway_process_exit(30,RegName);
        _ ->
            timer:sleep(1000),
            wait_old_gateway_process_exit(Index + 1, RegName)
    end.
do_quick_auth3(DataRecord,RoleInfo,MapId,MapProcessName,_Level,_Now,QuickKey,RegName) ->
    #m_auth_quick_tos{account_name=AccountName,
                      role_id=RoleId,
                      fcm=FCM,
                      device_id=DeviceId} = DataRecord,
    set_account_name(AccountName),
    set_fcm(FCM),
    set_device_id(DeviceId),
    set_role_id(RoleId),
    case erlang:register(RegName, erlang:self()) of
        true ->                
            set_register_name(RegName);
        _ ->
            erlang:throw({error,?_RC_AUTH_QUICK_009})
    end,
    case init_fcm(AccountName, FCM) of
        ok ->
            next;
        {error, fcm_kick_off_not_enough_off_time} ->
            erlang:throw({error,?_RC_AUTH_QUICK_010});
        {ok,need_fcm, TotalOnlineTime} ->
            %% 版署服特殊处理，即玩家没有通过防沉迷，登录游戏即立即提示
            %% erlang:send_after(1000, erlang:self(), {need_fcm_notify, -99999999}),
            %% 第一次防沉迷弹出时间
            %% 进入游戏后多久弹出第一次防沉迷时间
            [FirstNotifyFcmTime] = common_config_dyn:find(etc, first_notify_fcm_time),
            %% 在线多就之后被防沉迷， 被防沉迷后多就才能重新上线
            [FcmKickTime] = common_config_dyn:find(etc, fcm_kick_time),
            erlang:send_after(FirstNotifyFcmTime * 1000, erlang:self(), {notify_fcm, TotalOnlineTime + FirstNotifyFcmTime}),
            %% 满三个小时就干掉这个号
            erlang:send_after((FcmKickTime-TotalOnlineTime) * 1000, erlang:self(), fcm_kick_time),
            next
    end,
    SendSelf= #m_auth_quick_toc{op_code = 0,
                                server_time = common_tool:now2(),
                                role_info = RoleInfo,
                                map_id = MapId,
                                attr_list = common_misc:get_game_config_list(),
                                quick_key = QuickKey
                               },
    mgeeg_packet:send(get_socket(), ?AUTH, ?AUTH_QUICK, SendSelf),
    set_map_process_name(MapProcessName),
    set_state(?state_waiting_for_enter_map),
    ok.

%% 初始化防沉迷信息
init_fcm(AccountNameTmp,FCM) ->
    case common_misc:is_fcm_open() of
        false ->
            ok;
        _ ->
            init_fcm2(AccountNameTmp,FCM)
    end.
init_fcm2(AccountNameTmp,FCM) ->
    case FCM of
        1 ->
            Passed = true;
        _ ->
            Passed = false
    end,
    AccountName=common_tool:to_binary(AccountNameTmp),
    case db_api:dirty_read(?DB_FCM_DATA, AccountName) of
        [] ->
            FcmInfo = #r_fcm_data{account=AccountName, passed=Passed};
        [FcmInfoT] ->
            FcmInfo = FcmInfoT#r_fcm_data{passed=Passed}
    end,
    set_fcm(FCM),
    case Passed of
        true ->
            set_role_fcm_info(FcmInfo),
            ok;
        _ ->
            #r_fcm_data{offline_time=OffLineTime, total_online_time=TotalOnlineTime} = FcmInfo,
            %%如果离线时间超过5小时或者隔天登陆，持续在线时间清零
            OffLineTimeTotal = common_tool:now() - OffLineTime,
            OffLineDate = common_time:time_to_date(OffLineTime),
            {NowDate, _} = erlang:localtime(),
            [FCMOfflineTime] = common_config_dyn:find(etc, fcm_offline_time),
            case OffLineTimeTotal >= FCMOfflineTime orelse OffLineDate =/= NowDate of
                true ->
                    set_role_fcm_info(FcmInfo#r_fcm_data{total_online_time=0}),
                    {ok, need_fcm, 0};
                false ->
                    set_role_fcm_info(FcmInfo),
                    [FcmKickTime]=common_config_dyn:find(etc, fcm_kick_time),
                    case TotalOnlineTime >= FcmKickTime of
                        true ->
                            {error, fcm_kick_off_not_enough_off_time};
                        false ->
                            {ok, need_fcm, TotalOnlineTime}
                    end
            end
    end.
                               
set_device_id(DeviceId) ->
	erlang:put(device_id, DeviceId).
get_device_id() ->
	case erlang:get(device_id) of
		undefined ->
			"";
		DeviceId ->
			DeviceId
	end.

set_ip(IP) ->
    erlang:put(ip, IP).
get_ip() ->
    erlang:get(ip).

set_socket(Socket) ->
    erlang:put(socket, Socket).
get_socket() ->
    erlang:get(socket).

set_gateway(Value) ->
    erlang:put(g, Value).
get_gateway() ->
    erlang:get(g).

init_state() ->
    erlang:put(state, ?state_waiting_for_auth).
get_state() ->
    erlang:get(state).
set_state(State) ->
    erlang:put(state, State).

get_account_name() ->
    erlang:get(account_name).
set_account_name(AccountName) ->
    erlang:put(account_name, AccountName).

set_fcm(Fcm) ->
    erlang:put(fcm, Fcm).
get_fcm() ->
    erlang:get(fcm).

get_role_fcm_info() ->
    erlang:get(role_fcm_info).
set_role_fcm_info(RoleFcmInfo) ->
    erlang:put(role_fcm_info, RoleFcmInfo).
erase_role_fcm_info() ->
    erlang:erase(role_fcm_info).

get_role_id() ->
    erlang:get(role_Id).
set_role_id(RoleId) ->
    erlang:put(role_Id, RoleId).

get_last_heartbeat_time() ->
    erlang:get(last_hb_time).
set_last_heartbeat_time(T) ->
    erlang:put(last_hb_time, T).

%% 上一次发包时间
get_per_packet_time() ->
    erlang:get(per_packet_time).
set_per_packet_time(T) ->
    erlang:put(per_packet_time, T).
%% 发包次数统计
get_total_packet_number() ->
    erlang:get(total_packet_number).
set_total_packet_number(N) ->
    erlang:put(total_packet_number, N).

set_register_name(RegName) ->
    erlang:put(reg_name, RegName).
%% get_register_name() ->
%%     erlang:get(reg_name).

set_map_process_name(MapName) ->
    erlang:put(map_pname, MapName).
%% get_map_process_name() ->
%%     erlang:get(map_pname).
erase_map_process_name() ->
    erlang:erase(map_pname).
%% 玩家逻辑进程
get_role_world_pid() ->
    erlang:get(role_world_pid).
set_role_world_pid(PId) ->
    erlang:put(role_world_pid, PId).
%% erase_role_world_pid() ->
%%     erlang:erase(role_world_pid).

is_enter_map_status() ->
    erlang:get(is_enter_map).
set_enter_map_status() ->
    erlang:put(is_enter_map, true).
clear_enter_map_status() ->
    erlang:put(is_enter_map, false).

%% 进程启动时间，秒
get_start_process_time() ->
    erlang:get(start_process_time).
set_start_process_time(StartProcessTime) ->
    erlang:put(start_process_time, StartProcessTime).
