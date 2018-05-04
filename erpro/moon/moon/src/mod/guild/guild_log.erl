%----------------------------------------------------
%%  帮会日志
%% @author liuweihua(yjbgwxf@gmail.com)
%%----------------------------------------------------
-module(guild_log).
-export([join_leave/10, log/8, log_claim/4]).

-include("common.hrl").

%% 角色退帮进帮日志
join_leave(Rid, Rsrvid, Rname, Type, Gid, Gsrvid, Gname, Eid, Esrvid, Ename) ->
    Sql = <<"insert into log_guild_join_leave(rid, srv_id, name, type, g_id, g_srv_id, g_name, e_id, e_srv_id, e_name, utime) values(~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s)">>,
    case db:execute(Sql, [Rid, Rsrvid, Rname, Type, Gid, Gsrvid, Gname, Eid, Esrvid, Ename, util:unixtime()]) of
        {ok, _Result} ->
            true;
        {error, _Why} ->
            ?ERR("保存角色加入帮会，退出帮会日志时错误, 【Reason:~s】", [_Why]),
            false
    end.

%% 帮会操作日志
log(Gid, Gsrvid, Gname, Rid, Rsrvid, Rname, Type, Remark) ->
    Sql = <<"insert into log_guild(gid, srv_id, name, rid, rsrv_id, rname, type, remark, utime) values(~s,~s,~s,~s,~s,~s,~s,~s,~s)">>,
    case db:execute(Sql, [Gid, Gsrvid, Gname, Rid, Rsrvid, Rname, Type, Remark, util:unixtime()]) of
        {ok, _Result} ->
            true;
        {error, _Why} ->
            ?ERR("保存帮会操作日志时发生错误 [Reason:~s]", [_Why]),
            false
    end.

%% 角色帮会相关领用记录
log_claim(Rid, Rsrvid, Rname, Remark) ->
    Sql = <<"insert into log_guild_claim(rid, srv_id, name, remark, utime) values(~s, ~s, ~s, ~s, ~s)">>,
    case db:execute(Sql, [Rid, Rsrvid, Rname, Remark, util:unixtime()]) of
        {ok, _Result} ->
            true;
        {error, _Why} ->
            ?ERR("保存角色 [~w, ~s, ~s] 的帮会相关领用记录 [~s] 是发生错误，保存失败", [Rid, Rsrvid, Rname, Remark]),
            false
    end.
