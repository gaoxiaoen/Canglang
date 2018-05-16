%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-12-06 03:35:50
%%----------------------------------------------------
-module(pt_330).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"该时装在使用中"; 
err(3) ->"时装未激活"; 
err(4) ->"时装已过期"; 
err(5) ->"时装不存在"; 
err(6) ->"时装已激活"; 
err(7) ->"激活物品数量不足"; 
err(8) ->"时装已满级"; 
err(9) ->"升级物品数量不足"; 
err(10) ->"限时时装不能升级"; 
err(11) ->"没有穿该时装"; 
err(12) ->"时装数量不足"; 
err(13) ->"对方不是您好友"; 
err(14) ->"对方不在线"; 
err(15) ->"对方等级不足"; 
err(16) ->"绑定时装不能赠送"; 
err(17) ->"当前暂无可激活阶段属性"; 
err(18) ->"已经激活"; 
err(19) ->"前暂无可激活阶段属性"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(33001, _B0) ->
    {ok, {}};

read(33002, _B0) ->
    {P0_type, _B1} = proto:read_int8(_B0),
    {P0_id, _B2} = proto:read_uint32(_B1),
    {ok, {P0_type, P0_id}};

read(33003, _B0) ->
    {P0_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_id}};

read(33004, _B0) ->
    {P0_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_id}};

read(33005, _B0) ->
    {ok, {}};

read(33006, _B0) ->
    {ok, {}};

read(33007, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {P0_gkey, _B2} = proto:read_key(_B1),
    {P0_content, _B3} = proto:read_string(_B2),
    {ok, {P0_pkey, P0_gkey, P0_content}};

read(33008, _B0) ->
    {ok, {}};

read(33009, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_pkey}};

read(33010, _B0) ->
    {ok, {}};

read(33011, _B0) ->
    {P0_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_id}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 时装列表 
write(33001, {P0_cbp, P0_attribute_list, P0_fashion_list}) ->
    D_a_t_a = <<P0_cbp:32, (length(P0_attribute_list)):16, (list_to_binary([<<P1_type:32, P1_value:32/signed>> || [P1_type, P1_value] <- P0_attribute_list]))/binary, (length(P0_fashion_list)):16, (list_to_binary([<<P1_id:32, P1_time:32/signed, P1_stage:8, P1_is_use:8, P1_cbp:32, (length(P1_attribute_list)):16, (list_to_binary([<<P2_type:32, P2_value:32/signed>> || [P2_type, P2_value] <- P1_attribute_list]))/binary, (length(P1_activation_list)):16, (list_to_binary([<<P2_stage1:32, P2_state:32/signed, (length(P2_attribute_list)):16, (list_to_binary([<<P3_type:32, P3_value:32/signed>> || [P3_type, P3_value] <- P2_attribute_list]))/binary>> || [P2_stage1, P2_state, P2_attribute_list] <- P1_activation_list]))/binary>> || [P1_id, P1_time, P1_stage, P1_is_use, P1_cbp, P1_attribute_list, P1_activation_list] <- P0_fashion_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 33001:16,0:8, D_a_t_a/binary>>};


%% 穿戴时装 
write(33002, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 33002:16,0:8, D_a_t_a/binary>>};


%% 激活时装 
write(33003, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 33003:16,0:8, D_a_t_a/binary>>};


%% 升级时装 
write(33004, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 33004:16,0:8, D_a_t_a/binary>>};


%% 时装激活通知 
write(33005, {P0_id}) ->
    D_a_t_a = <<P0_id:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 33005:16,0:8, D_a_t_a/binary>>};


%% 获取赠送列表 
write(33006, {P0_relations}) ->
    D_a_t_a = <<(length(P0_relations)):16, (list_to_binary([<<P1_pkey:32, (proto:write_string(P1_nickname))/binary, P1_career:8, P1_realm:8, P1_lv:16, P1_qinmidu:16, P1_sex:8, P1_vip_lv:16, P1_cbp:32, P1_off_line_time:32, (proto:write_string(P1_avatar))/binary, (proto:write_string(P1_guild_name))/binary, P1_fashion_decoration_id:32/signed>> || [P1_pkey, P1_nickname, P1_career, P1_realm, P1_lv, P1_qinmidu, P1_sex, P1_vip_lv, P1_cbp, P1_off_line_time, P1_avatar, P1_guild_name, P1_fashion_decoration_id] <- P0_relations]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 33006:16,0:8, D_a_t_a/binary>>};


%% 时装赠送 
write(33007, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 33007:16,0:8, D_a_t_a/binary>>};


%% 收到时装赠送 
write(33008, {P0_pkey, P0_nickname, P0_sex, P0_avatar, P0_goods_id, P0_content}) ->
    D_a_t_a = <<P0_pkey:32, (proto:write_string(P0_nickname))/binary, P0_sex:8/signed, (proto:write_string(P0_avatar))/binary, P0_goods_id:32, (proto:write_string(P0_content))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 33008:16,0:8, D_a_t_a/binary>>};


%% 感谢赠送 
write(33009, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 33009:16,0:8, D_a_t_a/binary>>};


%% 赠送被感谢 
write(33010, {P0_pkey, P0_sn_cur, P0_nickname, P0_career, P0_realm, P0_lv, P0_qinmidu, P0_sex, P0_vip_lv, P0_cbp, P0_off_line_time, P0_avatar, P0_guild_name}) ->
    D_a_t_a = <<P0_pkey:32, P0_sn_cur:32, (proto:write_string(P0_nickname))/binary, P0_career:8, P0_realm:8, P0_lv:16, P0_qinmidu:16, P0_sex:8, P0_vip_lv:16, P0_cbp:32, P0_off_line_time:32, (proto:write_string(P0_avatar))/binary, (proto:write_string(P0_guild_name))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 33010:16,0:8, D_a_t_a/binary>>};


%% 激活等级加成 
write(33011, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 33011:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



