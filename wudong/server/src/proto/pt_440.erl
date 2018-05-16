%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-12-07 05:11:06
%%----------------------------------------------------
-module(pt_440).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"该称号在使用中"; 
err(3) ->"称号未激活"; 
err(4) ->"称号已过期"; 
err(5) ->"称号不存在"; 
err(6) ->"称号已激活"; 
err(7) ->"激活物品数量不足"; 
err(8) ->"称号已满级"; 
err(9) ->"升级物品数量不足"; 
err(10) ->"唯一称号不能激活"; 
err(11) ->"唯一称号不能升级"; 
err(12) ->"限时称号不能升级 "; 
err(13) ->"只能穿戴三个称号,请卸下其他再穿戴"; 
err(14) ->"特殊称号不可操作"; 
err(15) ->"前暂无可激活阶段属性"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(44001, _B0) ->
    {ok, {}};

read(44002, _B0) ->
    {P0_type, _B1} = proto:read_int8(_B0),
    {P0_id, _B2} = proto:read_uint32(_B1),
    {ok, {P0_type, P0_id}};

read(44003, _B0) ->
    {P0_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_id}};

read(44004, _B0) ->
    {P0_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_id}};

read(44005, _B0) ->
    {P0_goods_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_goods_id}};

read(44007, _B0) ->
    {P0_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_id}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 称号列表 
write(44001, {P0_cbp, P0_attribute_list, P0_designation_list}) ->
    D_a_t_a = <<P0_cbp:32, (length(P0_attribute_list)):16, (list_to_binary([<<P1_type:32, P1_value:32/signed>> || [P1_type, P1_value] <- P0_attribute_list]))/binary, (length(P0_designation_list)):16, (list_to_binary([<<P1_id:32, P1_time:32/signed, P1_stage:8, P1_is_use:8, P1_cbp:32, (length(P1_attribute_list)):16, (list_to_binary([<<P2_type:32, P2_value:32/signed>> || [P2_type, P2_value] <- P1_attribute_list]))/binary, (length(P1_activation_list)):16, (list_to_binary([<<P2_stage1:32, P2_state:32/signed, (length(P2_attribute_list)):16, (list_to_binary([<<P3_type:32, P3_value:32/signed>> || [P3_type, P3_value] <- P2_attribute_list]))/binary>> || [P2_stage1, P2_state, P2_attribute_list] <- P1_activation_list]))/binary>> || [P1_id, P1_time, P1_stage, P1_is_use, P1_cbp, P1_attribute_list, P1_activation_list] <- P0_designation_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44001:16,0:8, D_a_t_a/binary>>};


%% 穿戴称号 
write(44002, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44002:16,0:8, D_a_t_a/binary>>};


%% 激活称号 
write(44003, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44003:16,0:8, D_a_t_a/binary>>};


%% 升级称号 
write(44004, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44004:16,0:8, D_a_t_a/binary>>};


%% 激活称号(不替换) 
write(44005, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44005:16,0:8, D_a_t_a/binary>>};


%% 激活等级加成 
write(44007, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44007:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



