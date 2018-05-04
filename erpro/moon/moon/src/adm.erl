%%----------------------------------------------------
%% 管理工具(供中央控制服调用的管理接口)
%%
%% @author yeahoo2000@gmail.com
%% @end
%%----------------------------------------------------
-module(adm).
-export([
        cmd/1
        ,guild_war_stop/0
        ,game_nodes/0
        ,top/1
        ,top/3
        ,get_all_erl/0
        ,file_list/2
        ,get_src_hrl/0
        ,get_inc_hrl/0
        ,get_src_erl/0
        ,get_xml/0
        ,get_dir_files/2
    ]
).

-include_lib("kernel/include/file.hrl").
-include("common.hrl").
-include("node.hrl").

%% @doc 执行一个命令
cmd(CmdStr)->
    F = util:build_fun("fun()-> " ++ CmdStr ++ " end."),
    try
        lists:flatten(util:term_to_string(F()))
    catch
        X:T ->
            util:term_to_string({X, T})
    end.

%% @doc 获取所有*.erl文件
%% 注意：对于没有访问权限的文件将不在出现在此列表中
%% @spec get_all_erl() -> FileList
%% FileList = [{FileName, FilePath}] | {error, Reason}
%%     FileName = list()
%%     FilePath = list()
%%     Reason = list()
get_all_erl() ->
    {ok, Cwd} = file:get_cwd(),
    Dir = Cwd ++ "/../src",
    case file:list_dir(Dir) of
        {ok, L} ->
            {ok, file_filter(L, Dir, ".erl", [])};
        _Other ->
            {error, _Other}
    end.

get_src_erl() -> 
    {ok, Cwd} = file:get_cwd(),
    Dir = Cwd ++ "/../src",
    case file:list_dir(Dir) of
        {ok, L} ->
            {ok, file_filter(L, Dir, ".erl", [])};
        _Other ->
            {error, _Other}
    end.

get_src_hrl() -> 
    {ok, Cwd} = file:get_cwd(),
    Dir = Cwd ++ "/../src",
    case file:list_dir(Dir) of
        {ok, L} ->
            {ok, file_filter(L, Dir, ".hrl", [])};
        _Other ->
            {error, _Other}
    end.

get_inc_hrl() -> 
    {ok, Cwd} = file:get_cwd(),
    Dir = Cwd ++ "/../inc",
    case file:list_dir(Dir) of
        {ok, L} ->
            {ok, file_filter(L, Dir, ".hrl", [])};
        _Other ->
            {error, _Other}
    end.

get_xml() ->
    {ok, Cwd} = file:get_cwd(),
    Dir = Cwd ++ "/../src/xml",
    case file:list_dir(Dir) of
        {ok, L} -> 
            {ok, file_filter(L, Dir, ".xml", [])};
        _Other ->
            {error, _Other}
    end.

get_dir_files(Dir, Ext) ->
    {ok, Cwd} = file:get_cwd(),
    case file:list_dir(Cwd ++ Dir) of
        {ok, L} -> 
            {ok, file_filter(L, Cwd ++  Dir, Ext, [])};
        _Other -> 
            {error, _Other}
    end.

%% 关闭帮战
guild_war_stop() ->
    case erlang:whereis(guild_war) of
        Pid when is_pid(Pid) ->
            erlang:exit(Pid, kill),
            ?INFO("帮战进程已经强制关闭");
        _ -> 
            ?INFO("帮战进程目前未运行")
    end.
%% @spec file_list(Dir, Ext) -> {ok, FileList} | {error, Why}
%% Dir = string()
%% Ext = string()
%% FileList = list()
%% Why = term()
%% @doc 获取指定目录下指定类型的文件(包括子目录)
file_list(Dir, Ext) ->
    case file:list_dir(Dir) of
        {ok, L} ->
            {ok, file_filter(L, Dir, Ext, [])};
        Why ->
            {error, Why}
    end.

