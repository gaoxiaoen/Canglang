%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2018-04-25 18:20:57
%%----------------------------------------------------
-module(pt_240).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"好友个数已到上限"; 
err(3) ->"黑名单已到上限"; 
err(4) ->"玩家已是你的好友"; 
err(5) ->"玩家不是你的好友"; 
err(6) ->"玩家已在您的屏蔽名单"; 
err(7) ->"玩家不在您的屏蔽名单"; 
err(8) ->"拒绝添加好友"; 
err(9) ->"对方不在线"; 
err(10) ->"对方当前不在线无法赠送"; 
err(11) ->"语内容含敏感词，请重新输入在赠"; 
err(12) ->"物品不足"; 
err(13) ->"元宝不足"; 
err(14) ->"自身等级不足"; 
err(15) ->"对方等级不足"; 
err(16) ->"包含敏感词"; 
err(17) ->"对方好友已达上限"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(24000, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {ok, {P0_type}};

read(24001, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_pkey}};

read(24002, _B0) ->
    {ok, {}};

read(24003, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_pkey}};

read(24004, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_pkey}};

read(24005, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_pkey}};

read(24006, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_pkey}};

read(24007, _B0) ->
    {ok, {}};

read(24008, _B0) ->
    {P0_nickname, _B1} = proto:read_string(_B0),
    {ok, {P0_nickname}};

read(24009, _B0) ->
    {ok, {}};

read(24010, _B0) ->
    {ok, {}};

read(24011, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_pkey}};

read(24012, _B0) ->
    {ok, {}};

read(24013, _B0) ->
    {ok, {}};

read(24014, _B0) ->
    {ok, {}};

read(24015, _B0) ->
    {ok, {}};

read(24016, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {P0_chat, _B2} = proto:read_string(_B1),
    {P0_goods_id, _B3} = proto:read_uint32(_B2),
    {P0_num, _B4} = proto:read_int16(_B3),
    {ok, {P0_pkey, P0_chat, P0_goods_id, P0_num}};

read(24017, _B0) ->
    {ok, {}};

read(24018, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_pkey}};

read(24019, _B0) ->
    {ok, {}};

read(24020, _B0) ->
    {ok, {}};

read(24021, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_pkey}};

read(24022, _B0) ->
    {P0_ret, _B1} = proto:read_int8(_B0),
    {P0_pkey, _B2} = proto:read_uint32(_B1),
    {ok, {P0_ret, P0_pkey}};

