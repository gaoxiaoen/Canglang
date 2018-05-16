%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-07-13 14:32:01
%%----------------------------------------------------
-module(pt_436).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"元宝不足"; 
err(3) ->"您已婚，不能再发布宣言"; 
err(4) ->"已关注当前玩家"; 
err(5) ->"不可关注自己"; 
err(6) ->"对方不在线"; 
err(7) ->"亲密度不够,还不能表白"; 
err(8) ->"发送CD时间限制"; 
err(9) ->"内容不合法,含有敏感字"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(43601, _B0) ->
    {ok, {}};

read(43602, _B0) ->
    {P0_page, _B1} = proto:read_uint16(_B0),
    {ok, {P0_page}};

read(43603, _B0) ->
    {ok, {}};

read(43604, _B0) ->
    {ok, {}};

read(43605, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_pkey}};

read(43606, _B0) ->
    {P0_love_desc_type, _B1} = proto:read_uint8(_B0),
    {P0_love_desc, _B2} = proto:read_string(_B1),
    {ok, {P0_love_desc_type, P0_love_desc}};

read(43607, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_pkey}};

read(43608, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {P0_desc, _B2} = proto:read_string(_B1),
    {ok, {P0_type, P0_desc}};

read(43609, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_pkey}};

read(43610, _B0) ->
    {ok, {}};

read(43611, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {P0_code, _B2} = proto:read_uint8(_B1),
    {ok, {P0_pkey, P0_code}};

read(43612, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 获取大厅玩家自己信息 
write(43601, {P0_rp_val, P0_qm_val, P0_page, P0_is_first_photo}) ->
    D_a_t_a = <<P0_rp_val:32, P0_qm_val:32, P0_page:16, P0_is_first_photo:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43601:16,0:8, D_a_t_a/binary>>};


%% 获取大厅排行信息 
write(43602, {P0_page, P0_list}) ->
    D_a_t_a = <<P0_page:16, (length(P0_list)):16, (list_to_binary([<<P1_pkey:32, (proto:write_string(P1_nickname))/binary, P1_career:8, P1_sex:8, P1_vip_lv:8, (proto:write_string(P1_avatar))/binary, P1_rp_val:16, P1_is_marry:8, (proto:write_string(P1_love_desc))/binary, P1_online:8, P1_is_look:8, P1_is_friend:8>> || [P1_pkey, P1_nickname, P1_career, P1_sex, P1_vip_lv, P1_avatar, P1_rp_val, P1_is_marry, P1_love_desc, P1_online, P1_is_look, P1_is_friend] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43602:16,0:8, D_a_t_a/binary>>};


%% 获取我的关注玩家信息 
write(43603, {P0_list}) ->
    D_a_t_a = <<(length(P0_list)):16, (list_to_binary([<<P1_pkey:32, (proto:write_string(P1_nickname))/binary, P1_career:8, P1_sex:8, P1_vip_lv:8, (proto:write_string(P1_avatar))/binary, P1_rp_val:16, P1_qm_val:16, P1_is_marry:8, (proto:write_string(P1_love_desc))/binary, P1_online:8, P1_is_look:8, P1_is_friend:8>> || [P1_pkey, P1_nickname, P1_career, P1_sex, P1_vip_lv, P1_avatar, P1_rp_val, P1_qm_val, P1_is_marry, P1_love_desc, P1_online, P1_is_look, P1_is_friend] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43603:16,0:8, D_a_t_a/binary>>};


%% 获取我的粉丝玩家信息 
write(43604, {P0_list}) ->
    D_a_t_a = <<(length(P0_list)):16, (list_to_binary([<<P1_pkey:32, (proto:write_string(P1_nickname))/binary, P1_career:8, P1_sex:8, P1_vip_lv:8, (proto:write_string(P1_avatar))/binary, P1_rp_val:16, P1_qm_val:16, P1_is_marry:8, (proto:write_string(P1_love_desc))/binary, P1_online:8, P1_is_look:8, P1_is_friend:8>> || [P1_pkey, P1_nickname, P1_career, P1_sex, P1_vip_lv, P1_avatar, P1_rp_val, P1_qm_val, P1_is_marry, P1_love_desc, P1_online, P1_is_look, P1_is_friend] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43604:16,0:8, D_a_t_a/binary>>};


%% 点击关注玩家 
write(43605, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43605:16,0:8, D_a_t_a/binary>>};


%% 宣言发布 
write(43606, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43606:16,0:8, D_a_t_a/binary>>};


%% 取消关注玩家 
write(43607, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43607:16,0:8, D_a_t_a/binary>>};


%% 发布 
write(43608, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43608:16,0:8, D_a_t_a/binary>>};


%% 表白玩家 
write(43609, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43609:16,0:8, D_a_t_a/binary>>};


%% 收到表白 
write(43610, {P0_pkey, P0_nickname, P0_career, P0_sex, P0_vip_lv, P0_avatar}) ->
    D_a_t_a = <<P0_pkey:32, (proto:write_string(P0_nickname))/binary, P0_career:8, P0_sex:8, P0_vip_lv:8, (proto:write_string(P0_avatar))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43610:16,0:8, D_a_t_a/binary>>};


%% 回应表白 
write(43611, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43611:16,0:8, D_a_t_a/binary>>};


%% 收到回应表白 
write(43612, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43612:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



