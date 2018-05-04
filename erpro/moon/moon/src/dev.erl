%%----------------------------------------------------
%% 开发工具
%%
%% @author yeahoo2000@gmail.com
%% @end
%%----------------------------------------------------
-module(dev).
-export([
        info/0
        ,fix/0
        ,pinfo/1
        ,eprof_start/0
        ,eprof_start/2
        ,eprof_stop/0
        ,eprof_stop/1
        ,nodes/0
        ,top/1
        ,top/3
        ,m/0
        ,m/1
        ,u/0
        ,u/1
        ,u/2
        ,edoc/0
        ,mq_info/2
        ,mq_info/3
        ,mq_info_top/2
    ]
).

-include_lib("kernel/include/file.hrl").
-include("common.hrl").
-include("node.hrl").
-include("role.hrl").
-include("map.hrl").
-include("link.hrl").

%% @spec info() -> ok
%% @doc 查看系统当前的综合信息
info() ->
    SchedId      = erlang:system_info(scheduler_id),
    SchedNum     = erlang:system_info(schedulers),
    ProcCount    = erlang:system_info(process_count),
    ProcLimit    = erlang:system_info(process_limit),
    ProcMemUsed  = erlang:memory(processes_used),
    ProcMemAlloc = erlang:memory(processes),
    MemTot       = erlang:memory(total),
    RoleNum      = ets:info(role_online, size),
    RoleNumTotal = case catch sys_node_mgr:role_num(all) of
        N when is_integer(N) -> N;
        _ -> 0
    end,
    util:cn(
        "   Scheduler id:                         ~p~n"
        "   Num scheduler:                        ~p~n"
        "   Memory used by erlang processes:      ~p~n"
        "   Memory allocated by erlang processes: ~p~n"
        "   The total amount of memory allocated: ~p~n"
        "   可创建进程数量上限:                   ~p~n"
        "   当前节点进程数:                       ~p~n"
        "   总在线角色数:                         ~p~n"
        "   本节点在线角色数:                     ~p~n"
        ,[SchedId, SchedNum, ProcMemUsed, ProcMemAlloc, MemTot, ProcLimit, ProcCount, RoleNumTotal, RoleNum]),
    ok.

fix() ->
    case ets:info(role_online, size) of
        N when is_integer(N) andalso N > 0 -> {ok, N};
        _ -> erlang:halt()
    end.

%% @spec top(Type) -> ok
%% @doc 显示资源占最多的进程列表
%% 参数说明见{@link adm:top/1}
top(Type) ->
    top(Type, 1, 10).

%% @spec top(Type, Start, Len) -> ok
%% @doc 显示资源占最多的进程列表
%% 参数说明见{@link adm:top/3}
top(Type, Start, Len) ->
    L = adm:top(Type, Start, Len),
    util:cn(
        "~20s ~24s ~36s ~12s ~12s ~12s~n"
        , ["Pid", "registered_name", "initial_call", "memory", "reductions", "msg_len"]
    ),
    print_top(lists:reverse(L)).

%% @spec nodes() -> ok
%% @doc 打印所有节点的信息
nodes() ->
    Ns = adm:game_nodes(),
    p_nodes(Ns).

%% @spec pinfo(Options) -> ok
%% @doc 打印进程信息
pinfo({global, Name}) ->
    case global:whereis_name(Name) of
        undefined -> undefined;
        P -> pinfo(P)
    end;
pinfo(Name) when is_atom(Name) ->
    case erlang:whereis(Name) of
        undefined -> undefined;
        P -> pinfo(P)
    end;
pinfo(P) when is_list(P) ->
    pinfo(list_to_pid(P));
pinfo(P) when node(P) == node() ->
    io:format("~p~n", [erlang:process_info(P)]),
    io:format("----------------------------------------------------~n");
pinfo(P) when is_pid(P) ->
    Info = case rpc:call(node(P), erlang, process_info, [P]) of
        {badrpc, _} -> undefined;
        X -> X
    end,
    io:format("~p~n", [Info]),
    io:format("----------------------------------------------------~n").


