%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-08-25 14:21:44
%%----------------------------------------------------
-module(pt_190).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"背包空间不够，不能提取附件"; 
err(3) ->"充值邮件过期自动删除"; 
err(4) ->"邮件有附件未提取"; 
err(5) ->"没有附件可提取"; 
err(6) ->"没有邮件可删除"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(19001, _B0) ->
    {ok, {}};

read(19002, _B0) ->
    {P0_mkey, _B1} = proto:read_key(_B0),
    {ok, {P0_mkey}};

read(19003, _B0) ->
    {P0_mkey, _B1} = proto:read_key(_B0),
    {ok, {P0_mkey}};

read(19004, _B0) ->
    {P0_mkey, _B1} = proto:read_key(_B0),
    {ok, {P0_mkey}};

read(19005, _B0) ->
    {ok, {}};

read(19006, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 获取邮件列表 
write(19001, {P0_maillist}) ->
    D_a_t_a = <<(length(P0_maillist)):16, (list_to_binary([<<(proto:write_string(P1_mkey))/binary, P1_type:8, (proto:write_string(P1_title))/binary, P1_time:32, P1_state:8/signed, P1_attachment:8>> || [P1_mkey, P1_type, P1_title, P1_time, P1_state, P1_attachment] <- P0_maillist]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 19001:16,0:8, D_a_t_a/binary>>};


%% 获取邮件内容 
write(19002, {P0_mkey, P0_type, P0_title, P0_content, P0_time, P0_overtime, P0_goodslist}) ->
    D_a_t_a = <<(proto:write_string(P0_mkey))/binary, P0_type:8, (proto:write_string(P0_title))/binary, (proto:write_string(P0_content))/binary, P0_time:32, P0_overtime:32, (length(P0_goodslist)):16, (list_to_binary([<<(proto:write_string(P1_gkey))/binary, P1_goodstype:32, P1_num:32, P1_bind:8, P1_color:8, P1_sex:8, P1_power:32/signed, (length(P1_fix_attr)):16, (list_to_binary([<<P2_attr_type:8, P2_value:16>> || [P2_attr_type, P2_value] <- P1_fix_attr]))/binary, (length(P1_random_attr)):16, (list_to_binary([<<P2_attr_type:8, P2_value:16>> || [P2_attr_type, P2_value] <- P1_random_attr]))/binary>> || [P1_gkey, P1_goodstype, P1_num, P1_bind, P1_color, P1_sex, P1_power, P1_fix_attr, P1_random_attr] <- P0_goodslist]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 19002:16,0:8, D_a_t_a/binary>>};


%% 删除邮件 
write(19003, {P0_code, P0_mkey}) ->
    D_a_t_a = <<P0_code:8, (proto:write_string(P0_mkey))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 19003:16,0:8, D_a_t_a/binary>>};


%% 收取邮件附件 
write(19004, {P0_code, P0_mkey}) ->
    D_a_t_a = <<P0_code:8, (proto:write_string(P0_mkey))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 19004:16,0:8, D_a_t_a/binary>>};


%% 一键提取附件 
write(19005, {P0_code, P0_maillist}) ->
    D_a_t_a = <<P0_code:8, (length(P0_maillist)):16, (list_to_binary([<<(proto:write_string(P1_mkey))/binary>> || P1_mkey <- P0_maillist]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 19005:16,0:8, D_a_t_a/binary>>};


%% 一键删除邮件 
write(19006, {P0_code, P0_maillist}) ->
    D_a_t_a = <<P0_code:8, (length(P0_maillist)):16, (list_to_binary([<<(proto:write_string(P1_mkey))/binary>> || P1_mkey <- P0_maillist]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 19006:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



