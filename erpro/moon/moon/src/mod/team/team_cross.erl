%% **********************************************************
%% 跨服队伍相关的处理接口
%% @author wpf(wpf0208@jieyou.cn)
%% <div>
%%  1、支持了目前节点间通过中央服转发消息的机制
%% </div>
%% **********************************************************
-module(team_cross).
-export([
        send/2
        ,call/2
        ,catch_call/2
        ,pack_send/3
        ,create_cross_team/1   %% TODO: 目前中央服机制不支持，暂时不可以用
    ]).

-include("common.hrl").
-include("role.hrl").
-include("team.hrl").

%% @spec send(Pid, Msg) -> ok
%% Pid = pid()
%% Msg = term()
%% @doc 给进程发送消息
send(Pid, Msg) ->
    case node(Pid) =:= node() of
        true ->
            Pid ! Msg;
        false ->
            center:cast(erlang, send, [Pid, Msg])
    end,
    ok.

%% @spec call(Pid, Msg) -> Msg | {badrpc, Reason}
%% Pid = pid()
%% Msg = term()
%% @doc 给gen_server进程发送同步请求
call(Pid, Msg) ->
    case node(Pid) =:= node() of
        true ->
            ?CALL(Pid, Msg);
        false ->
            center:call(team_cross, catch_call, [Pid, Msg])
    end.

catch_call(Pid, Msg) ->
    ?CALL(Pid, Msg).

%% @spec pack_send(Pid, Cmd, Msg) -> Msg | {badrpc, Reason}
%% Pid = pid()
%% Cmd = integer()
%% Msg = term()
%% @doc 给gen_server进程发送同步请求
pack_send(Pid, Cmd, Msg) ->
    case node(Pid) =:= node() of
        true ->
            sys_conn:pack_send(Pid, Cmd, Msg);
        false ->
            center:cast(sys_conn, pack_send, [Pid, Cmd, Msg])
    end.

%% @spec create_cross_team(IdList) -> {ok, TeamPid} | {false, Msg}
%% IdList = [{Rid, SrvId} | ...] 队长ID放最前面
%% TeamPid = pid()
%% @doc 创建跨服队伍，队伍进程创建在中央服
%% <div> 适合以下情况：
%%  1、由中央服节点创建队伍
%%  2、中央服和节点服无差别查询玩家
%% </div>
create_cross_team([]) ->
    {false, ?L(<<"操作失败">>)};
create_cross_team([RoleId = {_Id, _SrvId} | T]) ->
    case c_proxy:role_lookup(by_id, RoleId, to_team_member) of
        {ok, _Node, Member} ->
            Team = #team{ride = ?ride_no, leader = Member#team_member{mode = ?MODE_NORMAL}},
            TeamPid = team_mgr:create_team(Team),
            remote_check_join(T, TeamPid),
            {ok, TeamPid};
        _ -> {false, ?L(<<"网络异常，操作失败">>)}
    end.

%% -------------------------------------------------------------------------
%% 内部函数
%% -------------------------------------------------------------------------

%% 远程检测玩家加入跨服队伍
remote_check_join([], _TeamPid) -> ok;
remote_check_join([RoleId = {_Id, _SrvId} | T], TeamPid) ->
    case c_proxy:role_lookup(by_id, RoleId, #role.pid) of
        {ok, _Node, RolePid} when is_pid(RolePid) ->
            role:apply(async, RolePid, {fun do_remote_check_join/2, [TeamPid]});
        _ ->
            ?INFO("角色[ID:~w, SrvID:~s]远程检测转换数据失败，可能掉线或网络异常", [_Id, _SrvId])
    end,
    remote_check_join(T, TeamPid).
%% 异步回调加入跨服队伍
do_remote_check_join(Role, TeamPid) when is_pid(TeamPid) ->
    case team:join(TeamPid, Role) of
        {ok, NewRole} ->
            {ok, NewRole};
        _ -> {ok}
    end.
