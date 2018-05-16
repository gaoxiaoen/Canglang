%% @Mothod tool
%% @Author zj
%% @Created 2013.8.13
%% @Description 系统检测工具，一般函数不放此模块
-module(tool).
-include("common.hrl").

-compile(export_all).

%% 服务器状态查询
info() ->
    SchedId = erlang:system_info(scheduler_id),
    SchedNum = erlang:system_info(schedulers),
    ProcCount = erlang:system_info(process_count),
    ProcLimit = erlang:system_info(process_limit),
    ProcMemUsed = erlang:memory(processes_used),
    ProcMemAlloc = erlang:memory(processes),
    MemTot = erlang:memory(total),
    Atom = system_info(atom),
    io:format("abormal termination:
                       ~n   Scheduler id:                         ~p
                       ~n   Num scheduler:                        ~p
                       ~n   Process count:                        ~p
                       ~n   Process limit:                        ~p
                       ~n   Memory used by erlang processes:      ~p
                       ~n   Memory allocated by erlang processes: ~p
                       ~n   The total amount of memory allocated: ~p
                       ~n   Atom info: ~p
                       ~n",
        [SchedId, SchedNum, ProcCount, ProcLimit,
            ProcMemUsed, ProcMemAlloc, MemTot,Atom]),
    ok.

%%系统状况
system_info() ->
    binary_to_list(erlang:system_info(info)).

system_info(scheduler_id) ->
    erlang:system_info(scheduler_id);

system_info(schedulers) ->
    erlang:system_info(schedulers);

system_info(process_count) ->
    erlang:system_info(process_count);

system_info(process_limit) ->
    erlang:system_info(process_limit);

system_info(atom) ->
    get_atom_info(util:explode("\n", system_info())).


get_atom_info([]) ->
    [0, 0, 0];
get_atom_info([Info | L]) ->
    case Info of
        "=index_table:atom_tab" ->
                "size: " ++ Size = lists:nth(1, L),
                "limit: " ++ Limit = lists:nth(2, L),
                "entries: " ++ Entries = lists:nth(3, L),
            [util:to_integer(Size), util:to_integer(Limit), util:to_integer(Entries)];
        _ ->
            get_atom_info(L)
    end.

info_all()->
    string:tokens( binary_to_list(erlang:system_info(info)),"\n").


%%info_all_rp()->
%%    rp(string:tokens( binary_to_list(erlang:system_info(info)),"\n")).


%%内存信息
system_mem(total) ->
    erlang:memory(total);

system_mem(processes_used) ->
    erlang:memory(processes_used);

system_mem(processes) ->
    erlang:memory(processes);

system_mem(system) ->
    erlang:memory(system);

system_mem(atom) ->
    erlang:memory(atom);

system_mem(atom_used) ->
    erlang:memory(atom_used);

system_mem(binary) ->
    erlang:memory(binary);

system_mem(code) ->
    erlang:memory(code);

system_mem(ets) ->
    erlang:memory(ets).


%%节点状态前50个进程
cmq(Type) ->
    A = lists:foldl(
        fun(P, Acc0) ->
            case Type of
                1 ->
                    [{P,
                        erlang:process_info(P, registered_name),
                        erlang:process_info(P, reductions)}
                        | Acc0];
                2 ->
                    [{P,
                        erlang:process_info(P, registered_name),
                        erlang:process_info(P, memory)}
                        | Acc0];
                3 ->
                    [{P,
                        erlang:process_info(P, registered_name),
                        erlang:process_info(P, message_queue_len)}
                        | Acc0]
            end
        end,
        [],
        erlang:processes()
    ),
    F = fun({_, _, R1}, {_, _, R2}) ->
        if R1 =/= undefined andalso R2 =/= undefined ->
            {_, N1} = R1, {_, N2} = R2,
            N1 > N2;
            true ->
                false
        end
        end,
    B = lists:sublist(lists:sort(F, A), 50),
    B.

%%内存溢出检查
memcheck() ->
    spawn(fun do_check_mem/0),
    ok.

do_check_mem() ->
    util:sleep(5000),
    case hd(cmq(2)) of
        {Pid, Pname, {memory, Value}} when Value > 500000000 ->
            io:format("memory overflow:~p/~p/~p~n", [Pid, Pname, node()]),
            util:write("../logs/overflow", util:term_to_string(process_info(Pid))),
            util:sleep(2000),
            exit(Pid, kill);
        _ ->
            %%io:format("check mem ok~n"),
            skip
    end,
    do_check_mem().



