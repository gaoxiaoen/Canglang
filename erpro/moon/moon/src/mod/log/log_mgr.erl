%% **************************************
%% 日志服务管理接口
%% @author wpf (wprehard@qq.com)
%% **************************************

-module(log_mgr).
-behaviour(gen_server).
-export([
        is_host_alive/1
        ,get_host_index/1
        ,get_host_num/0
        ,adm_reload/0
        ,adm_get/0
        ,start_link/0
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").

-define(TOTAL_HOSTS, 24). %% 日志服务进程数

-record(state, {
        count = 0       %% 编号范围
    }
).

-record(log_host, {
        index = 0       %% 日志服务器的编号
        ,pid = 0        %% 日志服务器PID
    }).

%% @spec is_host_alive(Index) -> true | false
%% @doc 日志服务是否可用
is_host_alive(Index) ->
    case ets:lookup(log_host, Index) of
        [#log_host{}] -> true;
        _ -> false
    end.

%% @spec get_host_num() -> integer()
%% @doc 获取主机数
get_host_num() ->
    ?TOTAL_HOSTS.

%% @spec get_host_index(Pid) -> integer()
%% @doc 获取主机索引
get_host_index(Pid) ->
    case catch ets:match_object(log_host, #log_host{_ = '_', pid = Pid}) of
        [#log_host{index = Index}] -> Index;
        _ -> 0
    end.

%% @spec adm_reload() -> ok | false
%% @doc 重载日志服务模块
adm_reload() ->
    L = ets:tab2list(log_host),
    adm_reload(L).
adm_reload([]) -> ?INFO("日志服务重载完成");
adm_reload([#log_host{pid = Pid} | T]) ->
    log_host:reload(Pid),
    adm_reload(T).

%% @spec adm_get() -> integer()
%% @doc 获取当前日志服务进程数
adm_get() ->
    gen_server:call(?MODULE, get_total).

%% @spec start_link() -> pid()
%% @doc 创建日志管理进程
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% -----------------------------------------
%% 内部
%% -----------------------------------------

%% 启动N个日志服务
create(Index) ->
    create(Index, get_host_num()).
create(Index, Total) when Index =< Total ->
    NextIndex = case catch log_host:start_link() of
        {ok, Pid} ->
            ets:insert(log_host, #log_host{index = Index, pid = Pid}),
            Index + 1;
        _Err ->
            ?ELOG("日志服务器启动失败:~w", [_Err]),
            Index
    end,
    create(NextIndex, Total);
create(_, Total) -> Total.

%% 检查host是否运行
check(Total) ->
    check(Total, 0).
check(0, N) -> N;
check(Total, N) ->
    X = case ets:lookup(log_host, Total) of
        [#log_host{pid = Pid}] ->
            case is_process_alive(Pid) of
                true -> 1;
                false -> 0
            end;
        _ -> 0
    end,
    check(Total - 1, N + X).

%% 检查并修复log_host
check_host(Total) ->
    L = check_host(Total, []),
    %% ?DEBUG("日志服务进程待修复HOST：~w", [L]),
    repair(L),
    erlang:send_after(60000, self(), check_host).
check_host(0, L) -> L;
check_host(Index, L) ->
    case catch ets:lookup(log_host, Index) of
        [#log_host{pid = Pid}] ->
            case is_process_alive(Pid) of
                true -> check_host(Index - 1, L);
                false -> check_host(Index - 1, [Index | L])
            end;
        _ ->
            ?ELOG("日志管理进程检查发现异常")
    end.
repair([]) -> ok;
repair([Index | T]) ->
    case catch log_host:start_link() of
        {ok, Pid} ->
            ?ELOG("日志服务进程[INDEX:~w]修复完成", [Index]),
            ets:insert(log_host, #log_host{index = Index, pid = Pid});
        _ ->
            ?ELOG("日志服务异常重启失败[Index:~w]", [Index])
    end,
    repair(T).

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    process_flag(trap_exit, true),
    self() ! start,
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, #state{}}.

%% 获取当前服务器个数
handle_call(get_total, _From, State = #state{count = Total}) ->
    N = check(Total),
    {reply, N, State};

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(start, State = #state{count = TotalCnt}) ->
    ets:new(log_host, [public, named_table, set, {keypos, #log_host.index}]),
    log:init(),
    NewCnt = create(TotalCnt + 1),
    check_host(NewCnt),
    {noreply, State#state{count = NewCnt}};

handle_info(check_host, State = #state{count = TotalCnt}) ->
    check_host(TotalCnt),
    {noreply, State};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    L = ets:tab2list(log_host),
    [log_host:shutdown(Pid) || #log_host{pid = Pid} <- L],
    ?DEBUG("日志管理进程关闭"),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

