%%-------------------------------------------------------------------------
%% GM管理系统 管理接口
%% @author shawn 
%%-------------------------------------------------------------------------

-module(gm_adm).
-export([
        get_role/1
       ,silent/5
       ,lock/4
       ,kick/1
       ,unlock/2
       ,push_unread_msg/1
       ,notice_msg/2
       ,login/1
    ]).

-define(gm_role_free, 0). %%解封
-define(gm_role_lock, 1). %%封号
-define(gm_role_silent, 2). %%禁言
-define(gm_role_lock_and_silent, 3).%%封号+禁言

-include("common.hrl").
-include("role.hrl").
-include("link.hrl").

%% 禁言
%% Rid = 角色ID
%% SrvId = 服务器标识
%% TIme = 禁言时间, 0表示永久
%% Msg = 备注
%% Adminname = 管理员名字
silent(RoleList, 0, Flag, Msg, AdminName) when is_binary(Msg), is_binary(AdminName) ->
    Ctime = util:unixtime(),
    case do_change_role(silent, RoleList, Ctime, Flag, Msg, AdminName, []) of
        [] -> ok;
        Reason ->
            ?DEBUG("Reason:~s",[Reason]),
            Reason
    end;
silent(RoleList, Time, Flag, Msg, AdminName) when is_binary(Msg), is_binary(AdminName) ->
    Ctime = util:unixtime(),
    TimeOut = Ctime + Time*3600,
    case do_change_role(silent, RoleList, Ctime, TimeOut, Flag, Msg, AdminName, []) of
        [] -> ok;
        Reason ->
            ?DEBUG("Reason:~s",[Reason]),
            Reason
    end.
lock(RoleList, 0, Msg, AdminName) when is_binary(Msg), is_binary(AdminName) ->
    Ctime = util:unixtime(),
    case do_change_role(lock, RoleList, Ctime, Msg, AdminName, []) of
        [] -> ok;
        Reason ->
            ?DEBUG("Reason:~s",[Reason]),
            Reason
    end;
lock(RoleList, Time, Msg, AdminName) when is_binary(Msg), is_binary(AdminName) ->
    Ctime = util:unixtime(),
    TimeOut = Ctime + Time*3600,
    case do_change_role(lock, RoleList, Ctime, TimeOut, Msg, AdminName, []) of
        [] -> ok;
        Reason ->
            ?DEBUG("Reason:~s",[Reason]),
            Reason
    end.

kick(RoleList) ->
    case do_kick(RoleList, []) of
        [] -> ok;
        Reason ->
            ?DEBUG("Reason:~s",[Reason]),
            Reason
    end.

unlock(RoleList, AdminName) ->
    Ctime = util:unixtime(),
    case do_unlock(RoleList, AdminName, Ctime, []) of
        [] -> ok;
        Reason ->
            ?DEBUG("Reason:~s",[Reason]),
            Reason
    end.

%% --------------
%% 查找角色
%% --------------
%% 如果是同一角色调用则需使用参数角色记录
get_role({Rid, SrvId}) ->
    case role_api:lookup(by_id, {Rid, SrvId}) of
        {ok, _N, R} -> {online, R};
        _ -> %% 查找数据库
            case role_data:fetch_base(by_id, {Rid, SrvId}) of
                {ok, R} -> {offline, R};
                {false, _Err} -> {false, ?L(<<"角色不存在">>)}
            end
    end;
get_role(Name) ->
    case role_api:lookup(by_name, Name) of
        {ok, _N, R} -> {online, R};
        _ -> %% 查找数据库
            case role_data:fetch_base(by_name, Name) of
                {ok, R} -> {offline, R};
                {false, _Err} -> {false, ?L(<<"角色不存在">>)}
            end
    end.

