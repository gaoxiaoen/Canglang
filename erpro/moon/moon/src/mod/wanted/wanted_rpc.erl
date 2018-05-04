%%----------------------------------------------------
%% 悬赏Boss相关远程调用
%%
%% @author mobin
%%----------------------------------------------------
-module(wanted_rpc).
-export([handle/3]).
-include("common.hrl").
-include("wanted.hrl").
-include("role.hrl").
-include("link.hrl").
-include("pos.hrl").

handle(15000, {}, _Role = #role{id = Rid, link = #link{conn_pid = ConnPid}}) ->
    wanted_mgr:get_info(Rid, ConnPid),
    {ok};

handle(15001, {_}, Role = #role{event = ?event_wanted}) ->
    notice:alert(error, Role, ?MSGID(<<"当前状态下不能进入悬赏海盗区域">>)),
    {ok};
handle(15001, {Id}, _Role = #role{id = Rid, pid = RolePid, link = #link{conn_pid = ConnPid}}) ->
    wanted_mgr:enter(Id, Rid, RolePid, ConnPid),
    {ok};

handle(15002, {Id}, _Role = #role{id = Rid, pid = Pid, link = #link{conn_pid = ConnPid}}) ->
    wanted_mgr:steal(Id, Rid, ConnPid, Pid),
    {ok};

handle(15003, {}, Role = #role{event = ?event_wanted}) ->
    wanted_mgr:combat_start(Role),
    {ok};

handle(15004, {}, #role{id = Rid, pid = Pid, lev = Lev, event = ?event_wanted}) ->
    wanted_mgr:exit(Rid, Pid, Lev),
    {ok};

handle(15005, {}, #role{link = #link{conn_pid = ConnPid}}) ->
    wanted_mgr:get_status(ConnPid),
    {ok};

handle(_Cmd, _Data, _Role) ->
    ?ERR("接到错误指令: ~w, ~w, ~w, ~n", [_Cmd, _Data, _Role]),
    {ok}.
