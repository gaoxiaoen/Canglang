%%----------------------------------------------------
%% @doc 雇佣npc 数据库操作模块
%%
%% <pre>
%% 雇佣npc数据库操作模块
%% </pre>
%% @author yankai
%% @doc
%%----------------------------------------------------
-module(npc_employ_dao).

-export([
        save_impression/1,
        load_all_impression/0
    ]).

-include("common.hrl").
-include("npc.hrl").

%% @spec save_impression(NpcImpression) -> true | {false, Reason}
%% NpcImpression = #npc_impression{}
%% 保存NPC好感度
save_impression(#npc_impression{role_id = RoleId, srv_id = SrvId, npc_base_id = NpcBaseId, impression = Impression}) ->
    Sql = <<"replace into sys_npc_impression(role_id, srv_id, npc_base_id, impression) values (~s, ~s, ~s, ~s)">>,
    case db:execute(Sql, [RoleId, SrvId, NpcBaseId, Impression]) of
        {error, _Why} -> 
            {false, ?L(<<"更新NPC好感度失败">>)};
        {ok, _} -> true
    end.

%% @spec load_all_impression(N) -> [#npc_impression{}]
%% 读取所有NPC好感度
load_all_impression() ->
    Sql = <<"select role_id,srv_id,npc_base_id,impression from sys_npc_impression">>,
    case db:get_all(Sql, []) of
        {ok, Data} when is_list(Data) ->
            convert_to_npc_impression(Data, []);
        {error, _Msg} ->
            ?ERR("读取所有NPC好感度出错: ~s", [_Msg]),
            [];
        _ ->
            []
    end.

convert_to_npc_impression([], L) -> lists:reverse(L);
convert_to_npc_impression([[RoleId, SrvId, NpcBaseId, Impression] | T], L) ->
    NpcImpression = #npc_impression{role_id = RoleId, srv_id = SrvId, npc_base_id = NpcBaseId, impression = Impression},
    convert_to_npc_impression(T, [NpcImpression|L]).
