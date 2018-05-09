%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. 五月 2018 15:21
%%%-------------------------------------------------------------------
-module(m1).
-author("Administrator").

%% API
-export([loop/1]).

-ifdef(debug_flag).
-define(DEBUG(X),io:format("DEBUG ~p:~p ~p~n",[?MODULE, ?LINE,X])).
-else.
-define(DEBUG(X),void).
-endif.


loop(0) ->
    done;
loop(N) ->
    ?DEBUG(N),
    loop(N-1).
