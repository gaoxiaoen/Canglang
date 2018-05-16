
-module(proc_info).

%% API
-export([fprof/2,eprof/2]).


fprof(Pid,Time) ->
	fprof:trace([start, {procs, [Pid]}]),
	io:format("Profiling started ~p ~n",[Pid]),
	timer:sleep(Time*1000),
	fprof:trace([stop]),
	fprof:stop(),
	fprof:profile(),
	fprof:analyse([totals, no_details, {sort, own},no_callers, {dest, "fprof.analysis"}]),
	fprof:stop(),
	io:format("Profiling over ~n",[]).


eprof(Pid,Time) ->
    eprof:start(),
    eprof:start_profiling([Pid]),
    io:format("Profiling started ~p ~n",[Pid]),
    timer:sleep(Time*1000),
    eprof:stop_profiling(),
    eprof:analyze(total,[{sort,time}]),
    eprof:stop(),
    io:format("Profiling over ~n",[]).



    

