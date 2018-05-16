%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-11-07 15:32:25
%%----------------------------------------------------
-module(pt_432).
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
err(7) ->"没有掷骰子次数了"; 
err(8) ->"当前位置不需要掷骰子"; 
err(9) ->"会员等级不足"; 
err(10) ->"购买次数已达上限"; 
err(11) ->"每日兑换次数不足"; 
err(12) ->"兑换材料不足"; 
err(13) ->"兑换图纸已拥有"; 
err(14) ->"原石鉴定材料不足"; 
err(15) ->"积分不足"; 
err(16) ->"充值天数不足"; 
err(17) ->"充值金额不足"; 
err(18) ->"秘宝密匙不足"; 
err(19) ->"积分不足"; 
err(20) ->"请刷新后再砸"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(43201, _B0) ->
    {ok, {}};

read(43202, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {P0_day, _B2} = proto:read_uint16(_B1),
    {ok, {P0_type, P0_day}};

read(43211, _B0) ->
    {ok, {}};

read(43221, _B0) ->
    {ok, {}};

read(43231, _B0) ->
    {ok, {}};

read(43232, _B0) ->
    {P0_type, _B1} = proto:read_uint16(_B0),
    {ok, {P0_type}};

read(43241, _B0) ->
    {ok, {}};

read(43251, _B0) ->
    {ok, {}};

read(43252, _B0) ->
    {P0_auto_buy, _B1} = proto:read_uint8(_B0),
    {ok, {P0_auto_buy}};

read(43253, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {ok, {P0_type}};

read(43254, _B0) ->
    {ok, {}};

read(43255, _B0) ->
    {P0_id, _B1} = proto:read_uint8(_B0),
    {ok, {P0_id}};

read(43256, _B0) ->
    {P0_round, _B1} = proto:read_uint8(_B0),
    {ok, {P0_round}};

read(43257, _B0) ->
    {ok, {}};

read(43261, _B0) ->
    {ok, {}};

read(43262, _B0) ->
    {P0_vip_lv, _B1} = proto:read_uint8(_B0),
    {ok, {P0_vip_lv}};

read(43264, _B0) ->
    {ok, {}};

read(43265, _B0) ->
    {ok, {}};

read(43266, _B0) ->
    {P0_charge_gold, _B1} = proto:read_uint32(_B0),
    {ok, {P0_charge_gold}};

read(43267, _B0) ->
    {ok, {}};

read(43268, _B0) ->
    {ok, {}};

read(43270, _B0) ->
    {ok, {}};

read(43271, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {ok, {P0_type}};

read(43272, _B0) ->
    {P0_id, _B1} = proto:read_uint16(_B0),
    {P0_num, _B2} = proto:read_uint16(_B1),
    {ok, {P0_id, P0_num}};

read(43273, _B0) ->
    {ok, {}};

read(43274, _B0) ->
    {ok, {}};

read(43275, _B0) ->
    {P0_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_id}};

read(43276, _B0) ->
    {ok, {}};

read(43277, _B0) ->
    {P0_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_id}};

read(43280, _B0) ->
    {ok, {}};

read(43281, _B0) ->
    {ok, {}};

read(43282, _B0) ->
    {ok, {}};

read(43283, _B0) ->
    {ok, {}};

read(43284, _B0) ->
    {ok, {}};

read(43285, _B0) ->
    {ok, {}};

read(43286, _B0) ->
    {ok, {}};

read(43287, _B0) ->
    {ok, {}};

read(43288, _B0) ->
    {ok, {}};

read(43289, _B0) ->
    {P0_id, _B1} = proto:read_uint16(_B0),
    {ok, {P0_id}};

read(43290, _B0) ->
    {P0_id, _B1} = proto:read_uint16(_B0),
    {ok, {P0_id}};

read(43291, _B0) ->
    {ok, {}};

read(43292, _B0) ->
    {P0_type, _B1} = proto:read_uint16(_B0),
    {ok, {P0_type}};

read(43293, _B0) ->
    {ok, {}};

read(43294, _B0) ->
    {P0_type, _B1} = proto:read_uint16(_B0),
    {P0_is_auto, _B2} = proto:read_uint16(_B1),
    {ok, {P0_type, P0_is_auto}};

read(43295, _B0) ->
    {P0_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_id}};

