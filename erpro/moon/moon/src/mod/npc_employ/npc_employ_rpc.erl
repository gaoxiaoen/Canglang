%%----------------------------------------------------
%% @doc 雇佣npc RPC模块
%%
%% <pre>
%% 雇佣npc协议处理
%% </pre>
%% @author yankai
%% @doc
%%----------------------------------------------------
-module(npc_employ_rpc).
-export([
        handle/3
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("npc.hrl").
-include("attr.hrl").

%% 获取某npc的好感度信息
handle(15600, {NpcBaseId}, Role = #role{id = Rid, pid = RolePid, lev = Lev, attr = #attr{fight_capacity = FightCapacity}}) when Lev >= 45 ->
    IsEmployee = npc_employ_mgr:is_employee(Role, NpcBaseId),
    EmployLeftTime = npc_employ_mgr:get_employ_left_time(Role),
    npc_employ_mgr:get_npc_impression_info(Rid, RolePid, NpcBaseId, [FightCapacity, IsEmployee, EmployLeftTime]),
    {ok};
handle(15600, _, _) -> {ok};

%% 获取全部npc的好感度信息
handle(15601, {}, #role{id = Rid, pid = RolePid, lev = Lev}) when Lev >= 45 ->
    npc_employ_mgr:get_all_npc_impression_info(Rid, RolePid, []),
    {ok};
handle(15601, _, _) -> {ok};

%% 获取正在雇佣的npc信息
handle(15602, {}, Role = #role{lev = Lev}) when Lev >= 45 ->
    case npc_employ_mgr:get_employee(Role) of
        undefined -> {reply, {0}};
        NpcBaseId -> {reply, {NpcBaseId}}
    end;
handle(15602, _, _) -> {reply, {0}};

%% 预计算好感度提升值
handle(15609, _, _) -> {ok};

%% 赠送礼物给npc
handle(15610, {NpcBaseId, Gifts}, #role{pid = RolePid, lev = Lev}) when Lev >= 45 ->
    npc_employ_mgr:gift_npc(RolePid, NpcBaseId, Gifts),
    {ok};
handle(15610, _, _) -> {ok};

%% 雇佣npc
handle(15611, {NpcBaseId, Hours}, Role = #role{id = Rid, pid = RolePid, lev = Lev}) when Lev >= 45 andalso is_integer(Hours) andalso Hours>0 ->
    case npc_employ_mgr:get_employee(Role) of
        undefined ->
            case npc_employ_data:is_in_employ_list(NpcBaseId) of
                true ->
                    npc_employ_mgr:employ_npc(Rid, RolePid, NpcBaseId, Hours),
                    {ok};
                false ->
                    {reply, {?false, ?L(<<"这个npc不能被雇佣">>), 0}}
            end;
        _ ->
            {reply, {?false, ?L(<<"你已经雇佣了一个npc">>), 0}}
    end;
handle(15611, _, _) -> {ok};

%% 解雇npc
handle(15612, {NpcBaseId}, Role = #role{id = Rid, pid = RolePid, lev = Lev}) when Lev >= 45 ->
    case npc_employ_mgr:get_employee(Role) of
        undefined -> {reply, {?false, ?L(<<"你并未雇佣任何npc">>)}};
        NpcBaseId ->
            npc_employ_mgr:fire_npc(Rid, RolePid),
            {ok};
        _ ->
            {reply, {?false, ?L(<<"你雇佣的不是这个npc，不能解雇">>)}}
    end;
handle(15612, _, _) -> {ok};


handle(_Cmd, _Data, _Role) ->
    {error, unknow_command}.

