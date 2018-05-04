%%----------------------------------------------------
%% 新手流程
%% @author 
%%----------------------------------------------------
-module(tutorial).
-include("common.hrl").
-include("role.hrl").
-include("link.hrl").
-include("npc.hrl").
-include("pos.hrl").
-include("map.hrl").
-include("tutorial.hrl").
-export([
    get_map_npc/1     
    ,get_npc/1
    ,finish/1
    ,leave/1
    %,is_finished/1
    %,can_finish/1
    %,remove_npc/2
    ,check_finish/2
]).

%% -> #map_npc{} | undefined
get_map_npc(NpcId) ->
    case get_npc(NpcId) of
        Npc = #npc{} ->
            npc_convert:do(to_map_npc, Npc);
        _ ->
            undefined
    end.
 
%% -> #npc{} | undefined
get_npc(NpcId) ->
    {NpcBaseId, PosX, PosY} = tutorial_data:npc(NpcId),
    case npc_data:get(NpcBaseId) of
        {ok, NpcBase} ->
            NpcPos = #pos{
                map = ?tutorial_map
                ,x = PosX
                ,y = PosY
            },
            npc_convert:base_to_npc(NpcId, NpcBase, NpcPos);
        _ ->
            undefined
    end.

%% 完成并离开新手场景
%% -> #role{}
finish(Role = #role{tutorial=#tutorial{}}) ->
    Role1 = Role#role{tutorial = undefined},
    %{PosX, PosY} = ?map_def_xy,
    %{ok, Role2} = map:role_enter(?capital_map_id, PosX, PosY, Role1),
    Role1;
finish(Role) ->
    Role.

leave(Role = #role{tutorial=#tutorial{}}) ->
    Role1 = Role#role{tutorial = undefined},
    {PosX, PosY} = ?map_def_xy,
    {ok, Role2} = map:role_enter(?capital_map_id, PosX, PosY, Role1),
    Role2.

%% 新手是否已完成 
%% -> true | false
is_finished(_Role = #role{tutorial=#tutorial{}}) ->
    false;
is_finished(_) ->
    true.

%% 是否可以完成
%% -> true | false
can_finish(NpcKilled) ->
    lists:member(?tutorial_npc1, NpcKilled).

%% -> #role{} 
remove_npc(Role = #role{tutorial = T = #tutorial{npc = NpcIds}}, NpcBaseId) when is_integer(NpcBaseId) ->
    Role#role{tutorial = T#tutorial{npc = lists:delete(tutorial_data:npc_id(NpcBaseId), NpcIds)}};
remove_npc(Role = #role{tutorial = T = #tutorial{npc = NpcIds}}, NpcKilled) when is_list(NpcKilled) ->
    Role#role{tutorial = T#tutorial{npc = NpcIds -- [tutorial_data:npc_id(NpcBaseId)||NpcBaseId<-NpcKilled]}}.

%% -> #role{}
check_finish(Role = #role{link=#link{conn_pid=ConnPid}}, NpcKilled) ->
    case is_finished(Role) of
        true -> Role;
        false ->
            case can_finish(NpcKilled) of
                true -> 
                    sys_conn:pack_send(ConnPid, 10792, {?capital_map_id}),
                    finish(Role);
                false -> remove_npc(Role, NpcKilled)
            end
    end.

