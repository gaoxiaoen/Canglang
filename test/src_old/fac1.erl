%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. 五月 2018 16:05
%%%-------------------------------------------------------------------
-module(fac1).
-author("Administrator").

%% API
-export([main/1]).

main([A]) ->
    I = list_to_integer(atom_to_list(A)),
    F=fac(I),
    io:format("factorial ~w = ~w~n",[I,F]),
    init:stop().

fac(0) ->1;
fac(N) ->N*fac(N-1).