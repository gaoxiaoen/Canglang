%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-06-28 11:37:08
%%----------------------------------------------------
-module(pt_490).
-export([read/2, write/2]).

-include("common.hrl").
-include("notice.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"没有喇叭"; 
err(3) ->"内容不合法"; 
err(4) ->"元宝不足以支付"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(49000, _B0) ->
    {ok, {}};

read(49001, _B0) ->
    {ok, {}};

read(49010, _B0) ->
    {P0_id, _B1} = proto:read_uint8(_B0),
    {P0_content, _B2} = proto:read_string(_B1),
    {P0_isAuto, _B3} = proto:read_uint8(_B2),
    {ok, {P0_id, P0_content, P0_isAuto}};

read(49011, _B0) ->
    {ok, {}};

read(49012, _B0) ->
    {ok, {}};

read(49013, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 获取广播列表  玩家登陆时请求/广播有更新时服务端会推过来 
write(49000, {P0_broadcast_list}) ->
    D_a_t_a = zlib:compress(<<(length(P0_broadcast_list)):16, (list_to_binary([<<P1_id:32, (proto:write_string(P1_content))/binary, (length(P1_showpos)):16, (list_to_binary([<<P2_pos:8>> || P2_pos <- P1_showpos]))/binary>> || [P1_id, P1_content, P1_showpos] <- P0_broadcast_list]))/binary>>),
    {ok, <<(byte_size(D_a_t_a) + 7):32, 49000:16,1:8, D_a_t_a/binary>>};


%% 播放广播 服务端推 
write(49001, {P0_broadcast_list}) ->
    D_a_t_a = <<(length(P0_broadcast_list)):16, (list_to_binary([<<P1_id:32, (proto:write_string(P1_content))/binary, (length(P1_showpos)):16, (list_to_binary([<<P2_pos:8>> || P2_pos <- P1_showpos]))/binary>> || [P1_id, P1_content, P1_showpos] <- P0_broadcast_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 49001:16,0:8, D_a_t_a/binary>>};


%% 使用喇叭 
write(49010, {P0_id}) ->
    D_a_t_a = <<P0_id:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 49010:16,0:8, D_a_t_a/binary>>};


%% 喇叭 服务端推，客户端播放 
write(49011, {P0_id, P0_content, P0_sn, P0_pkey, P0_nickname, P0_title, P0_vip, P0_time, P0_career}) ->
    D_a_t_a = <<P0_id:8, (proto:write_string(P0_content))/binary, P0_sn:32/signed, P0_pkey:32, (proto:write_string(P0_nickname))/binary, P0_title:16, P0_vip:8, P0_time:32, P0_career:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 49011:16,0:8, D_a_t_a/binary>>};


%% 获取当前发喇叭状态信息 
write(49012, {P0_num}) ->
    D_a_t_a = <<P0_num:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 49012:16,0:8, D_a_t_a/binary>>};


%% 指定位置播放 
write(49013, {P0_type, P0_content}) ->
    D_a_t_a = <<P0_type:8/signed, (proto:write_string(P0_content))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 49013:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



