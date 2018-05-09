%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 五月 2018 16:56
%%%-------------------------------------------------------------------
-module(lib_misc).
-author("Administrator").

%% API
-export([string2Value/1,sleep/1,dump/2,deliberate_error/1]).

%%-define(NYI(X),(begin
%%                    io:format("*** NYI ~p ~p~p~n",[?MODULE,?LINE,X]),
%%                    exit(NYI)
%%                end)).
%%glurk() ->
%%    ?NYI({glurk,X,Y}).

dump(File,Term) ->
    Out = File ++ ".tmp",
    io:format("** dumping to ~s~n",[Out]),
    {ok,S} = file:open(Out,[write]),
    io:format(S,"~p.~n",[Term]),
    file:close(S).

string2Value(Str) ->
    {ok,Tokens,_} = erl_scan:string(Str ++ "."),
    {ok,Exprs} = erl_parse:parse_exprs(Tokens),
    Bindings = erl_eval:new_bindings(),
    {value,Value,_} = erl_eval:exprs(Exprs,Bindings),
    Value.

sleep(T)->
    receive
    after T->
        true
    end.

deliberate_error(A) ->
    bad_function(A,12),
    lists:reverse(A).

bad_function(A,_) ->
    {ok,Bin} = file:open({abc,123},A),
    binary_to_list(Bin).