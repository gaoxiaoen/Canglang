%%----------------------------------------------------
%% NPC商店数据转换
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(npc_store_parse).
-export([do/1]).
-include("common.hrl").
-include("npc_store.hrl").

do({npc_store, Ver = 0, Day, Log, SmRef}) ->
    do({npc_store, Ver + 1, Day, Log, SmRef, {0, 0}});
do(NpcStore = #npc_store{ver = ?NPC_STORE_VER}) ->
    {ok, NpcStore};
do(_NpcStore) ->
    ?ERR("NPC商店数据转换失败"),
    {false, ?L(<<"NPC商店数据转换失败">>)}.
