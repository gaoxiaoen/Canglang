%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 五月 2018 10:55
%%%-------------------------------------------------------------------
-module(lib_send).
-include("common.hrl").
-include("record.hrl").

%% API
-export([
  send_one/2,
  send_to_all/1
]).


%%发送信息给指定socket角色.
%%Pid:逻辑ID
%%Bin:二进制数据.
send_one(S, Bin) ->
  gen_tcp:send(S, Bin).

%%发送信息给指定sid角色.
%%Sid:逻辑进程ID
%%Bin:二进制数据.
send_to_sid(S, Bin) ->
  rand_to_process(S) ! {send, Bin}.


%%随机挑出一个进程
rand_to_process(S) ->
  {_,_,R} = erlang:now(),
  Rand = R div 1000 rem ?SEND_MSG + 1,
  lists:nth(Rand, S).

%% 发送信息到世界
send_to_all(Bin) ->
  send_to_local_all(Bin).

send_to_local_all(Bin) ->
  L = ets:match(?ETS_ONLINE, #ets_online{sid='$1', _='_'}),
  do_broadcast(L, Bin).

%% 对列表中的所有socket进行广播
do_broadcast(L, Bin) ->
  F = fun([S]) ->
    send_to_sid(S, Bin)
      end,
  [F(D) || D <- L].