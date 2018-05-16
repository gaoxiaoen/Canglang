%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2018-01-11 17:57:07
%%----------------------------------------------------
-module(pt_642).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"活动未开启"; 
err(3) ->"已经报名"; 
err(4) ->"等级不符合要求"; 
err(5) ->"元宝不足"; 
err(6) ->"购买次数不足"; 
err(7) ->"今日已领取"; 
err(8) ->"擂主才可领取"; 
err(9) ->"擂主才可购买"; 
err(10) ->"挑战者才可购买"; 
err(11) ->"比赛已结束"; 
err(12) ->"已经参与竞猜"; 
err(13) ->"已经投注该擂主"; 
err(14) ->"已达投注上限"; 
err(15) ->"只剩一位擂主不可投注"; 
err(16) ->"擂主已战败"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(64200, _B0) ->
    {ok, {}};

read(64201, _B0) ->
    {ok, {}};

read(64202, _B0) ->
    {ok, {}};

read(64205, _B0) ->
    {ok, {}};

read(64206, _B0) ->
    {ok, {}};

read(64207, _B0) ->
    {ok, {}};

read(64208, _B0) ->
    {ok, {}};

read(64209, _B0) ->
    {P0_group, _B1} = proto:read_int8(_B0),
    {P0_page, _B2} = proto:read_int8(_B1),
    {ok, {P0_group, P0_page}};

read(64210, _B0) ->
    {ok, {}};

read(64211, _B0) ->
    {P0_group, _B1} = proto:read_int8(_B0),
    {P0_page, _B2} = proto:read_int8(_B1),
    {ok, {P0_group, P0_page}};

read(64212, _B0) ->
    {ok, {}};

read(64213, _B0) ->
    {ok, {}};

read(64214, _B0) ->
    {ok, {}};

read(64215, _B0) ->
    {ok, {}};

read(64216, _B0) ->
    {ok, {}};

read(64217, _B0) ->
    {ok, {}};

read(64220, _B0) ->
    {P0_type, _B1} = proto:read_int8(_B0),
    {ok, {P0_type}};

read(64221, _B0) ->
    {P0_type, _B1} = proto:read_int8(_B0),
    {P0_id, _B2} = proto:read_int8(_B1),
    {ok, {P0_type, P0_id}};

read(64223, _B0) ->
    {P0_group, _B1} = proto:read_uint32(_B0),
    {ok, {P0_group}};

read(64224, _B0) ->
    {ok, {}};

read(64225, _B0) ->
    {P0_month, _B1} = proto:read_int16(_B0),
    {P0_day, _B2} = proto:read_int16(_B1),
    {P0_group, _B3} = proto:read_uint8(_B2),
    {ok, {P0_month, P0_day, P0_group}};

read(64226, _B0) ->
    {P0_group, _B1} = proto:read_int16(_B0),
    {ok, {P0_group}};

read(64227, _B0) ->
    {P0_group, _B1} = proto:read_int8(_B0),
    {P0_floor, _B2} = proto:read_int8(_B1),
    {P0_cost_id, _B3} = proto:read_int8(_B2),
    {P0_type, _B4} = proto:read_int8(_B3),
    {ok, {P0_group, P0_floor, P0_cost_id, P0_type}};

read(64228, _B0) ->
    {P0_group, _B1} = proto:read_int16(_B0),
    {ok, {P0_group}};

read(64229, _B0) ->
    {P0_group, _B1} = proto:read_int8(_B0),
    {P0_pkey, _B2} = proto:read_uint32(_B1),
    {P0_cost_id, _B3} = proto:read_int8(_B2),
    {ok, {P0_group, P0_pkey, P0_cost_id}};

read(64230, _B0) ->
    {ok, {}};

read(64231, _B0) ->
    {ok, {}};

read(64232, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 活动状态 
write(64200, {P0_state, P0_time}) ->
    D_a_t_a = <<P0_state:8, P0_time:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64200:16,0:8, D_a_t_a/binary>>};


%% 获取报名信息 
write(64201, {P0_state, P0_count, P0_sign_state, P0_group}) ->
    D_a_t_a = <<P0_state:32, P0_count:32, P0_sign_state:8, P0_group:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64201:16,0:8, D_a_t_a/binary>>};


%% 报名参加 
write(64202, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64202:16,0:8, D_a_t_a/binary>>};


