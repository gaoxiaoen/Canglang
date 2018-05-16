%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2018-01-30 10:40:56
%%----------------------------------------------------
-module(pt_601).
-export([read/2, write/2]).

-include("common.hrl").
-include("cross_war.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"活动未开启"; 
err(3) ->"您还没有加入仙盟"; 
err(4) ->"捐献道具不足"; 
err(5) ->"元宝不足"; 
err(6) ->"银币不足"; 
err(7) ->"已领取"; 
err(8) ->"仙盟阵营捐献未进入前6，不可参加城战"; 
err(9) ->"活动已开启,不可再切换阵营"; 
err(10) ->"长老及以上玩家才可进行阵营选择"; 
err(11) ->"切换阵营时间限制"; 
err(12) ->"非本期城主，不能领取"; 
err(13) ->"非本期城主仙盟成员，不能领取"; 
err(14) ->"攻城资源不足"; 
err(15) ->"攻城炮弹资源不足"; 
err(16) ->"等级不足"; 
err(17) ->"已有炸弹，不能再兑换"; 
err(18) ->"本次城主守卫阵营，不可切换"; 
err(19) ->"本次复仇攻击阵营，不可切换"; 
err(20) ->"今日开启战场,不可切换阵营"; 
err(21) ->"活动结束,不能再捐献"; 
err(22) ->"活动已开启,不能再捐献"; 
err(23) ->"已经有了战车，不可再次兑换"; 
err(24) ->"攻城战车资源不足"; 
err(25) ->"掌门以及掌教才可进入攻城议会"; 
err(26) ->"仙盟等级2级以下不得参加议会"; 
err(27) ->"本周活动已结束"; 
err(28) ->"仙盟阵营捐献未进入前6，不可参加议会"; 
err(29) ->"本次城主守卫阵营，不用再捐献"; 
err(30) ->"本次复仇攻击阵营，不用再捐献"; 
err(31) ->"周六和周日可报名参战"; 
err(32) ->"已膜拜"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(60101, _B0) ->
    {ok, {}};

read(60102, _B0) ->
    {ok, {}};

read(60103, _B0) ->
    {ok, {}};

read(60104, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {ok, {P0_type}};

read(60105, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {ok, {P0_type}};

read(60108, _B0) ->
    {P0_goods_id, _B1} = proto:read_uint32(_B0),
    {P0_goods_num, _B2} = proto:read_uint32(_B1),
    {ok, {P0_goods_id, P0_goods_num}};

read(60109, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {ok, {P0_type}};

read(60110, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {ok, {P0_type}};

read(60111, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {ok, {P0_type}};

read(60112, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {ok, {P0_type}};

read(60113, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {ok, {P0_type}};

read(60116, _B0) ->
    {ok, {}};

read(60117, _B0) ->
    {ok, {}};

read(60118, _B0) ->
    {ok, {}};

read(60119, _B0) ->
    {ok, {}};

read(60120, _B0) ->
    {ok, {}};

read(60121, _B0) ->
    {ok, {}};

read(60122, _B0) ->
    {ok, {}};

read(60123, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {ok, {P0_type}};

read(60124, _B0) ->
    {ok, {}};

read(60125, _B0) ->
    {ok, {}};

read(60126, _B0) ->
    {ok, {}};

read(60127, _B0) ->
    {ok, {}};

read(60128, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 查询活动状态 
write(60101, {P0_state, P0_time, P0_is_recv_daily, P0_is_recv_king, P0_my_sign, P0_is_orz}) ->
    D_a_t_a = <<P0_state:8, P0_time:32, P0_is_recv_daily:8, P0_is_recv_king:8, P0_my_sign:8, P0_is_orz:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60101:16,0:8, D_a_t_a/binary>>};


%% 攻城战面板信息 
write(60102, {P0_king_name, P0_king_sn, P0_king_sn_name, P0_king_sex, P0_king_wing_id, P0_king_wepon_id, P0_king_clothing_id, P0_king_light_wepon_id, P0_king_fashion_cloth_id, P0_king_fashion_head_id, P0_guild_name, P0_couple_name, P0_couple_sex, P0_couple_wing_id, P0_couple_wepon_id, P0_couple_clothing_id, P0_couple_light_wepon_id, P0_couple_fashion_cloth_id, P0_couple_fashion_head_id, P0_acc_win, P0_reward_list1, P0_reward_list2, P0_reward_list3, P0_member_list}) ->
    D_a_t_a = <<(proto:write_string(P0_king_name))/binary, P0_king_sn:16, (proto:write_string(P0_king_sn_name))/binary, P0_king_sex:8, P0_king_wing_id:32, P0_king_wepon_id:32, P0_king_clothing_id:32, P0_king_light_wepon_id:32, P0_king_fashion_cloth_id:32, P0_king_fashion_head_id:32/signed, (proto:write_string(P0_guild_name))/binary, (proto:write_string(P0_couple_name))/binary, P0_couple_sex:8, P0_couple_wing_id:32, P0_couple_wepon_id:32, P0_couple_clothing_id:32, P0_couple_light_wepon_id:32, P0_couple_fashion_cloth_id:32, P0_couple_fashion_head_id:32/signed, P0_acc_win:8, (length(P0_reward_list1)):16, (list_to_binary([<<P1_goods_id1:32, P1_goods_num1:32>> || [P1_goods_id1, P1_goods_num1] <- P0_reward_list1]))/binary, (length(P0_reward_list2)):16, (list_to_binary([<<P1_goods_id2:32, P1_goods_num2:32>> || [P1_goods_id2, P1_goods_num2] <- P0_reward_list2]))/binary, (length(P0_reward_list3)):16, (list_to_binary([<<P1_goods_id3:32, P1_goods_num3:32>> || [P1_goods_id3, P1_goods_num3] <- P0_reward_list3]))/binary, (length(P0_member_list)):16, (list_to_binary([<<(proto:write_string(P1_member_nickname))/binary, P1_member_sex:8, P1_member_rank:8, (proto:write_string(P1_member_g_name))/binary, P1_member_sn:16, (proto:write_string(P1_member_sn_name))/binary, P1_member_wing_id:32, P1_member_wepon_id:32, P1_member_clothing_id:32, P1_member_light_wepon_id:32, P1_member_fashion_cloth_id:32, P1_member_fashion_head_id:32/signed>> || [P1_member_nickname, P1_member_sex, P1_member_rank, P1_member_g_name, P1_member_sn, P1_member_sn_name, P1_member_wing_id, P1_member_wepon_id, P1_member_clothing_id, P1_member_light_wepon_id, P1_member_fashion_cloth_id, P1_member_fashion_head_id] <- P0_member_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60102:16,0:8, D_a_t_a/binary>>};


%% 获取自身贡献信息 
write(60103, {P0_contrib, P0_contrib_rank, P0_remain_time}) ->
    D_a_t_a = <<P0_contrib:32, P0_contrib_rank:16, P0_remain_time:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60103:16,0:8, D_a_t_a/binary>>};


%% 获取 防守/攻击 公会贡献排行榜 
write(60104, {P0_type, P0_my_rank, P0_my_guild_name, P0_my_sn, P0_my_sn_name, P0_my_contrib_val, P0_list}) ->
    D_a_t_a = <<P0_type:8, P0_my_rank:16, (proto:write_string(P0_my_guild_name))/binary, P0_my_sn:16, (proto:write_string(P0_my_sn_name))/binary, P0_my_contrib_val:32, (length(P0_list)):16, (list_to_binary([<<P1_type:8, P1_rank:16, (proto:write_string(P1_guild_name))/binary, P1_sn:16, (proto:write_string(P1_sn_name))/binary, P1_contrib_val:32>> || [P1_type, P1_rank, P1_guild_name, P1_sn, P1_sn_name, P1_contrib_val] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60104:16,0:8, D_a_t_a/binary>>};


%% 获取 防守/攻击 个人贡献排行榜 
write(60105, {P0_type, P0_my_rank, P0_my_nickname, P0_my_sn, P0_my_guild_name, P0_my_contrib_val, P0_list}) ->
    D_a_t_a = <<P0_type:8, P0_my_rank:16, (proto:write_string(P0_my_nickname))/binary, P0_my_sn:16, (proto:write_string(P0_my_guild_name))/binary, P0_my_contrib_val:32, (length(P0_list)):16, (list_to_binary([<<P1_rank:16, (proto:write_string(P1_nickname))/binary, P1_sn:16, (proto:write_string(P1_guild_name))/binary, P1_contrib_val:32>> || [P1_rank, P1_nickname, P1_sn, P1_guild_name, P1_contrib_val] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60105:16,0:8, D_a_t_a/binary>>};


%% 贡献 
write(60108, {P0_code, P0_val}) ->
    D_a_t_a = <<P0_code:8, P0_val:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60108:16,0:8, D_a_t_a/binary>>};


%% 议会 
write(60109, {P0_code, P0_list}) ->
    D_a_t_a = <<P0_code:8, (length(P0_list)):16, (list_to_binary([<<P1_rank:16, (proto:write_string(P1_guild_name))/binary, P1_sn:16, (proto:write_string(P1_sn_name))/binary, P1_type:8>> || [P1_rank, P1_guild_name, P1_sn, P1_sn_name, P1_type] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60109:16,0:8, D_a_t_a/binary>>};


%% 阵营选择 
write(60110, {P0_code, P0_type}) ->
    D_a_t_a = <<P0_code:8, P0_type:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60110:16,0:8, D_a_t_a/binary>>};


%% 每日奖励福利领取 
write(60111, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60111:16,0:8, D_a_t_a/binary>>};


%% 获取 防守/攻击 公会积分排行榜 
write(60112, {P0_type, P0_my_rank, P0_my_guild_name, P0_my_sn, P0_my_sn_name, P0_my_score, P0_list}) ->
    D_a_t_a = <<P0_type:8, P0_my_rank:16, (proto:write_string(P0_my_guild_name))/binary, P0_my_sn:16, (proto:write_string(P0_my_sn_name))/binary, P0_my_score:32, (length(P0_list)):16, (list_to_binary([<<P1_rank:16, (proto:write_string(P1_guild_name))/binary, P1_sn:16, (proto:write_string(P1_sn_name))/binary, P1_score:32>> || [P1_rank, P1_guild_name, P1_sn, P1_sn_name, P1_score] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60112:16,0:8, D_a_t_a/binary>>};


%% 获取 防守/攻击 个人积分排行榜 
write(60113, {P0_type, P0_my_rank, P0_my_nickname, P0_my_sn, P0_my_guild_name, P0_my_score, P0_list}) ->
    D_a_t_a = <<P0_type:8, P0_my_rank:16, (proto:write_string(P0_my_nickname))/binary, P0_my_sn:16, (proto:write_string(P0_my_guild_name))/binary, P0_my_score:32, (length(P0_list)):16, (list_to_binary([<<P1_rank:16, (proto:write_string(P1_nickname))/binary, P1_sn:16, (proto:write_string(P1_guild_name))/binary, P1_score:32>> || [P1_rank, P1_nickname, P1_sn, P1_guild_name, P1_score] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60113:16,0:8, D_a_t_a/binary>>};


%% 获取攻城信息 
write(60116, {P0_sn, P0_sn_name, P0_g_name, P0_acc_win, P0_sign, P0_kill_door_lists, P0_kill_king_door_lists, P0_def_guild_list, P0_att_guild_list}) ->
    D_a_t_a = <<P0_sn:16, (proto:write_string(P0_sn_name))/binary, (proto:write_string(P0_g_name))/binary, P0_acc_win:8, P0_sign:8, (length(P0_kill_door_lists)):16, (list_to_binary([<<P1_sn:16, (proto:write_string(P1_sn_name))/binary, (proto:write_string(P1_player_nickname))/binary>> || [P1_sn, P1_sn_name, P1_player_nickname] <- P0_kill_door_lists]))/binary, (length(P0_kill_king_door_lists)):16, (list_to_binary([<<P1_sn:16, (proto:write_string(P1_sn_name))/binary, (proto:write_string(P1_player_nickname))/binary>> || [P1_sn, P1_sn_name, P1_player_nickname] <- P0_kill_king_door_lists]))/binary, (length(P0_def_guild_list)):16, (list_to_binary([<<P1_sn:16, (proto:write_string(P1_sn_name))/binary, (proto:write_string(P1_guild_name))/binary>> || [P1_sn, P1_sn_name, P1_guild_name] <- P0_def_guild_list]))/binary, (length(P0_att_guild_list)):16, (list_to_binary([<<P1_sn:16, (proto:write_string(P1_sn_name))/binary, (proto:write_string(P1_guild_name))/binary>> || [P1_sn, P1_sn_name, P1_guild_name] <- P0_att_guild_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60116:16,0:8, D_a_t_a/binary>>};


%% 进入战场 
write(60117, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60117:16,0:8, D_a_t_a/binary>>};


%% 活动开启通知，仅通知被选中的帮派玩家 
write(60118, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60118:16,0:8, D_a_t_a/binary>>};


%% 获取数据，积分相关信息 
write(60119, {P0_my_score, P0_my_materis, P0_my_bomb, P0_my_car, P0_king_name, P0_king_sn, P0_king_sn_name, P0_my_acc_kill, P0_king_gold_state, P0_mon_list}) ->
    D_a_t_a = <<P0_my_score:32, P0_my_materis:32, P0_my_bomb:8, P0_my_car:8, (proto:write_string(P0_king_name))/binary, P0_king_sn:16, (proto:write_string(P0_king_sn_name))/binary, P0_my_acc_kill:8, P0_king_gold_state:8, (length(P0_mon_list)):16, (list_to_binary([<<P1_mon_key:32, P1_mid:32, P1_hp:32, P1_hp_lim:32>> || [P1_mon_key, P1_mid, P1_hp, P1_hp_lim] <- P0_mon_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60119:16,0:8, D_a_t_a/binary>>};


%% 退出城战 
write(60120, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60120:16,0:8, D_a_t_a/binary>>};


%% 服务器推送活动结束 
write(60121, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60121:16,0:8, D_a_t_a/binary>>};


%% 战斗结束，结算界面 
write(60122, {P0_win_sign, P0_sn, P0_sn_name, P0_guild_name}) ->
    D_a_t_a = <<P0_win_sign:8, P0_sn:16, (proto:write_string(P0_sn_name))/binary, (proto:write_string(P0_guild_name))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60122:16,0:8, D_a_t_a/binary>>};


%% 战车或者炮弹可以兑换 
write(60123, {P0_type, P0_code}) ->
    D_a_t_a = <<P0_type:8, P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60123:16,0:8, D_a_t_a/binary>>};


%% 读取王珠携带者坐标 
write(60124, {P0_x, P0_y}) ->
    D_a_t_a = <<P0_x:16, P0_y:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60124:16,0:8, D_a_t_a/binary>>};


%% 放下宝珠 
write(60125, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60125:16,0:8, D_a_t_a/binary>>};


%% 使用炮弹/战车 
write(60126, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60126:16,0:8, D_a_t_a/binary>>};


%% 读取战场地图信息 
write(60127, {P0_king_x, P0_king_y, P0_list1, P0_list2}) ->
    D_a_t_a = <<P0_king_x:32, P0_king_y:32, (length(P0_list1)):16, (list_to_binary([<<P1_x:32, P1_y:32, P1_sign:32>> || [P1_x, P1_y, P1_sign] <- P0_list1]))/binary, (length(P0_list2)):16, (list_to_binary([<<P1_x:32, P1_y:32, P1_hp:32, P1_hp_lim:32>> || [P1_x, P1_y, P1_hp, P1_hp_lim] <- P0_list2]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60127:16,0:8, D_a_t_a/binary>>};


%% 膜拜 
write(60128, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60128:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