read(43296, _B0) ->
    {ok, {}};

read(43297, _B0) ->
    {P0_num, _B1} = proto:read_uint32(_B0),
    {ok, {P0_num}};

read(43299, _B0) ->
    {P0_des_id, _B1} = proto:read_uint8(_B0),
    {ok, {P0_des_id}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 获取合服签到活动信息 
write(43201, {P0_leave_time, P0_cur_day, P0_sign_in_list, P0_pt_gift_id, P0_pt_state, P0_zz_cur_day, P0_zz_sign_in_list, P0_zz_gift_id, P0_zz_state}) ->
    D_a_t_a = <<P0_leave_time:32, P0_cur_day:8, (length(P0_sign_in_list)):16, (list_to_binary([<<P1_day:16, P1_gift_id:32, P1_state:8>> || [P1_day, P1_gift_id, P1_state] <- P0_sign_in_list]))/binary, P0_pt_gift_id:32, P0_pt_state:8, P0_zz_cur_day:8, (length(P0_zz_sign_in_list)):16, (list_to_binary([<<P1_day:16, P1_charge_val:32, P1_need_charge_val:32, P1_gift_id:32, P1_state:8>> || [P1_day, P1_charge_val, P1_need_charge_val, P1_gift_id, P1_state] <- P0_zz_sign_in_list]))/binary, P0_zz_gift_id:32, P0_zz_state:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43201:16,0:8, D_a_t_a/binary>>};


%% 领取奖励 
write(43202, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43202:16,0:8, D_a_t_a/binary>>};


