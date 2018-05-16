%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%   玩家进程字典操作api
%%% @end
%%% Created : 08. 一月 2015 下午12:40
%%%-------------------------------------------------------------------
-module(lib_dict).
-author("fancy").
-include("common.hrl").

%% API
-export([init/1,is_role_process/0,get/1,put/2]).

init(Key) ->
    case is_role_process() of
        true ->
            erlang:put(Key,[]),
            ok;
        false ->
            ?ERR("init key[~w] in wrong porcess !~n",[Key]),
            err
    end.


put(Key,Val) ->
    case is_role_process() orelse erlang:get(debug_t1111) of
        true ->
            erlang:put(Key,Val);
        false ->
            ?ERR("put key[~w] in wrong process !~n",[Key]),
            err

    end.

get(Key) ->
    case is_role_process() orelse erlang:get(debug_t1111) of
        true ->
            case erlang:get(Key) of
                undefined -> [];
                Val -> Val
            end;
        false ->
            ?ERR("get key[~w] in wrong process !~n",[Key]),
            err
    end .


is_role_process() ->
    case erlang:get(is_role_process) of
        true -> true;
        _ -> false
    end.