%% 匹配成功,推送双方挑战信息 
write(64205, {P0_time, P0_list}) ->
    D_a_t_a = <<P0_time:16, (length(P0_list)):16, (list_to_binary([<<P1_sn:32, P1_pkey:32, (proto:write_string(P1_nickname))/binary, (proto:write_string(P1_guild_name))/binary, P1_position:32, P1_career:8/signed, P1_sex:8/signed, (proto:write_string(P1_avatar))/binary, P1_group:8/signed, P1_power:32, P1_win:32, P1_lose:32, P1_lv:32, P1_hp_lim:32>> || [P1_sn, P1_pkey, P1_nickname, P1_guild_name, P1_position, P1_career, P1_sex, P1_avatar, P1_group, P1_power, P1_win, P1_lose, P1_lv, P1_hp_lim] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64205:16,0:8, D_a_t_a/binary>>};


%% 初赛结算信息 
write(64206, {P0_ret, P0_old_score, P0_change_score, P0_times, P0_goods_list}) ->
    D_a_t_a = <<P0_ret:8, P0_old_score:32/signed, P0_change_score:32/signed, P0_times:32/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64206:16,0:8, D_a_t_a/binary>>};


%% 退出 
write(64207, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64207:16,0:8, D_a_t_a/binary>>};


%% 准备场景信息 
write(64208, {P0_score, P0_times, P0_floor, P0_next_time, P0_rank, P0_win, P0_lose, P0_exp, P0_top_score, P0_top_sn, P0_top_nickname}) ->
    D_a_t_a = <<P0_score:32/signed, P0_times:32/signed, P0_floor:32/signed, P0_next_time:32/signed, P0_rank:32/signed, P0_win:32/signed, P0_lose:32/signed, (proto:write_string(P0_exp))/binary, P0_top_score:32/signed, P0_top_sn:32/signed, (proto:write_string(P0_top_nickname))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64208:16,0:8, D_a_t_a/binary>>};


%% 获取资格赛排名列表 
write(64209, {P0_score, P0_rank, P0_win, P0_lose, P0_goods_list, P0_page, P0_max_page, P0_len, P0_guild_member_list}) ->
    D_a_t_a = <<P0_score:32/signed, P0_rank:32/signed, P0_win:32/signed, P0_lose:32/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary, P0_page:8/signed, P0_max_page:8/signed, P0_len:8/signed, (length(P0_guild_member_list)):16, (list_to_binary([<<P1_rank:32, P1_pkey:32, P1_sn:32, (proto:write_string(P1_pname))/binary, P1_career:8, P1_sex:8, (proto:write_string(P1_guild_name))/binary, P1_position:8, P1_score:8, P1_win:8, P1_lose:8, P1_power:32>> || [P1_rank, P1_pkey, P1_sn, P1_pname, P1_career, P1_sex, P1_guild_name, P1_position, P1_score, P1_win, P1_lose, P1_power] <- P0_guild_member_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64209:16,0:8, D_a_t_a/binary>>};


%% 决赛结算信息 
write(64210, {P0_ret, P0_role_type, P0_floor, P0_name, P0_live_number, P0_goods_list}) ->
    D_a_t_a = <<P0_ret:8, P0_role_type:32/signed, P0_floor:32/signed, (proto:write_string(P0_name))/binary, P0_live_number:32/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64210:16,0:8, D_a_t_a/binary>>};


%% 获取擂主赛排名列表 
write(64211, {P0_score, P0_my_rank, P0_floor, P0_win, P0_lose, P0_goods_list, P0_page, P0_max_page, P0_len, P0_guild_member_list}) ->
    D_a_t_a = <<P0_score:32/signed, P0_my_rank:32/signed, P0_floor:32/signed, P0_win:32/signed, P0_lose:32/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary, P0_page:8/signed, P0_max_page:8/signed, P0_len:8/signed, (length(P0_guild_member_list)):16, (list_to_binary([<<P1_rank:32, P1_pkey:32, P1_sn:32, (proto:write_string(P1_pname))/binary, P1_career:8, P1_sex:8, (proto:write_string(P1_guild_name))/binary, P1_position:8, P1_score:8, P1_floor:8, P1_state:8, P1_power:32>> || [P1_rank, P1_pkey, P1_sn, P1_pname, P1_career, P1_sex, P1_guild_name, P1_position, P1_score, P1_floor, P1_state, P1_power] <- P0_guild_member_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64211:16,0:8, D_a_t_a/binary>>};


%% 膜拜擂主 
write(64212, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64212:16,0:8, D_a_t_a/binary>>};


%% 领取擂主奖励 
write(64213, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64213:16,0:8, D_a_t_a/binary>>};


%% 擂主赛准备场景信息 
write(64214, {P0_status, P0_floor, P0_score, P0_exp, P0_exp_up, P0_next_time, P0_winner_num}) ->
    D_a_t_a = <<P0_status:32, P0_floor:32, P0_score:32, P0_exp:32, P0_exp_up:32, P0_next_time:32/signed, P0_winner_num:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64214:16,0:8, D_a_t_a/binary>>};


%% 资格赛结算信息 
write(64215, {P0_rank, P0_score, P0_state, P0_goods_list}) ->
    D_a_t_a = <<P0_rank:32, P0_score:32, P0_state:32, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64215:16,0:8, D_a_t_a/binary>>};


%% 擂主赛结算信息 
write(64216, {P0_rank, P0_score, P0_floor, P0_goods_list}) ->
    D_a_t_a = <<P0_rank:32, P0_score:32, P0_floor:32, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64216:16,0:8, D_a_t_a/binary>>};


