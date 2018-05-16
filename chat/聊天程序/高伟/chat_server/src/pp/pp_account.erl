%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 五月 2018 10:55
%%%-------------------------------------------------------------------
-module(pp_account).
-export([handle/3]).
-include("common.hrl").
-include("record.hrl").

%%登陆验证
handle(10000, Socket, Data) ->
  [Accid, Accname] = Data,
  case lib_account:login_role(Accid, Accname, Socket) of
    {true, Pid} ->
      %%创建角色成功
      {ok, BinData} = pt_10:write(10003, 1),
      lib_send:send_one(Socket, BinData),
      {ok, Pid};
    _ ->
      %%角色创建失败
      {ok, BinData} = pt_10:write(10003, 0),
      lib_send:send_one(Socket, BinData),
      {error, 0}
  end;

%%退出登陆
handle(10001, Status, logout) ->
  gen_server:cast(Status#player_status.pid, 'LOGOUT'),
  {ok, BinData} = pt_10:write(10001, []),
  lib_send:send_one(Status#player_status.socket, BinData);

%% 获取角色列表
handle(10002, Socket, Accname)
  when is_list(Accname) ->
  L = lib_account:get_role_list(Accname),
  {ok, BinData} = pt_10:write(10002, L),
  lib_send:send_one(Socket, BinData);

%%心跳包
handle(10006, Socket, _R) ->
  {ok, BinData} = pt_10:write(10006, []),
  lib_send:send_one(Socket, BinData);

handle(_Cmd, _Status, _Data) ->
  ?DEBUG("handle_account no match", []),
  {error, "handle_account no match"}.
