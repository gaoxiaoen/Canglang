%%----------------------------------------------------
%% @doc 雇佣npc数据
%%
%% <pre>
%% 雇佣npc数据
%% </pre>
%% @author yankai@jieyou.cn
%%----------------------------------------------------
-module(npc_employ_data).
-export([
        is_in_employ_list/1,
        get_all/0
    ]
).

-include("common.hrl").
-include("boss.hrl").

%% @spec is_in_employ_list(NpcBaseId) -> true | false
%% @doc 判断是否在可以雇佣的列表里
is_in_employ_list(NpcBaseId) ->
    L = get_all(),
    lists:member(NpcBaseId, L).

%% @spec get_all() -> [integer()]
%% @doc 返回全部可以雇佣的npc基础id
get_all() ->
    [10025, 11014, 11016, 11009, 11013, 11006, 11035, 11004, 11031, 11002].

