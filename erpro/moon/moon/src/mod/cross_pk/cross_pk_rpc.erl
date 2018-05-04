%%----------------------------------------------------
%% 跨服PK场
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(cross_pk_rpc).
-export([handle/3]).
-include("common.hrl").
-include("role.hrl").
-include("cross_pk.hrl").
-include("pos.hrl").
-include("link.hrl").

%% 获取状态
handle(16901, {}, _Role) ->
    {reply, cross_pk:get_status()};

%% 获取房间列表信息
handle(16902, {}, Role) ->
    case check_time(handle_16902, 5) of
        false -> {ok};
        true ->
            put(handle_16902, util:unixtime()),
            {reply, {cross_pk:get_room_list(Role)}}
    end;

%% 获取房间内成员列表信息
handle(16903, {Page}, Role = #role{pos = #pos{map_base_id = ?CROSS_PK_MAP}}) ->
    ?DEBUG("===============================[~p]", [Page]),
    {reply, cross_pk:get_roles(Role, Page)};
handle(16903, {_Page}, _Role) ->
    {ok};

%% 进入指定房间
handle(16904, {RoomId}, Role) ->
    case cross_pk:role_enter(Role, RoomId) of 
        {false, coin_all} -> {reply, {?coin_all_less, <<>>}};
        {false, Reason} -> {reply, {0, Reason}};
        {ok} -> {ok}
    end;

%% 退出跨服比武场
handle(16905, {}, Role) ->
    case cross_pk:role_leave(Role) of
        {false, Reason} -> {reply, {0, Reason}};
        {ok, NRole} -> {reply, {1, <<>>}, NRole};
        {ok} -> {ok}
    end;

%% 发起跨服决斗
handle(16910, PkRoleId = {_PkId, _PkSrvId}, Role = #role{id = {Rid, SrvId}, name = Name}) ->
    case cross_pk:check_duel(Role, PkRoleId) of
        {ok, PkPid} ->
            role:c_pack_send(PkPid, 16911, {Rid, SrvId, Name}),
            {reply, {?true, ?L(<<"跨服决斗请求已发送">>)}};
        {false, Msg} ->
            {reply, {?false, Msg}}
    end;

%% 返回决斗请求的结果
handle(16912, {?false, PkId, PkSrvId}, #role{id = {Rid, SrvId}, name = Rname}) ->
    case role_api:c_lookup(by_id, {PkId, PkSrvId}, #role.pid) of
        {ok, _Node, Pid} ->
            role:c_pack_send(Pid, 16913, {?false, Rid, SrvId, Rname, util:fbin(?L(<<"~s 拒绝了您的决斗请求">>), [Rname])});
        _ -> ignore
    end,
    {ok};
handle(16912, {?true, PkId, PkSrvId}, Role) ->
    case role_api:c_lookup(by_id, {PkId, PkSrvId}, #role.pid) of
        {ok, _Node, Pid} ->
            case cross_pk:check_duel(Role) of
                {false, Msg} -> {reply, {?false, Msg}};
                ok ->
                    case role:c_apply(sync, Pid, {cross_pk, check_duel_sync, []}) of
                        {false, Msg} -> {reply, {?false, Msg}};
                        {badrpc, _} -> {reply, {?false, ?L(<<"对方不在线">>)}};
                        ok ->

                            case cross_pk:start_duel(Role, Pid) of
                                {ok, NewRole} -> {ok, NewRole};
                                {false, Msg} ->
                                    {reply, {?false, Msg}}
                            end
                    end
            end;
        _ ->
            {reply, {?false, ?L(<<"对方不在线">>)}}
    end;

%% 容错
handle(_Cmd, _Data, _Role) ->
    {error, unknow_command}.

%%-------------------------------------
%% 内部方法
%%-------------------------------------

%% 时间间隔最小为: 秒
check_time(Type, N) -> 
    LastTime = case role:get_dict(Type) of
        {ok, undefined} -> 0;
        {ok, T} -> T
    end,
    (LastTime + N) < util:unixtime().

