%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2018-05-08 14:07:54
%%----------------------------------------------------
-module(pt_438).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"还不能领取"; 
err(3) ->"领取ID不存在"; 
err(4) ->"活动还没开启"; 
err(5) ->"元宝不足"; 
err(6) ->"兑换下标不正确"; 
err(7) ->"兑换已达到上限"; 
err(8) ->"积分不足"; 
err(9) ->"次数不足"; 
err(10) ->"已经领取"; 
err(11) ->"领取条件不满足"; 
err(12) ->"已经全部翻开"; 
err(13) ->"未全部翻开"; 
err(14) ->"投资的ID不存在"; 
err(15) ->"已投资"; 
err(16) ->"领取档数不正确"; 
err(17) ->"领取等级不足"; 
err(18) ->"该卡牌已翻"; 
err(19) ->"卡牌不存在"; 
err(20) ->"不可邀请自己"; 
err(21) ->"已经使用过邀请码"; 
err(22) ->"战力提升不足"; 
err(23) ->"礼包已经领取"; 
err(24) ->"礼包未激活"; 
err(25) ->"您的帐号注册时间与要求不符"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(43801, _B0) ->
    {ok, {}};

read(43802, _B0) ->
    {P0_id, _B1} = proto:read_uint8(_B0),
    {ok, {P0_id}};

read(43803, _B0) ->
    {ok, {}};

read(43804, _B0) ->
    {P0_id, _B1} = proto:read_uint8(_B0),
    {ok, {P0_id}};

read(43805, _B0) ->
    {P0_cell_id, _B1} = proto:read_uint8(_B0),
    {P0_goods_num, _B2} = proto:read_int16(_B1),
    {ok, {P0_cell_id, P0_goods_num}};

read(43806, _B0) ->
    {ok, {}};

read(43807, _B0) ->
    {ok, {}};

read(43808, _B0) ->
    {ok, {}};

read(43809, _B0) ->
    {ok, {}};

read(43810, _B0) ->
    {P0_id, _B1} = proto:read_uint8(_B0),
    {ok, {P0_id}};

read(43811, _B0) ->
    {P0_cell_id, _B1} = proto:read_uint8(_B0),
    {P0_goods_num, _B2} = proto:read_int16(_B1),
    {ok, {P0_cell_id, P0_goods_num}};

read(43812, _B0) ->
    {ok, {}};

read(43813, _B0) ->
    {ok, {}};

read(43820, _B0) ->
    {ok, {}};

read(43821, _B0) ->
    {ok, {}};

read(43822, _B0) ->
    {P0_id, _B1} = proto:read_uint8(_B0),
    {ok, {P0_id}};

read(43823, _B0) ->
    {P0_id, _B1} = proto:read_uint8(_B0),
    {ok, {P0_id}};

read(43825, _B0) ->
    {ok, {}};

read(43826, _B0) ->
    {ok, {}};

read(43828, _B0) ->
    {ok, {}};

read(43829, _B0) ->
    {ok, {}};

read(43831, _B0) ->
    {ok, {}};

read(43832, _B0) ->
    {P0_id, _B1} = proto:read_uint8(_B0),
    {ok, {P0_id}};

read(43835, _B0) ->
    {ok, {}};

read(43836, _B0) ->
    {P0_id, _B1} = proto:read_uint8(_B0),
    {ok, {P0_id}};

read(43837, _B0) ->
    {ok, {}};

read(43838, _B0) ->
    {ok, {}};

read(43839, _B0) ->
    {P0_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_id}};

read(43840, _B0) ->
    {ok, {}};

read(43841, _B0) ->
    {P0_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_id}};

read(43842, _B0) ->
    {ok, {}};

read(43843, _B0) ->
    {P0_id, _B1} = proto:read_uint32(_B0),
    {P0_id2, _B2} = proto:read_uint8(_B1),
    {ok, {P0_id, P0_id2}};

read(43844, _B0) ->
    {P0_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_id}};

read(43845, _B0) ->
    {ok, {}};

read(43846, _B0) ->
    {P0_type, _B1} = proto:read_uint16(_B0),
    {P0_is_auto, _B2} = proto:read_uint16(_B1),
    {ok, {P0_type, P0_is_auto}};

read(43847, _B0) ->
    {P0_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_id}};

