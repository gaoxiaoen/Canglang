%%----------------------------------------------------
%% 中央服连接器
%% 
%% @author yeahoo2000@gmail.com
%% @end
%%----------------------------------------------------
-module(c_conn).
-behaviour(gen_server).
-export([
        create/3
        ,send/2
        ,pack/2
        ,pack_send/3
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("common.hrl").
-record(state, {
         mpid               %% 对应的远端服务器镜像进程
        ,socket
        ,host
        ,port
        ,read_head = false  %% 标识正在读取数据包头
        ,length = 0         %% 包体长度
    }
).

-define(TCP_OPTS, [binary, {packet, 0}, {nodelay, false}, {delay_send, true}, {exit_on_close, false}]).

%% 调试选项
-ifdef(debug_socket).
-define(PRINT_RECV(Cmd, Data),
    case Cmd of
        1099 -> ignore;
        10115 -> ignore;
        10122 -> ignore;
        _ -> ?DEBUG("接收到远端服务器命令[Cmd:~w Host:~s Data:~w]", [Cmd, State#state.host, Data])
    end
).
-define(PRINT_SEND(Bin),
    case is_list(Bin) of
        true -> <<_L:32, C:16, B/binary>> = list_to_binary(Bin);
        false -> <<_L:32, C:16, B/binary>> = Bin
    end,
    case C of
        1099 -> ignore;
        10115 -> ignore;
        10122 -> ignore;
        _ ->
            ?DEBUG("已发送数据到客户端[Cmd:~p Host:~s Data:~w]", [C, Host, B])
    end
).
-else.
-define(PRINT_RECV(Cmc, Data), ok).
-define(PRINT_SEND(Bin), ok).
-endif.

%% ----------------------------------------------------
%% 对外接口
%% ----------------------------------------------------

%% @spec create(ClientType, Socket, Ip, Port) -> {ok, Pid} | ignore | {error, Error}
%% ClientType = monitor | game | tester
%% Socket = port()
%% Ip = binary()
%% Port = int()
%% @doc 创建一个连接器
create(Mpid, Host, Port) ->
    gen_server:start(?MODULE, [Mpid, Host, Port], []).

%% @spec send(Spid, Bin) -> ok
%% Spid = pid()
%% Data = binary()
%% @doc 通知连接器发送数据
%% <div>当此函数在角色进程内执行时会自动处理发送缓冲区的操作</div>
%% <div>如果不是在角色进程内执行则会直接将数据发送到客户端</div>
send(Spid, Bin) ->
    case get(send_buff) of
        undefined -> Spid ! {send_data, Bin};
        [] -> Spid ! {send_data, Bin};
        [H] -> put(send_buff, [[Bin | H]]);
        [H | T] -> put(send_buff, [[Bin | H] | T])
    end.

%% @spec pack(Cmd, Data) -> {ok, Bin} | {false, Reason}
%% Cmd = integer()
%% Data = tuple()
%% Bin = binary()
%% Reason = bitstring()
%% @doc 打包协议数据
pack(Cmd, Data) ->
    case mapping:module(center_server, Cmd) of
        {ok, _Auth, _Caller, Proto, _ModName} ->
            case catch Proto:pack(cli, Cmd, Data) of
                {ok, Bin} -> {ok, Bin};
                _Err -> {false, ?L(<<"打包数据时发生异常">>)}
            end;
        {error, _Code} ->
            {false, ?L(<<"打包数据时发生异常">>)}
    end.

%% @spec pack_send(Spid, Cmd, Data) -> ok
%% Spid = pid()
%% Cmd = int()
%% Data = tuple()
%% @doc 打包并发送消息
pack_send(Spid, Cmd, Data) ->
    case mapping:module(center_server, Cmd) of
        {ok, _Auth, _Caller, Proto, _ModName} ->
            case catch Proto:pack(srv, Cmd, Data) of
                {ok, Bin} ->
                    send(Spid, Bin);
                Err ->
                    ?ERR("打包数据出错[Cmd:~w][Err:~w]", [Cmd, Err])
            end;
        {error, _Code} ->
            ?ERR("模块影射失败[~w]:~w", [Cmd, Data])
    end.

%% ----------------------------------------------------
%% 内部处理
%% ----------------------------------------------------

init([Mpid, Host, Port]) ->
    case gen_tcp:connect(Host, Port, ?TCP_OPTS) of
        {error, Reason} -> {stop, Reason};
        {ok, Socket} ->
            %% 握手消息
            self() ! {send_data, <<"center-----------------">>},
            {ok, #state{mpid = Mpid, socket = Socket, host = Host, port = Port}}
    end.

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

%% ----------------------------------------------------
%% 数据接收处理
%% ----------------------------------------------------

%% 客户端断开了连接
handle_info({inet_async, _Socket, _Ref, {error, closed}}, State) ->
    {stop, normal, State};

%% 收到包头数据
handle_info({inet_async, Socket, _Ref, {ok, <<Len:32>>}}, State = #state{read_head = true}) ->
    %% ?DEBUG("包头长度:~w", [Len]),
    prim_inet:async_recv(Socket, Len, 80000), %% 读取内容
    {noreply, State#state{length = Len, read_head = false}};

%% 接收到正常数据
handle_info({inet_async, Socket, _Ref, {ok, <<_Seq:8, _Chk:8, Cmd:16, Bin/binary>>}}, State = #state{read_head = false}) ->
    ?PRINT_RECV(Cmd, Bin),
    routing(Cmd, Bin, State),
    prim_inet:async_recv(Socket, 4, 0),
    {noreply, State#state{read_head = true}};

%% 收到异常数据
handle_info({inet_async, Socket, _Ref, {ok, Bin}}, State = #state{host = Host, socket = Socket}) ->
    ?ERR("远端服务器[~s]发送了无效请求: ~w", [Host, Bin]),
    {noreply, State};

%% 接收socket数据时发生了未预料的错误
handle_info({inet_async, _Socket, _Ref, {error, Reason}}, State = #state{host = Host}) ->
    ?ERR("读取远端服务器[~s]发送的数据时出错:~w", [Host, Reason]),
    {stop, normal, State};

%% ----------------------------------------------------
%% 数据发送处理
%% ----------------------------------------------------

%% 发送socket数据
handle_info({send_data, Bin}, State = #state{socket = Socket, host = Host}) ->
    case catch erlang:port_command(Socket, Bin) of
        true -> ?PRINT_SEND(Bin);
        false -> ?ERR("对远端服务器[~s]执行port_command失败", [Host]);
        _Err -> ?ERR("对远端服务器[~s]发送socket数据失败:~w", [Host, _Err])
    end,
    {noreply, State};

%% 处理socket数据发送结果
handle_info({inet_reply, _Socket, ok}, State) ->
    {noreply, State};

%% 发送在连接断开
handle_info({inet_reply, _Socket, {error, closed}}, State) ->
    {stop, normal, State};

%% 发送超时
handle_info({inet_reply, _Socket, {error, timeout}}, State) ->
    {noreply, State};

%% 发送时出现未知异常
handle_info({inet_reply, _Socket, _Else}, State = #state{host = Host}) ->
    ?ERR("对远端服务器[~s]发送socket数据时发生了未预料的错误: ~w", [Host, _Else]),
    {stop, normal, State};

%% 处理关联进程退出事件
handle_info({'EXIT', _Pid, normal}, State) ->
    {stop, normal, State};

%% 远端服务器主动断开连接
handle_info({tcp_closed, _Socket}, State = #state{host = _Host}) ->
    ?DEBUG("远端服务器[~s]主动断开连接", [_Host]),
    {noreply, State};

handle_info(Info, State = #state{host = Host}) ->
    ?ERR("远端服务器[~s]的连接器收到未知消息: ~w", [Host, Info]),
    {stop, normal, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ----------------------------------------------------
%% 私有函数
%% ----------------------------------------------------

%% 路由处理
routing(Cmd, Bin, #state{mpid = Mpid, host = Host}) ->
    case mapping:module(center_server, Cmd) of
        {ok, true, _Caller, Proto, Mod} ->
            case catch Proto:unpack(cli, Cmd, Bin) of
                {ok, Data} ->
                    c_mirror:rpc(Mpid, Mod, Cmd, Data);
                Err ->
                    ?ERR("对远端服务器[~s]发送的数据进行解包时出错[Mod:~w Cmd:~w Err:~w]", [Host, Mod, Cmd, Err])
            end;
        _Else ->
            ?ERR("远端服务器[~s]发送了无效请求[~w]", [Host, Cmd])
    end.
