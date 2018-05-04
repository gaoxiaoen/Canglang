%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(proto_12).
-export([pack/3, unpack/3]).

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

pack(srv, 1200, {MapId}) ->
    D_a_t_a = <<MapId:32/signed>>,
    {ok, <<1200:16, D_a_t_a/binary>>};
pack(cli, 1200, {}) ->
    D_a_t_a = <<>>,
    {ok, <<1200:16, D_a_t_a/binary>>};

pack(srv, 1210, {Result, Msg}) ->
    D_a_t_a = <<Result:8, (byte_size(Msg)):16, Msg/binary>>,
    {ok, <<1210:16, D_a_t_a/binary>>};
pack(cli, 1210, {MapId}) ->
    D_a_t_a = <<MapId:32/signed>>,
    {ok, <<1210:16, D_a_t_a/binary>>};

pack(srv, 1211, {}) ->
    D_a_t_a = <<>>,
    {ok, <<1211:16, D_a_t_a/binary>>};
pack(cli, 1211, {}) ->
    D_a_t_a = <<>>,
    {ok, <<1211:16, D_a_t_a/binary>>};

pack(srv, 1212, {Result, Msg}) ->
    D_a_t_a = <<Result:8, (byte_size(Msg)):16, Msg/binary>>,
    {ok, <<1212:16, D_a_t_a/binary>>};
pack(cli, 1212, {MapId}) ->
    D_a_t_a = <<MapId:32/signed>>,
    {ok, <<1212:16, D_a_t_a/binary>>};

pack(srv, 1213, {Id, Name, Dir, Speed}) ->
    D_a_t_a = <<Id:32, (byte_size(Name)):16, Name/binary, Dir:8, Speed:8>>,
    {ok, <<1213:16, D_a_t_a/binary>>};
pack(cli, 1213, {}) ->
    D_a_t_a = <<>>,
    {ok, <<1213:16, D_a_t_a/binary>>};

pack(srv, 1214, {RoleId}) ->
    D_a_t_a = <<RoleId:32>>,
    {ok, <<1214:16, D_a_t_a/binary>>};
pack(cli, 1214, {}) ->
    D_a_t_a = <<>>,
    {ok, <<1214:16, D_a_t_a/binary>>};

pack(srv, 1215, {RoleId, Ts, Speed, X, Y}) ->
    D_a_t_a = <<RoleId:32, Ts:32/signed, Speed:8, X:16, Y:16>>,
    {ok, <<1215:16, D_a_t_a/binary>>};
pack(cli, 1215, {Ts, Speed, X, Y}) ->
    D_a_t_a = <<Ts:32/signed, Speed:8, X:16, Y:16>>,
    {ok, <<1215:16, D_a_t_a/binary>>};

pack(srv, 1220, {Id, Name, Dir, Speed}) ->
    D_a_t_a = <<Id:32, (byte_size(Name)):16, Name/binary, Dir:8, Speed:8>>,
    {ok, <<1220:16, D_a_t_a/binary>>};
pack(cli, 1220, {}) ->
    D_a_t_a = <<>>,
    {ok, <<1220:16, D_a_t_a/binary>>};

pack(srv, 1221, {Id}) ->
    D_a_t_a = <<Id:32>>,
    {ok, <<1221:16, D_a_t_a/binary>>};
pack(cli, 1221, {}) ->
    D_a_t_a = <<>>,
    {ok, <<1221:16, D_a_t_a/binary>>};

pack(srv, 1222, {Id, Ts, Speed, X, Y}) ->
    D_a_t_a = <<Id:32, Ts:32/signed, Speed:8, X:16, Y:16>>,
    {ok, <<1222:16, D_a_t_a/binary>>};
pack(cli, 1222, {}) ->
    D_a_t_a = <<>>,
    {ok, <<1222:16, D_a_t_a/binary>>};

pack(srv, 1223, {Id, Msg}) ->
    D_a_t_a = <<Id:32, (byte_size(Msg)):16, Msg/binary>>,
    {ok, <<1223:16, D_a_t_a/binary>>};
pack(cli, 1223, {}) ->
    D_a_t_a = <<>>,
    {ok, <<1223:16, D_a_t_a/binary>>};

