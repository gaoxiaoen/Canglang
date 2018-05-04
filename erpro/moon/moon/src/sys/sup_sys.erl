%%----------------------------------------------------
%% 进程监控树
%%
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(sup_sys).
-behaviour(supervisor).
-export([
        start_child/1
        ,start_childs/1
    ]
).

-export([start_link/1, init/1]).
-include("common.hrl").

start_link(Args) ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, Args).

start_child(ChildSpec) when is_tuple(ChildSpec) ->
    supervisor:start_child(?MODULE, ChildSpec).

start_childs([H | T]) ->
    start_child(H),
    start_childs(T).

init([Host, Port]) ->
    ?INFO("启动监控树~w...", [?MODULE]),
    %% 基础服务
    List = [
         {sys_env, {sys_env, start_link, []}, transient, 10000, worker, [sys_env]}
        ,{sys_node_mgr, {sys_node_mgr, start_link, [Host, Port]}, transient, 10000, worker, [sys_node_mgr]}
        ,{sys_rand, {sys_rand, start_link, []}, transient, 10000, worker, [sys_rand]}
    ],
    {ok, {{one_for_one, 50, 1}, List}}.
