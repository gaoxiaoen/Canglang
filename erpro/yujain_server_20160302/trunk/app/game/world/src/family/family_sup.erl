%%% -------------------------------------------------------------------
%%% Author  : caochuncheng2002@gmail.com
%%% Description : 帮派监控树
%%%
%%% Created : 2013-8-22
%%% -------------------------------------------------------------------
-module(family_sup).

-behaviour(supervisor).

-include("mgeew.hrl").

-export([
         start_link/0,
         init/1
        ]).


start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).


init([]) ->
    RestartStrategy = one_for_one,
    MaxRestarts = 1000,
    MaxSecondsBetweenRestarts = 3600,
    SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},
    {ok, {SupFlags, []}}.
%%     AChild = {'AName',{'AModule',start_link,[]},
%% 	      permanent,2000,worker,['AModule']},
%%     {ok,{{one_for_all,0,1}, [AChild]}}.