pack(_T, _Cmd, _Data) ->
    {error, {unknown_command, _T, _Cmd}}.

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

unpack(srv, 1200, _B0) ->
    {ok, {}};
unpack(cli, 1200, _B0) ->
    {MapId, _B1} = lib_proto:read_int32(_B0),
    {ok, {MapId}};

unpack(srv, 1210, _B0) ->
    {MapId, _B1} = lib_proto:read_int32(_B0),
    {ok, {MapId}};
unpack(cli, 1210, _B0) ->
    {Result, _B1} = lib_proto:read_uint8(_B0),
    {Msg, _B2} = lib_proto:read_string(_B1),
    {ok, {Result, Msg}};

unpack(srv, 1211, _B0) ->
    {ok, {}};
unpack(cli, 1211, _B0) ->
    {ok, {}};

unpack(srv, 1212, _B0) ->
    {MapId, _B1} = lib_proto:read_int32(_B0),
    {ok, {MapId}};
unpack(cli, 1212, _B0) ->
    {Result, _B1} = lib_proto:read_uint8(_B0),
    {Msg, _B2} = lib_proto:read_string(_B1),
    {ok, {Result, Msg}};

unpack(srv, 1213, _B0) ->
    {ok, {}};
unpack(cli, 1213, _B0) ->
    {Id, _B1} = lib_proto:read_uint32(_B0),
    {Name, _B2} = lib_proto:read_string(_B1),
    {Dir, _B3} = lib_proto:read_uint8(_B2),
    {Speed, _B4} = lib_proto:read_uint8(_B3),
    {ok, {Id, Name, Dir, Speed}};

unpack(srv, 1214, _B0) ->
    {ok, {}};
unpack(cli, 1214, _B0) ->
    {RoleId, _B1} = lib_proto:read_uint32(_B0),
    {ok, {RoleId}};

unpack(srv, 1215, _B0) ->
    {Ts, _B1} = lib_proto:read_int32(_B0),
    {Speed, _B2} = lib_proto:read_uint8(_B1),
    {X, _B3} = lib_proto:read_uint16(_B2),
    {Y, _B4} = lib_proto:read_uint16(_B3),
    {ok, {Ts, Speed, X, Y}};
unpack(cli, 1215, _B0) ->
    {RoleId, _B1} = lib_proto:read_uint32(_B0),
    {Ts, _B2} = lib_proto:read_int32(_B1),
    {Speed, _B3} = lib_proto:read_uint8(_B2),
    {X, _B4} = lib_proto:read_uint16(_B3),
    {Y, _B5} = lib_proto:read_uint16(_B4),
    {ok, {RoleId, Ts, Speed, X, Y}};

unpack(srv, 1220, _B0) ->
    {ok, {}};
unpack(cli, 1220, _B0) ->
    {Id, _B1} = lib_proto:read_uint32(_B0),
    {Name, _B2} = lib_proto:read_string(_B1),
    {Dir, _B3} = lib_proto:read_uint8(_B2),
    {Speed, _B4} = lib_proto:read_uint8(_B3),
    {ok, {Id, Name, Dir, Speed}};

unpack(srv, 1221, _B0) ->
    {ok, {}};
unpack(cli, 1221, _B0) ->
    {Id, _B1} = lib_proto:read_uint32(_B0),
    {ok, {Id}};

unpack(srv, 1222, _B0) ->
    {ok, {}};
unpack(cli, 1222, _B0) ->
    {Id, _B1} = lib_proto:read_uint32(_B0),
    {Ts, _B2} = lib_proto:read_int32(_B1),
    {Speed, _B3} = lib_proto:read_uint8(_B2),
    {X, _B4} = lib_proto:read_uint16(_B3),
    {Y, _B5} = lib_proto:read_uint16(_B4),
    {ok, {Id, Ts, Speed, X, Y}};

unpack(srv, 1223, _B0) ->
    {ok, {}};
unpack(cli, 1223, _B0) ->
    {Id, _B1} = lib_proto:read_uint32(_B0),
    {Msg, _B2} = lib_proto:read_string(_B1),
    {ok, {Id, Msg}};

unpack(_T, _Cmd, _Bin) ->
    {error, {unknown_command, _T, _Cmd}}.
