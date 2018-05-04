%%%-------------------------------------------------------------------
%%% File        :common_config_code.erl
%%% Author      :caochuncheng2002@gmail.com
%%% Create Date :2010-12-2
%%% @doc
%%%     用于动态生成代码，主要是从.config文件转换成erl，并编译成beam
%%% @end
%%%-------------------------------------------------------------------
-module(common_config_code).


%% API
-export([gen_src/4]). 

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("common.hrl").
-include("common_server.hrl").

%% ====================================================================
%% API Functions
%% ====================================================================

%%@spec gen_src/2
%%@param    ConfModuleName::string()
%%@param    KeyValues::list(),  [{Par,Val}]
gen_src(ConfModuleName,Type,KeyValues,ValList) ->
    KeyValues2 =
        if Type =:= bag ->
                lists:foldl(fun({K, V}, Acc) ->
                                    case lists:keyfind(K, 1, Acc) of
                                        false ->
                                            [{K, [V]}|Acc];
                                        {K, VO} ->
                                            [{K, [V|VO]}|lists:keydelete(K, 1, Acc)]
                                    end
                            end, [], KeyValues);
           true ->
                KeyValues
        end,
    Cases = lists:foldl(fun({Key, Value}, C) ->
                                lists:concat([C,lists:flatten(io_lib:format("find_by_key(~w) -> ~w;\n", [Key, Value]))])
                        end,
                        "",
                        KeyValues2),
    StrList = lists:flatten(io_lib:format("     ~w\n", [ValList])),
    
"
-module(" ++ common_tool:to_list(ConfModuleName) ++ ").
-export([list/0,find_by_key/1]).

list()->"++ StrList ++".
" ++ Cases ++ "
find_by_key(_) -> undefined.
".