%% @spec mq_info(Options, N, Order) -> ok
%% N = integer() 取消息队列前N个
%% Order = asc | desc
%% @doc 打印进程消息队列
mq_info(P, N) ->
    mq_info(P, N, asc).
mq_info(P, N, Order) when is_list(P) ->
    mq_info(list_to_pid(P), N, Order);
mq_info(P, N, Order) when node(P) == node() ->
    L = erlang:process_info(P),
    case lists:keyfind(messages, 1, L) of
        {_, Mgs} when is_list(Mgs) ->
            Mgs1 = case Order of
                desc -> lists:reverse(Mgs);
                _ -> Mgs
            end,
            Len = length(Mgs1),
            N1 = if
                N < 0 -> 0;
                N > Len -> Len;
                true -> N
            end,
            {L1, _} = lists:split(N1, Mgs1),
            ?INFO("Pid=~w的消息队列前N=~w个：~w", [P, N, L1]);
        _ -> ?INFO("错误的参数:P=~w, N=~w", [P, N])
    end.

%% @spec mq_info_top(TopNum, MsgNum) -> ok
%% TopNum = integer()   消息队列最高的多少个
%% MsgNum = integer() 消息条数
%% @doc 打印消息队列最高的几个进程的消息队列
mq_info_top(TopNum, MsgNum) ->
    case adm:top(queue, 1, TopNum) of
        L when is_list(L) ->
            lists:foreach(fun(Args) ->
                        case Args of
                            [Pid, Name, _, Memory, Reds, MsgLen] ->
                                ?INFO("Pid=~w, Name=~s, Memory=~w, Reds=~w, MsgLen=~w, 消息队列前[~w]个:", [Pid, Name, Memory, Reds, MsgLen, MsgNum]),
                                mq_info(Pid, MsgNum);
                            _ ->
                                ?INFO("top(queue)返回格式错误:~w", [Args])
                        end
                    end, L);
        _ -> ?INFO("top(queue)返回格式错误")
    end.
    

%% @spec eprof_start() -> ok
%% @doc 开始对当前进程执行eprof分析程序
eprof_start() -> eprof_start(pid, [self()]).
%% @spec eprof_start(pid, Pids) -> ok
%% Pids = [pid()]
%% @doc 开始执行eprof分析程序
eprof_start(pid, Pids) ->
    case eprof:start_profiling(Pids) of
        profiling -> ?INFO("eprof启动成功");
        E -> ?INFO("eprof启动失败: ~w", [E])
    end;

