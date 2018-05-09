%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 五月 2018 11:30
%%%-------------------------------------------------------------------
-module(tracer_test).
-author("Administrator").

%% API
-export([trace_module/2,test2/0]).

test1() ->
    dbg:tracer(),
    dbg:tpl/4(tracer_test,fib,'_',
        dbg:fun2ms(fun(_) -> return_trace() end),
    dbg:p(call,[c])),
    tracer_test:fib(4).

test2() ->
    trace_module(tracer_test,fun() ->fib(4) end).
fib(0) ->1;
fib(1) ->1;
fib(N) ->fib(N-1) + fib(N-2).

trace_module(Mod,StartFun) ->
%%    分裂一个进程来执行跟踪
    spawn(fun() -> trace_module1(Mod,StartFun) end).

trace_module1(Mod,StartFun) ->
%%    下一行的意思是：跟踪Mod里的
    erlang:trace_pattern({Mod,'_','_'},
        [{'_',[],[{return_trace}]}],
        [local]),
%%    分裂一个函数来执行跟踪
    S= self(),
    Pid = spawn(fun() -> do_trace(S,StartFun) end),
%%    设置跟踪，告诉系统开始
%%    跟踪进程Pid
    erlang:trace(Pid,true,[call,procs]),
%%    现在让pid启动
    Pid ! {self(),start},
    trace_loop().

%% do_trace 会在Parent指示下执行StartFun()
do_trace(Parent,StartFun) ->
    receive
        {Parent,start} ->
            StartFun()
    end.

%% trace_loop 负责显示函数调用和返回值
trace_loop() ->
    receive
        {trace,_,call,X} ->
            io:format("Call:~p~n",[X]),
            trace_loop();
        {trace,_,return_from,Call,Ret} ->
            io:format("Return From:~p =>~p~n",[Call,Ret]),
            trace_loop();
        Other ->
%%            我们得到了其他的一些消息，打印他们
            io:format("Other = ~p~n",[Other]),
            trace_loop()
    end.

