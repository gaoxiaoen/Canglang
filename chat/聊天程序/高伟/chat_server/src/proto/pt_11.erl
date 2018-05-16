-module(pt_11).
-export([read/2, write/2]).

%%
%%客户端 -> 服务端 ----------------------------
%%

%%世界聊天
read(11001, <<Bin/binary>>) ->
  {Msg, _} = pt:read_string(Bin),
  {ok, [Msg]};

%%私聊
read(11002, <<Id:32, Bin/binary>>) ->
  {Accname, Bin1} = pt:read_string(Bin),
  {Msg, _} = pt:read_string(Bin1),
  {ok, [Id, Accname, Msg]};

read(_Cmd, _R) ->
  {error, no_match}.

%%
%%服务端 -> 客户端 ------------------------------------
%%

%%世界
write(11001, [Id, Accname, Bin]) ->
  Nick1 = list_to_binary(Accname),
  Len = byte_size(Nick1),
  Bin1 = list_to_binary(Bin),
  Len1 = byte_size(Bin1),
  Data = <<Id:32, Len:16, Nick1/binary, Len1:16, Bin1/binary>>,
  {ok, pt:pack(11001, Data)};

%%私聊
write(11002, [Id, Accname, Bin]) ->
  Nick1 = list_to_binary(Accname),
  Len = byte_size(Nick1),
  Bin1 = list_to_binary(Bin),
  Len1 = byte_size(Bin1),
  Data = <<Id:32, Len:16, Nick1/binary, Len1:16, Bin1/binary>>,
  {ok, pt:pack(11002, Data)};

write(_Cmd, _R) ->
  {ok, pt:pack(0, <<>>)}.
