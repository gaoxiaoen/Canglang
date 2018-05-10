%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. 五月 2018 15:05
%%%-------------------------------------------------------------------
-module(start_server).
-author("Administrator").

%% API
-export([start/0]).

start() ->
    role_manage:start_link(),
    tcp_link:start(3321).
