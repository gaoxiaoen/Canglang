%%----------------------------------------------------
%% @doc 合服程序监控树
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(merge_sup).

-behaviour(supervisor).

-export([
        start_link/0
        ,init/1
    ]
).

-include("common.hrl").
-include("merge.hrl").

start_link() ->
    ?INFO("[~w] 正在启动监控树...", [?MODULE]),
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    List = [
        {merge_context, {merge_context, start_link, []}, transient, 10000, worker, [merge_context]}
    ],
    {ok, {{one_for_one, 50, 1}, List}}.