%% @doc 对指定角色执行eprof分析
eprof_start(role, {Rid, SrvId}) ->
    case role_api:lookup(by_id, {Rid, SrvId}) of
        {ok, _Node, #role{pid = Pid, link = #link{conn_pid = ConnPid}}} ->
            eprof_start(pid, [Pid, ConnPid]);
        _ ->
            ?INFO("角色[Rid:~w SrvId:~s]不在线", [Rid, SrvId])
    end;

%% @doc 对指定地图进程执行eprof分析
eprof_start(map, MapId) ->
    case ets:lookup(map_info, MapId) of
        [#map{pid = Pid}] ->
            eprof_start(pid, [Pid]);
        _ ->
            ?INFO("地图[~w]不在线", [MapId])
    end.

%% @spec eprof_stop() -> ok
%% @doc 停止eprof并输出分析结果到指eprof_analyze.log文件中
eprof_stop() -> eprof_stop("eprof_analyze").
%% @spec eprof_stop(FileName) -> ok
%% FileName = string()
%% @doc 停止eprof并输出分析结果到指定文件
eprof_stop(FileName) ->
    File = FileName ++ ".log",
    eprof:stop_profiling(),
    eprof:log(File),
    eprof:analyze(total),
    ?INFO("eprof分析结果已经输出到了:~s", [File]).

%% @spec m() -> ok
%% @doc 编译并热更新模块(默认带debug参数)
m() ->
    m(debug).

%% @spec m(Options) -> ok
%% Options = debug | release | list()
%% @doc 编译并更新模块(带参数)
%% <dl><dt>{@type {d, Define::atom()@}}</dt>
%% <dd><ul>
%% <li>debug 开启debug模式，打开宏?DEBUG的输出</li>
%% <li>debug_sql 开启数据库调试模式，打印所有的SQL查询信息</li>
%% <li>debug_socket 开启socket调试模式，打印所有收发的socket数据</li>
%% </ul></dd></dl>
m(debug) -> m([{d, debug}, {outdir, "ebin"}]);
m(release) -> m([{outdir, "ebin_release"}]);
m(Param) ->
    Ns = adm:game_nodes(),
    case lists:keyfind(node(), #node.name, Ns) of
        false -> ?ERR("当前节点无法执行热更新操作");
        _ ->
            util:cn("### 正在编译源码，使用参数:~p~n", [Param]),
            case sys_code:make(Param) of
                up_to_date -> do_up(Ns, [], false);
                _ -> ignore
            end
    end.

%% @doc 热更新所有模块(非强制)
u() ->
    do_up(adm:game_nodes(), [], false).

%% @doc 热更新所有模块(强制更新)
u(force) ->
    do_up(adm:game_nodes(), [], true);

%% @doc 热更新指定模块(非强制)
u(ModList) when is_list(ModList) ->
    do_up(adm:game_nodes(), ModList, false).

%% @doc 热更新指定模块(强制更新)
u(ModList, force) when is_list(ModList) ->
    do_up(adm:game_nodes(), ModList, true).

%% @spec edoc() -> ok
%% @doc 生成API文档，将源码文件全部放入ebin/同级的tmp/目录中
edoc() ->
    {ok, Cwd} = file:get_cwd(),
    Dir = Cwd ++ "/../tmp",
    case adm:file_list(Dir, ".erl") of
        {error, _Why} -> ignore;
        {ok, L} ->
            edoc:files(do_edoc(L, []), [{dir, "../api_doc"}])
    end,
    ok.

%% ----------------------------------------------------
%% 私有函数
%% ----------------------------------------------------

%% 打印节点信息
p_nodes([]) -> ok;
p_nodes([H | T]) ->
    [_ | L] = tuple_to_list(H),
    util:cn(
        " ------------------------------------~n"
        "   节点:       ~p~n"
        "   梆定域名:   ~p~n"
        "   监听端口:   ~p~n"
        "   是否隐藏:   ~p~n"
        "   在线角色数: ~p~n"
        "   进程数量:   ~p~n"
        "   负载:       ~p~n"
        , L),
    p_nodes(T).

%% 格式化打钱top信息
print_top([]) -> ok;
print_top([H | T]) ->
    io:format("~20w ~24w ~36w ~12w ~12w ~12w~n", H),
    print_top(T).

%% 执行更新
do_up([], _L, _F) -> ok;
do_up([N | Ns], L, F) ->
    util:cn("--- 正在热更新节点: ~p~n", [N#node.name]),
    Args = case {L, F} of
        {[], false}         -> [];
        {[], true}          -> [force];
        {[_H | _T], false}  -> [L];
        {[_H | _T], true}   -> [L, force]
    end,

    Rtn = rpc:call(N#node.name, sys_code, up, Args, infinity),
    print_up(Rtn),
    do_up(Ns, L, F).

%% 显示更新结果
print_up([]) -> ok;
print_up([{M, R} | T]) ->
    case R of
        ok ->
            util:cn("# 加载模块成功: ~p~n", [M]);
        {error, Reason} ->
            util:cn("* 加载模块失败[~p]: ~p~n", [M, Reason])
    end,
    print_up(T).

%% 处理edoc使用的文件列表，过滤掉没有必要生成文档的文件
do_edoc([], L) -> L;
do_edoc([{M, F} | T], L) ->
    case util:text_banned(M, ["proto_.*", ".*_data", "sup_.*", ".*_rpc", "mysql.*"]) of
        true -> do_edoc(T, L);
        false -> do_edoc(T, [F | L])
    end.
