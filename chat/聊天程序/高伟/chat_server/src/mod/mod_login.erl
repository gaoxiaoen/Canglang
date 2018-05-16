%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 五月 2018 10:55
%%%-------------------------------------------------------------------
-module(mod_login).
-include("common.hrl").
-include("record.hrl").

%% API
-export([login/3, logout/1, fix_pid/1, stop_all/0]).

%%用户登陆
login(Player, check, Socket)  ->
  Pid1 = none, %%暂时默认
  Pid2 = fix_pid(Pid1),
  %% 检查用户登陆和状态
  Condition = check_player(Pid2,
    [
      fun is_player_online/1,
      fun is_offline/1
    ]),
  {Pid3, _} = login(Pid2, Condition, Socket),
  login_success(Player, Pid3, Socket);

%%登陆检查入口
%%Data:登陆验证数据
%%Arg:tcp的Socket进程,socket ID
login(start, [Id, Accname], Socket) ->
  Player = [Id, Accname],
  login(Player, check, Socket);

%%重新登陆
login(Pid, player_online, Socket) ->
  %通知客户端账户在别处登陆
  {ok, BinData} = pt_10:write(10007, []),
  gen_server:cast(Pid, {'SEND',BinData}),
  logout(Pid),
  login(Pid, player_offline, Socket);

%% 开始一个进程
login(_Pid, player_offline, _Socket) ->
  {ok, Pid} = mod_player:start(),
  {Pid, {ok, Pid}};

login(_Player, _S, _Arg) ->
  {error, fail}.

%%检查用户
%%Player：用户信息
%%Args：登陆参数
%%[Guard|Rest]:函数
check_player(Player, [Guard|Rest]) ->
  case Guard(Player) of
    {true, Condition} ->
      Condition;
    _ ->
      check_player(Player, Rest)
  end;

check_player(_Player, []) ->
  unknown_error.

%%当前已经在线
is_player_online(Pid) ->
  PlayerAlive = Pid /= none,
  { PlayerAlive, player_online}.

%%检查不在线
is_offline(Pid) ->
  PlayerDown = Pid == none,
  { PlayerDown, player_offline}.

%%检查进程是否存活
%%Pid：进程ID
fix_pid(Pid)
  when is_pid(Pid) ->
  case is_process_alive(Pid) of
    true ->
      Pid;
    _ ->
      none
  end;

fix_pid(Pid) ->
  Pid.

%% 把所有在线踢出去
stop_all() ->
  L = ets:tab2list(?ETS_ONLINE),
  do_stop_all(L).

%% 让所有角色自动退出
do_stop_all([]) ->
  ok;
do_stop_all([H | T]) ->
  logout(H#ets_online.pid),
  do_stop_all(T).


%%退出登陆
logout(Pid) when is_pid(Pid) ->
  mod_player:stop(Pid),
  ok;

logout(Status) ->
  %%删除ETS记录
  ets:delete(?ETS_ONLINE, Status#player_status.accid),
  %关闭socket连接
  gen_tcp:close(Status#player_status.socket),
  ok.

%% 登陆成功
login_success(Player, Pid, Socket) ->
  [Accid, Accname] = Player,

  %% 打开广播信息进程
  Sid = lists:map(fun(_)-> spawn_link(fun()->send_msg(Socket) end) end,lists:duplicate(?SEND_MSG, 1)),

  %% 设置mod_player 状态
  PlayerStatus = #player_status {
    accid = Accid,
    accname = Accname,
    sid = Sid,
    pid = Pid
  },
  gen_server:cast(Pid, {'SET_PLAYER', PlayerStatus}),

  %更新ETS_ONLINE在线表
  ets:insert(?ETS_ONLINE, #ets_online{
    id = PlayerStatus#player_status.accid,
    accname = PlayerStatus#player_status.accname,
    pid = PlayerStatus#player_status.pid,
    sid = PlayerStatus#player_status.sid
  }),
  {true, Pid}.



%%发消息
send_msg(Socket) ->
  receive
    {send, Bin} ->
      gen_tcp:send(Socket, Bin),
      send_msg(Socket)
  end.
