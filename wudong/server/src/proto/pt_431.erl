%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-09-18 14:09:48
%%----------------------------------------------------
-module(pt_431).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"还不能领取"; 
err(3) ->"已经领取"; 
err(4) ->"活动还没开启"; 
err(5) ->"元宝不足"; 
err(6) ->"已经领取完了"; 
err(7) ->"幻想徽章不足"; 
err(8) ->"在线奖章不足"; 
err(9) ->"还不能抽奖"; 
err(10) ->"抽奖次数不足"; 
err(11) ->"该物品今天的兑换次数已用完"; 
err(12) ->"兑换材料不足"; 
err(13) ->"次数不足"; 
err(14) ->"没有可领取奖励"; 
err(15) ->"已经领取该礼包"; 
err(16) ->"等级不足"; 
err(17) ->"今日抽奖机会已用完，请明日再来"; 
err(18) ->"金蛋已经被砸"; 
err(19) ->"砸蛋次数不满足"; 
err(20) ->"请刷新后再砸"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(43101, _B0) ->
    {ok, {}};

read(43102, _B0) ->
    {P0_exchange_id, _B1} = proto:read_uint16(_B0),
    {ok, {P0_exchange_id}};

read(43111, _B0) ->
    {ok, {}};

read(43112, _B0) ->
    {ok, {}};

read(43121, _B0) ->
    {ok, {}};

read(43122, _B0) ->
    {P0_id, _B1} = proto:read_uint16(_B0),
    {ok, {P0_id}};

read(43131, _B0) ->
    {ok, {}};

read(43132, _B0) ->
    {P0_times, _B1} = proto:read_uint8(_B0),
    {ok, {P0_times}};

read(43141, _B0) ->
    {ok, {}};

read(43142, _B0) ->
    {P0_times, _B1} = proto:read_uint8(_B0),
    {ok, {P0_times}};

read(43151, _B0) ->
    {ok, {}};

read(43152, _B0) ->
    {P0_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_id}};

read(43161, _B0) ->
    {ok, {}};

read(43162, _B0) ->
    {P0_id, _B1} = proto:read_uint8(_B0),
    {ok, {P0_id}};

read(43171, _B0) ->
    {ok, {}};

read(43172, _B0) ->
    {P0_day, _B1} = proto:read_uint8(_B0),
    {ok, {P0_day}};

read(43181, _B0) ->
    {ok, {}};

read(43182, _B0) ->
    {P0_pos_id, _B1} = proto:read_uint8(_B0),
    {ok, {P0_pos_id}};

read(43183, _B0) ->
    {ok, {}};

read(43187, _B0) ->
    {ok, {}};

read(43189, _B0) ->
    {ok, {}};

read(43190, _B0) ->
    {ok, {}};

