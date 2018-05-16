%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2018-04-08 17:02:36
%%----------------------------------------------------
-module(pt_446).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"元宝不足"; 
err(3) ->"道具消耗不足"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(44601, _B0) ->
    {ok, {}};

read(44602, _B0) ->
    {P0_id, _B1} = proto:read_uint32(_B0),
    {P0_pkey, _B2} = proto:read_uint32(_B1),
    {P0_is_auto, _B3} = proto:read_uint8(_B2),
    {ok, {P0_id, P0_pkey, P0_is_auto}};

read(44603, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% vip表情信息 
write(44601, {P0_vip_face_list}) ->
    D_a_t_a = <<(length(P0_vip_face_list)):16, (list_to_binary([<<P1_vip:8, P1_expire_time:32>> || [P1_vip, P1_expire_time] <- P0_vip_face_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44601:16,0:8, D_a_t_a/binary>>};


%% 使用魔法表情 
write(44602, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44602:16,0:8, D_a_t_a/binary>>};


%% 魔法表情效果 
write(44603, {P0_id}) ->
    D_a_t_a = <<P0_id:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44603:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



