-module(pt).
-export([
  read_string/1,
  pack/2
]).

%%读取字符串
read_string(Bin) ->
  case Bin of
    <<Len:16, Bin1/binary>> ->
      case Bin1 of
        <<Str:Len/binary-unit:8, Rest/binary>> ->
          {binary_to_list(Str), Rest};
        _R1 ->
          {[],<<>>}
      end;
    _R1 ->
      {[],<<>>}
  end.

%% 打包信息，添加消息头
pack(Cmd, Data) ->
  L = byte_size(Data) + 4,
  <<L:16, Cmd:16, Data/binary>>.