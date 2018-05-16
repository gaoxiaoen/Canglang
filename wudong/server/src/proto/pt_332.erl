%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-12-06 03:36:01
%%----------------------------------------------------
-module(pt_332).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"该气泡在使用中"; 
err(3) ->"气泡未激活"; 
err(4) ->"气泡已过期"; 
err(5) ->"气泡不存在"; 
err(6) ->"气泡已激活"; 
err(7) ->"激活物品数量不足"; 
err(8) ->"气泡已满级"; 
err(9) ->"升级物品数量不足"; 
err(10) ->"限时泡泡不能升级"; 
err(11) ->"没有使用该气泡"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(33201, _B0) ->
    {ok, {}};

read(33202, _B0) ->
    {P0_type, _B1} = proto:read_int8(_B0),
    {P0_id, _B2} = proto:read_uint32(_B1),
    {ok, {P0_type, P0_id}};

read(33203, _B0) ->
    {P0_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_id}};

read(33204, _B0) ->
    {P0_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_id}};

read(33206, _B0) ->
    {P0_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_id}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 气泡列表 
write(33201, {P0_cbp, P0_attribute_list, P0_bubble_list}) ->
    D_a_t_a = <<P0_cbp:32, (length(P0_attribute_list)):16, (list_to_binary([<<P1_type:32, P1_value:32/signed>> || [P1_type, P1_value] <- P0_attribute_list]))/binary, (length(P0_bubble_list)):16, (list_to_binary([<<P1_id:32, P1_time:32/signed, P1_stage:8, P1_is_use:8, P1_cbp:32, (length(P1_attribute_list)):16, (list_to_binary([<<P2_type:32, P2_value:32/signed>> || [P2_type, P2_value] <- P1_attribute_list]))/binary, (length(P1_activation_list)):16, (list_to_binary([<<P2_stage1:32, P2_state:32/signed, (length(P2_attribute_list)):16, (list_to_binary([<<P3_type:32, P3_value:32/signed>> || [P3_type, P3_value] <- P2_attribute_list]))/binary>> || [P2_stage1, P2_state, P2_attribute_list] <- P1_activation_list]))/binary>> || [P1_id, P1_time, P1_stage, P1_is_use, P1_cbp, P1_attribute_list, P1_activation_list] <- P0_bubble_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 33201:16,0:8, D_a_t_a/binary>>};


%% 使用气泡 
write(33202, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 33202:16,0:8, D_a_t_a/binary>>};


%% 激活气泡 
write(33203, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 33203:16,0:8, D_a_t_a/binary>>};


%% 升级气泡 
write(33204, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 33204:16,0:8, D_a_t_a/binary>>};


%% 激活等级加成 
write(33206, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 33206:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



