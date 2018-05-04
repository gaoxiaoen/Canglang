%%%----------------------------------------------------------------------
%%% File    : common_mysql_misc.erl
%%%----------------------------------------------------------------------
 
-module(common_mysql_misc).

%%
%% Include files
%%

%%
%% Exported Functions
%%
 
-export([to_tinyint/1,
         tinyint_to_bool/1,
         field_to_varchar/1,
         field_to_varchar_by_list/1]).
-export([tuplechar_to_tuple/1]).
-export([]).

%%
%% API Functions
%%


%% @doc 将term类型转换成tinyiint类型
to_tinyint(Val) when is_boolean(Val)->
    case Val of 
        true-> 1;
        false-> 0
    end;
to_tinyint(Val) when is_integer(Val)->
    case (Val>0) of
        true-> 1;
        false-> 0
    end;
to_tinyint(Val) ->
    Val.

%% @doc 将tinyint类型转换为boolean类型
tinyint_to_bool(Val) when is_integer(Val)->
    case (Val>0) of
        true-> 1;
        false-> 0
    end;
tinyint_to_bool(null) ->
    undefined;
tinyint_to_bool(Val) ->
    Val.


%% @doc 将字段转换为varchar类型
field_to_varchar(Val) when is_tuple(Val)->
    List1 = lists:foldr(fun(E,AccIn)->
                                case AccIn of
                                    []-> [E];
                                    _ -> [E,","|AccIn]
                                end 
                        end, [], tuple_to_list(Val)),
    lists:concat( [ common_tool:to_list(I)||I<-List1 ] );
field_to_varchar(Val) ->
    common_tool:to_list( Val ).

field_to_varchar_by_list([]) ->
    "";
field_to_varchar_by_list(Data) when erlang:is_list(Data) ->
    field_to_varchar_by_list2(Data);
field_to_varchar_by_list(Data) ->
    common_tool:to_list(Data).

field_to_varchar_by_list2([]) ->
    "";
field_to_varchar_by_list2(List) ->
    field_to_varchar_by_list3(List,"").

field_to_varchar_by_list3([],Str) ->
    Str;
field_to_varchar_by_list3([H|T],Str) ->
    case erlang:is_tuple(H) of
        true ->
            case Str of
                "" ->
                    NewStr = lists:concat([[ common_tool:to_list(I) || I <- tuple_to_list(H)]]);
                _ ->
                    NewStr = lists:concat([Str,",",[ common_tool:to_list(I) || I <- tuple_to_list(H)]])
            end;
        _ ->
            case Str of
                "" ->
                    NewStr = lists:concat([ common_tool:to_list(H)]);
                _ ->
                    NewStr = lists:concat([ Str,",", common_tool:to_list(H)])
            end
    end,
    field_to_varchar_by_list3(T,NewStr).
    


%% @doc 将tuplechar字段转换为tuple类型,
%% @tip tuple的元素必须是数字或atom
tuplechar_to_tuple(Val) when is_binary(Val)->
    tuplechar_to_tuple( binary_to_list(Val) );
tuplechar_to_tuple(Val) when is_list(Val)->
    List1 = string:tokens(Val, ","),
    list_to_tuple( [ from_varchar_element(I)||I<-List1 ] ).

from_varchar_element(Val) when is_list(Val)->
    [H|_T] = Val,
    case (H >= $0) andalso ( H =<$9 ) of
        true-> 
            list_to_integer(Val);
        false->
            common_tool:list_to_atom(Val)
    end.