%% 获取充值多倍活动信息 
write(43211, {P0_leave_time, P0_charge_list}) ->
    D_a_t_a = <<P0_leave_time:32, (length(P0_charge_list)):16, (list_to_binary([<<P1_min_gold:32, P1_max_gold:32, P1_mul:16>> || [P1_min_gold, P1_max_gold, P1_mul] <- P0_charge_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43211:16,0:8, D_a_t_a/binary>>};


%% 获取仙盟排行活动信息 
write(43221, {P0_leave_time, P0_rank_list}) ->
    D_a_t_a = <<P0_leave_time:32, (length(P0_rank_list)):16, (list_to_binary([<<P1_rank:8, P1_gift_id:32, (proto:write_string(P1_name))/binary, P1_cbp:32>> || [P1_rank, P1_gift_id, P1_name, P1_cbp] <- P0_rank_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43221:16,0:8, D_a_t_a/binary>>};


%% 获取活动信息 
write(43231, {P0_leave_time, P0_act_list}) ->
    D_a_t_a = <<P0_leave_time:32, (length(P0_act_list)):16, (list_to_binary([<<P1_type:16, P1_gift_id:32, P1_target_val:32, P1_cur_val:32, P1_state:8>> || [P1_type, P1_gift_id, P1_target_val, P1_cur_val, P1_state] <- P0_act_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43231:16,0:8, D_a_t_a/binary>>};


%% 领取奖励 
write(43232, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43232:16,0:8, D_a_t_a/binary>>};


%% 获取信息 
write(43241, {P0_leave_time}) ->
    D_a_t_a = <<P0_leave_time:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43241:16,0:8, D_a_t_a/binary>>};


%% 获取大富翁信息 
write(43251, {P0_leave_time, P0_gift_icon, P0_dice_num, P0_cost_gold, P0_cell_list, P0_cur_dice, P0_gift_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_gift_icon:32, P0_dice_num:16, P0_cost_gold:32, (length(P0_cell_list)):16, (list_to_binary([<<P1_id:8, P1_type:16, P1_state:8>> || [P1_id, P1_type, P1_state] <- P0_cell_list]))/binary, P0_cur_dice:8, (length(P0_gift_list)):16, (list_to_binary([<<P1_num:8, P1_gift_id:32, P1_gift_state:8>> || [P1_num, P1_gift_id, P1_gift_state] <- P0_gift_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43251:16,0:8, D_a_t_a/binary>>};


%% 掷骰子 
write(43252, {P0_res, P0_point, P0_is_new_round, P0_cur_dice, P0_type, P0_msg, P0_cost_gold}) ->
    D_a_t_a = <<P0_res:8, P0_point:8, P0_is_new_round:8, P0_cur_dice:8, P0_type:16, (proto:write_string(P0_msg))/binary, P0_cost_gold:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43252:16,0:8, D_a_t_a/binary>>};


%% 猜拳 
write(43253, {P0_res, P0_type, P0_type2, P0_coin}) ->
    D_a_t_a = <<P0_res:8, P0_type:8, P0_type2:8, P0_coin:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43253:16,0:8, D_a_t_a/binary>>};


%% 获得骰子的任务列表 
write(43254, {P0_task_list}) ->
    D_a_t_a = <<(length(P0_task_list)):16, (list_to_binary([<<P1_id:8, (proto:write_string(P1_msg))/binary, P1_times:32, P1_finish_times:32, P1_get_num:8, P1_state:8>> || [P1_id, P1_msg, P1_times, P1_finish_times, P1_get_num, P1_state] <- P0_task_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43254:16,0:8, D_a_t_a/binary>>};


%% 领取骰子 
write(43255, {P0_res, P0_dice_num}) ->
    D_a_t_a = <<P0_res:8, P0_dice_num:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43255:16,0:8, D_a_t_a/binary>>};


%% 领取圈数奖励 
write(43256, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43256:16,0:8, D_a_t_a/binary>>};


%% 刷新格子事件 服务端推送 
write(43257, {P0_is_midnight}) ->
    D_a_t_a = <<P0_is_midnight:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43257:16,0:8, D_a_t_a/binary>>};


%% 获取活动信息 
write(43261, {P0_leave_time, P0_gift_list}) ->
    D_a_t_a = <<P0_leave_time:32, (length(P0_gift_list)):16, (list_to_binary([<<P1_vip_lv:8, P1_gift_id:32, P1_gold:32, P1_old_gold:32, P1_max_times:32, P1_buy_times:32>> || [P1_vip_lv, P1_gift_id, P1_gold, P1_old_gold, P1_max_times, P1_buy_times] <- P0_gift_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43261:16,0:8, D_a_t_a/binary>>};


%% 购买 
write(43262, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43262:16,0:8, D_a_t_a/binary>>};


%% 通知客户端弹框 
write(43264, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43264:16,0:8, D_a_t_a/binary>>};


%% 花千骨每日首充，获取活动信息 
write(43265, {P0_leave_time, P0_charge_gold, P0_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_charge_gold:32, (length(P0_list)):16, (list_to_binary([<<P1_acc:32, P1_gift_id:32, P1_is_recv:8, P1_is_acc:8>> || [P1_acc, P1_gift_id, P1_is_recv, P1_is_acc] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43265:16,0:8, D_a_t_a/binary>>};


%% 领取奖励 
write(43266, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43266:16,0:8, D_a_t_a/binary>>};


%% 多倍经验活动通知 
write(43267, {P0_state, P0_time}) ->
    D_a_t_a = <<P0_state:8, P0_time:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43267:16,0:8, D_a_t_a/binary>>};


%% 多倍经验活动信息 
write(43268, {P0_state, P0_time, P0_exp, P0_multiple}) ->
    D_a_t_a = <<P0_state:8, P0_time:16/signed, P0_exp:32/signed, P0_multiple:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43268:16,0:8, D_a_t_a/binary>>};


%% 获取抽奖转盘信息 
write(43270, {P0_leave_time, P0_score, P0_daily_count, P0_index, P0_refresh_cost, P0_ont_cost, P0_ten_cost, P0_cell_list, P0_gift_list, P0_turn_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_score:32, P0_daily_count:32, P0_index:8, P0_refresh_cost:32, P0_ont_cost:32, P0_ten_cost:32, (length(P0_cell_list)):16, (list_to_binary([<<P1_id:8, P1_goods_id:32, P1_goods_num:32, P1_value:16>> || [P1_id, P1_goods_id, P1_goods_num, P1_value] <- P0_cell_list]))/binary, (length(P0_gift_list)):16, (list_to_binary([<<P1_id:16, P1_goods_id:32, P1_num:32, P1_count:16, P1_limit:16, P1_cost:16>> || [P1_id, P1_goods_id, P1_num, P1_count, P1_limit, P1_cost] <- P0_gift_list]))/binary, (length(P0_turn_list)):16, (list_to_binary([<<P1_id:8, (length(P1_turn_list_info)):16, (list_to_binary([<<P2_id:8, P2_goods_id:32, P2_goods_num:32>> || [P2_id, P2_goods_id, P2_goods_num] <- P1_turn_list_info]))/binary>> || [P1_id, P1_turn_list_info] <- P0_turn_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43270:16,0:8, D_a_t_a/binary>>};


%% 抽奖转盘抽奖 
write(43271, {P0_res, P0_id, P0_goods_list}) ->
    D_a_t_a = <<P0_res:8, P0_id:8, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43271:16,0:8, D_a_t_a/binary>>};


%% 抽奖转盘兑换 
write(43272, {P0_res, P0_score}) ->
    D_a_t_a = <<P0_res:8, P0_score:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43272:16,0:8, D_a_t_a/binary>>};


%% 抽奖转盘刷新 
write(43273, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43273:16,0:8, D_a_t_a/binary>>};


%% 获取物品兑换活动信息 
write(43274, {P0_times, P0_max_times, P0_goods_list}) ->
    D_a_t_a = <<P0_times:32, P0_max_times:32, (length(P0_goods_list)):16, (list_to_binary([<<P1_id:32, P1_goods_id:32, P1_goods_num:32, P1_state:8, (length(P1_cost_goods_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_cost_goods_list]))/binary>> || [P1_id, P1_goods_id, P1_goods_num, P1_state, P1_cost_goods_list] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43274:16,0:8, D_a_t_a/binary>>};


%% 兑换 
write(43275, {P0_res, P0_id}) ->
    D_a_t_a = <<P0_res:8, P0_id:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43275:16,0:8, D_a_t_a/binary>>};


%% 获取原石鉴定信息 
write(43276, {P0_goods_list}) ->
    D_a_t_a = <<(length(P0_goods_list)):16, (list_to_binary([<<P1_id:32, P1_state:8, (length(P1_cost_goods_list)):16, (list_to_binary([<<P2_goods_id:32, P2_num:32>> || [P2_goods_id, P2_num] <- P1_cost_goods_list]))/binary, (length(P1_get_goods_list)):16, (list_to_binary([<<P2_goods_id:32, P2_num:32>> || [P2_goods_id, P2_num] <- P1_get_goods_list]))/binary>> || [P1_id, P1_state, P1_cost_goods_list, P1_get_goods_list] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43276:16,0:8, D_a_t_a/binary>>};


%% 鉴定 
write(43277, {P0_res, P0_id, P0_goods_list}) ->
    D_a_t_a = <<P0_res:8, P0_id:32, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43277:16,0:8, D_a_t_a/binary>>};


%% 获取百倍返利信息 
write(43280, {P0_leave_time, P0_state, P0_cost, P0_value, P0_goods_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_state:32, P0_cost:32, P0_value:32, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43280:16,0:8, D_a_t_a/binary>>};


%% 购买百倍返利 
write(43281, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43281:16,0:8, D_a_t_a/binary>>};


%% 百倍返利弹框 
write(43282, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43282:16,0:8, D_a_t_a/binary>>};


%% 消费排行榜(单服) 
write(43283, {P0_leave_time, P0_consume, P0_my_rank, P0_rank_list, P0_reward_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_consume:32, P0_my_rank:32, (length(P0_rank_list)):16, (list_to_binary([<<P1_rank:32, (proto:write_string(P1_nickname))/binary, P1_consume_gold:32>> || [P1_rank, P1_nickname, P1_consume_gold] <- P0_rank_list]))/binary, (length(P0_reward_list)):16, (list_to_binary([<<P1_rank_top:32, P1_rank_down:32, P1_limit:32, (length(P1_award_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_award_list]))/binary>> || [P1_rank_top, P1_rank_down, P1_limit, P1_award_list] <- P0_reward_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43283:16,0:8, D_a_t_a/binary>>};


%% 充值排行榜(单服) 
write(43284, {P0_leave_time, P0_recharge, P0_my_rank, P0_rank_list, P0_reward_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_recharge:32, P0_my_rank:32, (length(P0_rank_list)):16, (list_to_binary([<<P1_rank:32, (proto:write_string(P1_nickname))/binary, P1_recharge_gold:32>> || [P1_rank, P1_nickname, P1_recharge_gold] <- P0_rank_list]))/binary, (length(P0_reward_list)):16, (list_to_binary([<<P1_rank_top:32, P1_rank_down:32, P1_limit:32, (length(P1_award_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_award_list]))/binary>> || [P1_rank_top, P1_rank_down, P1_limit, P1_award_list] <- P0_reward_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43284:16,0:8, D_a_t_a/binary>>};


%% 消费排行榜(跨服) 
write(43285, {P0_leave_time, P0_consume, P0_my_rank, P0_rank_list, P0_reward_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_consume:32, P0_my_rank:32, (length(P0_rank_list)):16, (list_to_binary([<<P1_rank:16, P1_pkey:32/signed, P1_sn:32, (proto:write_string(P1_nickname))/binary, P1_consume_gold:32>> || [P1_rank, P1_pkey, P1_sn, P1_nickname, P1_consume_gold] <- P0_rank_list]))/binary, (length(P0_reward_list)):16, (list_to_binary([<<P1_rank_top:32, P1_rank_down:32, P1_limit:32, (length(P1_award_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_award_list]))/binary>> || [P1_rank_top, P1_rank_down, P1_limit, P1_award_list] <- P0_reward_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43285:16,0:8, D_a_t_a/binary>>};


%% 充值排行榜(跨服) 
write(43286, {P0_leave_time, P0_recharge, P0_my_rank, P0_rank_list, P0_reward_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_recharge:32, P0_my_rank:32, (length(P0_rank_list)):16, (list_to_binary([<<P1_rank:16, P1_pkey:32/signed, P1_sn:32, (proto:write_string(P1_nickname))/binary, P1_recharge_gold:32>> || [P1_rank, P1_pkey, P1_sn, P1_nickname, P1_recharge_gold] <- P0_rank_list]))/binary, (length(P0_reward_list)):16, (list_to_binary([<<P1_rank_top:32, P1_rank_down:32, P1_limit:32, (length(P1_award_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_award_list]))/binary>> || [P1_rank_top, P1_rank_down, P1_limit, P1_award_list] <- P0_reward_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43286:16,0:8, D_a_t_a/binary>>};


%% 充值、消费榜状态 
write(43287, {P0_open_day, P0_consume_rank_state, P0_recharge_rank_state, P0_cross_consume_rank_state, P0_cross_recharge_rank_state, P0_area_consume_rank_state, P0_area_recharge_rank_state}) ->
    D_a_t_a = <<P0_open_day:16, P0_consume_rank_state:8/signed, P0_recharge_rank_state:8/signed, P0_cross_consume_rank_state:8/signed, P0_cross_recharge_rank_state:8/signed, P0_area_consume_rank_state:8/signed, P0_area_recharge_rank_state:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43287:16,0:8, D_a_t_a/binary>>};


%% 获取连续充值状态 
write(43288, {P0_leave_time, P0_acc_val, P0_daily_list, P0_con_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_acc_val:32, (length(P0_daily_list)):16, (list_to_binary([<<P1_id:16, P1_state:16, P1_gold:16, (length(P1_goods_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_goods_list]))/binary>> || [P1_id, P1_state, P1_gold, P1_goods_list] <- P0_daily_list]))/binary, (length(P0_con_list)):16, (list_to_binary([<<P1_gold:32, P1_act_state:32, P1_need_gold:32, (length(P1_con_info_list)):16, (list_to_binary([<<P2_id:16, P2_state:16, P2_day:16, P2_days:16, (length(P2_goods_list)):16, (list_to_binary([<<P3_goods_id:32, P3_goods_num:32>> || [P3_goods_id, P3_goods_num] <- P2_goods_list]))/binary>> || [P2_id, P2_state, P2_day, P2_days, P2_goods_list] <- P1_con_info_list]))/binary>> || [P1_gold, P1_act_state, P1_need_gold, P1_con_info_list] <- P0_con_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43288:16,0:8, D_a_t_a/binary>>};


%% 连续充值活动 兑换累计奖励 
write(43289, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43289:16,0:8, D_a_t_a/binary>>};


%% 连续充值活动 兑换每日奖励 
write(43290, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43290:16,0:8, D_a_t_a/binary>>};


%% 获取金银塔信息 
write(43291, {P0_leave_time, P0_fashion_id, P0_count, P0_index, P0_cost_ont, P0_cost_ten, P0_cost_fifty, P0_con_info_list, P0_general_info}) ->
    D_a_t_a = <<P0_leave_time:32, P0_fashion_id:32, P0_count:32, P0_index:8, P0_cost_ont:32, P0_cost_ten:32, P0_cost_fifty:32, (length(P0_con_info_list)):16, (list_to_binary([<<P1_floor:16, P1_make_goods_id:32, (length(P1_goods_list)):16, (list_to_binary([<<P2_id:32, P2_goods_id:32, P2_goods_num:32>> || [P2_id, P2_goods_id, P2_goods_num] <- P1_goods_list]))/binary>> || [P1_floor, P1_make_goods_id, P1_goods_list] <- P0_con_info_list]))/binary, (length(P0_general_info)):16, (list_to_binary([<<(proto:write_string(P1_nickname))/binary, P1_goods_id:32, P1_goods_num:32>> || [P1_nickname, P1_goods_id, P1_goods_num] <- P0_general_info]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43291:16,0:8, D_a_t_a/binary>>};


%% 金银塔抽奖 
write(43292, {P0_res, P0_before_floor, P0_later_floor, P0_id, P0_reward_list}) ->
    D_a_t_a = <<P0_res:8, P0_before_floor:8, P0_later_floor:8, P0_id:8, (length(P0_reward_list)):16, (list_to_binary([<<P1_floor:32, (length(P1_goods_list)):16, (list_to_binary([<<P2_goods_id:32, P2_num:32>> || [P2_goods_id, P2_num] <- P1_goods_list]))/binary>> || [P1_floor, P1_goods_list] <- P0_reward_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43292:16,0:8, D_a_t_a/binary>>};


%% 获取天宫寻宝信息 
write(43293, {P0_leave_time, P0_goods_cost, P0_score, P0_state, P0_goods_id, P0_num1, P0_num2, P0_sp_list, P0_all_info, P0_one_info, P0_reward_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_goods_cost:32, P0_score:32, P0_state:32, P0_goods_id:32, P0_num1:32, P0_num2:32, (length(P0_sp_list)):16, (list_to_binary([<<P1_id:32>> || P1_id <- P0_sp_list]))/binary, (length(P0_all_info)):16, (list_to_binary([<<(proto:write_string(P1_nickname))/binary, P1_goods_id:32, P1_goods_num:32>> || [P1_nickname, P1_goods_id, P1_goods_num] <- P0_all_info]))/binary, (length(P0_one_info)):16, (list_to_binary([<<(proto:write_string(P1_nickname))/binary, P1_goods_id:32, P1_goods_num:32>> || [P1_nickname, P1_goods_id, P1_goods_num] <- P0_one_info]))/binary, (length(P0_reward_list)):16, (list_to_binary([<<P1_id:32, P1_goods_id:32, P1_goods_num:32>> || [P1_id, P1_goods_id, P1_goods_num] <- P0_reward_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43293:16,0:8, D_a_t_a/binary>>};


%% 天宫寻宝抽奖 
write(43294, {P0_res, P0_list}) ->
    D_a_t_a = <<P0_res:8, (length(P0_list)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32>> || [P1_goods_id, P1_num] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43294:16,0:8, D_a_t_a/binary>>};


%% 天宫寻宝积分兑换 
write(43295, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43295:16,0:8, D_a_t_a/binary>>};


%% 获取天宫寻宝积分商店 
write(43296, {P0_goods_list}) ->
    D_a_t_a = <<(length(P0_goods_list)):16, (list_to_binary([<<P1_id:32, P1_score:32, P1_goods_id:32, P1_num:32>> || [P1_id, P1_score, P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43296:16,0:8, D_a_t_a/binary>>};


%% 天宫寻宝道具购买 
write(43297, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43297:16,0:8, D_a_t_a/binary>>};


%% 合服活动 
write(43299, {P0_act_list}) ->
    D_a_t_a = <<(length(P0_act_list)):16, (list_to_binary([<<P1_des_id:8, P1_state:8/signed, P1_leave_time:32/signed>> || [P1_des_id, P1_state, P1_leave_time] <- P0_act_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43299:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



