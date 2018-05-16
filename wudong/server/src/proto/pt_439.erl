%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2018-02-05 19:37:45
%%----------------------------------------------------
-module(pt_439).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"元宝不足"; 
err(3) ->"刷新次数不足"; 
err(4) ->"已购买"; 
err(5) ->"已领取"; 
err(6) ->"购买次数不足"; 
err(7) ->"未达成"; 
err(8) ->"活动过期"; 
err(9) ->"抢购还未开始"; 
err(10) ->"抢购结束，请期待下轮"; 
err(11) ->"抢购次数不足"; 
err(12) ->"充值可再领一次"; 
err(13) ->"全服抢购次数不足"; 
err(14) ->"红包已全部被领完"; 
err(15) ->"材料不足"; 
err(16) ->"兑换次数不足"; 
err(17) ->"充值可领取"; 
err(18) ->"明天可领取"; 
err(19) ->"当前积分不足"; 
err(20) ->"不可领取"; 
err(21) ->"已过期"; 
err(22) ->"已经购买"; 
err(23) ->"未购买"; 
err(24) ->"已经领取"; 
err(25) ->"金币不足"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(43901, _B0) ->
    {ok, {}};

read(43902, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {ok, {P0_type}};

read(43903, _B0) ->
    {P0_order, _B1} = proto:read_uint8(_B0),
    {ok, {P0_order}};

read(43904, _B0) ->
    {P0_base_num, _B1} = proto:read_uint16(_B0),
    {ok, {P0_base_num}};

read(43905, _B0) ->
    {ok, {}};

read(43906, _B0) ->
    {P0_id, _B1} = proto:read_uint16(_B0),
    {ok, {P0_id}};

read(43907, _B0) ->
    {ok, {}};

read(43908, _B0) ->
    {ok, {}};

read(43909, _B0) ->
    {ok, {}};

read(43910, _B0) ->
    {P0_order_id, _B1} = proto:read_uint8(_B0),
    {P0_buy_num, _B2} = proto:read_uint16(_B1),
    {ok, {P0_order_id, P0_buy_num}};

read(43911, _B0) ->
    {P0_buy_num, _B1} = proto:read_uint16(_B0),
    {ok, {P0_buy_num}};

read(43912, _B0) ->
    {P0_act_num, _B1} = proto:read_int8(_B0),
    {ok, {P0_act_num}};

read(43913, _B0) ->
    {ok, {}};

read(43914, _B0) ->
    {ok, {}};

read(43915, _B0) ->
    {P0_login_day, _B1} = proto:read_uint8(_B0),
    {ok, {P0_login_day}};

read(43916, _B0) ->
    {ok, {}};

read(43917, _B0) ->
    {P0_base_charge_gold, _B1} = proto:read_uint32(_B0),
    {ok, {P0_base_charge_gold}};

read(43918, _B0) ->
    {ok, {}};

read(43919, _B0) ->
    {P0_order_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_order_id}};

read(43920, _B0) ->
    {ok, {}};

read(43921, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {ok, {P0_type}};

read(43922, _B0) ->
    {ok, {}};

read(43923, _B0) ->
    {P0_exchange_id, _B1} = proto:read_uint8(_B0),
    {ok, {P0_exchange_id}};

read(43924, _B0) ->
    {ok, {}};

read(43925, _B0) ->
    {ok, {}};

read(43926, _B0) ->
    {ok, {}};

read(43927, _B0) ->
    {P0_id, _B1} = proto:read_uint8(_B0),
    {ok, {P0_id}};

read(43928, _B0) ->
    {ok, {}};

read(43930, _B0) ->
    {ok, {}};

read(43931, _B0) ->
    {ok, {}};

read(43932, _B0) ->
    {ok, {}};

read(43933, _B0) ->
    {ok, {}};

read(43934, _B0) ->
    {ok, {}};

read(43935, _B0) ->
    {P0_id, _B1} = proto:read_uint8(_B0),
    {P0_day, _B2} = proto:read_uint8(_B1),
    {ok, {P0_id, P0_day}};

read(43936, _B0) ->
    {ok, {}};

read(43937, _B0) ->
    {ok, {}};

read(43938, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {ok, {P0_type}};

read(43939, _B0) ->
    {ok, {}};

read(43940, _B0) ->
    {P0_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_id}};

read(43941, _B0) ->
    {P0_score, _B1} = proto:read_uint16(_B0),
    {ok, {P0_score}};

read(43942, _B0) ->
    {ok, {}};

read(43943, _B0) ->
    {ok, {}};

read(43944, _B0) ->
    {P0_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_id}};

read(43945, _B0) ->
    {ok, {}};

