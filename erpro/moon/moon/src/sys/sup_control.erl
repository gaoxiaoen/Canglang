%%----------------------------------------------------
%% 进程监控树
%%
%% @author qingxuan 
%%----------------------------------------------------
-module(sup_control).
-behaviour(supervisor).
-export([start_link/0, init/1]).
-include("common.hrl").

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    ?INFO("[~w] 正在启动监控树...", [?MODULE]),
    List = [
         {u, {u, start_link, []}, transient, 10000, worker, [u]}
        ,{sys_env, {sys_env, start_link, [?MODULE]}, transient, 10000, worker, [sys_env]}
        ,{sys_rand, {sys_rand, start_link, []}, transient, 10000, worker, [sys_rand]}
    ],
    {ok, {{one_for_one, 50, 1}, List}}.