get_msg_queue() ->
    io:format("process count:~p~n~p value is not 0 count:~p~nLists:~p~n",
        get_process_info_and_zero_value(message_queue_len)).

get_memory() ->
    io:format("process count:~p~n~p value is large than ~p count:~p~nLists:~p~n",
        get_process_info_and_large_than_value(memory, 1048576)).

get_memory(Value) ->
    io:format("process count:~p~n~p value is large than ~p count:~p~nLists:~p~n",
        get_process_info_and_large_than_value(memory, Value)).

get_heap() ->
    io:format("process count:~p~n~p value is large than ~p count:~p~nLists:~p~n",
        get_process_info_and_large_than_value(heap_size, 1048576)).

get_heap(Value) ->
    io:format("process count:~p~n~p value is large than ~p count:~p~nLists:~p~n",
        get_process_info_and_large_than_value(heap_size, Value)).

get_processes() ->
    io:format("process count:~p~n~p value is large than ~p count:~p~nLists:~p~n",
        get_process_info_and_large_than_value(memory, 0)).


get_process_info_and_zero_value(InfoName) ->
    PList = erlang:processes(),
    ZList = lists:filter(
        fun(T) ->
            case erlang:process_info(T, InfoName) of
                {InfoName, 0} -> false;
                _ -> true
            end
        end, PList),
    ZZList = lists:map(
        fun(T) -> {T, erlang:process_info(T, InfoName), erlang:process_info(T, registered_name)}
        end, ZList),
    [length(PList), InfoName, length(ZZList), ZZList].

get_process_info_and_large_than_value(InfoName, Value) ->
    PList = erlang:processes(),
    ZList = lists:filter(
        fun(T) ->
            case erlang:process_info(T, InfoName) of
                {InfoName, VV} ->
                    if VV > Value -> true;
                        true -> false
                    end;
                _ -> true
            end
        end, PList),
    ZZList = lists:map(
        fun(T) -> {T, erlang:process_info(T, InfoName), erlang:process_info(T, registered_name)}
        end, ZList),
    [length(PList), InfoName, Value, length(ZZList), ZZList].

snapshot() ->
    AllProcess = erlang:processes(),
    case get(erlang_process) of
        undefined ->
            io:format("run again!~n"),
            put(erlang_process, AllProcess);
        OldProcess ->
            put(erlang_process, AllProcess),
            L1 = length(AllProcess),
            L2 = length(OldProcess),
            if
                L1 > L2 ->
                    F = fun(P) ->
                        case lists:member(P, OldProcess) of
                            true ->
                                [];
                            false ->
                                io:format("new pid:~p~n", [P]),
                                [P]
                        end
                        end,
                    lists:flatmap(F, AllProcess);
                L1 < L2 ->
                    F = fun(P) ->
                        case lists:member(P, AllProcess) of
                            true ->
                                [];
                            false ->
                                io:format("lose pid:~p~n", [P]),
                                [P]
                        end
                        end,
                    lists:flatmap(F, OldProcess);
                true ->
                    io:format("two times num same !~n")
            end
    end.

write_dict(PidString) ->
    Pid = list_to_pid(PidString),
    if
        is_pid(Pid) ->
            PidInfo = erlang:process_info(Pid),
            {_, DictList} = lists:keyfind(dictionary, 1, PidInfo),
            io:format("dictLen:~p~n", [length(DictList)]),
            file:write_file("dict.txt", io_lib:format("~w", [DictList]));
        true ->
            io:format("pid error~n")
    end.


write_msg_queue(Pid) ->
    PidInfo = erlang:process_info(Pid),
    {_, List} = lists:keyfind(messages, 1, PidInfo),
    io:format("message_queue:~p~n", [length(List)]),
    file:write_file("message_queue.txt", io_lib:format("~w", [List])).

proto(A, B) ->
    A * math:pow(2, 8) + B.  %%就是协议号

%% fprof
fprof_player(Pkey, Time) ->
    case player_util:get_player_pid(Pkey) of
        false ->
            io:format("PKey ~p is not online ~n", [Pkey]);
        Pid ->
            proc_info:fprof(Pid, Time)
    end.

fprof(PidString, Time) ->
    proc_info:fprof(list_to_pid(PidString), Time).

