%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% 测试最大可创建的进程数
%%% @end
%%% Created : 08. 五月 2018 11:27
%%%-------------------------------------------------------------------
-module(processes).
-author("Administrator").

%% API
-export([max/1]).

%% 创建N个进程，然后销毁他们，看看需要花费的时间
max(N) ->
    Max = erlang:system_info(process_limit),
    io:format("Maxinum allowed processes:~p~n",[Max]),
    statistics(runtime),
    statistics(wall_clock),
    L = for(1,N,fun() ->spawn(fun() ->wait() end) end),
    {_,Time1} = statistics(runtime),
    {_,Time2} = statistics(wall_clock),
    lists:foreach(fun(Pid)->Pid!die end,L),
    U1 = Time1 *1000/N,
    U2=Time2 *1000/N,
    io:format("Process spawn time=~p(~p) microseconds~n",[U1,U2]).

wait() ->
    receive
        die->void
    end.

for(N,N,F) ->[F()];
for(I,N,F) ->[F()|for(I+1,N,F)].




