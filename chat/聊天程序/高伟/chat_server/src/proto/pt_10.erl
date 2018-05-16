-module(pt_10).
-export([read/2, write/2]).

%%
%%客户端 -> 服务端 ----------------------------
%%

%%登陆
read(10000, <<Accid:32, Bin/binary>>) ->
  {Accname, _} = pt:read_string(Bin),
  {ok, login, [Accid, Accname]};

%%退出
read(10001, _) ->
  {ok, logout};

%%读取列表
read(10002, _R) ->
  {ok, lists, []};

%%心跳包
read(10006, _) ->
  {ok, heartbeat};

read(_Cmd, _R) ->
  {error, no_match}.

%%
%%服务端 -> 客户端 ------------------------------------
%%

%%登陆返回
write(10000, Code) ->
  Data = <<Code:16>>,
  {ok, pt:pack(10000, Data)};

%%登陆退出
write(10001, _) ->
  Data = <<>>,
  {ok, pt:pack(10001, Data)};

%%心跳包
write(10006, _) ->
  Data = <<>>,
  {ok, pt:pack(10006, Data)};

write(_Cmd, _R) ->
  {ok, pt:pack(0, <<>>)}.