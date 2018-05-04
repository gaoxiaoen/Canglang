%% **************************************
%% 日志服务进程
%% @author wpf (wprehard@qq.com)
%% **************************************
-module(log_host).
-behaviour(gen_server).
-export([
        log/2
        ,reload/1
        ,shutdown/1
        ,start_link/0
    ]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").

-record(state, {
        index = 0       %% 编号，日志的当前进程的唯一ID
    }).

%% @spec log(Type, DataList) -> any()
%% @doc 日志写ets
log(Type, Data) when is_tuple(Data) ->
    do_log(Type, Data);
log(Type, Data) when is_list(Data) ->
    do_log(Type, Data);
log(_Type, _Data) ->
    ?DEBUG("错误的日志信息[Type:~w, Data:~w]", [_Type, _Data]),
    inore.
do_log(_Type, []) -> ignore;
do_log(Type, Data) ->
    Num = log_mgr:get_host_num(),
    HostIndex = erlang:phash(Data, Num),
    case log_mgr:is_host_alive(HostIndex) of
        false ->
            %% 预留一次错误机会，重新散列分布
            HostIndex0 = HostIndex + erlang:phash(Data, Num - HostIndex),
            case log_mgr:is_host_alive(HostIndex0) of
                false ->
                    ?ELOG("日志记录二次忽略TYPE:~w, Data:~w", [Type, Data]),
                    ignore;
                true ->
                    put(Type, {HostIndex0, Data}), %% TODO: 用于回滚
                    ets:insert(Type, {HostIndex0, Data})
            end;
        true ->
            put(Type, {HostIndex, Data}), %% TODO: 用于回滚
            ets:insert(Type, {HostIndex, Data})
    end.

%% @spec reload(Pid) -> ok | false
%% @doc 重载定时器
reload(HostPid) ->
    gen_server:call(HostPid, reload_timer).

%% @spec shutdown(Pid) -> ok | false
%% @doc 关机保存
shutdown(Pid) ->
    gen_server:call(Pid, shutdown).

%% @spec start_link(CdTime, CdCnt) -> pid()
%% CdTime = integer() 豪秒
%% CdCnt = integer() 次数
%% 创建一个日志服务器
start_link() ->
    gen_server:start_link(?MODULE, [], []).

%% -----------------------------
%% 内部函数
%% -----------------------------
%% 同步ets日志
sync(LogType) ->
    Index = log_mgr:get_host_index(self()),
    case ets:lookup(LogType, Index) of
        [] -> ignore;
        L ->
            Sql = log_db:to_sql(LogType),
            case db:tx(fun() -> do_sync_to_db(Sql, L) end) of
                {ok, true} -> ok;
                {ok, _X} ->
                    ?DEBUG("角色日志信息写入返回：~w", [_X]),
                    ok;
                _E -> ?ERR("角色日志信息写入出错TYPE:~w, ERR:~w", [LogType, _E])
            end,
            do_delete(LogType, L)
    end.

log_to_db(_Sql, []) -> ignore;
log_to_db(Sql, [H | T]) ->
    log_to_db(Sql, H),
    log_to_db(Sql, T);
log_to_db(Sql, Data) when is_tuple(Data) ->
    case db:execute(Sql, tuple_to_list(Data)) of
        {ok, _} -> true;
        {error, Why} ->
            ?ERR("插入日志数据失败[SQL:~w, REASON:~w]", [Sql, Why]),
            {false, Why}
    end;
log_to_db(_, _) -> ignore.

do_sync_to_db(_Type, []) -> true;
do_sync_to_db(Type, [{_, Data} | T]) ->
    log_to_db(Type, Data),
    do_sync_to_db(Type, T).

%% 删除ets日志
do_delete(_Type, []) -> ok;
do_delete(Type, [{I, _Data} | T]) ->
    ets:delete(Type, I),
    do_delete(Type, T).

%% 定时器初始化
timer_init() ->
    L = log:timer_init(),
    do_timer_init(L).
do_timer_init([]) -> ok;
do_timer_init([{LogType, Time} | T]) ->
    case ets:info(LogType, name) of
        undefined ->
            ets:new(LogType, [public, duplicate_bag, named_table]);
        _ -> ignore
    end,
    case get(LogType) of
        undefined -> ignore;
        Ref -> erlang:cancel_timer(Ref)
    end,
    NewTime = Time + util:rand(0, Time - 1), %% 分散压力
    put(LogType, erlang:send_after(NewTime * 1000, self(), {sync, LogType, NewTime})),
    do_timer_init(T).

%% 同步所有日志
do_shutdown([]) -> ok;
do_shutdown([{LogType, _} | T]) ->
    sync(LogType),
    do_shutdown(T).

%% gen_server 内部处理

init([]) ->
    %% ?INFO("[~w] 正在启动...", [?MODULE]),
    process_flag(trap_exit, true),
    timer_init(),
    %% ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, #state{}}.

%% 更新同步的间隔时间
handle_call(reload_timer, _From, State) ->
    timer_init(),
    {reply, ok, State};

%% 关机
handle_call(shutdown, _From, State) ->
    L = log:timer_init(),
    do_shutdown(L),
    {reply, ok, State};

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info({sync, LogType, Time}, State) ->
    sync(LogType),
    erlang:send_after(Time * 1000, self(), {sync, LogType, Time}),
    {noreply, State};

handle_info(_Info, State) ->
    ?DEBUG("忽略的异步消息：~w", [_Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    ?DEBUG("日志服务进程关闭"),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
