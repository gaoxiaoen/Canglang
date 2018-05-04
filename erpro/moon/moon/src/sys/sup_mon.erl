%%----------------------------------------------------
%% 进程监控树
%%
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(sup_mon).
-behaviour(supervisor).
-export([start_link/1, init/1]).
-include("common.hrl").

start_link(Args) ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, Args).

init([Port]) ->
    ?INFO("[~w] 正在启动监控树...", [?MODULE]),
    List = [
         {sys_env, {sys_env, start_link, []}, transient, 10000, worker, [sys_env]}
        ,{sys_rand, {sys_rand, start_link, []}, transient, 10000, worker, [sys_rand]}
        ,{mon, {mon, start_link, []}, transient, 10000, worker, [mon]}
        ,{sup_acceptor, {sup_acceptor, start_link, []}, permanent, 10000, supervisor, [sup_acceptor]}
        ,{sys_listener, {sys_listener, start_link, [Port]}, transient, 10000, worker, [sys_listener]}
    ],
    {ok, {{one_for_one, 50, 1}, List}}.
