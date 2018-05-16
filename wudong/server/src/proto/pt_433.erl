%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2018-04-17 20:48:29
%%----------------------------------------------------
-module(pt_433).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"还不能领取"; 
err(3) ->"已经领取"; 
err(4) ->"活动还没开启"; 
err(5) ->"元宝不足"; 
err(6) ->"已经投资"; 
err(7) ->"已经开启"; 
err(8) ->"到终点了"; 
err(9) ->"抢购未开始"; 
err(10) ->"全服抢购次数不足"; 
err(11) ->"抢购次数不足"; 
err(12) ->"抢购结束"; 
err(13) ->"本轮全部开启"; 
err(14) ->"在线时间不足"; 
err(15) ->"兑换次数不足"; 
err(16) ->"兑换材料不足"; 
err(17) ->"今日还没充值"; 
err(18) ->"购买次数不足"; 
err(19) ->"次数不足"; 
err(20) ->"消耗材料不足"; 
err(21) ->"装备已达上限"; 
err(22) ->"装备已达上限"; 
err(23) ->"今日已经参与"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(43300, _B0) ->
    {ok, {}};

read(43301, _B0) ->
    {ok, {}};

read(43302, _B0) ->
    {P0_act_type, _B1} = proto:read_uint8(_B0),
    {P0_act_args, _B2} = proto:read_uint32(_B1),
    {ok, {P0_act_type, P0_act_args}};

read(43305, _B0) ->
    {ok, {}};