read(43946, _B0) ->
    {ok, {}};

read(43947, _B0) ->
    {P0_recv_charge_gold, _B1} = proto:read_uint32(_B0),
    {ok, {P0_recv_charge_gold}};

read(43948, _B0) ->
    {ok, {}};

read(43949, _B0) ->
    {ok, {}};

read(43950, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {ok, {P0_type}};

read(43951, _B0) ->
    {P0_score, _B1} = proto:read_uint16(_B0),
    {ok, {P0_score}};

read(43953, _B0) ->
    {ok, {}};

read(43954, _B0) ->
    {ok, {}};

read(43956, _B0) ->
    {ok, {}};

read(43957, _B0) ->
    {P0_exchange_id, _B1} = proto:read_uint8(_B0),
    {ok, {P0_exchange_id}};

read(43958, _B0) ->
    {ok, {}};

read(43959, _B0) ->
    {ok, {}};

read(43960, _B0) ->
    {P0_days, _B1} = proto:read_uint8(_B0),
    {ok, {P0_days}};

read(43965, _B0) ->
    {ok, {}};

read(43966, _B0) ->
    {ok, {}};

read(43967, _B0) ->
    {ok, {}};

read(43968, _B0) ->
    {ok, {}};

read(43969, _B0) ->
    {P0_id, _B1} = proto:read_uint8(_B0),
    {ok, {P0_id}};

read(43970, _B0) ->
    {ok, {}};

read(43971, _B0) ->
    {P0_id, _B1} = proto:read_uint16(_B0),
    {ok, {P0_id}};

read(43972, _B0) ->
    {ok, {}};

read(43973, _B0) ->
    {P0_type, _B1} = proto:read_uint16(_B0),
    {ok, {P0_type}};

read(43974, _B0) ->
    {P0_id, _B1} = proto:read_uint16(_B0),
    {ok, {P0_id}};

read(43978, _B0) ->
    {P0_type, _B1} = proto:read_uint16(_B0),
    {ok, {P0_type}};

read(43979, _B0) ->
    {ok, {}};

read(43980, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {P0_id, _B2} = proto:read_uint8(_B1),
    {P0_is_auto, _B3} = proto:read_uint8(_B2),
    {ok, {P0_type, P0_id, P0_is_auto}};

read(43981, _B0) ->
    {P0_type, _B1} = proto:read_uint16(_B0),
    {ok, {P0_type}};

read(43982, _B0) ->
    {ok, {}};

read(43983, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {P0_id, _B2} = proto:read_uint8(_B1),
    {P0_is_auto, _B3} = proto:read_uint8(_B2),
    {ok, {P0_type, P0_id, P0_is_auto}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 请求神秘商城面板数据 
write(43901, {P0_leave_time, P0_refresh_num, P0_refresh_cost, P0_free_refresh_time, P0_order_list, P0_target_list, P0_show_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_refresh_num:16, P0_refresh_cost:16, P0_free_refresh_time:32, (length(P0_order_list)):16, (list_to_binary([<<P1_order:32, P1_goods_id:32, P1_goods_num:32, P1_price:16, P1_rarity:8, P1_is_buy:8>> || [P1_order, P1_goods_id, P1_goods_num, P1_price, P1_rarity, P1_is_buy] <- P0_order_list]))/binary, (length(P0_target_list)):16, (list_to_binary([<<P1_base_refresh_num:16, P1_goods_id:32, P1_goods_num:32, P1_is_recv:8>> || [P1_base_refresh_num, P1_goods_id, P1_goods_num, P1_is_recv] <- P0_target_list]))/binary, (length(P0_show_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_show_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43901:16,0:8, D_a_t_a/binary>>};


%% 神秘商城刷新 
write(43902, {P0_code, P0_type, P0_is_rarity, P0_refresh_num, P0_cost}) ->
    D_a_t_a = <<P0_code:8, P0_type:8, P0_is_rarity:8, P0_refresh_num:8, P0_cost:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43902:16,0:8, D_a_t_a/binary>>};


%% 购买 
write(43903, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43903:16,0:8, D_a_t_a/binary>>};


%% 领取刷新次数奖励 
write(43904, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43904:16,0:8, D_a_t_a/binary>>};


%% 获取限时礼包活动面板信息 
write(43905, {P0_leave_time, P0_list}) ->
    D_a_t_a = <<P0_leave_time:32, (length(P0_list)):16, (list_to_binary([<<P1_id:8, P1_price:32, P1_base_price:32, P1_buy_num:8, P1_base_buy_num:32, (length(P1_reward_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_reward_list]))/binary>> || [P1_id, P1_price, P1_base_price, P1_buy_num, P1_base_buy_num, P1_reward_list] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43905:16,0:8, D_a_t_a/binary>>};


%% 购买 
write(43906, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43906:16,0:8, D_a_t_a/binary>>};


%% 获取小额充值活动面板信息 
write(43907, {P0_leave_time, P0_base_buy_num, P0_buy_num, P0_rmb, P0_is_recv, P0_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_base_buy_num:8, P0_buy_num:8, P0_rmb:16, P0_is_recv:8, (length(P0_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43907:16,0:8, D_a_t_a/binary>>};


%% 小额充值活动领取 
write(43908, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43908:16,0:8, D_a_t_a/binary>>};


%% 一元充值活动面板 
write(43909, {P0_status, P0_leave_time, P0_act_num, P0_buy_num, P0_log_list, P0_recv_list, P0_price_list, P0_goods_list}) ->
    D_a_t_a = <<P0_status:8, P0_leave_time:32, P0_act_num:8, P0_buy_num:16, (length(P0_log_list)):16, (list_to_binary([<<P1_log_act_num:8, (proto:write_string(P1_nickname))/binary, P1_goods_id:32, P1_goods_num:32, P1_sn:16>> || [P1_log_act_num, P1_nickname, P1_goods_id, P1_goods_num, P1_sn] <- P0_log_list]))/binary, (length(P0_recv_list)):16, (list_to_binary([<<P1_flag:8, P1_base_buy_num:16, P1_goods_id:32, P1_goods_num:32>> || [P1_flag, P1_base_buy_num, P1_goods_id, P1_goods_num] <- P0_recv_list]))/binary, (length(P0_price_list)):16, (list_to_binary([<<P1_base_buy_num:8, P1_price:16>> || [P1_base_buy_num, P1_price] <- P0_price_list]))/binary, (length(P0_goods_list)):16, (list_to_binary([<<P1_order_id:8, P1_base_buy_num:16, P1_now_buy_num:16, P1_goods_id:32, P1_goods_num:32>> || [P1_order_id, P1_base_buy_num, P1_now_buy_num, P1_goods_id, P1_goods_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43909:16,0:8, D_a_t_a/binary>>};


%% 一元抢购活动购买 
write(43910, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43910:16,0:8, D_a_t_a/binary>>};


%% 一元抢购次数奖励领取 
write(43911, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43911:16,0:8, D_a_t_a/binary>>};


%% 一元抢购夺宝记录 
write(43912, {P0_log_list, P0_my_log_list}) ->
    D_a_t_a = <<(length(P0_log_list)):16, (list_to_binary([<<P1_act_num:8/signed, P1_order_id:8/signed, P1_goods_id:32, P1_goods_num:16, (proto:write_string(P1_nickname))/binary, P1_buy_num:16/signed, P1_sn:16/signed>> || [P1_act_num, P1_order_id, P1_goods_id, P1_goods_num, P1_nickname, P1_buy_num, P1_sn] <- P0_log_list]))/binary, (length(P0_my_log_list)):16, (list_to_binary([<<P1_act_num:8/signed, P1_order_id:8/signed, P1_goods_id:32, P1_goods_num:16, P1_buy_num:16/signed, P1_status:8>> || [P1_act_num, P1_order_id, P1_goods_id, P1_goods_num, P1_buy_num, P1_status] <- P0_my_log_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43912:16,0:8, D_a_t_a/binary>>};


%% 本期广告主打 
write(43913, {P0_id1, P0_id2, P0_id3, P0_id4, P0_id5}) ->
    D_a_t_a = <<P0_id1:32, P0_id2:32, P0_id3:32, P0_id4:32, P0_id5:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43913:16,0:8, D_a_t_a/binary>>};


%% 节日活动之登陆有礼 
write(43914, {P0_leave_time, P0_list}) ->
    D_a_t_a = <<P0_leave_time:32, (length(P0_list)):16, (list_to_binary([<<P1_login_day:8, P1_status:8, (length(P1_reward_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_reward_list]))/binary>> || [P1_login_day, P1_status, P1_reward_list] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43914:16,0:8, D_a_t_a/binary>>};


%% 领取 
write(43915, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43915:16,0:8, D_a_t_a/binary>>};


%% 获取节日活动之累积充值信息 
write(43916, {P0_leave_time, P0_charge_gold, P0_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_charge_gold:32, (length(P0_list)):16, (list_to_binary([<<P1_base_charge_gold:32, P1_state:8, (length(P1_reward_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_reward_list]))/binary>> || [P1_base_charge_gold, P1_state, P1_reward_list] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43916:16,0:8, D_a_t_a/binary>>};


%% 领取累积充值奖励 
write(43917, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43917:16,0:8, D_a_t_a/binary>>};


%% 节日活动之返利抢购 
write(43918, {P0_leave_time, P0_list}) ->
    D_a_t_a = <<P0_leave_time:32, (length(P0_list)):16, (list_to_binary([<<P1_order_id:32, P1_state:8, P1_discount:8, P1_base_price:32, P1_price:32, P1_is_hour:8, P1_goods_id:32, P1_goods_num:32, P1_limit_buy_num:16>> || [P1_order_id, P1_state, P1_discount, P1_base_price, P1_price, P1_is_hour, P1_goods_id, P1_goods_num, P1_limit_buy_num] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43918:16,0:8, D_a_t_a/binary>>};


%% 节日活动之返利抢购购买 
write(43919, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43919:16,0:8, D_a_t_a/binary>>};


%% 节日活动之财神挑战 
write(43920, {P0_leave_time, P0_consume_goods_id, P0_consume_goods_num, P0_consume_bgold, P0_consume_gold}) ->
    D_a_t_a = <<P0_leave_time:32, P0_consume_goods_id:32, P0_consume_goods_num:32, P0_consume_bgold:32, P0_consume_gold:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43920:16,0:8, D_a_t_a/binary>>};


%% 挑战 
write(43921, {P0_type, P0_code, P0_my_num, P0_cs_num, P0_reward_num}) ->
    D_a_t_a = <<P0_type:8, P0_code:8, P0_my_num:8, P0_cs_num:8, P0_reward_num:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43921:16,0:8, D_a_t_a/binary>>};


%% 获取兑换活动信息 
write(43922, {P0_open_time, P0_end_time, P0_list}) ->
    D_a_t_a = <<P0_open_time:32, P0_end_time:32, (length(P0_list)):16, (list_to_binary([<<P1_exchange_id:8, P1_num:32, (length(P1_cost_list)):16, (list_to_binary([<<P2_cost_goods_id:32, P2_cost_num:32>> || [P2_cost_goods_id, P2_cost_num] <- P1_cost_list]))/binary, (length(P1_get_list)):16, (list_to_binary([<<P2_get_goods_id:32, P2_get_num:32>> || [P2_get_goods_id, P2_get_num] <- P1_get_list]))/binary>> || [P1_exchange_id, P1_num, P1_cost_list, P1_get_list] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43922:16,0:8, D_a_t_a/binary>>};


%% 兑换 
write(43923, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43923:16,0:8, D_a_t_a/binary>>};


%% 红包雨面板信息 
write(43924, {P0_leave_time, P0_next_open_time, P0_sys_score, P0_nickname, P0_sn, P0_career, P0_sex, P0_head_id, P0_avatar, P0_goods_list1, P0_show_list, P0_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_next_open_time:32, P0_sys_score:32, (proto:write_string(P0_nickname))/binary, P0_sn:32, P0_career:8, P0_sex:8, P0_head_id:32, (proto:write_string(P0_avatar))/binary, (length(P0_goods_list1)):16, (list_to_binary([<<P1_goods_id1:32, P1_goods_num1:32>> || [P1_goods_id1, P1_goods_num1] <- P0_goods_list1]))/binary, (length(P0_show_list)):16, (list_to_binary([<<P1_base_score:32, (length(P1_goods_list2)):16, (list_to_binary([<<P2_goods_id2:32, P2_goods_num2:32>> || [P2_goods_id2, P2_goods_num2] <- P1_goods_list2]))/binary>> || [P1_base_score, P1_goods_list2] <- P0_show_list]))/binary, (length(P0_list)):16, (list_to_binary([<<P1_id:32, P1_gift_num:16, P1_score:32, (length(P1_goods_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_goods_list]))/binary>> || [P1_id, P1_gift_num, P1_score, P1_goods_list] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43924:16,0:8, D_a_t_a/binary>>};


%% 上期手气排行榜 
write(43925, {P0_my_rank, P0_my_goods_list, P0_list}) ->
    D_a_t_a = <<P0_my_rank:16, (length(P0_my_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_my_goods_list]))/binary, (length(P0_list)):16, (list_to_binary([<<P1_rank:16, (proto:write_string(P1_nickname))/binary, P1_sn:32, P1_career:8, P1_sex:8, P1_head_id:32, (proto:write_string(P1_avatar))/binary, (length(P1_goods_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_goods_list]))/binary>> || [P1_rank, P1_nickname, P1_sn, P1_career, P1_sex, P1_head_id, P1_avatar, P1_goods_list] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43925:16,0:8, D_a_t_a/binary>>};


%% 红包通知 
write(43926, {P0_id}) ->
    D_a_t_a = <<P0_id:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43926:16,0:8, D_a_t_a/binary>>};


%% 抢红包 
write(43927, {P0_code, P0_goods_list}) ->
    D_a_t_a = <<P0_code:8, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43927:16,0:8, D_a_t_a/binary>>};


%% 红包查看前10手气 
write(43928, {P0_list}) ->
    D_a_t_a = <<(length(P0_list)):16, (list_to_binary([<<P1_rank:16, (proto:write_string(P1_nickname))/binary, P1_sn:32, P1_sex:8, P1_career:8, (proto:write_string(P1_avatar))/binary, P1_head_id:32, (length(P1_goods_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_goods_list]))/binary>> || [P1_rank, P1_nickname, P1_sn, P1_sex, P1_career, P1_avatar, P1_head_id, P1_goods_list] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43928:16,0:8, D_a_t_a/binary>>};


%% 充值排行榜(区域跨服) 
write(43930, {P0_leave_time, P0_recharge, P0_my_rank, P0_rank_list, P0_reward_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_recharge:32, P0_my_rank:32, (length(P0_rank_list)):16, (list_to_binary([<<P1_rank:16, P1_pkey:32/signed, P1_sn:32, (proto:write_string(P1_nickname))/binary, P1_recharge_gold:32>> || [P1_rank, P1_pkey, P1_sn, P1_nickname, P1_recharge_gold] <- P0_rank_list]))/binary, (length(P0_reward_list)):16, (list_to_binary([<<P1_rank_top:32, P1_rank_down:32, P1_limit:32, (length(P1_award_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_award_list]))/binary>> || [P1_rank_top, P1_rank_down, P1_limit, P1_award_list] <- P0_reward_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43930:16,0:8, D_a_t_a/binary>>};


%% 消费排行榜(区域跨服) 
write(43931, {P0_leave_time, P0_consume, P0_my_rank, P0_rank_list, P0_reward_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_consume:32, P0_my_rank:32, (length(P0_rank_list)):16, (list_to_binary([<<P1_rank:16, P1_pkey:32/signed, P1_sn:32, (proto:write_string(P1_nickname))/binary, P1_consume_gold:32>> || [P1_rank, P1_pkey, P1_sn, P1_nickname, P1_consume_gold] <- P0_rank_list]))/binary, (length(P0_reward_list)):16, (list_to_binary([<<P1_rank_top:32, P1_rank_down:32, P1_limit:32, (length(P1_award_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_award_list]))/binary>> || [P1_rank_top, P1_rank_down, P1_limit, P1_award_list] <- P0_reward_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43931:16,0:8, D_a_t_a/binary>>};


%% 获取财神单笔充值活动面板信息 
write(43932, {P0_leave_time, P0_base_buy_num, P0_buy_num, P0_rmb, P0_is_recv, P0_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_base_buy_num:8, P0_buy_num:8, P0_rmb:16, P0_is_recv:8, (length(P0_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43932:16,0:8, D_a_t_a/binary>>};


%% 财神单笔充值活动领取 
write(43933, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43933:16,0:8, D_a_t_a/binary>>};


%% 聚宝盆面板信息 
write(43934, {P0_leave_time, P0_status, P0_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_status:8, (length(P0_list)):16, (list_to_binary([<<P1_id:8, P1_charge_gold:32, (length(P1_list)):16, (list_to_binary([<<P2_day:8, P2_is_recv:8, (length(P2_list)):16, (list_to_binary([<<P3_goods_id:32, P3_goods_num:32>> || [P3_goods_id, P3_goods_num] <- P2_list]))/binary>> || [P2_day, P2_is_recv, P2_list] <- P1_list]))/binary>> || [P1_id, P1_charge_gold, P1_list] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43934:16,0:8, D_a_t_a/binary>>};


%% 聚宝盆领取 
write(43935, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43935:16,0:8, D_a_t_a/binary>>};


%% 仙装觉醒面板 
write(43936, {P0_leave_time, P0_show_type, P0_one_cost, P0_ten_cost, P0_list, P0_list2}) ->
    D_a_t_a = <<P0_leave_time:32, P0_show_type:8, P0_one_cost:16, P0_ten_cost:16, (length(P0_list)):16, (list_to_binary([<<P1_rank:8, (length(P1_sub_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_sub_list]))/binary>> || [P1_rank, P1_sub_list] <- P0_list]))/binary, (length(P0_list2)):16, (list_to_binary([<<P1_is_recv:8, P1_score:16, (length(P1_sub_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_sub_list]))/binary>> || [P1_is_recv, P1_score, P1_sub_list] <- P0_list2]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43936:16,0:8, D_a_t_a/binary>>};


%% 仙装觉醒获取积分 
write(43937, {P0_rank, P0_my_score, P0_list}) ->
    D_a_t_a = <<P0_rank:8, P0_my_score:16, (length(P0_list)):16, (list_to_binary([<<P1_rank:8, P1_sn:32, (proto:write_string(P1_nickname))/binary, P1_score:16, P1_rank_score:16>> || [P1_rank, P1_sn, P1_nickname, P1_score, P1_rank_score] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43937:16,0:8, D_a_t_a/binary>>};


%% 仙装觉醒抽奖 
write(43938, {P0_code, P0_list}) ->
    D_a_t_a = <<P0_code:8, (length(P0_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43938:16,0:8, D_a_t_a/binary>>};


%% 获取消费积分信息 
write(43939, {P0_my_score, P0_leave_time, P0_cost, P0_get_score, P0_skip_str, P0_list}) ->
    D_a_t_a = <<P0_my_score:32, P0_leave_time:32, P0_cost:32, P0_get_score:32, (proto:write_string(P0_skip_str))/binary, (length(P0_list)):16, (list_to_binary([<<P1_id:32, P1_count:32, P1_score:32, P1_goods_id:32, P1_goods_num:32>> || [P1_id, P1_count, P1_score, P1_goods_id, P1_goods_num] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43939:16,0:8, D_a_t_a/binary>>};


%% 消费积分兑换 
write(43940, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43940:16,0:8, D_a_t_a/binary>>};


%% 仙装觉醒档位领取 
write(43941, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43941:16,0:8, D_a_t_a/binary>>};


%% 一元购开启状态 
write(43942, {P0_status, P0_leave_time}) ->
    D_a_t_a = <<P0_status:8, P0_leave_time:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43942:16,0:8, D_a_t_a/binary>>};


%% 获取红装抢购信息 
write(43943, {P0_leave_time, P0_reset_cost, P0_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_reset_cost:32, (length(P0_list)):16, (list_to_binary([<<P1_id:32, P1_goods_id:32, P1_goods_num:32, P1_old_cost:32, P1_now_cost:32, P1_discount:32, P1_state:32, P1_is_paper:32, P1_next_count:32>> || [P1_id, P1_goods_id, P1_goods_num, P1_old_cost, P1_now_cost, P1_discount, P1_state, P1_is_paper, P1_next_count] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43943:16,0:8, D_a_t_a/binary>>};


%% 红装抢购购买 
write(43944, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43944:16,0:8, D_a_t_a/binary>>};


%% 红装抢购刷新 
write(43945, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43945:16,0:8, D_a_t_a/binary>>};


%% 获取小额单笔充值活动面板信息 
write(43946, {P0_leave_time, P0_charge_list}) ->
    D_a_t_a = <<P0_leave_time:32, (length(P0_charge_list)):16, (list_to_binary([<<P1_base_buy_num:8, P1_buy_num:8, P1_charge_gold:32, P1_is_recv:8, (length(P1_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_list]))/binary>> || [P1_base_buy_num, P1_buy_num, P1_charge_gold, P1_is_recv, P1_list] <- P0_charge_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43946:16,0:8, D_a_t_a/binary>>};


%% 小额单笔充值活动领取 
write(43947, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43947:16,0:8, D_a_t_a/binary>>};


%% 仙宠成长面板 
write(43948, {P0_leave_time, P0_one_cost, P0_ten_cost, P0_list, P0_list2, P0_list3}) ->
    D_a_t_a = <<P0_leave_time:32, P0_one_cost:16, P0_ten_cost:16, (length(P0_list)):16, (list_to_binary([<<P1_rank:8, (length(P1_sub_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_sub_list]))/binary>> || [P1_rank, P1_sub_list] <- P0_list]))/binary, (length(P0_list2)):16, (list_to_binary([<<P1_is_recv:8, P1_score:16, (length(P1_sub_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_sub_list]))/binary>> || [P1_is_recv, P1_score, P1_sub_list] <- P0_list2]))/binary, (length(P0_list3)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_list3]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43948:16,0:8, D_a_t_a/binary>>};


%% 仙宠成长获取积分 
write(43949, {P0_rank, P0_my_score, P0_list}) ->
    D_a_t_a = <<P0_rank:8, P0_my_score:16, (length(P0_list)):16, (list_to_binary([<<P1_rank:8, P1_sn:32, (proto:write_string(P1_nickname))/binary, P1_score:16, P1_rank_score:16>> || [P1_rank, P1_sn, P1_nickname, P1_score, P1_rank_score] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43949:16,0:8, D_a_t_a/binary>>};


%% 仙宠成长抽奖 
write(43950, {P0_code, P0_list}) ->
    D_a_t_a = <<P0_code:8, (length(P0_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43950:16,0:8, D_a_t_a/binary>>};


%% 仙宠成长档位领取 
write(43951, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43951:16,0:8, D_a_t_a/binary>>};


%% 获取充值有礼信息(回归活动) 
write(43953, {P0_leave_time, P0_sum_val, P0_val, P0_next_val, P0_goods_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_sum_val:32, P0_val:32, P0_next_val:32, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43953:16,0:8, D_a_t_a/binary>>};


%% 充值有礼领取(回归活动) 
write(43954, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43954:16,0:8, D_a_t_a/binary>>};


%% 获取兑换活动信息(回归活动) 
write(43956, {P0_open_time, P0_end_time, P0_list}) ->
    D_a_t_a = <<P0_open_time:32, P0_end_time:32, (length(P0_list)):16, (list_to_binary([<<P1_exchange_id:8, P1_num:32, (length(P1_cost_list)):16, (list_to_binary([<<P2_cost_goods_id:32, P2_cost_num:32>> || [P2_cost_goods_id, P2_cost_num] <- P1_cost_list]))/binary, (length(P1_get_list)):16, (list_to_binary([<<P2_get_goods_id:32, P2_get_num:32>> || [P2_get_goods_id, P2_get_num] <- P1_get_list]))/binary>> || [P1_exchange_id, P1_num, P1_cost_list, P1_get_list] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43956:16,0:8, D_a_t_a/binary>>};


%% 兑换(回归活动) 
write(43957, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43957:16,0:8, D_a_t_a/binary>>};


%% 回归活动广告 
write(43958, {P0_info_list}) ->
    D_a_t_a = <<(length(P0_info_list)):16, (list_to_binary([<<P1_code:8, (proto:write_string(P1_title))/binary, (proto:write_string(P1_content))/binary, P1_skip_id:16, P1_page_id:16>> || [P1_code, P1_title, P1_content, P1_skip_id, P1_page_id] <- P0_info_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43958:16,0:8, D_a_t_a/binary>>};


%% 获取回归登陆信息 
write(43959, {P0_info_list}) ->
    D_a_t_a = <<(length(P0_info_list)):16, (list_to_binary([<<P1_days:8, P1_state:8, (length(P1_goods_list)):16, (list_to_binary([<<P2_goods_id:32, P2_num:32>> || [P2_goods_id, P2_num] <- P1_goods_list]))/binary>> || [P1_days, P1_state, P1_goods_list] <- P0_info_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43959:16,0:8, D_a_t_a/binary>>};


%% 领取奖励 
write(43960, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43960:16,0:8, D_a_t_a/binary>>};


%% 回归活动列表状态 
write(43965, {P0_merge_act_list}) ->
    D_a_t_a = <<(length(P0_merge_act_list)):16, (list_to_binary([<<P1_act_type:8, P1_state:8/signed>> || [P1_act_type, P1_state] <- P0_merge_act_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43965:16,0:8, D_a_t_a/binary>>};


%% 双倍充值状态 
write(43966, {P0_list}) ->
    D_a_t_a = <<(length(P0_list)):16, (list_to_binary([<<P1_id:8, P1_state:8, P1_mul:8/signed>> || [P1_id, P1_state, P1_mul] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43966:16,0:8, D_a_t_a/binary>>};


%% 获取经验副本投资信息 
write(43967, {P0_cost, P0_ratio, P0_is_buy, P0_list}) ->
    D_a_t_a = <<P0_cost:32, P0_ratio:32, P0_is_buy:32, (length(P0_list)):16, (list_to_binary([<<P1_id:8, P1_floor:32/signed, P1_state:32/signed, (length(P1_reward_list)):16, (list_to_binary([<<P2_goods_id:32/signed, P2_goods_num:32/signed>> || [P2_goods_id, P2_goods_num] <- P1_reward_list]))/binary>> || [P1_id, P1_floor, P1_state, P1_reward_list] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43967:16,0:8, D_a_t_a/binary>>};


%% 购买经验副本投资 
write(43968, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43968:16,0:8, D_a_t_a/binary>>};


%% 领取经验副本投资 
write(43969, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43969:16,0:8, D_a_t_a/binary>>};


%% 获取神邸抢购活动面板信息 
write(43970, {P0_leave_time, P0_list}) ->
    D_a_t_a = <<P0_leave_time:32, (length(P0_list)):16, (list_to_binary([<<P1_id:8, (proto:write_string(P1_desc))/binary, P1_show_type:8, P1_price:32, P1_is_buy:8, (length(P1_reward_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_reward_list]))/binary>> || [P1_id, P1_desc, P1_show_type, P1_price, P1_is_buy, P1_reward_list] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43970:16,0:8, D_a_t_a/binary>>};


%% 购买 
write(43971, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43971:16,0:8, D_a_t_a/binary>>};


%% 获取唤神面板信息 
write(43972, {P0_leave_time, P0_one_cost, P0_ten_cost, P0_luck_value, P0_max_luck_value, P0_count, P0_show_id, P0_show_list, P0_top_list, P0_count_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_one_cost:32, P0_ten_cost:32, P0_luck_value:32, P0_max_luck_value:32, P0_count:32, P0_show_id:32, (length(P0_show_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_show_list]))/binary, (length(P0_top_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_top_list]))/binary, (length(P0_count_list)):16, (list_to_binary([<<P1_id:32, P1_count:32, P1_state:32, (length(P1_show_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_show_list]))/binary>> || [P1_id, P1_count, P1_state, P1_show_list] <- P0_count_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43972:16,0:8, D_a_t_a/binary>>};


%% 唤神 
write(43973, {P0_code, P0_show_list}) ->
    D_a_t_a = <<P0_code:8, (length(P0_show_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_show_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43973:16,0:8, D_a_t_a/binary>>};


%% 领取次数奖励 
write(43974, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43974:16,0:8, D_a_t_a/binary>>};


%% 许愿池信息(单) 
write(43978, {P0_type, P0_leave_time, P0_cost_goods_id, P0_one_cost, P0_one_val, P0_ten_val, P0_act_gold, P0_next_val, P0_list, P0_reward_list}) ->
    D_a_t_a = <<P0_type:16, P0_leave_time:32, P0_cost_goods_id:16, P0_one_cost:16, P0_one_val:16, P0_ten_val:16, P0_act_gold:16, P0_next_val:16, (length(P0_list)):16, (list_to_binary([<<P1_rank_top:16, P1_rank_down:16, (length(P1_sub_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_sub_list]))/binary>> || [P1_rank_top, P1_rank_down, P1_sub_list] <- P0_list]))/binary, (length(P0_reward_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_reward_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43978:16,0:8, D_a_t_a/binary>>};


%% 许愿池排名(单) 
write(43979, {P0_rank, P0_my_score, P0_list}) ->
    D_a_t_a = <<P0_rank:8, P0_my_score:16, (length(P0_list)):16, (list_to_binary([<<P1_rank:8, P1_sn:32, (proto:write_string(P1_nickname))/binary, P1_score:16, P1_rank_score:16>> || [P1_rank, P1_sn, P1_nickname, P1_score, P1_rank_score] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43979:16,0:8, D_a_t_a/binary>>};


%% 许愿池抽奖(单) 
write(43980, {P0_code, P0_list}) ->
    D_a_t_a = <<P0_code:8, (length(P0_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43980:16,0:8, D_a_t_a/binary>>};


%% 许愿池信息(跨) 
write(43981, {P0_type, P0_leave_time, P0_cost_goods_id, P0_one_cost, P0_one_val, P0_ten_val, P0_act_gold, P0_next_val, P0_list, P0_reward_list}) ->
    D_a_t_a = <<P0_type:16, P0_leave_time:32, P0_cost_goods_id:16, P0_one_cost:16, P0_one_val:16, P0_ten_val:16, P0_act_gold:16, P0_next_val:16, (length(P0_list)):16, (list_to_binary([<<P1_rank_top:16, P1_rank_down:16, (length(P1_sub_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_sub_list]))/binary>> || [P1_rank_top, P1_rank_down, P1_sub_list] <- P0_list]))/binary, (length(P0_reward_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_reward_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43981:16,0:8, D_a_t_a/binary>>};


%% 许愿池排名(跨) 
write(43982, {P0_rank, P0_my_score, P0_list}) ->
    D_a_t_a = <<P0_rank:8, P0_my_score:16, (length(P0_list)):16, (list_to_binary([<<P1_rank:8, P1_sn:32, (proto:write_string(P1_nickname))/binary, P1_score:16, P1_rank_score:16>> || [P1_rank, P1_sn, P1_nickname, P1_score, P1_rank_score] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43982:16,0:8, D_a_t_a/binary>>};


%% 许愿池抽奖(跨) 
write(43983, {P0_code, P0_list}) ->
    D_a_t_a = <<P0_code:8, (length(P0_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43983:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



