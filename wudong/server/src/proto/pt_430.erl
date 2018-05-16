%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2018-01-24 14:01:18
%%----------------------------------------------------
-module(pt_430).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"还不能领取"; 
err(3) ->"已经领取"; 
err(4) ->"活动还没开启"; 
err(5) ->"元宝不足"; 
err(6) ->"已经抢购完了"; 
err(7) ->"还不能抽奖"; 
err(8) ->"兑换物品不足"; 
err(9) ->"已经领取了其他礼包"; 
err(10) ->"卡号不存在"; 
err(11) ->"错误"; 
err(12) ->"非法卡号"; 
err(13) ->"使用时间未到"; 
err(14) ->"卡号过期"; 
err(15) ->"非本渠道卡号"; 
err(16) ->"非本服卡号"; 
err(17) ->"卡号已使用"; 
err(18) ->"同类卡号已使用"; 
err(19) ->"限购次数不足"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(43000, _B0) ->
    {ok, {}};

read(43001, _B0) ->
    {ok, {}};

read(43002, _B0) ->
    {P0_days, _B1} = proto:read_uint8(_B0),
    {ok, {P0_days}};

read(43011, _B0) ->
    {ok, {}};

read(43012, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {P0_giftid, _B2} = proto:read_uint32(_B1),
    {ok, {P0_type, P0_giftid}};

read(43013, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {ok, {P0_type}};

read(43014, _B0) ->
    {ok, {}};

read(43015, _B0) ->
    {ok, {}};

read(43021, _B0) ->
    {ok, {}};

read(43022, _B0) ->
    {ok, {}};

read(43023, _B0) ->
    {ok, {}};

read(43031, _B0) ->
    {ok, {}};

read(43032, _B0) ->
    {P0_id, _B1} = proto:read_uint16(_B0),
    {ok, {P0_id}};

read(43041, _B0) ->
    {ok, {}};

read(43042, _B0) ->
    {P0_id, _B1} = proto:read_uint16(_B0),
    {ok, {P0_id}};

read(43051, _B0) ->
    {ok, {}};

read(43052, _B0) ->
    {P0_id, _B1} = proto:read_uint16(_B0),
    {ok, {P0_id}};

read(43060, _B0) ->
    {P0_card_id, _B1} = proto:read_string(_B0),
    {ok, {P0_card_id}};

read(43061, _B0) ->
    {P0_card_id, _B1} = proto:read_string(_B0),
    {ok, {P0_card_id}};

read(43071, _B0) ->
    {ok, {}};

read(43072, _B0) ->
    {P0_id, _B1} = proto:read_uint16(_B0),
    {ok, {P0_id}};

read(43081, _B0) ->
    {ok, {}};

read(43082, _B0) ->
    {ok, {}};

read(43091, _B0) ->
    {ok, {}};

read(43092, _B0) ->
    {ok, {}};

read(43094, _B0) ->
    {ok, {}};

read(43095, _B0) ->
    {ok, {}};

read(43096, _B0) ->
    {P0_id, _B1} = proto:read_uint8(_B0),
    {ok, {P0_id}};

read(43097, _B0) ->
    {ok, {}};

read(43098, _B0) ->
    {P0_id, _B1} = proto:read_uint8(_B0),
    {ok, {P0_id}};

read(43099, _B0) ->
    {P0_des_id, _B1} = proto:read_uint8(_B0),
    {ok, {P0_des_id}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 总活动列表 
write(43000, {P0_act_list}) ->
    D_a_t_a = <<(length(P0_act_list)):16, (list_to_binary([<<P1_des_id:8, P1_state:8/signed>> || [P1_des_id, P1_state] <- P0_act_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43000:16,0:8, D_a_t_a/binary>>};


%% 获取首充活动信息 
write(43001, {P0_is_charge, P0_gift_list}) ->
    D_a_t_a = <<P0_is_charge:8, (length(P0_gift_list)):16, (list_to_binary([<<P1_days:8, P1_gift_id:32, P1_state:8>> || [P1_days, P1_gift_id, P1_state] <- P0_gift_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43001:16,0:8, D_a_t_a/binary>>};


%% 领取首充礼包 
write(43002, {P0_res, P0_days}) ->
    D_a_t_a = <<P0_res:8, P0_days:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43002:16,0:8, D_a_t_a/binary>>};


%% 获取冲榜活动信息 
write(43011, {P0_days, P0_rank_list}) ->
    D_a_t_a = <<P0_days:8, (length(P0_rank_list)):16, (list_to_binary([<<P1_type:8, P1_leave_time:32/signed, P1_myrank:8, (length(P1_gift_list)):16, (list_to_binary([<<P2_rank:8, P2_giftid:32>> || [P2_rank, P2_giftid] <- P1_gift_list]))/binary, (length(P1_reward_list)):16, (list_to_binary([<<P2_rank:8, P2_info:32, (pack_player(P2_player_info))/binary>> || [P2_rank, P2_info, P2_player_info] <- P1_reward_list]))/binary>> || [P1_type, P1_leave_time, P1_myrank, P1_gift_list, P1_reward_list] <- P0_rank_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43011:16,0:8, D_a_t_a/binary>>};


%% 购买促销物品 
write(43012, {P0_res, P0_giftid, P0_maxnum}) ->
    D_a_t_a = <<P0_res:8, P0_giftid:32, P0_maxnum:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43012:16,0:8, D_a_t_a/binary>>};


%% 获取排名信息 
write(43013, {P0_rank_list}) ->
    D_a_t_a = <<(length(P0_rank_list)):16, (list_to_binary([<<P1_rank:8, P1_info:32, (pack_player(P1_player_info))/binary>> || [P1_rank, P1_info, P1_player_info] <- P0_rank_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43013:16,0:8, D_a_t_a/binary>>};


%% 获取抢购信息 
write(43014, {P0_type, P0_leave_time, P0_sell_list}) ->
    D_a_t_a = <<P0_type:8, P0_leave_time:32/signed, (length(P0_sell_list)):16, (list_to_binary([<<P1_giftid:32, P1_maxnum:32, P1_gold:32, P1_oldgold:32>> || [P1_giftid, P1_maxnum, P1_gold, P1_oldgold] <- P0_sell_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43014:16,0:8, D_a_t_a/binary>>};


%% 获取名人堂信息 
write(43015, {P0_rank_list}) ->
    D_a_t_a = <<(length(P0_rank_list)):16, (list_to_binary([<<P1_type:8, P1_pkey:32, (proto:write_string(P1_name))/binary, P1_vip:8/signed, P1_realm:8/signed, P1_career:8/signed, P1_power:32/signed, P1_wing_id:32, P1_wepon_id:32, P1_clothing_id:32, P1_light_wepon_id:32, P1_fashion_cloth_id:32, P1_fashion_footprint_id:32, P1_mount_id:32, (length(P1_design_list)):16, (list_to_binary([<<P2_design_id:32>> || P2_design_id <- P1_design_list]))/binary>> || [P1_type, P1_pkey, P1_name, P1_vip, P1_realm, P1_career, P1_power, P1_wing_id, P1_wepon_id, P1_clothing_id, P1_light_wepon_id, P1_fashion_cloth_id, P1_fashion_footprint_id, P1_mount_id, P1_design_list] <- P0_rank_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43015:16,0:8, D_a_t_a/binary>>};


%% 获取每日充值活动信息 
write(43021, {P0_leave_time, P0_state, P0_goods_list, P0_get_goods_id, P0_get_goods_num, P0_ex_goods_id, P0_ex_goods_num, P0_ex_need_num, P0_record_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_state:8, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_goods_list]))/binary, P0_get_goods_id:32, P0_get_goods_num:32, P0_ex_goods_id:32, P0_ex_goods_num:32, P0_ex_need_num:32, (length(P0_record_list)):16, (list_to_binary([<<P1_pkey:32, (proto:write_string(P1_name))/binary, P1_goods_id:32>> || [P1_pkey, P1_name, P1_goods_id] <- P0_record_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43021:16,0:8, D_a_t_a/binary>>};


%% 每日充值抽奖 
write(43022, {P0_res, P0_goods_id, P0_goods_num}) ->
    D_a_t_a = <<P0_res:8, P0_goods_id:32, P0_goods_num:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43022:16,0:8, D_a_t_a/binary>>};


%% 每日充值兑换 
write(43023, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43023:16,0:8, D_a_t_a/binary>>};


%% 获取累计充值活动信息 
write(43031, {P0_leave_time, P0_acc_val, P0_act_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_acc_val:32, (length(P0_act_list)):16, (list_to_binary([<<P1_id:16, P1_acc:32, P1_state:8, (length(P1_get_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_get_list]))/binary>> || [P1_id, P1_acc, P1_state, P1_get_list] <- P0_act_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43031:16,0:8, D_a_t_a/binary>>};


%% 领取奖励 
write(43032, {P0_res, P0_id}) ->
    D_a_t_a = <<P0_res:8, P0_id:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43032:16,0:8, D_a_t_a/binary>>};


%% 获取累计消费活动信息 
write(43041, {P0_leave_time, P0_acc_val, P0_act_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_acc_val:32, (length(P0_act_list)):16, (list_to_binary([<<P1_id:16, P1_acc:32, P1_state:8, (length(P1_reward_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_reward_list]))/binary>> || [P1_id, P1_acc, P1_state, P1_reward_list] <- P0_act_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43041:16,0:8, D_a_t_a/binary>>};


%% 领取奖励 
write(43042, {P0_res, P0_id}) ->
    D_a_t_a = <<P0_res:8, P0_id:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43042:16,0:8, D_a_t_a/binary>>};


%% 获取单笔充值活动信息 
write(43051, {P0_leave_time, P0_acc_val, P0_act_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_acc_val:32, (length(P0_act_list)):16, (list_to_binary([<<P1_id:16, P1_acc:32, P1_gift_id:32, P1_state:8>> || [P1_id, P1_acc, P1_gift_id, P1_state] <- P0_act_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43051:16,0:8, D_a_t_a/binary>>};


%% 领取奖励 
write(43052, {P0_res, P0_id}) ->
    D_a_t_a = <<P0_res:8, P0_id:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43052:16,0:8, D_a_t_a/binary>>};


%% 卡号兑换 
write(43060, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43060:16,0:8, D_a_t_a/binary>>};


%% 自定义卡号兑换 
write(43061, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43061:16,0:8, D_a_t_a/binary>>};


%% 获取冲榜返还信息 
write(43071, {P0_rank_list}) ->
    D_a_t_a = <<(length(P0_rank_list)):16, (list_to_binary([<<P1_type:8, P1_leavetime:32, P1_now_goal:32, (length(P1_act_list)):16, (list_to_binary([<<P2_id:16, P2_goal:32, P2_gift_id:32, P2_state:8>> || [P2_id, P2_goal, P2_gift_id, P2_state] <- P1_act_list]))/binary>> || [P1_type, P1_leavetime, P1_now_goal, P1_act_list] <- P0_rank_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43071:16,0:8, D_a_t_a/binary>>};


%% 领取奖励 
write(43072, {P0_res, P0_id}) ->
    D_a_t_a = <<P0_res:8, P0_id:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43072:16,0:8, D_a_t_a/binary>>};


%% 获取新每日充值活动信息 
write(43081, {P0_state, P0_gift_id, P0_leave_time}) ->
    D_a_t_a = <<P0_state:8, P0_gift_id:32, P0_leave_time:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43081:16,0:8, D_a_t_a/binary>>};


%% 领取新每日充值礼包 
write(43082, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43082:16,0:8, D_a_t_a/binary>>};


%% 获取新单笔充值活动信息 
write(43091, {P0_state, P0_gift_id, P0_leave_time, P0_need_charge}) ->
    D_a_t_a = <<P0_state:8, P0_gift_id:32, P0_leave_time:32, P0_need_charge:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43091:16,0:8, D_a_t_a/binary>>};


%% 领取新单笔充值礼包 
write(43092, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43092:16,0:8, D_a_t_a/binary>>};


%% 获取藏宝阁活动信息 
write(43094, {P0_state, P0_act_open_day, P0_leave_time, P0_show_day, P0_login_reward_list, P0_buy_list}) ->
    D_a_t_a = <<P0_state:8, P0_act_open_day:8, P0_leave_time:32, P0_show_day:8, (length(P0_login_reward_list)):16, (list_to_binary([<<P1_id:32, P1_num:32>> || [P1_id, P1_num] <- P0_login_reward_list]))/binary, (length(P0_buy_list)):16, (list_to_binary([<<P1_id:8, P1_price:16, P1_base_price:16, P1_base_buy_num:16, P1_remain_buy_num:16, P1_show_type:8, P1_show_stage:8, (length(P1_buy_reward_list)):16, (list_to_binary([<<P2_id:32, P2_num:32>> || [P2_id, P2_num] <- P1_buy_reward_list]))/binary>> || [P1_id, P1_price, P1_base_price, P1_base_buy_num, P1_remain_buy_num, P1_show_type, P1_show_stage, P1_buy_reward_list] <- P0_buy_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43094:16,0:8, D_a_t_a/binary>>};


%% 领取藏宝阁登陆礼包 
write(43095, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43095:16,0:8, D_a_t_a/binary>>};


%% 购买限购礼包 
write(43096, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43096:16,0:8, D_a_t_a/binary>>};


%% 总活动集合信息 
write(43097, {P0_act_list}) ->
    D_a_t_a = <<(length(P0_act_list)):16, (list_to_binary([<<P1_id:8, (proto:write_string(P1_name))/binary>> || [P1_id, P1_name] <- P0_act_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43097:16,0:8, D_a_t_a/binary>>};


%% 活动集合信息 
write(43098, {P0_id, P0_leave_time, P0_name, P0_desc, P0_goods_list}) ->
    D_a_t_a = zlib:compress(<<P0_id:8, P0_leave_time:32/signed, (proto:write_string(P0_name))/binary, (proto:write_string(P0_desc))/binary, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32>> || P1_goods_id <- P0_goods_list]))/binary>>),
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43098:16,1:8, D_a_t_a/binary>>};


%% 所有活动/功能的奖励状态更新 
write(43099, {P0_act_list}) ->
    D_a_t_a = <<(length(P0_act_list)):16, (list_to_binary([<<P1_des_id:8, P1_state:8/signed, P1_leave_time:32/signed, P1_icon:32/signed, P1_show_pos:8/signed>> || [P1_des_id, P1_state, P1_leave_time, P1_icon, P1_show_pos] <- P0_act_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 43099:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------

pack_player([P0_player_key, P0_sn, P0_pf, P0_name, P0_lv, P0_career, P0_vip, P0_realm]) ->
    D_a_t_a = <<P0_player_key:32, P0_sn:32, P0_pf:32, (proto:write_string(P0_name))/binary, P0_lv:32, P0_career:8, P0_vip:32, P0_realm:32>>,
    <<D_a_t_a/binary>>.