read(43306, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {P0_args, _B2} = proto:read_uint32(_B1),
    {ok, {P0_type, P0_args}};

read(43311, _B0) ->
    {ok, {}};

read(43312, _B0) ->
    {P0_base_group_num, _B1} = proto:read_uint16(_B0),
    {P0_base_charge_gold, _B2} = proto:read_uint32(_B1),
    {ok, {P0_base_group_num, P0_base_charge_gold}};

read(43315, _B0) ->
    {ok, {}};

read(43316, _B0) ->
    {P0_base_charge_gold, _B1} = proto:read_uint32(_B0),
    {ok, {P0_base_charge_gold}};

read(43317, _B0) ->
    {ok, {}};

read(43318, _B0) ->
    {P0_act_type, _B1} = proto:read_uint8(_B0),
    {P0_base_lv, _B2} = proto:read_uint16(_B1),
    {P0_base_num, _B3} = proto:read_uint32(_B2),
    {ok, {P0_act_type, P0_base_lv, P0_base_num}};

read(43319, _B0) ->
    {ok, {}};

read(43320, _B0) ->
    {P0_act_type, _B1} = proto:read_uint8(_B0),
    {P0_base_lv, _B2} = proto:read_uint16(_B1),
    {P0_base_num, _B3} = proto:read_uint32(_B2),
    {ok, {P0_act_type, P0_base_lv, P0_base_num}};

read(43321, _B0) ->
    {ok, {}};

read(43322, _B0) ->
    {P0_act_type, _B1} = proto:read_uint8(_B0),
    {P0_base_lv, _B2} = proto:read_uint16(_B1),
    {P0_base_num, _B3} = proto:read_uint32(_B2),
    {ok, {P0_act_type, P0_base_lv, P0_base_num}};

read(43325, _B0) ->
    {ok, {}};

read(43326, _B0) ->
    {ok, {}};

read(43327, _B0) ->
    {P0_open_day, _B1} = proto:read_uint8(_B0),
    {ok, {P0_open_day}};

read(43328, _B0) ->
    {ok, {}};

read(43330, _B0) ->
    {ok, {}};

read(43331, _B0) ->
    {ok, {}};

read(43332, _B0) ->
    {ok, {}};

read(43333, _B0) ->
    {ok, {}};

read(43335, _B0) ->
    {ok, {}};

read(43336, _B0) ->
    {ok, {}};

read(43337, _B0) ->
    {P0_id, _B1} = proto:read_uint8(_B0),
    {ok, {P0_id}};

read(43338, _B0) ->
    {ok, {}};

read(43341, _B0) ->
    {ok, {}};

read(43342, _B0) ->
    {P0_base_lv, _B1} = proto:read_uint8(_B0),
    {ok, {P0_base_lv}};

read(43343, _B0) ->
    {ok, {}};

read(43344, _B0) ->
    {P0_base_lv, _B1} = proto:read_uint8(_B0),
    {ok, {P0_base_lv}};

read(43345, _B0) ->
    {ok, {}};

read(43346, _B0) ->
    {P0_base_lv, _B1} = proto:read_uint8(_B0),
    {ok, {P0_base_lv}};

read(43351, _B0) ->
    {ok, {}};

read(43355, _B0) ->
    {ok, {}};

read(43356, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {P0_args, _B2} = proto:read_uint32(_B1),
    {ok, {P0_type, P0_args}};

read(43357, _B0) ->
    {ok, {}};

read(43358, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {P0_args, _B2} = proto:read_uint32(_B1),
    {ok, {P0_type, P0_args}};

read(43361, _B0) ->
    {ok, {}};

read(43362, _B0) ->
    {P0_id, _B1} = proto:read_uint16(_B0),
    {ok, {P0_id}};

read(43363, _B0) ->
    {P0_num, _B1} = proto:read_uint16(_B0),
    {ok, {P0_num}};

read(43364, _B0) ->
    {ok, {}};

read(43365, _B0) ->
    {ok, {}};

read(43366, _B0) ->
    {P0_time, _B1} = proto:read_uint8(_B0),
    {ok, {P0_time}};

read(43367, _B0) ->
    {ok, {}};

read(43368, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {ok, {P0_type}};

read(43370, _B0) ->
    {ok, {}};

read(43371, _B0) ->
    {P0_exchange_id, _B1} = proto:read_uint8(_B0),
    {ok, {P0_exchange_id}};

read(43372, _B0) ->
    {ok, {}};

read(43373, _B0) ->
    {P0_id, _B1} = proto:read_uint8(_B0),
    {ok, {P0_id}};

read(43374, _B0) ->
    {ok, {}};

read(43375, _B0) ->
    {ok, {}};

read(43376, _B0) ->
    {ok, {}};

read(43377, _B0) ->
    {P0_id, _B1} = proto:read_uint16(_B0),
    {ok, {P0_id}};

read(43378, _B0) ->
    {ok, {}};

read(43379, _B0) ->
    {ok, {}};

read(43380, _B0) ->
    {ok, {}};

read(43381, _B0) ->
    {ok, {}};

read(43382, _B0) ->
    {ok, {}};

read(43383, _B0) ->
    {ok, {}};

read(43384, _B0) ->
    {P0_time, _B1} = proto:read_uint8(_B0),
    {ok, {P0_time}};

read(43385, _B0) ->
    {ok, {}};

read(43386, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {ok, {P0_type}};

read(43387, _B0) ->
    {ok, {}};

read(43388, _B0) ->
    {ok, {}};

read(43389, _B0) ->
    {ok, {}};

read(43390, _B0) ->
    {P0_order_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_order_id}};

read(43391, _B0) ->
    {ok, {}};

read(43392, _B0) ->
    {P0_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_id}};

read(43393, _B0) ->
    {ok, {}};

read(43394, _B0) ->
    {P0_id, _B1} = proto:read_uint32(_B0),
    {P0_num, _B2} = proto:read_uint32(_B1),
    {ok, {P0_id, P0_num}};

read(43395, _B0) ->
    {ok, {}};

read(43396, _B0) ->
    {P0_cost_type, _B1} = proto:read_uint32(_B0),
    {P0_type, _B2} = proto:read_uint32(_B1),
    {ok, {P0_cost_type, P0_type}};

read(43397, _B0) ->
    {ok, {}};

read(43398, _B0) ->
    {P0_cost, _B1} = proto:read_uint32(_B0),
    {ok, {P0_cost}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 获取开服天数 
write(43300, {P0_open_day, P0_open_act_list}) ->
    D_a_t_a = <<P0_open_day:16, (length(P0_open_act_list)):16, (list_to_binary([<<P1_act_type:8, P1_act_sub_type:8, P1_state:8/signed>> || [P1_act_type, P1_act_sub_type, P1_state] <- P0_open_act_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43300:16,0:8, D_a_t_a/binary>>};


%% 获取开服活动之江湖榜信息 
write(43301, {P0_leave_time, P0_list}) ->
    D_a_t_a = <<P0_leave_time:32, (length(P0_list)):16, (list_to_binary([<<P1_act_type:8, P1_act_args:32, P1_gift_id:32, P1_state:8>> || [P1_act_type, P1_act_args, P1_gift_id, P1_state] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43301:16,0:8, D_a_t_a/binary>>};


%% 领取江湖榜奖励 
write(43302, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43302:16,0:8, D_a_t_a/binary>>};


%% 获取开服活动之进阶目标信息 
write(43305, {P0_leave_time, P0_list}) ->
    D_a_t_a = <<P0_leave_time:32, (length(P0_list)):16, (list_to_binary([<<P1_type:8, P1_args:32, P1_state:8, (length(P1_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32, P2_time:16>> || [P2_goods_id, P2_goods_num, P2_time] <- P1_list]))/binary>> || [P1_type, P1_args, P1_state, P1_list] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43305:16,0:8, D_a_t_a/binary>>};


%% 领取进阶目标奖励 
write(43306, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43306:16,0:8, D_a_t_a/binary>>};


%% 获取开服活动之首充团购信息 
write(43311, {P0_leave_time, P0_list}) ->
    D_a_t_a = <<P0_leave_time:32, (length(P0_list)):16, (list_to_binary([<<P1_base_group_num:16, P1_group_num:16, P1_base_charge_gold:32, P1_gift_id:32, P1_state:8>> || [P1_base_group_num, P1_group_num, P1_base_charge_gold, P1_gift_id, P1_state] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43311:16,0:8, D_a_t_a/binary>>};


%% 领取首充团购奖励 
write(43312, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43312:16,0:8, D_a_t_a/binary>>};


%% 获取开服活动之累积充值信息 
write(43315, {P0_leave_time, P0_charge_gold, P0_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_charge_gold:32, (length(P0_list)):16, (list_to_binary([<<P1_base_charge_gold:32, P1_state:8, (length(P1_reward_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_reward_list]))/binary>> || [P1_base_charge_gold, P1_state, P1_reward_list] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43315:16,0:8, D_a_t_a/binary>>};


%% 领取累积充值奖励 
write(43316, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43316:16,0:8, D_a_t_a/binary>>};


%% 获取开服活动之全服动员3信息 
write(43317, {P0_leave_time, P0_lv, P0_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_lv:16, (length(P0_list)):16, (list_to_binary([<<P1_act_type:8, P1_base_lv:16, P1_base_num:32, P1_num:32, P1_gift_id:32, P1_state:8>> || [P1_act_type, P1_base_lv, P1_base_num, P1_num, P1_gift_id, P1_state] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43317:16,0:8, D_a_t_a/binary>>};


%% 领取全服动员3奖励 
write(43318, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43318:16,0:8, D_a_t_a/binary>>};


%% 获取开服活动之全服动员2信息 
write(43319, {P0_leave_time, P0_lv, P0_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_lv:16, (length(P0_list)):16, (list_to_binary([<<P1_act_type:8, P1_base_lv:16, P1_base_num:32, P1_num:32, P1_gift_id:32, P1_state:8>> || [P1_act_type, P1_base_lv, P1_base_num, P1_num, P1_gift_id, P1_state] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43319:16,0:8, D_a_t_a/binary>>};


%% 领取全服动员2奖励 
write(43320, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43320:16,0:8, D_a_t_a/binary>>};


%% 获取开服活动之全服动员信息 
write(43321, {P0_leave_time, P0_lv, P0_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_lv:16, (length(P0_list)):16, (list_to_binary([<<P1_act_type:8, P1_base_lv:16, P1_base_num:32, P1_num:32, P1_gift_id:32, P1_state:8>> || [P1_act_type, P1_base_lv, P1_base_num, P1_num, P1_gift_id, P1_state] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43321:16,0:8, D_a_t_a/binary>>};


%% 领取全服动员奖励 
write(43322, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43322:16,0:8, D_a_t_a/binary>>};


%% 获取投资计划信息 
write(43325, {P0_leave_time, P0_state, P0_cost, P0_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_state:8, P0_cost:16, (length(P0_list)):16, (list_to_binary([<<P1_open_day:8, P1_gift_id:32, P1_status:8>> || [P1_open_day, P1_gift_id, P1_status] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43325:16,0:8, D_a_t_a/binary>>};


%% 投资 
write(43326, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43326:16,0:8, D_a_t_a/binary>>};


%% 领取奖励 
write(43327, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43327:16,0:8, D_a_t_a/binary>>};


%% 升级推送投资弹框 
write(43328, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43328:16,0:8, D_a_t_a/binary>>};


%% 获取迷宫寻宝信息 
write(43330, {P0_leave_time, P0_step, P0_cost_gold, P0_free_num, P0_pass_num, P0_need_num, P0_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_step:16, P0_cost_gold:16, P0_free_num:16, P0_pass_num:16, P0_need_num:8, (length(P0_list)):16, (list_to_binary([<<P1_step:16>> || P1_step <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43330:16,0:8, D_a_t_a/binary>>};


%% 寻宝 
write(43331, {P0_res, P0_rand_step, P0_list}) ->
    D_a_t_a = <<P0_res:8, P0_rand_step:8, (length(P0_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43331:16,0:8, D_a_t_a/binary>>};


%% 奖励列表 
write(43332, {P0_list, P0_list2}) ->
    D_a_t_a = <<(length(P0_list)):16, (list_to_binary([<<P1_step:16, P1_goods_type:32, P1_goods_num:32, P1_type:8>> || [P1_step, P1_goods_type, P1_goods_num, P1_type] <- P0_list]))/binary, (length(P0_list2)):16, (list_to_binary([<<P1_goods_type:32, P1_goods_num:32>> || [P1_goods_type, P1_goods_num] <- P0_list2]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43332:16,0:8, D_a_t_a/binary>>};


%% 日志记录 
write(43333, {P0_list, P0_list2}) ->
    D_a_t_a = <<(length(P0_list)):16, (list_to_binary([<<P1_time:32, P1_goods_type:32, P1_goods_num:32>> || [P1_time, P1_goods_type, P1_goods_num] <- P0_list]))/binary, (length(P0_list2)):16, (list_to_binary([<<(proto:write_string(P1_nickname))/binary, P1_time:32, P1_goods_type:32, P1_goods_num:32>> || [P1_nickname, P1_time, P1_goods_type, P1_goods_num] <- P0_list2]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43333:16,0:8, D_a_t_a/binary>>};


%% 获取进阶宝箱信息 
write(43335, {P0_leave_time, P0_leave_time2, P0_free_num, P0_reset_cost_gold, P0_open_cost_gold, P0_list1, P0_list2}) ->
    D_a_t_a = <<P0_leave_time:32, P0_leave_time2:32, P0_free_num:16, P0_reset_cost_gold:16, P0_open_cost_gold:16, (length(P0_list1)):16, (list_to_binary([<<P1_goods_type:32, P1_goods_num:32>> || [P1_goods_type, P1_goods_num] <- P0_list1]))/binary, (length(P0_list2)):16, (list_to_binary([<<P1_id:8, P1_is_mult:8, P1_is_open:8>> || [P1_id, P1_is_mult, P1_is_open] <- P0_list2]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43335:16,0:8, D_a_t_a/binary>>};


%% 重置宝箱 
write(43336, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43336:16,0:8, D_a_t_a/binary>>};


%% 开启宝箱 
write(43337, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43337:16,0:8, D_a_t_a/binary>>};


%% 获取个人记录 
write(43338, {P0_list}) ->
    D_a_t_a = <<(length(P0_list)):16, (list_to_binary([<<P1_time:32, P1_goods_type:32, P1_goods_num:32, P1_type:8>> || [P1_time, P1_goods_type, P1_goods_num, P1_type] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43338:16,0:8, D_a_t_a/binary>>};


%% 获取开服活动之全民冲榜信息 
write(43341, {P0_leave_time, P0_act_type, P0_nickname, P0_creer, P0_sex, P0_avatar, P0_lv, P0_list1, P0_list2}) ->
    D_a_t_a = <<P0_leave_time:32, P0_act_type:8, (proto:write_string(P0_nickname))/binary, P0_creer:8, P0_sex:8, (proto:write_string(P0_avatar))/binary, P0_lv:8, (length(P0_list1)):16, (list_to_binary([<<P1_min_rank1:8, P1_max_rank1:8, P1_gift_id1:32>> || [P1_min_rank1, P1_max_rank1, P1_gift_id1] <- P0_list1]))/binary, (length(P0_list2)):16, (list_to_binary([<<P1_base_lv2:8, P1_gift_id2:32, P1_state2:8>> || [P1_base_lv2, P1_gift_id2, P1_state2] <- P0_list2]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43341:16,0:8, D_a_t_a/binary>>};


%% 领取全民冲榜奖励 
write(43342, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43342:16,0:8, D_a_t_a/binary>>};


%% 获取开服活动之全民冲榜2信息 
write(43343, {P0_leave_time, P0_act_type, P0_nickname, P0_creer, P0_sex, P0_avatar, P0_lv, P0_list1, P0_list2}) ->
    D_a_t_a = <<P0_leave_time:32, P0_act_type:8, (proto:write_string(P0_nickname))/binary, P0_creer:8, P0_sex:8, (proto:write_string(P0_avatar))/binary, P0_lv:8, (length(P0_list1)):16, (list_to_binary([<<P1_min_rank1:8, P1_max_rank1:8, P1_gift_id1:32>> || [P1_min_rank1, P1_max_rank1, P1_gift_id1] <- P0_list1]))/binary, (length(P0_list2)):16, (list_to_binary([<<P1_base_lv2:8, P1_gift_id2:32, P1_state2:8>> || [P1_base_lv2, P1_gift_id2, P1_state2] <- P0_list2]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43343:16,0:8, D_a_t_a/binary>>};


%% 领取全民冲榜2奖励 
write(43344, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43344:16,0:8, D_a_t_a/binary>>};


%% 获取开服活动之全民冲榜3信息 
write(43345, {P0_leave_time, P0_act_type, P0_nickname, P0_creer, P0_sex, P0_avatar, P0_lv, P0_list1, P0_list2}) ->
    D_a_t_a = <<P0_leave_time:32, P0_act_type:8, (proto:write_string(P0_nickname))/binary, P0_creer:8, P0_sex:8, (proto:write_string(P0_avatar))/binary, P0_lv:8, (length(P0_list1)):16, (list_to_binary([<<P1_min_rank1:8, P1_max_rank1:8, P1_gift_id1:32>> || [P1_min_rank1, P1_max_rank1, P1_gift_id1] <- P0_list1]))/binary, (length(P0_list2)):16, (list_to_binary([<<P1_base_lv2:8, P1_gift_id2:32, P1_state2:8>> || [P1_base_lv2, P1_gift_id2, P1_state2] <- P0_list2]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43345:16,0:8, D_a_t_a/binary>>};


%% 领取全民冲榜3奖励 
write(43346, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43346:16,0:8, D_a_t_a/binary>>};


%% 获取开服活动之公会排行 
write(43351, {P0_leave_time, P0_list}) ->
    D_a_t_a = <<P0_leave_time:32, (length(P0_list)):16, (list_to_binary([<<P1_rank:8, P1_type:8, P1_gift_id:32>> || [P1_rank, P1_type, P1_gift_id] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43351:16,0:8, D_a_t_a/binary>>};


%% 获取开服活动之进阶目标二信息 
write(43355, {P0_leave_time, P0_list}) ->
    D_a_t_a = <<P0_leave_time:32, (length(P0_list)):16, (list_to_binary([<<P1_type:8, P1_args:32, P1_state:8, (length(P1_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32, P2_time:16>> || [P2_goods_id, P2_goods_num, P2_time] <- P1_list]))/binary>> || [P1_type, P1_args, P1_state, P1_list] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43355:16,0:8, D_a_t_a/binary>>};


%% 领取进阶目标二奖励 
write(43356, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43356:16,0:8, D_a_t_a/binary>>};


%% 获取开服活动之进阶目标三信息 
write(43357, {P0_leave_time, P0_list}) ->
    D_a_t_a = <<P0_leave_time:32, (length(P0_list)):16, (list_to_binary([<<P1_type:8, P1_args:32, P1_state:8, (length(P1_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32, P2_time:16>> || [P2_goods_id, P2_goods_num, P2_time] <- P1_list]))/binary>> || [P1_type, P1_args, P1_state, P1_list] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43357:16,0:8, D_a_t_a/binary>>};


%% 领取进阶目标三奖励 
write(43358, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43358:16,0:8, D_a_t_a/binary>>};


%% 获取限时抢购信息 
write(43361, {P0_leave_time1, P0_leave_time2, P0_total_buy_num, P0_open_time, P0_list1, P0_list2}) ->
    D_a_t_a = <<P0_leave_time1:32, P0_leave_time2:32, P0_total_buy_num:16, P0_open_time:8, (length(P0_list1)):16, (list_to_binary([<<P1_status:8, P1_base_total_buy_num:16, (length(P1_list0)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_list0]))/binary>> || [P1_status, P1_base_total_buy_num, P1_list0] <- P0_list1]))/binary, (length(P0_list2)):16, (list_to_binary([<<P1_id:16, P1_time:8, P1_goods_id:32, P1_goods_num:32, P1_price1:32, P1_price2:32, P1_base_buy_num:16, P1_buy_num:16, P1_base_sys_buy_num:16, P1_sys_buy_num:16>> || [P1_id, P1_time, P1_goods_id, P1_goods_num, P1_price1, P1_price2, P1_base_buy_num, P1_buy_num, P1_base_sys_buy_num, P1_sys_buy_num] <- P0_list2]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43361:16,0:8, D_a_t_a/binary>>};


%% 抢购物品 
write(43362, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43362:16,0:8, D_a_t_a/binary>>};


%% 领取抢购次数奖励 
write(43363, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43363:16,0:8, D_a_t_a/binary>>};


%% 获取历史记录 
write(43364, {P0_list}) ->
    D_a_t_a = <<(length(P0_list)):16, (list_to_binary([<<(proto:write_string(P1_nickname))/binary, P1_time:8, P1_goods_id:32, P1_goods_num:32>> || [P1_nickname, P1_time, P1_goods_id, P1_goods_num] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43364:16,0:8, D_a_t_a/binary>>};


%% 获取符文寻宝信息 
write(43365, {P0_remain_time, P0_one_cost, P0_ten_cost, P0_discount, P0_list}) ->
    D_a_t_a = <<P0_remain_time:32, P0_one_cost:16, P0_ten_cost:16, P0_discount:16, (length(P0_list)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32, P1_is_cherish:8>> || [P1_goods_id, P1_num, P1_is_cherish] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43365:16,0:8, D_a_t_a/binary>>};


%% 符文寻宝 
write(43366, {P0_code, P0_chip_num, P0_list}) ->
    D_a_t_a = <<P0_code:8, P0_chip_num:8, (length(P0_list)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32>> || [P1_goods_id, P1_num] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43366:16,0:8, D_a_t_a/binary>>};


%% 获取登陆有礼信息 
write(43367, {P0_leave_time, P0_online_hour, P0_charge_gold, P0_login_gift, P0_login_recv_status, P0_online_time, P0_online_gift, P0_online_recv_status}) ->
    D_a_t_a = <<P0_leave_time:32, P0_online_hour:8, P0_charge_gold:32, (length(P0_login_gift)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32>> || [P1_goods_id, P1_num] <- P0_login_gift]))/binary, P0_login_recv_status:8, P0_online_time:32, (length(P0_online_gift)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32>> || [P1_goods_id, P1_num] <- P0_online_gift]))/binary, P0_online_recv_status:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43367:16,0:8, D_a_t_a/binary>>};


%% 登陆有礼领取 
write(43368, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43368:16,0:8, D_a_t_a/binary>>};


%% 获取新兑换活动信息 
write(43370, {P0_open_time, P0_end_time, P0_list}) ->
    D_a_t_a = <<P0_open_time:32, P0_end_time:32, (length(P0_list)):16, (list_to_binary([<<P1_exchange_id:8, P1_num:32, (length(P1_cost_list)):16, (list_to_binary([<<P2_cost_goods_id:32, P2_cost_num:32>> || [P2_cost_goods_id, P2_cost_num] <- P1_cost_list]))/binary, (length(P1_get_list)):16, (list_to_binary([<<P2_get_goods_id:32, P2_get_num:32>> || [P2_get_goods_id, P2_get_num] <- P1_get_list]))/binary>> || [P1_exchange_id, P1_num, P1_cost_list, P1_get_list] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43370:16,0:8, D_a_t_a/binary>>};


%% 兑换 
write(43371, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43371:16,0:8, D_a_t_a/binary>>};


%% 获取特权炫装信息 
write(43372, {P0_leave_time, P0_list}) ->
    D_a_t_a = <<P0_leave_time:32, (length(P0_list)):16, (list_to_binary([<<P1_id:8, P1_page:8, (proto:write_string(P1_desc))/binary, P1_goods_id:32, P1_goods_num:32, P1_remain_buy_num:8, P1_price:32, P1_cbp:32>> || [P1_id, P1_page, P1_desc, P1_goods_id, P1_goods_num, P1_remain_buy_num, P1_price, P1_cbp] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43372:16,0:8, D_a_t_a/binary>>};


%% 购买 
write(43373, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43373:16,0:8, D_a_t_a/binary>>};


%% 获取护送称号信息 
write(43374, {P0_leave_time, P0_convoy_num, P0_base_convoy_num, P0_is_recv, P0_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_convoy_num:8, P0_base_convoy_num:8, P0_is_recv:8, (length(P0_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43374:16,0:8, D_a_t_a/binary>>};


%% 护送称号领取 
write(43375, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43375:16,0:8, D_a_t_a/binary>>};


%% 获取大额累计充值活动信息 
write(43376, {P0_leave_time, P0_acc_val, P0_act_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_acc_val:32, (length(P0_act_list)):16, (list_to_binary([<<P1_id:16, P1_acc:32, P1_state:8, (length(P1_get_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_get_list]))/binary>> || [P1_id, P1_acc, P1_state, P1_get_list] <- P0_act_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43376:16,0:8, D_a_t_a/binary>>};


%% 大额领取奖励 
write(43377, {P0_res, P0_id}) ->
    D_a_t_a = <<P0_res:8, P0_id:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43377:16,0:8, D_a_t_a/binary>>};


%% 获取消费抽返利活动信息 
write(43378, {P0_leave_time, P0_need_consume_val, P0_num, P0_list, P0_list2, P0_list3}) ->
    D_a_t_a = <<P0_leave_time:32, P0_need_consume_val:32, P0_num:8, (length(P0_list)):16, (list_to_binary([<<P1_charge_gold:32, P1_percent:8, P1_state:8>> || [P1_charge_gold, P1_percent, P1_state] <- P0_list]))/binary, (length(P0_list2)):16, (list_to_binary([<<P1_charge_gold2:32>> || P1_charge_gold2 <- P0_list2]))/binary, (length(P0_list3)):16, (list_to_binary([<<P1_percent3:32>> || P1_percent3 <- P0_list3]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43378:16,0:8, D_a_t_a/binary>>};


%% 今日已获得奖励 
write(43379, {P0_list}) ->
    D_a_t_a = <<(length(P0_list)):16, (list_to_binary([<<P1_charge_gold:32, P1_percent:8, P1_state:8>> || [P1_charge_gold, P1_percent, P1_state] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43379:16,0:8, D_a_t_a/binary>>};


%% 查看今日奖励 
write(43380, {P0_total_gold_num, P0_list}) ->
    D_a_t_a = <<P0_total_gold_num:32, (length(P0_list)):16, (list_to_binary([<<P1_charge_gold:32, P1_percent:8, P1_state:8, P1_out_time:32>> || [P1_charge_gold, P1_percent, P1_state, P1_out_time] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43380:16,0:8, D_a_t_a/binary>>};


%% 中奖名单 
write(43381, {P0_list}) ->
    D_a_t_a = <<(length(P0_list)):16, (list_to_binary([<<(proto:write_string(P1_nickname))/binary, P1_charge_gold:32, P1_percent:8>> || [P1_nickname, P1_charge_gold, P1_percent] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43381:16,0:8, D_a_t_a/binary>>};


%% 抽奖 
write(43382, {P0_code, P0_charge_gold, P0_percent}) ->
    D_a_t_a = <<P0_code:8, P0_charge_gold:32, P0_percent:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43382:16,0:8, D_a_t_a/binary>>};


%% 获取剑道寻宝信息 
write(43383, {P0_remain_time, P0_one_cost, P0_ten_cost, P0_discount, P0_list}) ->
    D_a_t_a = <<P0_remain_time:32, P0_one_cost:16, P0_ten_cost:16, P0_discount:16, (length(P0_list)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32, P1_is_cherish:8>> || [P1_goods_id, P1_num, P1_is_cherish] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43383:16,0:8, D_a_t_a/binary>>};


%% 剑道寻宝 
write(43384, {P0_code, P0_chip_num, P0_list}) ->
    D_a_t_a = <<P0_code:8, P0_chip_num:8, (length(P0_list)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32>> || [P1_goods_id, P1_num] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43384:16,0:8, D_a_t_a/binary>>};


%% 获取仙境迷宫面板信息 
write(43385, {P0_leave_time, P0_leave_time2, P0_step, P0_remain_free_num, P0_one_go_cast, P0_one_go_consume, P0_remain_reset_num, P0_one_reset_cast, P0_list, P0_list3}) ->
    D_a_t_a = <<P0_leave_time:32, P0_leave_time2:32, P0_step:8, P0_remain_free_num:8, P0_one_go_cast:16, P0_one_go_consume:16, P0_remain_reset_num:8, P0_one_reset_cast:16, (length(P0_list)):16, (list_to_binary([<<P1_order_id:8, (length(P1_list2)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_list2]))/binary>> || [P1_order_id, P1_list2] <- P0_list]))/binary, (length(P0_list3)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_list3]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43385:16,0:8, D_a_t_a/binary>>};


%% 寻宝 
write(43386, {P0_code, P0_rand_step, P0_list, P0_list2}) ->
    D_a_t_a = <<P0_code:8, P0_rand_step:8, (length(P0_list)):16, (list_to_binary([<<P1_order_id:8, P1_goods_id:32, P1_goods_num:32>> || [P1_order_id, P1_goods_id, P1_goods_num] <- P0_list]))/binary, (length(P0_list2)):16, (list_to_binary([<<P1_goods_id2:32, P1_goods_num2:32>> || [P1_goods_id2, P1_goods_num2] <- P0_list2]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43386:16,0:8, D_a_t_a/binary>>};


%% 重置 
write(43387, {P0_code, P0_list3}) ->
    D_a_t_a = <<P0_code:8, (length(P0_list3)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_list3]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43387:16,0:8, D_a_t_a/binary>>};


%% 日志 
write(43388, {P0_list}) ->
    D_a_t_a = <<(length(P0_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43388:16,0:8, D_a_t_a/binary>>};


%% 开服活动之返利抢购 
write(43389, {P0_leave_time, P0_list}) ->
    D_a_t_a = <<P0_leave_time:32, (length(P0_list)):16, (list_to_binary([<<P1_order_id:32, P1_state:8, P1_discount:8, P1_base_price:32, P1_price:32, P1_is_hour:8, P1_goods_id:32, P1_goods_num:32, P1_limit_buy_num:16>> || [P1_order_id, P1_state, P1_discount, P1_base_price, P1_price, P1_is_hour, P1_goods_id, P1_goods_num, P1_limit_buy_num] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43389:16,0:8, D_a_t_a/binary>>};


%% 开服活动之返利抢购购买 
write(43390, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43390:16,0:8, D_a_t_a/binary>>};


%% 获取红装兑换信息 
write(43391, {P0_cost_goods_id, P0_list}) ->
    D_a_t_a = <<P0_cost_goods_id:32, (length(P0_list)):16, (list_to_binary([<<P1_id:32, P1_goods_id:32, P1_cost_count:32, P1_get_count:32, P1_state:32>> || [P1_id, P1_goods_id, P1_cost_count, P1_get_count, P1_state] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43391:16,0:8, D_a_t_a/binary>>};


%% 红装兑换 
write(43392, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43392:16,0:8, D_a_t_a/binary>>};


%% 获取碎片兑换信息 
write(43393, {P0_cost_goods_id, P0_list}) ->
    D_a_t_a = <<P0_cost_goods_id:32, (length(P0_list)):16, (list_to_binary([<<P1_id:32, P1_goods_id:32, P1_cost_count:32, P1_get_count:32, P1_lack_count:32, P1_state:32>> || [P1_id, P1_goods_id, P1_cost_count, P1_get_count, P1_lack_count, P1_state] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43393:16,0:8, D_a_t_a/binary>>};


%% 碎片兑换 
write(43394, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43394:16,0:8, D_a_t_a/binary>>};


%% 获取招财进宝信息 
write(43395, {P0_coin, P0_coin_remain, P0_coin_cost, P0_coin_ten_cost, P0_coin_free_num, P0_coin_next_time, P0_coin_sum, P0_lingqi, P0_lingqi_remain, P0_lingqi_cost, P0_lingqi_ten_cost, P0_lingqi_free_num, P0_lingqi_next_time, P0_lingqi_sum, P0_coin_list, P0_lingqi_list}) ->
    D_a_t_a = <<P0_coin:32, P0_coin_remain:32, P0_coin_cost:32, P0_coin_ten_cost:32, P0_coin_free_num:32, P0_coin_next_time:32, P0_coin_sum:32, P0_lingqi:32, P0_lingqi_remain:32, P0_lingqi_cost:32, P0_lingqi_ten_cost:32, P0_lingqi_free_num:32, P0_lingqi_next_time:32, P0_lingqi_sum:32, (length(P0_coin_list)):16, (list_to_binary([<<P1_ratio:32>> || P1_ratio <- P0_coin_list]))/binary, (length(P0_lingqi_list)):16, (list_to_binary([<<P1_ratio:32>> || P1_ratio <- P0_lingqi_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43395:16,0:8, D_a_t_a/binary>>};


%% 购买 
write(43396, {P0_code, P0_reward_list}) ->
    D_a_t_a = <<P0_code:8, (length(P0_reward_list)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32, P1_ratio:32>> || [P1_goods_id, P1_num, P1_ratio] <- P0_reward_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43396:16,0:8, D_a_t_a/binary>>};


%% 获取招财猫信息 
write(43397, {P0_leave_time, P0_count, P0_cost_list, P0_ratio_list, P0_notice_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_count:8, (length(P0_cost_list)):16, (list_to_binary([<<P1_cost:32>> || P1_cost <- P0_cost_list]))/binary, (length(P0_ratio_list)):16, (list_to_binary([<<P1_id:32, P1_ratio:32>> || [P1_id, P1_ratio] <- P0_ratio_list]))/binary, (length(P0_notice_list)):16, (list_to_binary([<<(proto:write_string(P1_nickname))/binary, P1_cost:32, P1_ratio:32>> || [P1_nickname, P1_cost, P1_ratio] <- P0_notice_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43397:16,0:8, D_a_t_a/binary>>};


%% 招财猫抽奖 
write(43398, {P0_code, P0_id, P0_bgold}) ->
    D_a_t_a = <<P0_code:8, P0_id:32, P0_bgold:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43398:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



