%%%-------------------------------------------------------------------
%%% File        :common_role.erl
%%%-------------------------------------------------------------------
-module(common_role).

-include("common.hrl").
-include("common_server.hrl").

-export([
         init_global_ets/0,
         get_role_global/1,
         set_role_global/2,
         erase_role_global/1,
         
         init_role_dict/1,
         get_role_dict/1,
         set_role_dict/2,
         erase_role_dict/1,
         
         on_transaction_begin/0,
         on_transaction_rollback/0,
         on_transaction_commit/0,
         is_transaction/0,
         set_transaction/1
         ]).


%%%===================================================================
%%% 所有玩家全局共享ETS表操作
%%%===================================================================
init_global_ets() ->
    ets:new(?ROLE_GLOBAL_ETS,[set,public,named_table,{keypos,#r_dict.key}]).
get_role_global(Key) ->
    case ets:lookup(?ROLE_GLOBAL_ETS,Key) of
        [] ->
            {error,not_found};
        [#r_dict{key = Key,value = Value}] ->
            {ok,Value}
    end.
set_role_global(Key,Value) ->
    ets:insert(?ROLE_GLOBAL_ETS, #r_dict{key = Key,value = Value}).
erase_role_global(Key) ->
    ets:delete(?ROLE_GLOBAL_ETS,Key).




%%%===================================================================
%%% 玩家全局共享ETS表操作
%%%===================================================================
get_role_ets_tab_name(RoleId) ->
    erlang:list_to_atom(lists:concat(["role_dict_ets_", RoleId])).
init_role_dict(RoleId) ->
    Tab = get_role_ets_tab_name(RoleId),
    case ets:info(Tab, name) of
        undefined ->
            ets:new(Tab,[set,public,named_table,{keypos,#r_dict.key}]);
        _ ->
            ets:delete(Tab)
    end.
get_role_dict({Key,RoleId}) ->
    Tab = get_role_ets_tab_name(RoleId),
    case ets:info(Tab, name) of
        undefined ->
            undefined;
        _ ->
            case ets:lookup(get_role_ets_tab_name(RoleId),Key) of
                [] ->
                    undefined;
                [#r_dict{key = Key,value = Value}] ->
                    Value
            end
    end.
set_role_dict({Key,RoleId},Value) ->
    Tab = get_role_ets_tab_name(RoleId),
    case ets:info(Tab, name) of
        undefined ->
            {error,not_found};
        _ ->
            ets:insert(Tab, #r_dict{key = Key,value = Value})
    end.

erase_role_dict({Key,RoleId}) ->
    Tab = get_role_ets_tab_name(RoleId),
    case ets:info(Tab, name) of
        undefined ->
            undefined;
        _ ->
            ets:delete(Tab,Key)
    end.

-define(dict_transaction_list,dict_transaction_list).
-define(dict_transaction_flag,dicttransaction_flag).

on_transaction_begin() ->
    erlang:put(?dict_transaction_list, []),
    case erlang:get(?dict_transaction_flag) of
        undefined ->
            erlang:put(?dict_transaction_flag, true),
            ok;
        _ ->
            erlang:throw({nesting_transaction, common_role})
    end,
    ok.
on_transaction_rollback() ->
    lists:foreach(
      fun({Key, BackKey}) ->
              BackInfo = erlang:get(BackKey),
              common_role:set_role_dict(Key,BackInfo),
              erlang:erase(BackKey)
      end, erlang:get(?dict_transaction_list)),
    erlang:erase(?dict_transaction_flag),
    erlang:erase(?dict_transaction_list).
on_transaction_commit() ->
    lists:foreach(
      fun({_Key, BackKey}) ->
              erlang:erase(BackKey)
      end, erlang:get(?dict_transaction_list)),
    erlang:erase(?dict_transaction_flag),
    erlang:erase(?dict_transaction_list).
is_transaction() ->
    case erlang:get(?dict_transaction_flag) of
        undefined ->
            false;
        _ ->
            true
    end.
set_transaction(Key) ->
    BackKey = {Key,?DATA_COPY},
    case erlang:get(?dict_transaction_list) of
        undefined ->
            erlang:throw({error, not_in_transaction});
        BackList ->
            case lists:member(Key, BackList) of
                true ->
                    ignore;
                _ ->
                    erlang:put(?dict_transaction_list, [{Key, BackKey}|BackList]),
                    case common_role:get_role_dict(Key) of
                        undefined ->
                            ignore;
                        BackInfo ->
                            %% 当一个事务操作过程中多次保存时，只需要备份第一次就可以
                            case erlang:get(BackKey) of
                                undefined ->
                                    erlang:put(BackKey, BackInfo);
                                _ ->
                                    ignore
                            end
                    end
            end
    end.