read(43848, _B0) ->
    {ok, {}};

read(43849, _B0) ->
    {P0_num, _B1} = proto:read_uint32(_B0),
    {ok, {P0_num}};

read(43850, _B0) ->
    {ok, {}};

read(43852, _B0) ->
    {ok, {}};

read(43853, _B0) ->
    {P0_invite_code, _B1} = proto:read_string(_B0),
    {ok, {P0_invite_code}};

read(43855, _B0) ->
    {ok, {}};

read(43856, _B0) ->
    {ok, {}};

read(43857, _B0) ->
    {ok, {}};

read(43858, _B0) ->
    {ok, {}};

read(43859, _B0) ->
    {P0_id, _B1} = proto:read_int32(_B0),
    {ok, {P0_id}};

read(43860, _B0) ->
    {ok, {}};

read(43861, _B0) ->
    {P0_type, _B1} = proto:read_int32(_B0),
    {P0_id, _B2} = proto:read_int32(_B1),
    {ok, {P0_type, P0_id}};

read(43863, _B0) ->
    {P0_rank_top, _B1} = proto:read_int32(_B0),
    {ok, {P0_rank_top}};

read(43864, _B0) ->
    {ok, {}};

read(43865, _B0) ->
    {ok, {}};

read(43866, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {ok, {P0_type}};

read(43871, _B0) ->
    {ok, {}};

read(43872, _B0) ->
    {P0_base_consume, _B1} = proto:read_uint32(_B0),
    {ok, {P0_base_consume}};

read(43873, _B0) ->
    {ok, {}};

read(43874, _B0) ->
    {P0_base_charge_gold, _B1} = proto:read_uint32(_B0),
    {ok, {P0_base_charge_gold}};

read(43899, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 请求全名来嗨数据 
write(43801, {P0_leave_time, P0_award_list, P0_now_val, P0_hi_config}) ->
    D_a_t_a = <<P0_leave_time:32, (length(P0_award_list)):16, (list_to_binary([<<P1_id:16, P1_get_num:32, P1_state:8, (length(P1_goods_arr)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_goods_arr]))/binary>> || [P1_id, P1_get_num, P1_state, P1_goods_arr] <- P0_award_list]))/binary, P0_now_val:32, (length(P0_hi_config)):16, (list_to_binary([<<P1_hi_id:16, P1_hi_num:16, P1_tar_num:16, P1_get_num:16, P1_fun_id:16, P1_fun_sub_id:16, (proto:write_string(P1_des_name))/binary, (length(P1_args)):16, (list_to_binary([<<P2_argval:32>> || P2_argval <- P1_args]))/binary>> || [P1_hi_id, P1_hi_num, P1_tar_num, P1_get_num, P1_fun_id, P1_fun_sub_id, P1_des_name, P1_args] <- P0_hi_config]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43801:16,0:8, D_a_t_a/binary>>};


%% 请求获取hi点奖励 
write(43802, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43802:16,0:8, D_a_t_a/binary>>};


%% 转池转盘信息 
write(43803, {P0_leave_time, P0_award_gold, P0_award_list, P0_free_time, P0_score, P0_cost_one, P0_cost_ten, P0_award_goods, P0_score_goods}) ->
    D_a_t_a = <<P0_leave_time:32, P0_award_gold:32, (length(P0_award_list)):16, (list_to_binary([<<P1_server_id:32, (proto:write_string(P1_nickname))/binary, P1_g_id:32, P1_g_num:32, P1_add_gold:32, P1_left_gold:32>> || [P1_server_id, P1_nickname, P1_g_id, P1_g_num, P1_add_gold, P1_left_gold] <- P0_award_list]))/binary, P0_free_time:8, P0_score:32/signed, P0_cost_one:16/signed, P0_cost_ten:16/signed, (length(P0_award_goods)):16, (list_to_binary([<<P1_cell_id:8, P1_goods_id:32, P1_goods_num:32>> || [P1_cell_id, P1_goods_id, P1_goods_num] <- P0_award_goods]))/binary, (length(P0_score_goods)):16, (list_to_binary([<<P1_cell_id:8, P1_goods_id:32, P1_goods_num:32, P1_score_cost:16, P1_left_num:16>> || [P1_cell_id, P1_goods_id, P1_goods_num, P1_score_cost, P1_left_num] <- P0_score_goods]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43803:16,0:8, D_a_t_a/binary>>};


%% 请求抽奖 
write(43804, {P0_code, P0_cell_id_list}) ->
    D_a_t_a = <<P0_code:8, (length(P0_cell_id_list)):16, (list_to_binary([<<P1_cell_id:8, P1_goods_id:32, P1_award_num:32>> || [P1_cell_id, P1_goods_id, P1_award_num] <- P0_cell_id_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43804:16,0:8, D_a_t_a/binary>>};


%% 请求兑换 
write(43805, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43805:16,0:8, D_a_t_a/binary>>};


%% 特效播放 
write(43806, {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43806:16,0:8, D_a_t_a/binary>>};


%% 奖池元宝更新 
write(43807, {P0_gold}) ->
    D_a_t_a = <<P0_gold:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43807:16,0:8, D_a_t_a/binary>>};


%% 积分更新 
write(43808, {P0_gold}) ->
    D_a_t_a = <<P0_gold:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43808:16,0:8, D_a_t_a/binary>>};


%% 本服转池转盘信息 
write(43809, {P0_leave_time, P0_award_gold, P0_award_list, P0_free_time, P0_score, P0_cost_one, P0_cost_ten, P0_award_goods, P0_score_goods}) ->
    D_a_t_a = <<P0_leave_time:32, P0_award_gold:32, (length(P0_award_list)):16, (list_to_binary([<<P1_server_id:32, (proto:write_string(P1_nickname))/binary, P1_g_id:32, P1_g_num:32, P1_add_gold:32, P1_left_gold:32>> || [P1_server_id, P1_nickname, P1_g_id, P1_g_num, P1_add_gold, P1_left_gold] <- P0_award_list]))/binary, P0_free_time:8, P0_score:32/signed, P0_cost_one:16/signed, P0_cost_ten:16/signed, (length(P0_award_goods)):16, (list_to_binary([<<P1_cell_id:8, P1_goods_id:32, P1_goods_num:32>> || [P1_cell_id, P1_goods_id, P1_goods_num] <- P0_award_goods]))/binary, (length(P0_score_goods)):16, (list_to_binary([<<P1_cell_id:8, P1_goods_id:32, P1_goods_num:32, P1_score_cost:16, P1_left_num:16>> || [P1_cell_id, P1_goods_id, P1_goods_num, P1_score_cost, P1_left_num] <- P0_score_goods]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43809:16,0:8, D_a_t_a/binary>>};


%% 本服转盘请求抽奖 
write(43810, {P0_code, P0_cell_id_list}) ->
    D_a_t_a = <<P0_code:8, (length(P0_cell_id_list)):16, (list_to_binary([<<P1_cell_id:8, P1_goods_id:32, P1_award_num:32>> || [P1_cell_id, P1_goods_id, P1_award_num] <- P0_cell_id_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43810:16,0:8, D_a_t_a/binary>>};


%% 本服转盘请求兑换 
write(43811, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43811:16,0:8, D_a_t_a/binary>>};


%% 本服转盘奖池元宝更新 
write(43812, {P0_gold}) ->
    D_a_t_a = <<P0_gold:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43812:16,0:8, D_a_t_a/binary>>};


%% 本服转盘积分更新 
write(43813, {P0_gold}) ->
    D_a_t_a = <<P0_gold:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43813:16,0:8, D_a_t_a/binary>>};


%% 获取水果大战信息 
write(43820, {P0_leave_time, P0_count, P0_free_count, P0_cost, P0_re_cost, P0_free_time, P0_reward_list, P0_count_reward_list, P0_egg_list, P0_notice_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_count:32, P0_free_count:32, P0_cost:32, P0_re_cost:32, P0_free_time:32, (length(P0_reward_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_reward_list]))/binary, (length(P0_count_reward_list)):16, (list_to_binary([<<P1_id:32, P1_count:32, P1_state:32, P1_goods_id:32, P1_goods_num:32>> || [P1_id, P1_count, P1_state, P1_goods_id, P1_goods_num] <- P0_count_reward_list]))/binary, (length(P0_egg_list)):16, (list_to_binary([<<P1_id:32, P1_state:8, P1_type:8, P1_goods_id:32, P1_goods_num:32>> || [P1_id, P1_state, P1_type, P1_goods_id, P1_goods_num] <- P0_egg_list]))/binary, (length(P0_notice_list)):16, (list_to_binary([<<(proto:write_string(P1_nickname))/binary, P1_goods_id:32, P1_goods_num:32>> || [P1_nickname, P1_goods_id, P1_goods_num] <- P0_notice_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43820:16,0:8, D_a_t_a/binary>>};


%% 水果大战刷新 
write(43821, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43821:16,0:8, D_a_t_a/binary>>};


%% 水果大战砸蛋 
write(43822, {P0_code, P0_egg_list}) ->
    D_a_t_a = <<P0_code:8, (length(P0_egg_list)):16, (list_to_binary([<<P1_id:32, P1_state:8, P1_type:8, P1_goods_id:32, P1_goods_num:32>> || [P1_id, P1_state, P1_type, P1_goods_id, P1_goods_num] <- P0_egg_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43822:16,0:8, D_a_t_a/binary>>};


%% 水果大战-领取次数奖励 
write(43823, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43823:16,0:8, D_a_t_a/binary>>};


%% 获取充值有礼信息 
write(43825, {P0_leave_time, P0_sum_val, P0_val, P0_next_val, P0_goods_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_sum_val:32, P0_val:32, P0_next_val:32, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43825:16,0:8, D_a_t_a/binary>>};


%% 充值有礼领取 
write(43826, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43826:16,0:8, D_a_t_a/binary>>};


%% 获取在线有礼信息 
write(43828, {P0_leave_time, P0_count, P0_next_time, P0_goods_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_count:32, P0_next_time:32, (length(P0_goods_list)):16, (list_to_binary([<<P1_id:32, P1_state:32, P1_goods_id:32, P1_goods_num:32>> || [P1_id, P1_state, P1_goods_id, P1_goods_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43828:16,0:8, D_a_t_a/binary>>};


%% 在线有礼领奖 
write(43829, {P0_code, P0_id}) ->
    D_a_t_a = <<P0_code:8, P0_id:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43829:16,0:8, D_a_t_a/binary>>};


%% 获取每日任务信息 
write(43831, {P0_leave_time, P0_list}) ->
    D_a_t_a = <<P0_leave_time:32, (length(P0_list)):16, (list_to_binary([<<P1_id:32, P1_type:32, P1_state:32, P1_now_count:32, P1_need_count:32, (length(P1_goods_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_goods_list]))/binary>> || [P1_id, P1_type, P1_state, P1_now_count, P1_need_count, P1_goods_list] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43831:16,0:8, D_a_t_a/binary>>};


%% 每日任务领奖 
write(43832, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43832:16,0:8, D_a_t_a/binary>>};


%% 获取幸运翻牌信息 
write(43835, {P0_leave_time, P0_cost, P0_same_list, P0_card_list, P0_reward_list, P0_log_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_cost:32, (length(P0_same_list)):16, (list_to_binary([<<P1_same:32, (length(P1_goods_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_goods_list]))/binary>> || [P1_same, P1_goods_list] <- P0_same_list]))/binary, (length(P0_card_list)):16, (list_to_binary([<<P1_id:32, P1_state:32, P1_goods_id:32, P1_goods_num:32>> || [P1_id, P1_state, P1_goods_id, P1_goods_num] <- P0_card_list]))/binary, (length(P0_reward_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_reward_list]))/binary, (length(P0_log_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_log_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43835:16,0:8, D_a_t_a/binary>>};


%% 幸运翻牌翻牌 
write(43836, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43836:16,0:8, D_a_t_a/binary>>};


%% 幸运翻牌刷新 
write(43837, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43837:16,0:8, D_a_t_a/binary>>};


%% 获取超值特惠信息 
write(43838, {P0_leave_time, P0_charge_gold, P0_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_charge_gold:32, (length(P0_list)):16, (list_to_binary([<<P1_id:32, P1_base_charge_gold:32, P1_state:8, (length(P1_reward_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_reward_list]))/binary>> || [P1_id, P1_base_charge_gold, P1_state, P1_reward_list] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43838:16,0:8, D_a_t_a/binary>>};


%% 领取超值特惠奖励 
write(43839, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43839:16,0:8, D_a_t_a/binary>>};


%% 获取额外特惠信息 
write(43840, {P0_leave_time, P0_charge_gold, P0_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_charge_gold:32, (length(P0_list)):16, (list_to_binary([<<P1_id:32, P1_base_charge_gold:32, P1_state:8, (length(P1_reward_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_reward_list]))/binary>> || [P1_id, P1_base_charge_gold, P1_state, P1_reward_list] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43840:16,0:8, D_a_t_a/binary>>};


%% 领取额外特惠奖励 
write(43841, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43841:16,0:8, D_a_t_a/binary>>};


%% 等级返利 
write(43842, {P0_list}) ->
    D_a_t_a = <<(length(P0_list)):16, (list_to_binary([<<P1_id:32, P1_need_gold:32, P1_state:8, (length(P1_reward_list)):16, (list_to_binary([<<P2_id2:8, P2_lv:16, P2_backgold:32, P2_is_get:8>> || [P2_id2, P2_lv, P2_backgold, P2_is_get] <- P1_reward_list]))/binary>> || [P1_id, P1_need_gold, P1_state, P1_reward_list] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43842:16,0:8, D_a_t_a/binary>>};


%% 领取等级返利 
write(43843, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43843:16,0:8, D_a_t_a/binary>>};


%% 投资等级返利 
write(43844, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43844:16,0:8, D_a_t_a/binary>>};


%% 秘境神树信息 
write(43845, {P0_leave_time, P0_goods_cost, P0_score, P0_state, P0_goods_id, P0_num1, P0_num2, P0_all_info, P0_one_info, P0_reward_list, P0_sp_list, P0_free_state, P0_next_time}) ->
    D_a_t_a = <<P0_leave_time:32, P0_goods_cost:32, P0_score:32, P0_state:8, P0_goods_id:32, P0_num1:32, P0_num2:32, (length(P0_all_info)):16, (list_to_binary([<<(proto:write_string(P1_nickname))/binary, P1_goods_id:32, P1_goods_num:32>> || [P1_nickname, P1_goods_id, P1_goods_num] <- P0_all_info]))/binary, (length(P0_one_info)):16, (list_to_binary([<<(proto:write_string(P1_nickname))/binary, P1_goods_id:32, P1_goods_num:32>> || [P1_nickname, P1_goods_id, P1_goods_num] <- P0_one_info]))/binary, (length(P0_reward_list)):16, (list_to_binary([<<P1_id:32, P1_goods_id:32, P1_goods_num:32>> || [P1_id, P1_goods_id, P1_goods_num] <- P0_reward_list]))/binary, (length(P0_sp_list)):16, (list_to_binary([<<P1_goods_id2:32, P1_goods_num2:32>> || [P1_goods_id2, P1_goods_num2] <- P0_sp_list]))/binary, P0_free_state:16, P0_next_time:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43845:16,0:8, D_a_t_a/binary>>};


%% 秘境神树信息抽奖 
write(43846, {P0_res, P0_list}) ->
    D_a_t_a = <<P0_res:8, (length(P0_list)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32>> || [P1_goods_id, P1_num] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43846:16,0:8, D_a_t_a/binary>>};


%% 秘境神树积分兑换 
write(43847, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43847:16,0:8, D_a_t_a/binary>>};


%% 获取秘境神树积分商店 
write(43848, {P0_goods_list}) ->
    D_a_t_a = <<(length(P0_goods_list)):16, (list_to_binary([<<P1_id:32, P1_score:32, P1_goods_id:32, P1_num:32>> || [P1_id, P1_score, P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43848:16,0:8, D_a_t_a/binary>>};


%% 秘境神树道具购买 
write(43849, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43849:16,0:8, D_a_t_a/binary>>};


%% 节日首领界面信息 
write(43850, {P0_lefttime, P0_tired, P0_maxtired, P0_boss_info, P0_kill_award, P0_drop_award}) ->
    D_a_t_a = <<P0_lefttime:32, P0_tired:32, P0_maxtired:32, (length(P0_boss_info)):16, (list_to_binary([<<P1_boss_id:32, P1_state:8, P1_scene_id:32, P1_x:16, P1_y:16, P1_rtime:32>> || [P1_boss_id, P1_state, P1_scene_id, P1_x, P1_y, P1_rtime] <- P0_boss_info]))/binary, (length(P0_kill_award)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32>> || [P1_goods_id, P1_num] <- P0_kill_award]))/binary, (length(P0_drop_award)):16, (list_to_binary([<<P1_goods_id2:32, P1_num2:32>> || [P1_goods_id2, P1_num2] <- P0_drop_award]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43850:16,0:8, D_a_t_a/binary>>};


%% 邀请码信息 
write(43852, {P0_invite_code, P0_invite_num, P0_be_invited, P0_reward_info}) ->
    D_a_t_a = <<(proto:write_string(P0_invite_code))/binary, (proto:write_string(P0_invite_num))/binary, P0_be_invited:32, (length(P0_reward_info)):16, (list_to_binary([<<P1_id:32, P1_state:32, P1_num:32, P1_gold:32, P1_type:32, P1_ratio:32>> || [P1_id, P1_state, P1_num, P1_gold, P1_type, P1_ratio] <- P0_reward_info]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43852:16,0:8, D_a_t_a/binary>>};


%% 输入邀请码 
write(43853, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43853:16,0:8, D_a_t_a/binary>>};


%% 集聚英雄信息 
write(43855, {P0_state, P0_charge_gold, P0_registertime_limit, P0_reward_info}) ->
    D_a_t_a = <<P0_state:32, P0_charge_gold:32, P0_registertime_limit:32, (length(P0_reward_info)):16, (list_to_binary([<<P1_id:32, P1_gold:32, (length(P1_state_list)):16, (list_to_binary([<<P2_goods_id:32/signed, P2_goods_num:32/signed>> || [P2_goods_id, P2_goods_num] <- P1_state_list]))/binary>> || [P1_id, P1_gold, P1_state_list] <- P0_reward_info]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43855:16,0:8, D_a_t_a/binary>>};


%% 领取 
write(43856, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43856:16,0:8, D_a_t_a/binary>>};


%% 获取跃升冲榜信息 
write(43857, {P0_leave_time, P0_lv_limit, P0_my_rank, P0_cbp_up, P0_daily_cbp_up, P0_cbp_up_limit, P0_skip_str, P0_up_reward_list, P0_rank_reward_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_lv_limit:16, P0_my_rank:16, P0_cbp_up:32, P0_daily_cbp_up:32, P0_cbp_up_limit:32, (proto:write_string(P0_skip_str))/binary, (length(P0_up_reward_list)):16, (list_to_binary([<<P1_id:32/signed, P1_state:32/signed, P1_cbp_limit:32/signed, (length(P1_goods_list)):16, (list_to_binary([<<P2_goods_id:32/signed, P2_goods_num:32/signed>> || [P2_goods_id, P2_goods_num] <- P1_goods_list]))/binary>> || [P1_id, P1_state, P1_cbp_limit, P1_goods_list] <- P0_up_reward_list]))/binary, (length(P0_rank_reward_list)):16, (list_to_binary([<<P1_rank_top:32/signed, P1_rank_down:32/signed, (proto:write_string(P1_nickname))/binary, (length(P1_final_goods_list)):16, (list_to_binary([<<P2_goods_id:32/signed, P2_goods_num:32/signed>> || [P2_goods_id, P2_goods_num] <- P1_final_goods_list]))/binary, (length(P1_daily_goods_list)):16, (list_to_binary([<<P2_goods_id:32/signed, P2_goods_num:32/signed>> || [P2_goods_id, P2_goods_num] <- P1_daily_goods_list]))/binary>> || [P1_rank_top, P1_rank_down, P1_nickname, P1_final_goods_list, P1_daily_goods_list] <- P0_rank_reward_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43857:16,0:8, D_a_t_a/binary>>};


%% 获取排行榜信息 
write(43858, {P0_my_rank, P0_my_cbp_up, P0_rank_list}) ->
    D_a_t_a = <<P0_my_rank:32/signed, P0_my_cbp_up:32/signed, (length(P0_rank_list)):16, (list_to_binary([<<P1_pkey:32/signed, P1_rank:32/signed, (proto:write_string(P1_nickname))/binary, (proto:write_string(P1_vip))/binary, (proto:write_string(P1_cbp_up))/binary>> || [P1_pkey, P1_rank, P1_nickname, P1_vip, P1_cbp_up] <- P0_rank_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43858:16,0:8, D_a_t_a/binary>>};


%% 领取达标奖励 
write(43859, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43859:16,0:8, D_a_t_a/binary>>};


%% 获取限时奇遇礼包信息 
write(43860, {P0_leave_time, P0_gift_list}) ->
    D_a_t_a = <<P0_leave_time:16, (length(P0_gift_list)):16, (list_to_binary([<<P1_type:32/signed, P1_id:32/signed, P1_state:32/signed, P1_end_time:32/signed, P1_gold:32/signed, P1_need_gold:32/signed, (proto:write_string(P1_desc))/binary, (length(P1_daily_goods_list)):16, (list_to_binary([<<P2_goods_id:32/signed, P2_goods_num:32/signed>> || [P2_goods_id, P2_goods_num] <- P1_daily_goods_list]))/binary>> || [P1_type, P1_id, P1_state, P1_end_time, P1_gold, P1_need_gold, P1_desc, P1_daily_goods_list] <- P0_gift_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43860:16,0:8, D_a_t_a/binary>>};


%% 领取奇遇礼包奖励 
write(43861, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43861:16,0:8, D_a_t_a/binary>>};


%% 获取每日奖励信息 
write(43863, {P0_res, P0_player_list, P0_daily_goods_list}) ->
    D_a_t_a = <<P0_res:8, (length(P0_player_list)):16, (list_to_binary([<<P1_day:32/signed, (proto:write_string(P1_nickname))/binary>> || [P1_day, P1_nickname] <- P0_player_list]))/binary, (length(P0_daily_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_goods_num:32/signed>> || [P1_goods_id, P1_goods_num] <- P0_daily_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43863:16,0:8, D_a_t_a/binary>>};


%% 活动推送 
write(43864, {P0_type}) ->
    D_a_t_a = <<P0_type:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43864:16,0:8, D_a_t_a/binary>>};


%% 获取零元礼包信息 
write(43865, {P0_leave_time, P0_act_list}) ->
    D_a_t_a = <<P0_leave_time:32, (length(P0_act_list)):16, (list_to_binary([<<P1_state:8, P1_get_leave_time:32, P1_type:8, P1_cost:32, P1_delay_day:32, (proto:write_string(P1_desc))/binary, (length(P1_award_list)):16, (list_to_binary([<<P2_goods_id:32, P2_num:32>> || [P2_goods_id, P2_num] <- P1_award_list]))/binary, (length(P1_re_reward_list)):16, (list_to_binary([<<P2_goods_id:32, P2_num:32>> || [P2_goods_id, P2_num] <- P1_re_reward_list]))/binary>> || [P1_state, P1_get_leave_time, P1_type, P1_cost, P1_delay_day, P1_desc, P1_award_list, P1_re_reward_list] <- P0_act_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43865:16,0:8, D_a_t_a/binary>>};


%% 购买零元礼包 
write(43866, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43866:16,0:8, D_a_t_a/binary>>};


%% 返利大厅消费奖励 
write(43871, {P0_leave_time, P0_acc_consume, P0_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_acc_consume:32, (length(P0_list)):16, (list_to_binary([<<P1_base_consume:32, P1_state:8, (length(P1_reward_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_reward_list]))/binary>> || [P1_base_consume, P1_state, P1_reward_list] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43871:16,0:8, D_a_t_a/binary>>};


%% 领取返利大厅消费奖励 
write(43872, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43872:16,0:8, D_a_t_a/binary>>};


%% 获取合服活动之累积消费信息 
write(43873, {P0_leave_time, P0_consume_gold, P0_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_consume_gold:32, (length(P0_list)):16, (list_to_binary([<<P1_base_charge_gold:32, P1_gift_id:32, P1_state:8>> || [P1_base_charge_gold, P1_gift_id, P1_state] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43873:16,0:8, D_a_t_a/binary>>};


%% 领取累积消费奖励 
write(43874, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43874:16,0:8, D_a_t_a/binary>>};


%% 获取活动总入口 
write(43899, {P0_state_list}) ->
    D_a_t_a = <<(length(P0_state_list)):16, (list_to_binary([<<P1_type:32/signed, P1_state:32/signed>> || [P1_type, P1_state] <- P0_state_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43899:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



