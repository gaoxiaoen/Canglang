%%----------------------------------------------------
%% 测试器进程
%% 
%% @author yeahoo2000@gmail.com
%% @end
%%----------------------------------------------------
-module(tester).
-behaviour(gen_server).
-export([
        start/3
        ,stop/1
        ,cmd/2
        ,cmd/3
        ,cmd/4
        ,pack_send/2
        ,rand/2
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("common.hrl").
-include("tester.hrl").

-define(TCP_OPTS, [binary, {packet, 0}, {nodelay, false}, {delay_send, true}, {exit_on_close, false}]).

%% 调试选项
-ifdef(debug_socket).
-define(PRINT_SEND(Bin), <<C:16, B/binary>> = Bin, case 1099 =:= C of true -> ignore; false -> ?DEBUG("已发送数据到服务端[~w]: ~w", [C, B]) end).
-define(PRINT_RECV(Cmd, Data), case 1099 =:= Cmd of true -> ignore; false -> ?DEBUG("接收到服务端命令[Cmd:~w Data:~w]", [Cmd, Data]) end).
-else.
-define(PRINT_SEND(Bin), ok).
-define(PRINT_RECV(Cmc, Data), ok).
-endif.

%% ----------------------------------------------------
%% 对外接口
%% ----------------------------------------------------
%% @spec start(Account, Host, Port) -> ok
%% Account = string() |iolist()
%% Host = string()
%% Port = integer()
%% @doc 创建测试进程
start(Account, Host, Port) when is_list(Account) ->
    start(list_to_binary(Account), Host, Port);
start(Account, Host, Port) ->
    gen_server:start(?MODULE, [Account, Host, Port], []).

%% @spec stop(Pid) -> ok
%% Pid = pid() | integer()
%% @doc 退出
stop(Rid) when is_integer(Rid) ->
    case ets:lookup(tester_online, Rid) of
        [T] ->
            stop(T#tester.pid);
        _ ->
            ignore
    end;
stop(Pid) ->
    Pid ! logout.

%% @spec cmd(Mod, Fun) -> ok
%% Mod = atom()
%% Fun = atom()
%% @doc 执行模块命令(当前进程，且不带命令参数)
cmd(Mod, Fun) ->
    cmd(self(), Mod, Fun, {}).

%% @spec cmd(Pid, Mod, Fun) -> ok
%% Pid = pid() | integer()
%% Mod = atom()
%% Fun = atom()
%% @doc 调用模块命令(不带命令参数)
cmd(Pid, Mod, Fun) when is_pid(Pid) ->
    cmd(Pid, Mod, Fun, {});
cmd(Mod, Fun, Args) ->
    cmd(self(), Mod, Fun, Args).

%% @spec cmd(Pid, Mod, Fun, Args) -> ok
%% Pid = pid() | integer()
%% Mod = atom()
%% Fun = atom()
%% Args = tuple()
%% @doc 调用本地命令
cmd(Rid, Mod, Fun, Args) when is_integer(Rid) ->
    case ets:lookup(tester_online, Rid) of
        [T] ->
            cmd(T#tester.pid, Mod, Fun, Args);
        _ ->
            ignore
    end;
cmd(Pid, Mod, Fun, Args) ->
    Pid ! {cmd, Mod, Fun, Args}.

%% @spec pack_send(Cmd, Data)-> ok
%% Cmd = integer()
%% Data = tuple()
%% @doc 打包并发送消息到服务器
pack_send(Cmd, Data) ->
    Socket = get(socket),
    case mapping:module(tester, Cmd) of
        {ok, Proto, _Mod} ->
            case Proto:pack(cli, Cmd, Data) of
                {ok, Bin} ->
                    ?PRINT_SEND(Bin),
                    gen_tcp:send(Socket, Bin);
                {error, Reason} ->
                    ?ERR("打包数据出错[Reason:~w]", [Reason])
            end;
        {error, Code} ->
            ?ERR("模块映射失败:~p", [Code])
    end.

%% 产生一个随机数
rand(Min, Min) -> Min;
rand(Min, Max) ->
    M = Min - 1,
    random:uniform(Max - M) + M.

%% ----------------------------------------------------
%% 内部调用处理
%% ----------------------------------------------------

init([Account, Host, Port]) ->
    {ok, Socket} = gen_tcp:connect(Host, Port, [
            binary
            ,{packet, 0}
            ,{active, false}
            ,{reuseaddr, true}
            ,{nodelay, false}
            ,{delay_send, true}
        ]
    ),
    gen_tcp:send(Socket, <<"game_client------------">>),
    State = #tester{socket = Socket, pid = self(), connect_time = now()},
    case ets:info(tester_online) of
        undefined ->
            ets:new(tester_online, [set, named_table, public, {keypos, #tester.id}]);
        _ ->
            ignore
    end,
    put(socket, Socket),    %% 保存socket

    put(acc_name, Account), %% 临时保存
    cmd(self(), test_client_rpc_open, acc_login, {Account, 0, <<"abc">>}),
    erlang:send_after(5000, self(), login_check), %% 5秒后登录超时
    self() ! heartbeat, %% 开始心跳
    {ok, State}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(heartbeat, State) ->
    pack_send(1099, {0, 0}),
    erlang:send_after(20000, self(), heartbeat),
    {noreply, State};

%% 处理原生命令
handle_info({cmd, Mod, Cmd, Data}, State) ->
    handle(Mod, Cmd, Data, State);

%% 如果检查到帐号未登录则退出进程
handle_info(login_check, State = #tester{acc_name = AccName})->
    case AccName =:= <<>> of
        true ->
            ?INFO("登录超时，进程结束运行"),
            {stop, normal, State};
        false ->
            {noreply, State}
    end;

%% 退出
handle_info(logout, State) ->
    {stop, normal, State};

%% 客户端断开了连接
handle_info({inet_async, _Socket, _Ref, {error, closed}}, State) ->
    ?DEBUG("连接关闭: ~w", [_Socket]),
    {stop, normal, State};
%% 收到包头数据
handle_info({inet_async, Socket, _Ref, {ok, <<Len:32>>}}, State = #tester{read_head = true}) ->
    %% ?DEBUG("包头长度:~w", [Len]),
    prim_inet:async_recv(Socket, Len, -1), %% 读取内容
    {noreply, State#tester{read_head = false}};
%% 收到正常数据
handle_info({inet_async, _Socket, _Ref, {ok, <<Cmd:16, Bin/binary>>}}, State = #tester{read_head = false}) ->
    ?PRINT_RECV(Cmd, Bin),
    case mapping:module(tester, Cmd) of
        {ok, Proto, Mod} ->
            case Proto:unpack(cli, Cmd, Bin) of
                {ok, Data} ->
                    handle(Mod, Cmd, Data, State);
                {error, _Reason} ->
                    ?ERR("解包数据出错[Mod:~w Cmd:~w Bin:~w]", [Mod, Cmd, Bin]),
                    read_next(State)
            end;
        _Other ->
            ?ERR("未知命令: ~w", [Cmd]),
            read_next(State)
    end;
%% 接收socket数据时发生了未预料的错误
handle_info({inet_async, _Socket, _Ref, {error, _Reason}}, State = #tester{acc_name = Account}) ->
    ?ERR("帐号[~s]读取socket数据出错:~w", [Account, _Reason]),
    {stop, normal, State};

handle_info(_Info, State) ->
    ?DEBUG("收到未知消息: ~w", [_Info]),
    {noreply, State}.

terminate(_Reason, State) ->
    ?INFO("~s进程已经退出", [State#tester.acc_name]),
    ok.

code_change(_OldVsn, State = #tester{id = Id}, _Extra) ->
    ets:delete(tester_online, Id),
    {ok, State}.

%% ----------------------------------------------------
%% 私有函数
%% ----------------------------------------------------

%% 处理结果
handle(Mod, Cmd, Data, State = #tester{acc_name = Account, name = Name}) ->
    case catch Mod:handle(Cmd, Data, State) of
        {ok} ->
            read_next(State);
        {ok, NewState} when is_record(NewState, tester) ->
            read_next(NewState);
        {stop} ->
            {stop, normal, State};
        {error, _Reason} ->
            ?ERR("处理命令时出错[Account:~s Name:~s Mod:~w Cmd:~w Why:~w]: ~w", [Account, Name, Mod, Cmd, _Reason, Data]),
            read_next(State);
        _Reason ->
            ?ERR("处理命令时发生了未预料的错误[Account:~s  Name:~s Mod:~w Cmd:~w]: ~w", [Account, Name, Mod, Cmd, _Reason]),
            read_next(State)
    end.

%% 通知连接器读取下一条指令
read_next(State = #tester{socket = Socket, read_head = false}) ->
    prim_inet:async_recv(Socket, 4, -1),
    {noreply, State#tester{read_head = true}};
read_next(State) ->
    %% 上一个数据包还未读取完成，忽略掉
    {noreply, State}.
