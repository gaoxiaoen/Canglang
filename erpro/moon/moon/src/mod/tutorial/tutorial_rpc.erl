%%----------------------------------------------------
%% 新手流程
%% @author 
%%----------------------------------------------------
-module(tutorial_rpc).
-export([handle/3]).

-include("common.hrl").
-include("role.hrl").
-include("vip.hrl").
-include("gain.hrl").
-include("link.hrl").
-include("item.hrl").
-include("tutorial.hrl").
-include("pos.hrl").
-include("combat.hrl").

%%

%% == 跳转的协议 ================================

%% 场景：进入新手剧情副本场景
%% 正常处理, 还有npc在里面
handle(10100, {0, _}, _Role = #role{link = #link{conn_pid = ConnPid}, pos = #pos{map = ?tutorial_map, x = X, y = Y}, tutorial = #tutorial{npc = [_|_]}}) ->
    sys_conn:pack_send(ConnPid, 10110, {?tutorial_map, X, Y}),
    {ok};
%% 容错处理，实际上已经完成新手副本
handle(10100, {0, _}, Role = #role{pos = #pos{map = ?tutorial_map}, tutorial = #tutorial{}}) ->
    Role1 = tutorial:leave(Role),
    {ok, Role1};

%% 场景：请求新手剧情副本场景元素
handle(10111, {}, _Role = #role{pos = #pos{map = ?tutorial_map}, tutorial = #tutorial{npc = NpcIds}}) ->
    NpcList = [tutorial:get_map_npc(NpcId)||NpcId<-NpcIds],
    ?DEBUG("-------------------------->> 新手  ~w", [NpcList]),
    {reply, {[], NpcList, []}};

%% 场景：新手剧情副本场景内移动
handle(10115, {DestX, DestY, Dir}, Role = #role{status = Status, pos = Pos = #pos{map = ?tutorial_map}}) when Status =:= ?status_normal -> %% 正常状态下才可以移动
    {ok, Role#role{pos = Pos#pos{x = DestX, y = DestY, dest_x = DestX, dest_y = DestY, dir = Dir}}};

%% --------------------------
%% 战斗：玩家对NPC发起战斗
handle(10705, {NpcId}, Role=#role{link=#link{conn_pid=_ConnPid}}) ->
    %NpcPos = #pos{map = ?tutorial_map, x = ?tutorial_npc_pos_x, y = ?tutorial_npc_pos_y},
    %{ok, NpcBase} = npc_data:get(?tutorial_npc),
    %Npc = npc_convert:base_to_npc(1, NpcBase, NpcPos),
    Npc = tutorial:get_npc(NpcId),
    DfdList = npc:fighter_group(Npc, Role),
    Referees1 = undefined,
    case combat:start(?combat_type_tutorial, Referees1, role_api:fighter_group(Role), DfdList) of
        {ok, _CombatPid} -> {ok};
        {error, _Err} -> 
            ?ERR("玩家对npc发起战斗失败:~w", [_Err]),
            {reply, {}}
    end;

%% --------------------------
handle(_Cmd, _Data, _Role) -> %% 容错处理
    {error, unknow_command}.