read(43191, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {ok, {P0_type}};

read(43192, _B0) ->
    {ok, {}};

read(43193, _B0) ->
    {ok, {}};

read(43194, _B0) ->
    {ok, {}};

read(43195, _B0) ->
    {ok, {}};

read(43196, _B0) ->
    {P0_id, _B1} = proto:read_uint8(_B0),
    {ok, {P0_id}};

read(43197, _B0) ->
    {P0_id, _B1} = proto:read_uint8(_B0),
    {ok, {P0_id}};

read(43199, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 获取兑换活动信息 
write(43101, {P0_leave_time, P0_have_num, P0_act_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_have_num:32, (length(P0_act_list)):16, (list_to_binary([<<P1_exchange_id:16, P1_exchange_num:32, P1_gift_id:32, P1_state:8>> || [P1_exchange_id, P1_exchange_num, P1_gift_id, P1_state] <- P0_act_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43101:16,0:8, D_a_t_a/binary>>};


%% 领取奖励 
write(43102, {P0_res, P0_exchange_num}) ->
    D_a_t_a = <<P0_res:8, P0_exchange_num:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43102:16,0:8, D_a_t_a/binary>>};


%% 获取在线时长奖励活动信息 
write(43111, {P0_online_time, P0_goods_list}) ->
    D_a_t_a = <<P0_online_time:32, (length(P0_goods_list)):16, (list_to_binary([<<P1_need_online_time:32, P1_state:8, P1_get_goods_id:32, P1_get_goods_num:32, (length(P1_goods_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_goods_list]))/binary>> || [P1_need_online_time, P1_state, P1_get_goods_id, P1_get_goods_num, P1_goods_list] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43111:16,0:8, D_a_t_a/binary>>};


%% 在线时长奖励抽奖 
write(43112, {P0_res, P0_goods_list}) ->
    D_a_t_a = <<P0_res:8, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43112:16,0:8, D_a_t_a/binary>>};


%% 获取每日累计充值活动信息 
write(43121, {P0_leave_time, P0_acc_val, P0_act_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_acc_val:32, (length(P0_act_list)):16, (list_to_binary([<<P1_id:16, P1_acc:32, P1_gift_id:32, P1_state:8>> || [P1_id, P1_acc, P1_gift_id, P1_state] <- P0_act_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43121:16,0:8, D_a_t_a/binary>>};


%% 领取奖励 
write(43122, {P0_res, P0_id}) ->
    D_a_t_a = <<P0_res:8, P0_id:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43122:16,0:8, D_a_t_a/binary>>};


%% 获取累充抽奖活动信息 
write(43131, {P0_leave_time, P0_acc_val, P0_one_charge, P0_times, P0_cost_gold, P0_goods_list, P0_record_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_acc_val:32, P0_one_charge:32, P0_times:32, P0_cost_gold:32, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary, (length(P0_record_list)):16, (list_to_binary([<<P1_pkey:32, (proto:write_string(P1_name))/binary, P1_goods_id:32, P1_goods_num:32>> || [P1_pkey, P1_name, P1_goods_id, P1_goods_num] <- P0_record_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43131:16,0:8, D_a_t_a/binary>>};


%% 抽奖 
write(43132, {P0_res, P0_goods_list}) ->
    D_a_t_a = <<P0_res:8, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43132:16,0:8, D_a_t_a/binary>>};


%% 获取累充礼包活动信息 
write(43141, {P0_leave_time, P0_acc_val, P0_one_charge, P0_times, P0_gift_id}) ->
    D_a_t_a = <<P0_leave_time:32, P0_acc_val:32, P0_one_charge:32, P0_times:32, P0_gift_id:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43141:16,0:8, D_a_t_a/binary>>};


%% 抽奖 
write(43142, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43142:16,0:8, D_a_t_a/binary>>};


%% 获取物品兑换活动信息 
write(43151, {P0_leave_time, P0_goods_list}) ->
    D_a_t_a = <<P0_leave_time:32, (length(P0_goods_list)):16, (list_to_binary([<<P1_id:32, (proto:write_string(P1_name))/binary, P1_goods_id:32, P1_goods_num:32, P1_times:32, P1_max_times:32, P1_state:8, (length(P1_cost_goods_list)):16, (list_to_binary([<<P2_cost_goods_id:32, P2_cost_goods_num:32>> || [P2_cost_goods_id, P2_cost_goods_num] <- P1_cost_goods_list]))/binary>> || [P1_id, P1_name, P1_goods_id, P1_goods_num, P1_times, P1_max_times, P1_state, P1_cost_goods_list] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43151:16,0:8, D_a_t_a/binary>>};


%% 兑换 
write(43152, {P0_res, P0_id}) ->
    D_a_t_a = <<P0_res:8, P0_id:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43152:16,0:8, D_a_t_a/binary>>};


%% 获取角色每日累充活动信息 
write(43161, {P0_leave_time, P0_charge, P0_cur_item, P0_gift_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_charge:32, P0_cur_item:8, (length(P0_gift_list)):16, (list_to_binary([<<P1_id:8, P1_charge_val:32, P1_gift_id:32, P1_state:8>> || [P1_id, P1_charge_val, P1_gift_id, P1_state] <- P0_gift_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43161:16,0:8, D_a_t_a/binary>>};


%% 领取 
write(43162, {P0_res, P0_cur_item, P0_id}) ->
    D_a_t_a = <<P0_res:8, P0_cur_item:8, P0_id:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43162:16,0:8, D_a_t_a/binary>>};


%% 获取连续充值活动信息 
write(43171, {P0_leave_time, P0_cur_day, P0_day_list, P0_spe_gift_id, P0_spe_state}) ->
    D_a_t_a = <<P0_leave_time:32, P0_cur_day:8, (length(P0_day_list)):16, (list_to_binary([<<P1_day:8, P1_charge_val:32, P1_need_charge_val:32, P1_gift_id:32, P1_state:8>> || [P1_day, P1_charge_val, P1_need_charge_val, P1_gift_id, P1_state] <- P0_day_list]))/binary, P0_spe_gift_id:32, P0_spe_state:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43171:16,0:8, D_a_t_a/binary>>};


%% 领取 
write(43172, {P0_res, P0_day}) ->
    D_a_t_a = <<P0_res:8, P0_day:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43172:16,0:8, D_a_t_a/binary>>};


%% 获取砸蛋活动信息 
write(43181, {P0_leave_time, P0_one_charge, P0_charge_val, P0_levae_times, P0_cost_gold, P0_mul, P0_goods_list, P0_egg_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_one_charge:32, P0_charge_val:32, P0_levae_times:32, P0_cost_gold:32, P0_mul:8, (length(P0_goods_list)):16, (list_to_binary([<<P1_id:8, P1_goods_id:32, P1_num:32, P1_lv:8, P1_state:8>> || [P1_id, P1_goods_id, P1_num, P1_lv, P1_state] <- P0_goods_list]))/binary, (length(P0_egg_list)):16, (list_to_binary([<<P1_pos_id:8, P1_state:8, P1_goods_id:32, P1_num:32>> || [P1_pos_id, P1_state, P1_goods_id, P1_num] <- P0_egg_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43181:16,0:8, D_a_t_a/binary>>};


%% 砸蛋 
write(43182, {P0_res, P0_pos_id, P0_goods_id, P0_num, P0_lv, P0_mul}) ->
    D_a_t_a = <<P0_res:8, P0_pos_id:8, P0_goods_id:32, P0_num:32, P0_lv:8, P0_mul:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43182:16,0:8, D_a_t_a/binary>>};


%% 刷新 
write(43183, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43183:16,0:8, D_a_t_a/binary>>};


%% 获取GM奖励信息 
write(43187, {P0_res, P0_award_list}) ->
    D_a_t_a = <<P0_res:8, (length(P0_award_list)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32>> || [P1_goods_id, P1_num] <- P0_award_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43187:16,0:8, D_a_t_a/binary>>};


%% GM反馈成功 
write(43189, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43189:16,0:8, D_a_t_a/binary>>};


%% 获取零元礼包信息 
write(43190, {P0_leave_time, P0_act_list}) ->
    D_a_t_a = <<P0_leave_time:32, (length(P0_act_list)):16, (list_to_binary([<<P1_state:8, P1_get_leave_time:32, P1_type:8, P1_cost:32, P1_delay_day:32, (proto:write_string(P1_desc))/binary, (length(P1_award_list)):16, (list_to_binary([<<P2_goods_id:32, P2_num:32>> || [P2_goods_id, P2_num] <- P1_award_list]))/binary, (length(P1_re_reward_list)):16, (list_to_binary([<<P2_goods_id:32, P2_num:32>> || [P2_goods_id, P2_num] <- P1_re_reward_list]))/binary>> || [P1_state, P1_get_leave_time, P1_type, P1_cost, P1_delay_day, P1_desc, P1_award_list, P1_re_reward_list] <- P0_act_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43190:16,0:8, D_a_t_a/binary>>};


%% 购买零元礼包 
write(43191, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43191:16,0:8, D_a_t_a/binary>>};


%% 获取新招财猫信息 
write(43192, {P0_leave_time, P0_act_id, P0_cost, P0_ratio_list, P0_notice_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_act_id:32, P0_cost:32, (length(P0_ratio_list)):16, (list_to_binary([<<P1_id:32, P1_ratio:32>> || [P1_id, P1_ratio] <- P0_ratio_list]))/binary, (length(P0_notice_list)):16, (list_to_binary([<<(proto:write_string(P1_nickname))/binary, P1_cost:32, P1_ratio:32>> || [P1_nickname, P1_cost, P1_ratio] <- P0_notice_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43192:16,0:8, D_a_t_a/binary>>};


%% 招财新猫抽奖 
write(43193, {P0_code, P0_id, P0_gold}) ->
    D_a_t_a = <<P0_code:8, P0_id:32, P0_gold:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43193:16,0:8, D_a_t_a/binary>>};


%% 获取疯狂砸蛋信息 
write(43194, {P0_leave_time, P0_count, P0_free_count, P0_cost, P0_re_cost, P0_free_time, P0_reward_list, P0_count_reward_list, P0_egg_list, P0_notice_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_count:32, P0_free_count:32, P0_cost:32, P0_re_cost:32, P0_free_time:32, (length(P0_reward_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_reward_list]))/binary, (length(P0_count_reward_list)):16, (list_to_binary([<<P1_id:32, P1_count:32, P1_state:32, P1_goods_id:32, P1_goods_num:32>> || [P1_id, P1_count, P1_state, P1_goods_id, P1_goods_num] <- P0_count_reward_list]))/binary, (length(P0_egg_list)):16, (list_to_binary([<<P1_id:32, P1_state:8, P1_type:8, P1_goods_id:32, P1_goods_num:32>> || [P1_id, P1_state, P1_type, P1_goods_id, P1_goods_num] <- P0_egg_list]))/binary, (length(P0_notice_list)):16, (list_to_binary([<<(proto:write_string(P1_nickname))/binary, P1_goods_id:32, P1_goods_num:32>> || [P1_nickname, P1_goods_id, P1_goods_num] <- P0_notice_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43194:16,0:8, D_a_t_a/binary>>};


%% 疯狂砸蛋刷新 
write(43195, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43195:16,0:8, D_a_t_a/binary>>};


%% 疯狂砸蛋砸蛋 
write(43196, {P0_code, P0_egg_list}) ->
    D_a_t_a = <<P0_code:8, (length(P0_egg_list)):16, (list_to_binary([<<P1_id:32, P1_state:8, P1_type:8, P1_goods_id:32, P1_goods_num:32>> || [P1_id, P1_state, P1_type, P1_goods_id, P1_goods_num] <- P0_egg_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43196:16,0:8, D_a_t_a/binary>>};


%% 疯狂砸蛋-领取次数奖励 
write(43197, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43197:16,0:8, D_a_t_a/binary>>};


%% 获取开服广告 
write(43199, {P0_open_day, P0_pic_list}) ->
    D_a_t_a = <<P0_open_day:8, (length(P0_pic_list)):16, (list_to_binary([<<P1_pic_id:32, P1_link_id:32>> || [P1_pic_id, P1_link_id] <- P0_pic_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43199:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



