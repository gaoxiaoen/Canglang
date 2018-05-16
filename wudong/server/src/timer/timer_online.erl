%%%-------------------------------------------------------------------
%%% @author fzl
%%% @copyright (C) 2015, junhai
%%% @doc
%%%
%%% @end
%%% Created : 27. 二月 2015 18:20
%%%-------------------------------------------------------------------
-module(timer_online).
-author("fzl").
-include("common.hrl").

%% API
-export([
    init/0,
    handle/2,
    cm/0
]).

init() ->
    {ok,ok}.

handle(State, _Time) ->
    spawn(fun() ->check_mem() end),
    spawn(fun() -> save_online() end),
    {ok, State}.

save_online() ->
    case config:is_center_node() of
        false ->
            Now = util:unixtime(),
            Size = ets:info(?ETS_ONLINE,size),
            Sql = io_lib:format("insert into online set num=~p,time=~p",[Size,Now]),
            db:execute(Sql);
        _ ->
            skip
    end.



cm() ->
    spawn(fun() ->
        timer:sleep(util:rand(1,10) * 1000),
        check_mem(200000)
    end).

%% 检查内存消耗
%% 默认设置凌晨4点查一次
%% 内存大于5M做一次手动gc
check_mem() ->
    {_, {_H, I, _S}} = erlang:localtime(),
    case I rem 50 =:= 0 of
        true ->
            timer:sleep(util:rand(1,10)* 1000),
            check_mem(500000);
        false ->
            skip
    end.

%% 检查溢出的内存，强制gc
check_mem(MemLim) ->
    lists:foreach(
        fun(P) ->
            case is_pid(P) andalso is_process_alive(P)  of
                true ->
                    case erlang:process_info(P, memory) of
                        {memory, Mem}  ->
                            case Mem  > MemLim of
                                true ->
                                    erlang:garbage_collect(P);
                                false ->
                                    []
                            end;
                        _ ->[]
                    end;
                false ->
                    []
            end
        end, erlang:processes()).
