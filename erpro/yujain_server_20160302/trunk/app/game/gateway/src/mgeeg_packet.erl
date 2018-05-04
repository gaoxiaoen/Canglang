%%%-------------------------------------------------------------------
%%% File        :mgeeg_packet.erl
%%%-------------------------------------------------------------------

-module(mgeeg_packet).

%%
%% Include files
%%
-include("mgeeg.hrl").

%%
%% Exported Functions
%%

-export([ 
         unpack/1,
         packet/2,
         send/2,
         send/4,
         get_method/1
        ]).

%% 发送二进制数据
-spec send(Socket,Bin)-> true | ignore when Socket :: port(), Bin :: <<>>.
send(Socket,Bin)->
    case erlang:is_port(Socket) of
        true -> catch erlang:port_command(Socket, Bin, [force]);
        false -> ignore
    end.
%% 发送数据
-spec 
send(Socket, Module, Method, DataRecord)-> true | ignore when 
    Socket :: port(),
    Module :: integer(),
    Method :: integer(),
    DataRecord :: tuple().
send(Socket, _Module, Method, DataRecord) ->
    Bin = packet(Method, DataRecord),
    send(Socket, Bin).

%% 根据协议生成二进制协议
%% erlang tuple to bin
-spec 
packet(Method,Record) -> Bin when 
    Method :: integer(),
    Record :: tuple(),
    Bin :: <<>>.
packet(Method,Record) ->
    Bin = proto_pack:pack_toc(element(1, Record), Record),
    case erlang:byte_size(Bin) > 2048 of
        true ->
            C = zlib:compress(Bin),
            Data = <<1:8, Method:32, C/binary>>;
        false ->
            Data = <<0:8, Method:32, Bin/binary>>
    end,
    Len = erlang:byte_size(Data),
    PacketData = <<Len:32,Data/binary>>,
    RoleId = mgeeg_tcp_client:get_role_id(),
    mgeeg_packet_logger:statistic(RoleId, Method, erlang:byte_size(PacketData)),
    PacketData.
%% 根据协议二进制数据解包成记录
%% bin to tuple
-spec
unpack(Bin) -> {ModuleId,MethodId,Record} when
    Bin :: <<>>,
    ModuleId :: integer(),
    MethodId :: integer(),
    Record :: tuple().
unpack(<<MethodId:32, Bin/binary>>) ->
    Tos = proto_unpack:unpack_tos(MethodId, Bin),
    ModuleId = MethodId div 100,
    {ModuleId, MethodId, Tos}.

%% 根据记录名称获取协议方法id
%% 0 即无此方法
-spec get_method(RecordName) -> undefined | integer() when RecordName :: atom().
get_method(RecordName) when erlang:is_atom(RecordName) ->
    mm_map:toc(RecordName);
get_method(_RecordName) -> undefined.
