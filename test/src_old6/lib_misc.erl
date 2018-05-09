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
-export([string2Value/1,sleep/1]).

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