%% 未被选中玩家 
write(64217, {P0_next_time}) ->
    D_a_t_a = <<P0_next_time:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64217:16,0:8, D_a_t_a/binary>>};


%% 获取抢购商店信息 
write(64220, {P0_shop_list}) ->
    D_a_t_a = <<(length(P0_shop_list)):16, (list_to_binary([<<P1_id:32, P1_goods_id:32, P1_num:32, P1_old_cost:32, P1_now_cost:32, P1_ratio:32, P1_my_now_count:32, P1_my_count:32, P1_all_now_count:32, P1_all_count:32>> || [P1_id, P1_goods_id, P1_num, P1_old_cost, P1_now_cost, P1_ratio, P1_my_now_count, P1_my_count, P1_all_now_count, P1_all_count] <- P0_shop_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64220:16,0:8, D_a_t_a/binary>>};


%% 抢购商店购买 
write(64221, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64221:16,0:8, D_a_t_a/binary>>};


%% 获取膜拜信息 
write(64223, {P0_count, P0_state, P0_state1, P0_member_list}) ->
    D_a_t_a = <<P0_count:8, P0_state:8, P0_state1:8, (length(P0_member_list)):16, (list_to_binary([<<P1_rank:32, P1_pkey:32, P1_sn:32, (proto:write_string(P1_pname))/binary, P1_career:8, P1_sex:8, (proto:write_string(P1_guild_name))/binary, P1_power:32, P1_fashion_head_id:32, P1_wing_id:32, P1_wepon_id:32, P1_clothing_id:32, P1_light_wepon_id:32, P1_fashion_cloth_id:32>> || [P1_rank, P1_pkey, P1_sn, P1_pname, P1_career, P1_sex, P1_guild_name, P1_power, P1_fashion_head_id, P1_wing_id, P1_wepon_id, P1_clothing_id, P1_light_wepon_id, P1_fashion_cloth_id] <- P0_member_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64223:16,0:8, D_a_t_a/binary>>};


%% 获取期数列表 
write(64224, {P0_list}) ->
    D_a_t_a = <<(length(P0_list)):16, (list_to_binary([<<P1_month:16/signed, P1_day:16/signed>> || [P1_month, P1_day] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64224:16,0:8, D_a_t_a/binary>>};


%% 历史守擂记录 
write(64225, {P0_list}) ->
    D_a_t_a = <<(length(P0_list)):16, (list_to_binary([<<P1_rank:16, P1_sn:32, P1_key:32, (proto:write_string(P1_nickname))/binary, P1_vip:32, P1_group:8, (proto:write_string(P1_guild_name))/binary>> || [P1_rank, P1_sn, P1_key, P1_nickname, P1_vip, P1_group, P1_guild_name] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64225:16,0:8, D_a_t_a/binary>>};


%% 中场竞猜 
write(64226, {P0_exp, P0_exp_up, P0_bet_count, P0_ratio, P0_floor, P0_challenge_num, P0_state, P0_is_bet, P0_my_bet_cost, P0_my_bet_ratio, P0_bet_list, P0_winner_list, P0_member_list}) ->
    D_a_t_a = <<P0_exp:32, P0_exp_up:32, P0_bet_count:16/signed, P0_ratio:16/signed, P0_floor:16/signed, P0_challenge_num:16/signed, P0_state:16/signed, P0_is_bet:16/signed, P0_my_bet_cost:16/signed, P0_my_bet_ratio:16/signed, (length(P0_bet_list)):16, (list_to_binary([<<P1_cost_id:16/signed, P1_cost:16/signed>> || [P1_cost_id, P1_cost] <- P0_bet_list]))/binary, (length(P0_winner_list)):16, (list_to_binary([<<P1_pkey:32, P1_sn:32, (proto:write_string(P1_pname))/binary, P1_career:8, P1_sex:8, (proto:write_string(P1_guild_name))/binary, P1_power:32, P1_fashion_head_id:32, (proto:write_string(P1_avatar))/binary>> || [P1_pkey, P1_sn, P1_pname, P1_career, P1_sex, P1_guild_name, P1_power, P1_fashion_head_id, P1_avatar] <- P0_winner_list]))/binary, (length(P0_member_list)):16, (list_to_binary([<<P1_pkey:32, P1_sn:32, (proto:write_string(P1_pname))/binary, P1_career:8, P1_sex:8, (proto:write_string(P1_guild_name))/binary, P1_power:32, P1_fashion_head_id:32, (proto:write_string(P1_avatar))/binary>> || [P1_pkey, P1_sn, P1_pname, P1_career, P1_sex, P1_guild_name, P1_power, P1_fashion_head_id, P1_avatar] <- P0_member_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64226:16,0:8, D_a_t_a/binary>>};


%% 中场竞猜投注 
write(64227, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64227:16,0:8, D_a_t_a/binary>>};


%% 获取擂主竞猜信息 
write(64228, {P0_count, P0_leave_time, P0_my_bet_list, P0_bet_list, P0_winner_list}) ->
    D_a_t_a = <<P0_count:16/signed, P0_leave_time:16/signed, (length(P0_my_bet_list)):16, (list_to_binary([<<P1_bet_key:32, P1_my_bet_cost:16/signed, P1_my_bet_ratio:16/signed>> || [P1_bet_key, P1_my_bet_cost, P1_my_bet_ratio] <- P0_my_bet_list]))/binary, (length(P0_bet_list)):16, (list_to_binary([<<P1_cost_id:16/signed, P1_cost:16/signed>> || [P1_cost_id, P1_cost] <- P0_bet_list]))/binary, (length(P0_winner_list)):16, (list_to_binary([<<P1_pkey:32, P1_ratio:32, P1_sn:32, (proto:write_string(P1_pname))/binary, P1_is_lose:32, P1_career:8, P1_sex:8, (proto:write_string(P1_guild_name))/binary, P1_power:32, P1_fashion_head_id:32, (proto:write_string(P1_avatar))/binary>> || [P1_pkey, P1_ratio, P1_sn, P1_pname, P1_is_lose, P1_career, P1_sex, P1_guild_name, P1_power, P1_fashion_head_id, P1_avatar] <- P0_winner_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64228:16,0:8, D_a_t_a/binary>>};


%% 擂主竞猜投注 
write(64229, {P0_code, P0_str}) ->
    D_a_t_a = <<P0_code:8, (proto:write_string(P0_str))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64229:16,0:8, D_a_t_a/binary>>};


%% 获取投注历史记录 
write(64230, {P0_bet_list}) ->
    D_a_t_a = <<(length(P0_bet_list)):16, (list_to_binary([<<P1_type:16/signed, (proto:write_string(P1_nickname))/binary, P1_sn:32, P1_cost:16/signed, P1_ratio:16/signed, P1_result:16/signed, P1_state:16/signed>> || [P1_type, P1_nickname, P1_sn, P1_cost, P1_ratio, P1_result, P1_state] <- P0_bet_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64230:16,0:8, D_a_t_a/binary>>};


%% 连杀广播 
write(64231, {P0_pkey, P0_combo}) ->
    D_a_t_a = <<P0_pkey:32/signed, P0_combo:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64231:16,0:8, D_a_t_a/binary>>};


%% 经验加成 
write(64232, {P0_exp_list}) ->
    D_a_t_a = <<(length(P0_exp_list)):16, (list_to_binary([<<P1_floor:16/signed, P1_exp:16/signed>> || [P1_floor, P1_exp] <- P0_exp_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 64232:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



