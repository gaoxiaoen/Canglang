%%----------------------------------------------------
%% 监控器进程(客户端)
%% 每一个监控器进程远端对应一台受控的服务器
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(mon_proc).
-behaviour(gen_server).
-export([
        create/3
        ,pack_send/3
        ,disconnect/1
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("common.hrl").
-include("mon.hrl").

-define(TCP_OPTS, [binary, {packet, 0}, {nodelay, false}, {delay_send, true}, {exit_on_close, false}]).

%% 创建监控进程
create(Account, Host, Port) ->
    gen_server:start(?MODULE, [Account, Host, Port], []).

%% 断开连接
disconnect(MonPid) ->
    MonPid ! disconnect.

%% 打包并发送消息到服务器
pack_send(Socket, Cmd, Data) ->
    case mapping:module(monitor, Cmd) of
        {ok, Proto, _Mod} ->
            case Proto:pack(cli, Cmd, Data) of
                {ok, Bin} ->
                    gen_tcp:send(Socket, Bin);
                {error, Reason} ->
                    ?ERR("打包数据出错[Reason:~w]", [Reason])
            end;
        {error, Code} ->
            ?ERR("模块映射失败:~p", [Code])
    end.

init([Account, Host, Port]) ->
    {ok, Socket} = gen_tcp:connect(Host, Port, ?TCP_OPTS),
    gen_tcp:send(Socket, <<"monitor_client---------">>),
    ok = inet:setopts(Socket, [{packet, 2}]),
    ?cmd(mon_rpc, heartbeat, {}),
    State = #mon{pid = self(), account = Account, host = Host, port = Port, socket = Socket, connect_time = now()},
    ets:insert(ets_mon, State),
    {ok, State}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

%% 断开连接
handle_info(disconnect, State) ->
    {stop, normal, State};

%% 处理原生命令
handle_info({cmd, Mod, Cmd, Data}, State) ->
    handle(Mod, Cmd, Data, State);

%% 处理服务端返回数据
handle_info({tcp, _Socket, <<Cmd:16, Bin/binary>>}, State) ->
    %% ?DEBUG("收到受控服务器数据: ~w", [Bin]),
    case mapping:module(monitor, Cmd) of
        {ok, Proto, Mod} ->
            case Proto:unpack(cli, Cmd, Bin) of
                {ok, Data} ->
                    handle(Mod, Cmd, Data, State);
                {error, _Reason} ->
                    ?ERR("解包数据出错[Mod:~w Cmd:~w Bin:~w]", [Mod, Cmd, Bin]),
                    {noreply, State}
            end;
        _Other ->
            ?ERR("未知命令: ~w", [Cmd]),
            {noreply, State}
    end;

handle_info({tcp_closed, _Socket}, State) ->
    ?DEBUG("连接关闭: ~w", [_Socket]),
    {noreply, State};

handle_info({tcp_error, _Socket, _Reason}, State) ->
    ?DEBUG("连接发生错误: ~w ~w", [_Socket, _Reason]),
    {noreply, State};

handle_info(_Info, State) ->
    ?DEBUG("收到未知消息: ~w", [_Info]),
    {noreply, State}.

terminate(_Reason, #mon{host = _Host}) ->
    ?DEBUG("服务器~s的监控进程已退出", [_Host]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ----------------------------------------------------
%% 私有函数
%% ----------------------------------------------------

%% 处理结果
handle(Mod, Cmd, Data, State = #mon{host = Host}) ->
    case catch Mod:handle(Cmd, Data, State) of
        {ok} ->
            {noreply, State};
        {ok, NewState} when is_record(NewState, mon) ->
            {noreply, NewState};
        {error, _Reason} ->
            ?ERR("[~s]处理命令时出错[Cmd:~w]: ~w", [Host, Cmd, _Reason]),
            {noreply, State};
        _Reason ->
            ?ERR("[~s]的角色进程处理命令时发生了未预料的错误[Cmd:~w]: ~w", [Host, Cmd, _Reason]),
            {noreply, State}
    end.
