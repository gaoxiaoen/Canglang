-module(sys_stat).
-behaviour(gen_server).
-export([
    start_link/0
    ,report/1
    ,report/0
]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("common.hrl").

-record(state, {
    mem_file
    ,stat_file
}).

%% 启动进程
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 由sh脚本调用 
report([MasterNode]) ->
    rpc:call(MasterNode, ?MODULE, report, []).

report() ->
    {{Y,M,D},{H,I,S}} = erlang:localtime(),
    FileName = io_lib:format("report_~p-~p-~p_~p-~p-~p.log", [Y,M,D,H,I,S]),
    case file:open("../var/" ++ FileName, [write]) of
        {ok, File} ->
            io:format(File, 
                       "erlang:memory().\n~p\n\n"
                    ++ "erlang:system_info(check_io).\n~p\n\n"
                    ++ "erlang:system_info(info).\n~s\n\n"
                    ++ "erlang:system_info(loaded).\n~s\n\n"
                    ++ "", 
                [
                    erlang:memory()
                    ,erlang:system_info(check_io)
                    ,erlang:system_info(info)
                    ,erlang:system_info(loaded)
                ]),
            report_all_processes_info(File),
            report_all_ets_info(File),
            file:close(File),
            io:format("report output -> ~s\n", [FileName]);
        Other ->
            Other
    end.

report_all_processes_info(File) ->
    io:format(File, "all processes info:\n", []),
    Procs = erlang:processes(),
    lists:foreach(fun(Pid)->
        Info = (catch erlang:process_info(Pid)),
        io:format(File, "~p\n~p\n\n", [Pid, Info])
    end, Procs).

report_all_ets_info(File) ->
    io:format(File, "all ets info:\n", []),
    AllEts = ets:all(),
    lists:foreach(fun(Ets)->
        Info = (catch ets:info(Ets)),
        io:format(File, "~p\n~p\n\n", [Ets, Info])
    end, AllEts).

%% ------------------------------------------------
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),  
    ?INFO("[~w] 进程启动完成", [?MODULE]),
    TimeRef = erlang:send_after(30000, self(), clock),
    put(timer, TimeRef),
    %% 
    {ok, MemFile} = file:open("../var/mem.log", [append]),
    {ok, StatFile} = file:open("../var/stat.log", [append]),
    file:write(MemFile, "boot\n"),
    file:write(StatFile, "boot\n"),
    {ok, #state{mem_file = MemFile, stat_file = StatFile}}.

handle_info(clock, State) -> 
    case erase(timer) of
        undefined -> ignore;
        OldTimeRef -> catch erlang:cancel_timer(OldTimeRef)
    end,
    TimeRef = erlang:send_after(30000, self(), clock),
    put(timer, TimeRef),
    try do_task(State) 
    catch T:X ->
        ?ERR("~p", [{T, X}])
    end,
    {noreply, State};

handle_info(_Info, State) ->
    {noreply, State}. 

handle_call(_Request, _From, State) ->
    {reply, _From, State}.

handle_cast(_Request, State) ->
    {noreply, State}.

terminate(_Reason, _State = #state{mem_file = MemFile, stat_file = StatFile}) ->
    file:write(MemFile, "shutdown\n"),
    file:write(StatFile, "shutdown\n"),
    file:close(MemFile),
    file:close(StatFile),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% -------------------------
do_task(#state{mem_file = MemFile, stat_file = StatFile}) ->
    {{Y,M,D},{H,I,S}} = erlang:localtime(),
    Time = io_lib:format("~p-~p-~p ~p:~p:~p", [Y,M,D,H,I,S]),
    ProcessCount = erlang:system_info(process_count),
    EtsCount = length(ets:all()),
    PortCount = length(erlang:ports()),
    OnlineCount = ets:info(role_online, size),
    MemInfo = erlang:memory(),
    MemTotal = proplists:get_value(total, MemInfo),
    MemProcess = proplists:get_value(processes, MemInfo),
    MemSystem = proplists:get_value(system, MemInfo),
    MemAtom = proplists:get_value(atom, MemInfo),
    MemBinary = proplists:get_value(binary, MemInfo),
    MemEts = proplists:get_value(ets, MemInfo),
    {Cpu, OsMemPercent, OsMem} = os_info(),
io:format(StatFile, "~s\t%cpu:~s\t%mem:~s\tmem:~s\tprocs:~p\tets_cnt:~p\tport_cnt:~p\tvmmem:~p\trole:~p\n", [Time, Cpu, OsMemPercent, OsMem, ProcessCount, EtsCount, PortCount, MemTotal, OnlineCount]),
    io:format(MemFile, "~s\ttotal:~p\tproc:~p\tsys:~p\tatom:~p\tbin:~p\tets:~p\n", [Time, MemTotal, MemProcess, MemSystem, MemAtom, MemBinary, MemEts]),
    ok.
   
os_info() ->
    try os:cmd("ps aux | grep " ++ atom_to_list(node()) ++ " | grep beam") of
        Ret when is_list(Ret) ->
            List = string:tokens(Ret, " "),
            case List of
                ["root", _Pid, Cpu, Mem, _VSZ, RSSMem|_] ->
                    {Cpu, Mem, RSSMem};
                _ ->
                    {"-", "-", "-"}
            end;
        _ ->
            {"-", "-", "-"}
        catch _:_ ->
            {"-", "-", "-"}
    end.
                
