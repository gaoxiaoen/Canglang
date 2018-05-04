%%%-------------------------------------------------------------------
%%%
%%%
%%% @doc
%%%
%%% @end
%%%
%%%-------------------------------------------------------------------
-module(statistics).

-include("mnesia.hrl").

%% API
-export([
         loop/0,
         get/1,
         help/0
        ]).


loop() ->
    print_runqueue(),
    timer:sleep(2000),
    loop().

help() ->
    ok.

%%获取当前在线的玩家数量
get(online) ->
    ok;
%%获取各个地图的玩家数量
get(map_online) ->
    ok;
%%获取某个地图的玩家数量
get({map_online, _MapID}) ->
    ok;
%%获取每个节点的runqueue信息
get(runqueue) ->
    ok;
%%获取关键进程的消息队列长度
get(messages) ->
    ok;
%%获取关键进程的内存占用
get(memory) ->
    ok.


print_runqueue() ->
    Result = get_runqueue(),
    io:format("~-30s | ~20s ~n", ["---node---", "---run_queue---"]),
    lists:foreach(
      fun({Node, RunQueue}) ->
              io:format("~-30w | ~20s ~n", [Node, erlang:integer_to_list(RunQueue)])
      end, Result).


%%获取系统中各个节点的队列信息
get_runqueue() ->
    lists:foldl(
      fun(Node, Acc) ->
              Run = rpc:call(Node, erlang, statistics, [run_queue]),
              [{Node, Run} | Acc]
      end, [], nodes()).
