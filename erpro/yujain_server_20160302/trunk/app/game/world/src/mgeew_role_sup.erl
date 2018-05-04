%%%-------------------------------------------------------------------
%%% File        :mgeew_role_sup.erl
%%%-------------------------------------------------------------------
-module(mgeew_role_sup).

-include("mgeew.hrl").

-behavior(supervisor).


-export([start/0, start_link/0, init/1]).
 
start() ->
    {ok, _Pid} = 
        supervisor:start_child(mgeew_sup,{?MODULE, {?MODULE, start_link, []},
                                          transient, infinity, supervisor, [?MODULE]}).

start_link() ->
    {ok, _Pid} = supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    ChildSpec = {mgeew_role,{mgeew_role,start_link,[]},temporary, 500, worker, [mgeew_role]},
    {ok, {{simple_one_for_one, 1, 1}, [ChildSpec]}}.
