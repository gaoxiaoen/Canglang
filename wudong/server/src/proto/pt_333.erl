%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-12-06 03:35:55
%%----------------------------------------------------
-module(pt_333).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"该头饰在使用中"; 
err(3) ->"头饰未激活"; 
err(4) ->"头饰已过期"; 
err(5) ->"头饰不存在"; 
err(6) ->"头饰已激活"; 
err(7) ->"激活物品数量不足"; 
err(8) ->"头饰已满级"; 
err(9) ->"升级物品数量不足"; 
err(10) ->"限时头饰不能升级"; 
err(11) ->"没有使用该头饰"; 
err(12) ->"改头饰不能激活"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(33301, _B0) ->
    {ok, {}};

read(33302, _B0) ->
    {P0_type, _B1} = proto:read_int8(_B0),
    {P0_id, _B2} = proto:read_uint32(_B1),
    {ok, {P0_type, P0_id}};

read(33303, _B0) ->
    {P0_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_id}};

read(33304, _B0) ->
    {P0_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_id}};

read(33305, _B0) ->
    {ok, {}};

read(33306, _B0) ->
    {P0_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_id}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 头饰列表 
write(33301, {P0_cbp, P0_attribute_list, P0_footprint_list}) ->
    D_a_t_a = <<P0_cbp:32, (length(P0_attribute_list)):16, (list_to_binary([<<P1_type:32, P1_value:32/signed>> || [P1_type, P1_value] <- P0_attribute_list]))/binary, (length(P0_footprint_list)):16, (list_to_binary([<<P1_id:32, P1_time:32/signed, P1_stage:8, P1_is_use:8, P1_cbp:32, (length(P1_attribute_list)):16, (list_to_binary([<<P2_type:32, P2_value:32/signed>> || [P2_type, P2_value] <- P1_attribute_list]))/binary, (length(P1_activation_list)):16, (list_to_binary([<<P2_stage1:32, P2_state:32/signed, (length(P2_attribute_list)):16, (list_to_binary([<<P3_type:32, P3_value:32/signed>> || [P3_type, P3_value] <- P2_attribute_list]))/binary>> || [P2_stage1, P2_state, P2_attribute_list] <- P1_activation_list]))/binary>> || [P1_id, P1_time, P1_stage, P1_is_use, P1_cbp, P1_attribute_list, P1_activation_list] <- P0_footprint_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 33301:16,0:8, D_a_t_a/binary>>};


%% 穿戴头饰 
write(33302, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 33302:16,0:8, D_a_t_a/binary>>};


%% 激活头饰 
write(33303, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 33303:16,0:8, D_a_t_a/binary>>};


%% 升级头饰 
write(33304, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 33304:16,0:8, D_a_t_a/binary>>};


%% 头饰激活通知 
write(33305, {P0_id}) ->
    D_a_t_a = <<P0_id:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 33305:16,0:8, D_a_t_a/binary>>};


%% 激活等级加成 
write(33306, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 33306:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



