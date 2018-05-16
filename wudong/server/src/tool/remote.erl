%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%         %%产生远程连接脚本
%%% @end
%%% Created : 05. 九月 2017 17:50
%%%-------------------------------------------------------------------
-module(remote).
-include("common.hrl").
-author("lzx").

%% API
-export([start/0,
    get_node_info/0
]).

%% 远程脚本
start() ->
    Nodes = erlang:nodes(connected),
    NodeCookieList =
    lists:foldl(fun(Node, AccInList) ->
        try
            case rpc:call(Node, ?MODULE, get_node_info, []) of
                {Node,Cookie,ServerNum}->
                    [{Node, Cookie,ServerNum} | AccInList];
                _ ->
                    AccInList
            end
        catch
            _:_ ->
                ?WARNING("rpc get rank fail,node:~s", [Node]),
                AccInList
        end
                end, [], Nodes),
    WriteList = [get_node_info()|NodeCookieList],
    ?PRINT("NodeList ~w",[WriteList]),
    save_to_file(WriteList).

%% 获取节点信息
get_node_info() ->
    Cookie = erlang:get_cookie(),
    ServerNum = config:get_server_num(),
    {node(),Cookie,ServerNum}.


%% 存储到文件
save_to_file(WriteList) ->
    {ok, S} = file:open("../remote.sh", write),
    io:format(S, "~s~n", ["#!/bin/sh "]),
    io:format(S, "~s~n", ["case $1 in"]),
    lists:foreach(fun({Node, Cookie, ServerNum}) ->
        io:format(S, "      ~p)~n", [ServerNum]),
        io:format(S, "         node=~w~n", [Node]),
        io:format(S, "         cookie='~w'~n", [Cookie]),
        io:format(S, "         server=~w~n", [ServerNum]),
        io:format(S, "         ;;~n", [])
                  end, WriteList),
    io:format(S, "      *)~n", []),
    io:format(S, "         node=\'\'~n", []),
    io:format(S, "         cookie=\'\'~n", []),
    io:format(S, "         server=0~n", []),
    io:format(S, "esac~n", []),
    io:format(S, "erl -setcookie ${cookie} -name remote_${server}@127.0.0.1 -remsh ${node}", []),
    file:close(S).

























