%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 五月 2018 10:55
%%%-------------------------------------------------------------------
-module(mod_player).
-behaviour(gen_server).
-export([start/0, stop/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("common.hrl").
-include("record.hrl").

%%开始
start() ->
  gen_server:start(?MODULE, [], []).

init([]) ->
  process_flag(priority, max),
  {ok, none}.

%%停止本进程
stop(Pid)
  when is_pid(Pid) ->
  gen_server:cast(Pid, stop).

terminate(_Reason, Status) ->
  %%角色下线
  spawn(fun() -> mod_login:logout(Status) end),
  ok.

%%停止进程
handle_cast(stop, Status) ->
  {stop, normal, Status};

%%发信息
%handle_cast({'SEND',Bin}, Status) ->
%    prim_inet:send(Status#player_status.socket, Bin),
%    {noreply, Status};

%%设置用户信息
handle_cast({'SET_PLAYER', NewStatus}, _Status) ->
  {noreply, NewStatus};

% 指定角色执行一个操作(函数形式)
handle_cast({cast, {M, F, A}}, Status) ->
  case erlang:apply(M, F, [Status|A]) of
    {ok, Status1} ->
      save_online(Status1),
      {noreply, Status1};
    _ ->
      {noreply, Status}
  end;

handle_cast(_Event, Status) ->
  {noreply, Status}.

%%处理socket协议
%%cmd：命令号
%%data：协议体
handle_call({'SOCKET_EVENT', Cmd, Bin}, _From, Status) ->
  case routing(Cmd, Status, Bin) of
    {ok, Status1} ->
      save_online(Status1),
      {reply, ok, Status1};
    _R ->
      {reply, ok, Status}
  end;

%%获取用户信息
handle_call('PLAYER', _from, Status) ->
  {reply, Status, Status};


handle_call(_Event, _From, Status) ->
  {reply, ok, Status}.

handle_info(_Info, Status) ->
  {noreply, Status}.

code_change(_oldvsn, Status, _extra) ->
  {ok, Status}.

%%
%% ------------------------私有函数------------------------
%%

%% 路由
%%cmd:命令号
%%Socket:socket id
%%data:消息体
routing(Cmd, Status, Bin) ->
  %%取前面二位区分功能类型
  [H1, H2, _, _, _] = integer_to_list(Cmd),
  case [H1, H2] of
    %%基础功能处理
    "10" -> pp_base:handle(Cmd, Status, Bin);
    "11" -> pp_chat:handle(Cmd, Status, Bin);
    %%错误处理
    _ ->
      ?ERR("[~w]路由失败.", [Cmd]),
      {error, "Routing failure"}
  end.

%% 同步更新ETS中的角色数据
save_online(Status) ->
  ets:insert(?ETS_ONLINE, #ets_online{
    id = Status#player_status.accid,
    accname = Status#player_status.accname,
    pid = Status#player_status.pid,
    sid = Status#player_status.sid
  }).

