%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2018-04-12 14:02:51
%%----------------------------------------------------
-module(pt_110).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"发言间隔不能低于 6 秒"; 
err(3) ->"还没有进仙盟"; 
err(4) ->"你已被禁言"; 
err(5) ->"元宝不够"; 
err(6) ->"等级不足"; 
err(7) ->"你没有进队伍"; 
err(8) ->"对方没有在线"; 
err(9) ->"找不到玩家"; 
err(10) ->"含有非法字符"; 
err(11) ->"不能和自己私聊"; 
err(12) ->"对方在您的屏蔽单中"; 
err(13) ->"您在对方屏蔽单中"; 
err(14) ->"仙盟捐献排名限制"; 
err(15) ->"vip等级不足"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(11000, _B0) ->
    {P0_type, _B1} = proto:read_int8(_B0),
    {P0_msg, _B2} = proto:read_string(_B1),
    {P0_voice, _B3} = proto:read_string(_B2),
    {P0_pkey, _B4} = proto:read_uint32(_B3),
    {P0_name, _B5} = proto:read_string(_B4),
    {ok, {P0_type, P0_msg, P0_voice, P0_pkey, P0_name}};

read(11001, _B0) ->
    {P0_type, _B1} = proto:read_int8(_B0),
    {ok, {P0_type}};

read(11002, _B0) ->
    {ok, {}};

read(11003, _B0) ->
    {P0_msg, _B1} = proto:read_string(_B0),
    {P0_voice, _B2} = proto:read_string(_B1),
    {P0_pkey, _B3} = proto:read_uint32(_B2),
    {P0_name, _B4} = proto:read_string(_B3),
    {ok, {P0_msg, P0_voice, P0_pkey, P0_name}};

read(11004, _B0) ->
    {ok, {}};

read(11010, _B0) ->
    {P0_face_str, _B1} = proto:read_string(_B0),
    {ok, {P0_face_str}};

read(11011, _B0) ->
    {ok, {}};

read(11012, _B0) ->
    {P0_type, _B1} = proto:read_int8(_B0),
    {ok, {P0_type}};

read(11013, _B0) ->
    {ok, {}};

read(11099, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 发送聊天 
write(11000, {P0_chat_info}) ->
    D_a_t_a = <<(pack_chat(P0_chat_info))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 11000:16,0:8, D_a_t_a/binary>>};


%% 获取聊天记录 
write(11001, {P0_type, P0_log_list}) ->
    D_a_t_a = <<P0_type:8/signed, (length(P0_log_list)):16, (list_to_binary([<<(pack_chat(P1_chat_info))/binary>> || P1_chat_info <- P0_log_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 11001:16,0:8, D_a_t_a/binary>>};


%% 获取私聊天记录 
write(11002, {P0_log_list}) ->
    D_a_t_a = <<(length(P0_log_list)):16, (list_to_binary([<<P1_pkey:32, (proto:write_string(P1_nickname))/binary, (proto:write_string(P1_avatar))/binary, P1_sex:8, P1_vip:8, P1_career:8, (length(P1_chat_list)):16, (list_to_binary([<<(pack_chat(P2_chat_info))/binary>> || P2_chat_info <- P1_chat_list]))/binary>> || [P1_pkey, P1_nickname, P1_avatar, P1_sex, P1_vip, P1_career, P1_chat_list] <- P0_log_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 11002:16,0:8, D_a_t_a/binary>>};


%% 发送私聊 
write(11003, {P0_pkey1, P0_pkey2, P0_nickname, P0_avatar, P0_sex, P0_vip, P0_career, P0_chat_info}) ->
    D_a_t_a = <<P0_pkey1:32, P0_pkey2:32, (proto:write_string(P0_nickname))/binary, (proto:write_string(P0_avatar))/binary, P0_sex:8, P0_vip:8, P0_career:8, (pack_chat(P0_chat_info))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 11003:16,0:8, D_a_t_a/binary>>};


%% 获取可聊天玩家 
write(11004, {P0_player_info}) ->
    D_a_t_a = <<(length(P0_player_info)):16, (list_to_binary([<<P1_vip:32, (proto:write_string(P1_avatar))/binary, (proto:write_string(P1_decoration_id))/binary, P1_sex:32, (proto:write_string(P1_nickname))/binary, P1_group:32, P1_pkey:32, P1_sign:32>> || [P1_vip, P1_avatar, P1_decoration_id, P1_sex, P1_nickname, P1_group, P1_pkey, P1_sign] <- P0_player_info]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 11004:16,0:8, D_a_t_a/binary>>};


%% 发送场景表情 
write(11010, {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 11010:16,0:8, D_a_t_a/binary>>};


%% 通知客户端内部更新 
write(11011, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 11011:16,0:8, D_a_t_a/binary>>};


%% 通知客户端内部更新 
write(11012, {P0_nickname, P0_num}) ->
    D_a_t_a = <<(proto:write_string(P0_nickname))/binary, P0_num:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 11012:16,0:8, D_a_t_a/binary>>};


%% 获取趣味问题 
write(11013, {P0_id}) ->
    D_a_t_a = <<P0_id:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 11013:16,0:8, D_a_t_a/binary>>};


%% 聊天错误 
write(11099, {P0_res}) ->
    D_a_t_a = <<P0_res:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 11099:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------

pack_chat([P0_type, P0_sn, P0_pkey, P0_nickname, P0_avatar, P0_gm, P0_title, P0_vip, P0_time, P0_career, P0_lv, P0_cbp, P0_content, P0_voice, P0_is_bugle, P0_sex, P0_fashion_decoration_id, P0_guild_position, P0_guild_name, P0_dvip]) ->
    D_a_t_a = <<P0_type:8/signed, P0_sn:32/signed, P0_pkey:32/signed, (proto:write_string(P0_nickname))/binary, (proto:write_string(P0_avatar))/binary, P0_gm:8, P0_title:16, P0_vip:8, P0_time:32, P0_career:8, P0_lv:8, P0_cbp:32, (proto:write_string(P0_content))/binary, (proto:write_string(P0_voice))/binary, P0_is_bugle:8, P0_sex:8, P0_fashion_decoration_id:32/signed, P0_guild_position:8, (proto:write_string(P0_guild_name))/binary, P0_dvip:8/signed>>,
    <<D_a_t_a/binary>>.