%% @spec top(Type::atom()) -> ProcList
%% Type = mem | queue | reds
%% @doc 返回当前节点中占用资源最多的N个进程列表.
%% Type: 排名方式
%% <ul>
%%     <li>{@type mem} 返回当前节点中内存占用前N的进程</li>
%%     <li>{@type queue} 返回当前节点中消息队列长度前N的进程</li>
%%     <li>{@type reds} 返回当前节点中reductions值前N的进程</li>
%% </ul>
top(mem) ->
    top(mem, 1, 10);
top(queue) ->
    top(queue, 1, 10);
top(reds) ->
    top(reductions, 1, 10).

%% @spec top(Type::atom(), Start::integer(), Len::integer()) -> ProcList
%% ProcList = list()
%% @doc 返回当前节点中占用资源最多的N个进程列表.
top(mem, Start, Len) ->
    do_top(memory, Start, Len);
top(queue, Start, Len) ->
    do_top(message_queue_len, Start, Len);
top(reds, Start, Len) ->
    do_top(reductions, Start, Len).

%% @spec game_nodes() -> NodeList
%% NodeList = [#node{}]
%% @doc 返回所有的游戏服务器节点
%% 如果节点管理器工作不正常，将只会得到当前节点的部份信息
game_nodes() ->
    case catch sys_node_mgr:list(all) of
        Ns when is_list(Ns) -> Ns;
        _ -> [#node{name = node()}]
    end.

%% ----------------------------------------------------
%% 私有函数
%% ----------------------------------------------------

%% top辅助函数
do_top(Type, Start, Len) when is_integer(Start), is_integer(Len), Start > 0, Len > 0 ->
    L = do_top1(Type, erlang:processes(), []),
    NL = lists:sublist(L, Start, Len),
    top_detail(NL, []).
do_top1(_Type, [], L) ->
    lists:sort(fun top_sort/2, L);
do_top1(Type, [P | Pids], L) ->
    NL = case process_info(P, Type) of
        {_, V} -> [{P, V} | L];
        _ -> L
    end,
    do_top1(Type, Pids, NL).
top_detail([], L) -> L;
top_detail([{P, _} | T], L) ->
    Mem = case process_info(P, memory) of
        {_, V1} -> V1;
        _ -> undefined
    end,
    Reds = case process_info(P, reductions) of
        {_, V2} -> V2;
        _ -> undefined
    end,
    InitCall = case process_info(P, initial_call) of
        {_, V3} -> V3;
        _ -> undefined
    end,
    MsgLen = case process_info(P, message_queue_len) of
        {_, V4} -> V4;
        _ -> undefined
    end,
    RegName = case process_info(P, registered_name) of
        {_, V5} -> V5;
        _ -> undefined
    end,
    top_detail(T, [[P, RegName, InitCall, Mem, Reds, MsgLen] | L]).
top_sort({_, A}, {_, B}) when A =< B -> false;
top_sort(_, _) -> true.

%% 文件过滤，查找指定目录下的所有文件(包括子目录)，返回指定扩展名的文件列表
file_filter([], _Dir, _Ext, List) -> List;
file_filter([H | T], Dir, Ext, List) ->
    F = Dir ++ "/" ++ H,
    NewList = case file:read_file_info(F) of
        {ok, I} ->
            if
                I#file_info.type =:= directory ->
                    case file:list_dir(F) of
                        {ok, L} ->
                            D = Dir ++ "/" ++ H,
                            List ++ file_filter(L, D, Ext, []);
                        _Err ->
                            io:format("error in list directory:~p~n", [_Err]),
                            List
                    end;
                I#file_info.type =:= regular ->
                    case filename:extension(F) =:= Ext of
                        true ->
                            List ++ [{filename:basename(filename:rootname(F)), F}];
                        false ->
                            List
                    end;
                true ->
                    List
            end;
        _Other ->
            io:format("error in read_file_info:~p ~w~n", [F, _Other]),
            List
    end,
    file_filter(T, Dir, Ext, NewList).