read(24023, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 关系列表信息 
write(24000, {P0_type, P0_relations}) ->
    D_a_t_a = <<P0_type:8, (length(P0_relations)):16, (list_to_binary([<<P1_pkey:32, (proto:write_string(P1_nickname))/binary, P1_career:8, P1_realm:8, P1_lv:16, P1_qinmidu:32, P1_sex:8, P1_vip_lv:16, P1_cbp:32, P1_off_line_time:32, (proto:write_string(P1_avatar))/binary, (proto:write_string(P1_guild_name))/binary, P1_fashion_decoration_id:32/signed>> || [P1_pkey, P1_nickname, P1_career, P1_realm, P1_lv, P1_qinmidu, P1_sex, P1_vip_lv, P1_cbp, P1_off_line_time, P1_avatar, P1_guild_name, P1_fashion_decoration_id] <- P0_relations]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 24000:16,0:8, D_a_t_a/binary>>};


%% 申请添加好友 
write(24001, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 24001:16,0:8, D_a_t_a/binary>>};


%% 弹出好友申请 
write(24002, {P0_pkey, P0_nickname, P0_career, P0_realm, P0_cbp, P0_sex, P0_lv, P0_avatar, P0_guild_name}) ->
    D_a_t_a = <<P0_pkey:32, (proto:write_string(P0_nickname))/binary, P0_career:8, P0_realm:8, P0_cbp:32, P0_sex:8, P0_lv:16, (proto:write_string(P0_avatar))/binary, (proto:write_string(P0_guild_name))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 24002:16,0:8, D_a_t_a/binary>>};


%% 添加好友 
write(24003, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 24003:16,0:8, D_a_t_a/binary>>};


%% 删除好友 
write(24004, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 24004:16,0:8, D_a_t_a/binary>>};


%% 添加黑名单 
write(24005, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 24005:16,0:8, D_a_t_a/binary>>};


%% 删除黑名单 
write(24006, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 24006:16,0:8, D_a_t_a/binary>>};


%% 获取推荐好友 
write(24007, {P0_players}) ->
    D_a_t_a = <<(length(P0_players)):16, (list_to_binary([<<P1_type:8, P1_pkey:32, P1_sn:32, (proto:write_string(P1_nickname))/binary, P1_career:8, P1_realm:8, P1_cbp:32, P1_sex:8, P1_lv:16, (proto:write_string(P1_location))/binary, P1_wing_id:32, P1_wepon_id:32, P1_clothing_id:32, P1_light_wepon_id:32, P1_fashion_cloth_id:32, P1_fashion_head_id:32/signed>> || [P1_type, P1_pkey, P1_sn, P1_nickname, P1_career, P1_realm, P1_cbp, P1_sex, P1_lv, P1_location, P1_wing_id, P1_wepon_id, P1_clothing_id, P1_light_wepon_id, P1_fashion_cloth_id, P1_fashion_head_id] <- P0_players]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 24007:16,0:8, D_a_t_a/binary>>};


%% 搜索好友 
write(24008, {P0_players}) ->
    D_a_t_a = <<(length(P0_players)):16, (list_to_binary([<<P1_pkey:32, P1_sn:32, (proto:write_string(P1_nickname))/binary, P1_career:8, P1_realm:8, P1_cbp:32, P1_sex:8, P1_lv:16, P1_wing_id:32, P1_wepon_id:32, P1_clothing_id:32, P1_light_wepon_id:32, P1_fashion_cloth_id:32, P1_fashion_head_id:32/signed>> || [P1_pkey, P1_sn, P1_nickname, P1_career, P1_realm, P1_cbp, P1_sex, P1_lv, P1_wing_id, P1_wepon_id, P1_clothing_id, P1_light_wepon_id, P1_fashion_cloth_id, P1_fashion_head_id] <- P0_players]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 24008:16,0:8, D_a_t_a/binary>>};


%% 获取可邀请关系列表(好友,仙盟成员) 
write(24009, {P0_rela_list}) ->
    D_a_t_a = <<(length(P0_rela_list)):16, (list_to_binary([<<P1_pkey:32, (proto:write_string(P1_nickname))/binary, P1_career:8/signed, P1_sex:8/signed, P1_vip:8/signed, P1_lv:8/signed, P1_cbp:32/signed, (proto:write_string(P1_avatar))/binary, (proto:write_string(P1_guild_name))/binary>> || [P1_pkey, P1_nickname, P1_career, P1_sex, P1_vip, P1_lv, P1_cbp, P1_avatar, P1_guild_name] <- P0_rela_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 24009:16,0:8, D_a_t_a/binary>>};


%% 获取当前可以点赞列表 
write(24010, {P0_times, P0_times_limit, P0_friend_list}) ->
    D_a_t_a = <<P0_times:8/signed, P0_times_limit:8/signed, (length(P0_friend_list)):16, (list_to_binary([<<P1_pkey:32, (proto:write_string(P1_nickname))/binary, P1_carrer:8, P1_reason:8/signed, P1_lv:32/signed>> || [P1_pkey, P1_nickname, P1_carrer, P1_reason, P1_lv] <- P0_friend_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 24010:16,0:8, D_a_t_a/binary>>};


%% 点赞 
write(24011, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 24011:16,0:8, D_a_t_a/binary>>};


%% 被好友点赞 
write(24012, {P0_nickname, P0_reason, P0_award}) ->
    D_a_t_a = <<(proto:write_string(P0_nickname))/binary, P0_reason:8/signed, (proto:write_string(P0_award))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 24012:16,0:8, D_a_t_a/binary>>};


%% 给好友点赞 
write(24013, {P0_nickname, P0_reason, P0_award}) ->
    D_a_t_a = <<(proto:write_string(P0_nickname))/binary, P0_reason:8/signed, (proto:write_string(P0_award))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 24013:16,0:8, D_a_t_a/binary>>};


%% 获取最近联系人 
write(24014, {P0_relations}) ->
    D_a_t_a = <<(length(P0_relations)):16, (list_to_binary([<<P1_pkey:32, (proto:write_string(P1_nickname))/binary, P1_career:8, P1_realm:8, P1_lv:16, P1_qinmidu:16, P1_sex:8, P1_vip_lv:16, P1_cbp:32, P1_off_line_time:32, (proto:write_string(P1_avatar))/binary, (proto:write_string(P1_guild_name))/binary, P1_fashion_decoration_id:32/signed>> || [P1_pkey, P1_nickname, P1_career, P1_realm, P1_lv, P1_qinmidu, P1_sex, P1_vip_lv, P1_cbp, P1_off_line_time, P1_avatar, P1_guild_name, P1_fashion_decoration_id] <- P0_relations]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 24014:16,0:8, D_a_t_a/binary>>};


%% 被好友送花 
write(24015, {P0_nickname, P0_pkey, P0_career, P0_avatar, P0_chat, P0_goods_id, P0_num, P0_sex}) ->
    D_a_t_a = <<(proto:write_string(P0_nickname))/binary, P0_pkey:32, P0_career:8, (proto:write_string(P0_avatar))/binary, (proto:write_string(P0_chat))/binary, P0_goods_id:32, P0_num:16/signed, P0_sex:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 24015:16,0:8, D_a_t_a/binary>>};


%% 给好友送花 
write(24016, {P0_error_code, P0_close}) ->
    D_a_t_a = <<P0_error_code:8, P0_close:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 24016:16,0:8, D_a_t_a/binary>>};


%% 送花被感谢 
write(24017, {P0_pkey, P0_sn_cur, P0_nickname, P0_career, P0_realm, P0_lv, P0_qinmidu, P0_sex, P0_vip_lv, P0_cbp, P0_off_line_time, P0_avatar, P0_guild_name}) ->
    D_a_t_a = <<P0_pkey:32, P0_sn_cur:32, (proto:write_string(P0_nickname))/binary, P0_career:8, P0_realm:8, P0_lv:16, P0_qinmidu:16, P0_sex:8, P0_vip_lv:16, P0_cbp:32, P0_off_line_time:32, (proto:write_string(P0_avatar))/binary, (proto:write_string(P0_guild_name))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 24017:16,0:8, D_a_t_a/binary>>};


%% 感谢送花人 
write(24018, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 24018:16,0:8, D_a_t_a/binary>>};


%% 飘花 
write(24019, {P0_pkey, P0_goods_id, P0_num}) ->
    D_a_t_a = <<P0_pkey:32, P0_goods_id:32, P0_num:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 24019:16,0:8, D_a_t_a/binary>>};


%% 获取送花好友列表 
write(24020, {P0_relations}) ->
    D_a_t_a = <<(length(P0_relations)):16, (list_to_binary([<<P1_pkey:32, (proto:write_string(P1_nickname))/binary>> || [P1_pkey, P1_nickname] <- P0_relations]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 24020:16,0:8, D_a_t_a/binary>>};


%% 获取简要信息 
write(24021, {P0_pkey, P0_sn_cur, P0_nickname, P0_career, P0_realm, P0_lv, P0_qinmidu, P0_sex, P0_vip_lv, P0_cbp, P0_off_line_time, P0_avatar, P0_guild_name}) ->
    D_a_t_a = <<P0_pkey:32, P0_sn_cur:32, (proto:write_string(P0_nickname))/binary, P0_career:8, P0_realm:8, P0_lv:16, P0_qinmidu:16, P0_sex:8, P0_vip_lv:16, P0_cbp:32, P0_off_line_time:32, (proto:write_string(P0_avatar))/binary, (proto:write_string(P0_guild_name))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 24021:16,0:8, D_a_t_a/binary>>};


%% 好友申请处理 
write(24022, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 24022:16,0:8, D_a_t_a/binary>>};


%% 好友申请返回 
write(24023, {P0_ret, P0_pname}) ->
    D_a_t_a = <<P0_ret:8/signed, (proto:write_string(P0_pname))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 24023:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



