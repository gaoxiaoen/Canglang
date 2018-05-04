%%----------------------------------------------------
%%
%%----------------------------------------------------
-module(tcp_prof).
-export([
    add/2
]).
-export([
    stop/0
    ,do_start/1
    ,do_start_mgr/0
]).
-define(secs(MSec, Sec), MSec*1000000+Sec).

add(Tag, Pid) ->
    case whereis(?MODULE) of
        undefined ->
            register(?MODULE, PidMgr = spawn(?MODULE, do_start_mgr, [])),
            PidMgr ! {add, Tag, Pid};
        PidMgr ->
            PidMgr ! {add, Tag, Pid}
    end.

stop() ->
    exit(whereis(?MODULE), kill).

do_start_mgr() ->
    do_loop_mgr([]).

do_loop_mgr(Pids) ->
    receive
        {add, Tag, Pid} ->
            Tracer = spawn_link(?MODULE, do_start, [Tag]),
            erlang:trace(Pid, true, [all, {tracer, Tracer}]),
            do_loop_mgr([Pid|Pids]);
        _ ->
            do_loop_mgr(Pids)
    end.

do_start(Tag) ->
    file:make_dir("../var/tcp_tracer"),
    {{Y,M,D},{H,I,S}} = erlang:localtime(),
    DateTime = integer_to_list(Y*10000000000+M*100000000+D*1000000+H*10000+I*100+S),
    {ok, File} = file:open("../var/tcp_tracer/"++DateTime++"-"++Tag++".log", [write]),
    {MSec, Sec, _} = erlang:now(),
    do_loop(File, ?secs(MSec, Sec), 0, 0, 0).

do_loop(File, InitTime, Recv, Send, Total) ->
    receive
        {trace_ts,_Pid,'receive',{inet_async,_Port,_,{ok,<<_:32>>}},_Now} ->
            do_loop(File, InitTime, Recv, Send, Total);

        {trace_ts,_Pid,'receive',{inet_async,_Port,_,{ok,Bin}},Now={MSec,Sec,_}} ->
            Size = byte_size(Bin),
            <<Cmd:16, _/binary>> = Bin,
            Recv1 = Recv + Size + 4,
            Total1 = Total + Size + 4,
            io:format(File, "~p[~ps] RECV: ~p acc: ~p ~p ~p cmd:~p\r\n", 
                    [calendar:now_to_local_time(Now), ?secs(MSec, Sec) - InitTime, Size, Recv1, Send, Total1, Cmd]),
            do_loop(File, InitTime, Recv1, Send, Total1);

        {trace_ts,_Pid,'receive',{send_data,Bin},Now={MSec,Sec,_}} when is_binary(Bin) -> %% send direct
            Size = byte_size(Bin),
            <<_Len:32, Cmd:16, _/binary>> = Bin,
            Send1 = Send + Size,
            Total1 = Total + Size,
            io:format(File, "~p[~ps] send: ~p acc: ~p ~p ~p cmd:~p\r\n", 
                    [calendar:now_to_local_time(Now), ?secs(MSec, Sec) - InitTime, Size, Recv, Send1, Total1, Cmd]),
            do_loop(File, InitTime, Recv, Send1, Total1);

        {trace_ts,_Pid,'receive',{send_data, BinList},Now={MSec,Sec,_}} -> %% send buff
            BinList2 = lists:flatten(BinList),
            {Send1, Total1} = lists:foldl(fun(Bin, {Send0, Total0}) ->
                Size = byte_size(Bin),
                <<_Len:32, Cmd:16, _/binary>> = Bin,
                Send1 = Send0 + Size,
                Total1 = Total0 + Size,
                io:format(File, "~p[~ps] send: ~p acc: ~p ~p ~p cmd:~p\r\n", 
                        [calendar:now_to_local_time(Now), ?secs(MSec, Sec) - InitTime, Size, Recv, Send1, Total1, Cmd]),
                {Send1, Total1}
            end, {Send, Total}, BinList2),
            do_loop(File, InitTime, Recv, Send1, Total1);

        _ ->
            do_loop(File, InitTime, Recv, Send, Total)
%        Msg ->
%            io:format(File, "~p: ~p\r\n", [erlang:localtime(), Msg]),
%            %io:format("~p\n", [Msg]),
%            do_loop(File)
    end.
            