do_kick([], Reason) -> Reason;
do_kick([Rinfo | T], Reason) ->
    case get_role(Rinfo) of
        {online, #role{pid = Pid}} ->
            role:stop(async, Pid, ?L(<<"亲,你干坏事了,被踢下去咯~">>)),
            do_kick(T, Reason);
        _ ->
            Err = util:fbin("玩家不在线或者不存在~w",[Rinfo]),
            do_kick(T, [Err | Reason])
    end.

do_unlock([], _AdminName, _Ctime, Reason) -> Reason;
do_unlock([Rinfo | T], AdminName, Ctime, Reason) ->
    case get_role(Rinfo) of
        {online, Role = #role{id = {Rid, SrvId}, pid = LockPid}} ->
            catch unlock_role({Rid, SrvId}),
            case role:apply(sync, LockPid, {gm_rpc, modify_role_lock_status, [?gm_role_free]}) of
                ok ->
                    gm_rpc:insert_gm_log(Rid, SrvId, AdminName, 0, Ctime, 0, ""),
                    do_unlock(T, AdminName, Ctime, Reason);
                _X ->
                    ?ELOG("同步调用解除人物状态失败:~w",[_X]),
                    Err = util:fbin(?L(<<"Name:~s同步调用修改角色封号字段失败:~w">>), [Role#role.name, _X]),
                    do_unlock(T, AdminName, Ctime, [Err | Reason])
            end;
        {offline, Role = #role{id = {Rid, SrvId}}} ->
            catch unlock_role({Rid, SrvId}),
            case update_role_lock(free, Role) of
                ok -> 
                    gm_rpc:insert_gm_log(Rid, SrvId, AdminName, 0, Ctime, 0, ""),
                    do_unlock(T, AdminName, Ctime, Reason);
                false ->
                    Err = util:fbin(?L(<<"Name:~s解除角色封号字段失败">>), [Role#role.name]),
                    do_unlock(T, AdminName, Ctime, [Err | Reason])
            end;
        _X ->
            Err = case is_tuple(Rinfo) of
                true -> {R, S} = Rinfo,
                    util:fbin(?L(<<"角色id:~w,标识:~s不存在">>), [R, S]);
                false -> util:fbin(?L(<<"角色名:~s不存在">>), [Rinfo])
            end,
            do_unlock(T, AdminName, Ctime, [Err | Reason])
    end.

do_change_role(lock, [], _Ctime, _Timeout, _Msg, _AdminName, Reason) -> Reason;
do_change_role(lock, [Rinfo | T], Ctime, TimeOut, Msg, AdminName, Reason) ->
    case get_role(Rinfo) of
        {online, Role = #role{id = {Rid, SrvId}, pid = LockPid}} ->
            catch do_update_role({AdminName, Msg, ?gm_role_lock, 1, Ctime, TimeOut}, {Rid, SrvId}),
            case role:apply(sync, LockPid, {gm_rpc, modify_role_lock_status, [?gm_role_lock]}) of
                ok -> 
                    role:stop(async, LockPid, ?L(<<"亲,你干坏事了,被封号咯~">>)),
                    gm_rpc:insert_gm_log(Rid, SrvId, AdminName, 1, Ctime, TimeOut, Msg),
                    do_change_role(lock, T, Ctime, TimeOut, Msg, AdminName, Reason);
                _X -> 
                    ?ELOG("同步调用修改角色封号字段失败:~w",[_X]),
                    Err = util:fbin(?L(<<"Name:~s同步调用修改角色封号字段失败:~w">>), [Role#role.name, _X]),
                    do_change_role(lock, T, Ctime, TimeOut, Msg, AdminName, [Err | Reason])
            end;
        {offline, Role = #role{id = {Rid, SrvId}}} ->
            catch do_update_role({AdminName, Msg, ?gm_role_lock, 1, Ctime, TimeOut}, {Rid, SrvId}),
            case update_role_lock(lock, Role) of
                ok ->
                    gm_rpc:insert_gm_log(Rid, SrvId, AdminName, 1, Ctime, TimeOut, Msg),
                    do_change_role(lock, T, Ctime, TimeOut, Msg, AdminName, Reason);
                false ->
                    Err = util:fbin(?L(<<"Name:~s修改角色封号字段失败">>), [Role#role.name]),
                    do_change_role(lock, T, Ctime, TimeOut, Msg, AdminName, [Err | Reason])
            end;
        _X ->
            Err = case is_tuple(Rinfo) of
                true -> {R, S} = Rinfo,
                    util:fbin(?L(<<"角色id:~w,标识:~s不存在">>), [R, S]);
                false -> util:fbin(?L(<<"角色名:~s不存在">>), [Rinfo])
            end,
            do_change_role(lock, T, Ctime, TimeOut, Msg, AdminName, [Err | Reason])
    end;

do_change_role(silent, [], _Ctime, _Flag, _Msg, _AdminName, Reason) -> Reason;
do_change_role(silent, [Rinfo | T], Ctime, Flag, Msg, AdminName, Reason) ->
    case get_role(Rinfo) of
        {online, Role = #role{id = {Rid, SrvId}, pid = SilentPid}} ->
            catch do_update_role({AdminName, Flag, Msg, ?gm_role_silent, 2, Ctime, 0}, {Rid, SrvId}),
            case role:apply(sync, SilentPid, {gm_rpc, modify_role_lock_status, [?gm_role_silent]}) of
                ok -> 
                    gm_rpc:insert_gm_log(Rid, SrvId, AdminName, 4, Ctime, 0, Msg),
                    do_change_role(silent, T, Ctime, Flag, Msg, AdminName, Reason);
                _X -> 
                    ?ELOG("同步调用修改角色禁言字段失败:~w",[_X]),
                    Err = util:fbin(?L(<<"Name:~s同步调用修改角色禁言字段失败:~w">>), [Role#role.name, _X]),
                    do_change_role(silent, T, Ctime, Flag, Msg, AdminName, [Err | Reason])
            end;
        {offline, Role = #role{id = {Rid, SrvId}}} ->
            catch do_update_role({AdminName, Flag, Msg, ?gm_role_silent, 2, Ctime, 0}, {Rid, SrvId}),
            case update_role_lock(silent, Role) of
                ok -> 
                    gm_rpc:insert_gm_log(Rid, SrvId, AdminName, 4, Ctime, 0, Msg),
                    do_change_role(silent, T, Ctime, Flag, Msg, AdminName, Reason);
                false ->
                    Err = util:fbin(?L(<<"Name:~s修改角色禁言字段失败">>), [Role#role.name]),
                    do_change_role(silent, T, Ctime, Flag, Msg, AdminName, [Err | Reason])
            end;
        _X ->
            Err = case is_tuple(Rinfo) of
                true -> {R, S} = Rinfo,
                    util:fbin(?L(<<"角色id:~w,标识:~s不存在">>), [R, S]);
                false -> util:fbin(?L(<<"角色名:~s不存在">>), [Rinfo])
            end,
            do_change_role(silent, T, Ctime, Flag, Msg, AdminName, [Err | Reason])
    end.

do_change_role(silent, [], _Ctime, _Timeout, _Flag, _Msg, _AdminName, Reason) -> Reason;
do_change_role(silent, [Rinfo | T], Ctime, TimeOut, Flag, Msg, AdminName, Reason) ->
    case get_role(Rinfo) of
        {online, Role = #role{id = {Rid, SrvId}, pid = SilentPid}} ->
            catch do_update_role({AdminName, Flag, Msg, ?gm_role_silent, 1, Ctime, TimeOut}, {Rid, SrvId}),
            case role:apply(sync, SilentPid, {gm_rpc, modify_role_lock_status, [?gm_role_silent]}) of
                ok ->
                    gm_rpc:insert_gm_log(Rid, SrvId, AdminName, 3, Ctime, TimeOut, Msg),
                    do_change_role(silent, T, Ctime, TimeOut, Flag, Msg, AdminName, Reason);
                _X -> 
                    ?ELOG("同步调用修改角色禁言字段失败:~w",[_X]),
                    Err = util:fbin(?L(<<"Name:~s同步调用修改角色禁言字段失败:~w">>), [Role#role.name, _X]),
                    do_change_role(silent, T, Ctime, TimeOut, Flag, Msg, AdminName, [Err | Reason])
            end;
        {offline, Role = #role{id = {Rid, SrvId}}} ->
            catch do_update_role({AdminName, Flag, Msg, ?gm_role_silent, 1, Ctime, TimeOut}, {Rid, SrvId}),
            case update_role_lock(silent, Role) of
                ok ->
                    gm_rpc:insert_gm_log(Rid, SrvId, AdminName, 3, Ctime, TimeOut, Msg),
                    do_change_role(silent, T, Ctime, TimeOut, Flag, Msg, AdminName, Reason);
                false ->
                    Err = util:fbin(?L(<<"Name:~s修改角色禁言字段失败">>), [Role#role.name]),
                    do_change_role(silent, T, Ctime, TimeOut, Flag, Msg, AdminName, [Err | Reason])
            end;
        _X ->
            Err = case is_tuple(Rinfo) of
                true -> {R, S} = Rinfo,
                    util:fbin(?L(<<"角色id:~w,标识:~s不存在">>), [R, S]);
                false -> util:fbin(?L(<<"角色名:~s不存在">>), [Rinfo])
            end,
            do_change_role(silent, T, Ctime, TimeOut, Flag, Msg, AdminName, [Err | Reason])
    end.

do_change_role(lock, [], _Ctime, _Msg, _AdminName, Reason) -> Reason;
do_change_role(lock, [Rinfo | T], Ctime, Msg, AdminName, Reason) ->
    case get_role(Rinfo) of
        {online, Role = #role{id = {Rid, SrvId}, pid = LockPid}} ->
            catch do_update_role({AdminName, Msg, ?gm_role_lock, 2, Ctime, 0}, {Rid, SrvId}),
            case role:apply(sync, LockPid, {gm_rpc, modify_role_lock_status, [?gm_role_lock]}) of
                ok ->
                    role:stop(async, LockPid, ?L(<<"亲,你干坏事了,被封号咯~">>)),
                    gm_rpc:insert_gm_log(Rid, SrvId, AdminName, 2, Ctime, 0, Msg),
                    do_change_role(lock, T, Ctime, Msg, AdminName, Reason);
                _X -> 
                    ?ELOG("同步调用修改角色封号字段失败:~w",[_X]),
                    Err = util:fbin(?L(<<"Name:~s同步调用修改角色封号字段失败:~w">>), [Role#role.name, _X]),
                    do_change_role(lock, T, Ctime, Msg, AdminName, [Err | Reason])
            end;
        {offline, Role = #role{id = {Rid, SrvId}}} ->
            catch do_update_role({AdminName, Msg, ?gm_role_lock, 2, Ctime, 0}, {Rid, SrvId}),
            case update_role_lock(lock, Role) of
                ok ->
                    gm_rpc:insert_gm_log(Rid, SrvId, AdminName, 2, Ctime, 0, Msg),
                    do_change_role(lock, T, Ctime, Msg, AdminName, Reason);
                false ->
                    Err = util:fbin(?L(<<"Name:~s修改角色封号字段失败">>), [Role#role.name]),
                    do_change_role(lock, T, Ctime, Msg, AdminName, [Err | Reason])
            end;
        _X ->
            Err = case is_tuple(Rinfo) of
                true -> {R, S} = Rinfo,
                    util:fbin(?L(<<"角色id:~w,标识:~s不存在">>), [R, S]);
                false -> util:fbin(?L(<<"角色名:~s不存在">>), [Rinfo])
            end,
            do_change_role(lock, T, Ctime, Msg, AdminName, [Err | Reason])
    end.

update_role_lock(free, #role{lock_info = ?gm_role_free}) -> ok;
update_role_lock(free, #role{id = {Rid, SrvId}}) ->
    Sql = "update role set lock_info=~s where id=~s and srv_id=~s",
    case db:execute(Sql, [?gm_role_free, Rid, SrvId]) of
        {error, Why} ->
            ?ELOG("解锁角色禁言封号字段失败:~w",[Why]),
            false;
        {ok, _Affected} -> ok 
    end;

update_role_lock(silent, #role{lock_info = ?gm_role_silent}) -> ok;
update_role_lock(silent, #role{lock_info = ?gm_role_lock_and_silent}) -> ok;
update_role_lock(silent, #role{id = {Rid, SrvId}, lock_info = ?gm_role_lock}) ->
    Sql = "update role set lock_info=~s where id=~s and srv_id=~s",
    case db:execute(Sql, [?gm_role_lock_and_silent, Rid, SrvId]) of
        {error, Why} ->
            ?ELOG("修改角色禁言字段失败:~w",[Why]),
            false;
        {ok, _Affected} -> ok 
    end;
update_role_lock(silent, #role{id = {Rid, SrvId}, lock_info = ?gm_role_free}) ->
    Sql = "update role set lock_info=~s where id=~s and srv_id=~s",
    case db:execute(Sql, [?gm_role_silent, Rid, SrvId]) of
        {error, Why} ->
            ?ELOG("修改角色禁言字段失败:~w",[Why]),
            false;
        {ok, _Affected} -> ok 
    end;

update_role_lock(lock, #role{lock_info = ?gm_role_lock}) -> ok;
update_role_lock(lock, #role{lock_info = ?gm_role_lock_and_silent}) -> ok;
update_role_lock(lock, #role{id = {Rid, SrvId}, lock_info = ?gm_role_silent}) ->
    Sql = "update role set lock_info=~s where id=~s and srv_id=~s",
    case db:execute(Sql, [?gm_role_lock_and_silent, Rid, SrvId]) of
        {error, Why} ->
            ?ELOG("修改角色封号字段失败:~w",[Why]),
            false;
        {ok, _Affected} -> ok 
    end;
update_role_lock(lock, #role{id = {Rid, SrvId}, lock_info = ?gm_role_free}) ->
    Sql = "update role set lock_info=~s where id=~s and srv_id=~s",
    case db:execute(Sql, [?gm_role_lock, Rid, SrvId]) of
        {error, Why} ->
            ?ELOG("修改角色封号字段失败:~w",[Why]),
            false;
        {ok, _Affected} -> ok 
    end.

%% ----------------
%% 更新玩家封号信息
%% Adminname 管理员名字
%% Msg 备注
%% Value 1时间,2永久
%% Ctime 封号时间
%% Timeout 自动解封时间, 0表示永不过期 
unlock_role({Rid, SrvId}) ->
    Sql = <<"delete from sys_lock_role_info where rid =~s and srv_id =~s">>,
    case db:execute(Sql, [Rid, SrvId]) of
        {ok, _} -> ok;
        _Other ->
            ?ELOG("解除封号禁言状态,Rid:~w,Srvid:~s,Reason:~s",[Rid,SrvId,_Other]),
            false
    end.

%% 更新玩家封号信息
do_update_role({AdminName, Msg, ?gm_role_lock, Value, Ctime, TimeOut}, {Rid, SrvId}) ->
    Sql = <<"insert into sys_lock_role_info(rid, srv_id, admin_name, lock_type, lock_ctime, lock_timeout, lock_info, silent_type, silent_ctime, silent_timeout, silent_hide, silent_info) values(~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s) ON DUPLICATE KEY UPDATE admin_name = ~s, lock_type = ~s, lock_ctime = ~s, lock_timeout = ~s, lock_info = ~s">>,
    case db:execute(Sql, [Rid, SrvId, AdminName, Value, Ctime, TimeOut, Msg, 0, 0, 0, 0, <<"">>, AdminName, Value, Ctime, TimeOut, Msg]) of
        {ok, _} -> ok;
        _Other ->
            ?ELOG("封号修改数据库失败,AdminName:~s,Rid:~w,Srvid:~s,Reason:~s",[AdminName,Rid,SrvId,_Other]),
            false
    end;

%% 更新玩家禁言信息
do_update_role({AdminName, Flag, Msg, ?gm_role_silent, Value, Ctime, TimeOut}, {Rid, SrvId}) ->
    Sql = <<"insert into sys_lock_role_info(rid, srv_id, admin_name, lock_type, lock_ctime, lock_timeout, lock_info, silent_type, silent_ctime, silent_timeout, silent_hide, silent_info) values(~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s) ON DUPLICATE KEY UPDATE admin_name = ~s, silent_type = ~s, silent_ctime = ~s, silent_timeout = ~s, silent_hide= ~s, silent_info = ~s">>,
    case db:execute(Sql, [Rid, SrvId, AdminName, 0, 0, 0, <<"">>, Value, Ctime, TimeOut, Flag, Msg, AdminName, Value, Ctime, TimeOut, Flag, Msg]) of
        {ok, _} -> ok;
        _Other ->
            ?ELOG("禁言修改数据库失败,AdminName:~s,Rid:~w,Srvid:~s,Reason:~s",[AdminName,Rid,SrvId,_Other]),
            false
    end.


%% 客服系统 ----
% 未读消息
%% -> [list()]
get_unread_msg(RoleId, SrvId) ->
    case db:get_all("SELECT `id`, `time`, `msg` FROM `service_msg` WHERE role_id=~p AND srv_id=~s AND `read`=0 ORDER BY id ASC", [RoleId, SrvId]) of
        {ok, List} ->
            List;
        _ ->
            []
    end.

% 推送新消息
%% -> any()
push_unread_msg(#role{id = {RoleId, SrvId}, link = #link{conn_pid = ConnPid}}) ->
    MsgList = get_unread_msg(RoleId, SrvId),
    case MsgList of
        [] -> {ok};
        _ ->
            mark_msg_as_readed(RoleId, SrvId, MsgList),
            Data = [ [Time, Msg] || [_Id, Time, Msg] <- MsgList ],
            sys_conn:pack_send(ConnPid, 14507, {Data}),
            {ok}
    end.

%% -> {ok}
mark_msg_as_readed(_RoleId, _SrvId, []) ->
    {ok};
mark_msg_as_readed(RoleId, SrvId, MsgList) ->
    [[Id, _Time, _Msg]|_] = lists:reverse(MsgList),
    db:execute("UPDATE `service_msg` SET `read`=1 WHERE id<=~p AND `role_id`=~p AND `srv_id`=~s AND `read`=0", [Id, RoleId, SrvId]),
    {ok}.

%% 服务端收到客服回复
%% -> online | offline
notice_msg(RoleId, SrvId) ->
    case global:whereis_name({role, RoleId, list_to_binary(SrvId)}) of
        Pid when is_pid(Pid) ->
            role:apply(async, Pid, {fun push_unread_msg/1, []}),
            online;
        _ ->
            offline
    end.

login(Role = #role{pid = Pid}) ->
    role:apply(async, Pid, {fun push_unread_msg/1, []}),
    Role.

