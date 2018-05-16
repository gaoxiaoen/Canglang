%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-07-20 15:01:56
%%----------------------------------------------------
-module(pt_437).
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

read(43700, _B0) ->
    {ok, {}};

read(43701, _B0) ->
    {ok, {}};

read(43702, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {P0_args, _B2} = proto:read_uint32(_B1),
    {ok, {P0_type, P0_args}};

read(43703, _B0) ->
    {ok, {}};

read(43704, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {P0_args, _B2} = proto:read_uint32(_B1),
    {ok, {P0_type, P0_args}};

read(43705, _B0) ->
    {ok, {}};

read(43706, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {P0_args, _B2} = proto:read_uint32(_B1),
    {ok, {P0_type, P0_args}};

read(43711, _B0) ->
    {ok, {}};

read(43712, _B0) ->
    {P0_base_group_num, _B1} = proto:read_uint16(_B0),
    {P0_base_charge_gold, _B2} = proto:read_uint32(_B1),
    {ok, {P0_base_group_num, P0_base_charge_gold}};

read(43713, _B0) ->
    {ok, {}};

read(43714, _B0) ->
    {P0_base_charge_gold, _B1} = proto:read_uint32(_B0),
    {ok, {P0_base_charge_gold}};

read(43715, _B0) ->
    {ok, {}};

read(43716, _B0) ->
    {P0_order_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_order_id}};

read(43717, _B0) ->
    {ok, {}};

read(43718, _B0) ->
    {ok, {}};

read(43719, _B0) ->
    {P0_exchange_id, _B1} = proto:read_uint8(_B0),
    {ok, {P0_exchange_id}};

read(43750, _B0) ->
    {ok, {}};

read(43751, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 获取合服天数 
write(43700, {P0_merge_day, P0_merge_act_list}) ->
    D_a_t_a = <<P0_merge_day:16, (length(P0_merge_act_list)):16, (list_to_binary([<<P1_act_type:8, P1_act_sub_type:8, P1_state:8/signed>> || [P1_act_type, P1_act_sub_type, P1_state] <- P0_merge_act_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43700:16,0:8, D_a_t_a/binary>>};


%% 获取合服活动之进阶目标一信息 
write(43701, {P0_leave_time, P0_list}) ->
    D_a_t_a = <<P0_leave_time:32, (length(P0_list)):16, (list_to_binary([<<P1_type:8, P1_args:32, P1_state:8, (length(P1_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32, P2_time:16>> || [P2_goods_id, P2_goods_num, P2_time] <- P1_list]))/binary>> || [P1_type, P1_args, P1_state, P1_list] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43701:16,0:8, D_a_t_a/binary>>};


%% 领取进阶目标一奖励 
write(43702, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43702:16,0:8, D_a_t_a/binary>>};


%% 获取合服活动之进阶二目标信息 
write(43703, {P0_leave_time, P0_list}) ->
    D_a_t_a = <<P0_leave_time:32, (length(P0_list)):16, (list_to_binary([<<P1_type:8, P1_args:32, P1_state:8, (length(P1_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32, P2_time:16>> || [P2_goods_id, P2_goods_num, P2_time] <- P1_list]))/binary>> || [P1_type, P1_args, P1_state, P1_list] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43703:16,0:8, D_a_t_a/binary>>};


%% 领取进阶目标二奖励 
write(43704, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43704:16,0:8, D_a_t_a/binary>>};


%% 获取开服活动之进阶目标三信息 
write(43705, {P0_leave_time, P0_list}) ->
    D_a_t_a = <<P0_leave_time:32, (length(P0_list)):16, (list_to_binary([<<P1_type:8, P1_args:32, P1_state:8, (length(P1_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32, P2_time:16>> || [P2_goods_id, P2_goods_num, P2_time] <- P1_list]))/binary>> || [P1_type, P1_args, P1_state, P1_list] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43705:16,0:8, D_a_t_a/binary>>};


%% 领取进阶目标奖励三 
write(43706, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43706:16,0:8, D_a_t_a/binary>>};


%% 获取合服活动之首充团购信息 
write(43711, {P0_leave_time, P0_list}) ->
    D_a_t_a = <<P0_leave_time:32, (length(P0_list)):16, (list_to_binary([<<P1_base_group_num:16, P1_group_num:16, P1_base_charge_gold:32, P1_gift_id:32, P1_state:8>> || [P1_base_group_num, P1_group_num, P1_base_charge_gold, P1_gift_id, P1_state] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43711:16,0:8, D_a_t_a/binary>>};


%% 领取首充团购奖励 
write(43712, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43712:16,0:8, D_a_t_a/binary>>};


%% 获取合服活动之累积充值信息 
write(43713, {P0_leave_time, P0_charge_gold, P0_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_charge_gold:32, (length(P0_list)):16, (list_to_binary([<<P1_base_charge_gold:32, P1_gift_id:32, P1_state:8>> || [P1_base_charge_gold, P1_gift_id, P1_state] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43713:16,0:8, D_a_t_a/binary>>};


%% 领取累积充值奖励 
write(43714, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43714:16,0:8, D_a_t_a/binary>>};


%% 合服活动之返利抢购 
write(43715, {P0_leave_time, P0_list}) ->
    D_a_t_a = <<P0_leave_time:32, (length(P0_list)):16, (list_to_binary([<<P1_order_id:32, P1_state:8, P1_discount:8, P1_base_price:32, P1_price:32, P1_is_hour:8, P1_goods_id:32, P1_goods_num:32, P1_limit_buy_num:16>> || [P1_order_id, P1_state, P1_discount, P1_base_price, P1_price, P1_is_hour, P1_goods_id, P1_goods_num, P1_limit_buy_num] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43715:16,0:8, D_a_t_a/binary>>};


%% 合服活动之返利抢购购买 
write(43716, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43716:16,0:8, D_a_t_a/binary>>};


%% 获取合服活动之公会排行 
write(43717, {P0_leave_time, P0_list}) ->
    D_a_t_a = <<P0_leave_time:32, (length(P0_list)):16, (list_to_binary([<<P1_rank:8, P1_type:8, P1_gift_id:32>> || [P1_rank, P1_type, P1_gift_id] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43717:16,0:8, D_a_t_a/binary>>};


%% 获取合服兑换活动信息 
write(43718, {P0_leave_time, P0_list}) ->
    D_a_t_a = <<P0_leave_time:32, (length(P0_list)):16, (list_to_binary([<<P1_exchange_id:8, P1_num:32, (length(P1_cost_list)):16, (list_to_binary([<<P2_cost_goods_id:32, P2_cost_num:32>> || [P2_cost_goods_id, P2_cost_num] <- P1_cost_list]))/binary, (length(P1_get_list)):16, (list_to_binary([<<P2_get_goods_id:32, P2_get_num:32>> || [P2_get_goods_id, P2_get_num] <- P1_get_list]))/binary>> || [P1_exchange_id, P1_num, P1_cost_list, P1_get_list] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43718:16,0:8, D_a_t_a/binary>>};


%% 兑换 
write(43719, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43719:16,0:8, D_a_t_a/binary>>};


%% 获取合服七天登陆信息 
write(43750, {P0_leave_time, P0_state, P0_get_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_state:8, (length(P0_get_list)):16, (list_to_binary([<<P1_get_goods_id:32, P1_get_num:32>> || [P1_get_goods_id, P1_get_num] <- P0_get_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43750:16,0:8, D_a_t_a/binary>>};


%% 领取合服七天奖励 
write(43751, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43751:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



