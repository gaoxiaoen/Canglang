%%%-------------------------------------------------------------------
%%% File        :common_transaction.erl
%%% @doc
%%%     事务处理模块
%%% @end
%%%-------------------------------------------------------------------
-module(common_transaction).

%% API
-export([
         transaction/1,
         commit/0,
         rollback/0,
         abort/1,
         t/1
        ]).

-export([
         on_transaction_begin/0,
         on_transaction_commit/0,
         on_transaction_rollback/0,
         is_transaction/0,
         set_transaction/1
         ]).

-include("common.hrl").
-include("common_server.hrl").

t(F) ->
    common_transaction:transaction(F).

transaction(F) ->
    try
        on_transaction_begin(),
        common_role:on_transaction_begin(),
        Result = F(),
        commit(),
        {atomic, Result}
    catch ErrorType:Error ->
              rollback(),
              case ErrorType of
                  throw ->
                      case Error of
                          {error, ErrorInfo} ->
                              {aborted, ErrorInfo};
                          _ ->
                              {aborted, Error}
                      end;
                  exit ->
                      case Error of
                          {aborted, _} ->
                              Error;
                          _ ->
                              {aborted, Error}
                      end;
                  _ ->
                      {aborted, {ErrorType, Error, erlang:get_stacktrace()}}
              end
    end.


commit() ->
    on_transaction_commit(),
    common_role:on_transaction_commit(),
    ok.


rollback() ->
    on_transaction_rollback(),
    common_role:on_transaction_rollback(),
    ok.

abort(Error) ->
    erlang:throw(Error).

%%%===================================================================
%%% API
%%%===================================================================
-define(transaction_list,transaction_list).
-define(transaction_flag,transaction_flag).

on_transaction_begin() ->
    erlang:put(?transaction_list, []),
    case erlang:get(?transaction_flag) of
        undefined ->
            erlang:put(?transaction_flag, true),
            ok;
        _ ->
            erlang:throw({nesting_transaction, common_transaction})
    end,
    ok.
on_transaction_rollback() ->
    lists:foreach(
      fun({Key, BackKey}) ->
              BackInfo = erlang:get(BackKey),
              erlang:put(Key, BackInfo),
              erlang:erase(BackKey)
      end, erlang:get(?transaction_list)),
    erlang:erase(?transaction_flag),
    erlang:erase(?transaction_list).
on_transaction_commit() ->
    lists:foreach(
      fun({_Key, BackKey}) ->
              erlang:erase(BackKey)
      end, erlang:get(?transaction_list)),
    erlang:erase(?transaction_flag),
    erlang:erase(?transaction_list).
is_transaction() ->
    case erlang:get(?transaction_flag) of
        undefined ->
            false;
        _ ->
            true
    end.
set_transaction(Key) ->
    BackKey = {Key,?DATA_COPY},
    case erlang:get(?transaction_list) of
        undefined ->
            erlang:throw({error, not_in_transaction});
        BackList ->
            case lists:member(Key, BackList) of
                true ->
                    ignore;
                _ ->
                    erlang:put(?transaction_list, [{Key, BackKey}|BackList]),
                    case erlang:get(Key) of
                        undefined ->
                            ignore;
                        BackInfo ->
                            %% 当一个事务操作过程中多次保存时，只需要备份第一次就可以
                            case erlang:get(BackKey) of
                                undefined ->
                                    erlang:put(BackKey, BackInfo);
                                _ ->
                                    next
                            end
                    end
            end
    end.
    