%% eprof
eprof_player(Pkey, Time) ->
    case player_util:get_player_pid(Pkey) of
        false ->
            io:format("PKey ~p is not online ~n", [Pkey]);
        Pid ->
            proc_info:eprof(Pid, Time)

    end.

eprof(PidString, Time) ->
    proc_info:eprof(list_to_pid(PidString), Time).


m() ->
    [{K, V / math:pow(1024, 3)} || {K, V} <- erlang:memory()].
gc() ->
    [erlang:garbage_collect(P) || P <- erlang:processes()].


process_scene_dict(Pid) ->
    List = element(2, lists:keyfind(dictionary, 1, erlang:process_info(Pid))),
    F = fun({Key, Val}, L) ->
        case Key of
            {scene_mon, _} ->
                case lists:keytake(scene_mon, 1, L) of
                    false ->
                        [{scene_mon, 1} | L];
                    {value, {_, Count}, T} ->
                        [{scene_mon, Count + 1} | T]
                end;
            {scene_player, _} ->
                case lists:keytake(scene_player, 1, L) of
                    false ->
                        [{scene_player, 1} | L];
                    {value, {_, Count}, T} ->
                        [{scene_player, Count + 1} | T]
                end;
            {tap, _X, _Y} ->
                case lists:keytake(tap, 1, L) of
                    false ->
                        [{tap, dict:size(Val)} | L];
                    {value, {_, Count}, T} ->
                        [{tap, dict:size(Val) + Count} | T]
                end;
            {tam, _X, _Y} ->
                case lists:keytake(tam, 1, L) of
                    false ->
                        [{tam, dict:size(Val)} | L];
                    {value, {_, Count}, T} ->
                        [{tam, dict:size(Val) + Count} | T]
                end;
            {ckp, _Copy} ->
                case lists:keytake(ckp, 1, L) of
                    false ->
                        [{ckp, dict:size(Val)} | L];
                    {value, {_, Count}, T} ->
                        [{ckp, dict:size(Val) + Count} | T]
                end;
            {ckm, _Copy} ->
                case lists:keytake(ckm, 1, L) of
                    false ->
                        [{ckm, dict:size(Val)} | L];
                    {value, {_, Count}, T} ->
                        [{ckm, dict:size(Val) + Count} | T]
                end;
            _ ->
                case lists:keytake(other, 1, L) of
                    false ->
                        [{other, [{Key, Val}]} | L];
                    {value, {_, L1}, T} ->
                        [{other, [{Key, Val} | L1]} | T]
                end
        end
        end,
    lists:foldl(F, [], List).

process_player_dict(Pid) ->
    List = element(2, lists:keyfind(dictionary, 1, erlang:process_info(Pid))),
    F = fun({Key, Val}, L) ->
        [{Key, Val} | L]
        end,
    Ret = lists:foldl(F, [], List),
    ?ERR("Ret ~p~n", [Ret]),
    ok.


get_player_count() ->
    Sn = config:get_server_num(),
    MatchName = unicode:characters_to_list(util:to_list(lists:concat([p_, Sn]))),
    F = fun(P) ->
        case erlang:process_info(P, registered_name) of
            {registered_name, Name} ->
                Name1 = unicode:characters_to_list(util:to_list(Name)),
                case market_util:match_name(MatchName, Name1) of
                    false -> [];
                    true ->
                        [Name]
                end;
            _ -> []
        end
        end,
    Data = lists:flatmap(F, erlang:processes()),
    ?ERR("len ~p/ ret ~p~n", [length(Data), Data]),
    length(Data).

%进程CPU占用排名
etop() ->
    spawn(fun() -> etop:start([{output, text}, {interval, 10}, {lines, 20}, {sort, reductions}]) end).

%进程Mem占用排名
etop_mem() ->
    spawn(fun() -> etop:start([{output, text}, {interval, 10}, {lines, 20}, {sort, memory}]) end).

%停止etop
etop_stop() ->
    etop:stop().


%进程栈
pstack(Reg) when is_atom(Reg) ->
    case whereis(Reg) of
        undefined -> undefined;
        Pid -> pstack(Pid)
    end;
pstack(Pid) ->
    io:format("~s~n", [element(2, process_info(Pid, backtrace))]).

calc_mem(Mem) ->
    length(lists:filter(fun(P) -> erlang:process_info(P, memory) == Mem end, erlang:processes())).