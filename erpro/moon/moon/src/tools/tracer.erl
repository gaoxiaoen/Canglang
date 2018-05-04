%%----------------------------------------------------
%%
%%----------------------------------------------------
-module(tracer).
-export([
    add/1
    ,start/0
    ,stop/0
    ,do_start/0
]).

start() ->
    case whereis(?MODULE) of
        undefined ->
            register(?MODULE, Pid = spawn(?MODULE, do_start, [])),
            Pid;
        Pid ->
            Pid
    end.

stop() ->
    exit(whereis(?MODULE), kill).

add(Pid) ->
    Tracer = start(),
    erlang:trace(Pid, true, [all, {tracer, Tracer}]).

do_start() ->
    {ok, File} = file:open("../var/tracer.log", [write]),
    do_loop(File).

do_loop(File) ->
    receive
        Msg ->
            io:format(File, "~p\r\n",[Msg]),
            %io:format("~p\n", [Msg]),
            do_loop(File)
    end.
            
