%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2018-05-14 22:01:45
%%----------------------------------------------------
-module(pt_288).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"你已结婚"; 
err(3) ->"请组队前来结婚"; 
err(4) ->"结婚队伍只允许2个人"; 
err(5) ->"对方不在线"; 
err(6) ->"虽然同性才是真爱,但是我们只支持异性结婚"; 
err(7) ->"结婚配置不存在"; 
err(8) ->"亲密度不足"; 
err(9) ->"元宝不足"; 
err(10) ->"你是个好人，但是我不适合你"; 
err(11) ->"虽然我们很传统,但我们不支持重婚"; 
err(12) ->"对方元宝不足以支付结婚费用"; 
err(13) ->"您未结婚"; 
err(14) ->"您已巡游"; 
err(15) ->"您没有巡游可预约"; 
err(16) ->"您已预约了巡游"; 
err(17) ->"不能预约该时间巡游"; 
err(18) ->"该时间段的巡游已被预约"; 
err(19) ->"当前没有巡游"; 
err(20) ->"您不再野外场景中"; 
err(21) ->"您不是新人,不能派红包"; 
err(22) ->"您不是新人,不能撒糖果"; 
err(23) ->"新娘才能抛绣球"; 
err(24) ->"新郎才能抛酒壶"; 
err(25) ->"您不是宾客"; 
err(26) ->"您已经抛过绣球"; 
err(27) ->"您已经抛过酒壶"; 
err(28) ->"Roll点不存在"; 
err(29) ->"Roll点已过期"; 
err(30) ->"您已经Roll过点"; 
err(31) ->"已经领取该称号"; 
err(32) ->"戒指阶级不足"; 
err(33) ->"心心相印等级不足"; 
err(34) ->"姻缘树等级不足"; 
err(35) ->"巡游中"; 
err(36) ->"甜蜜度不足"; 
err(37) ->"未结婚不可升级"; 
err(38) ->"没有升级材料"; 
err(39) ->"未婚不可升级"; 
err(40) ->"您的等级不足"; 
err(41) ->"对方等级不足"; 
err(42) ->"您不在野外场景中"; 
err(43) ->"对方不在野外场景中"; 
err(44) ->"戒指已达满级"; 
err(45) ->"巡游次数不足"; 
err(46) ->"请与您的配偶前来"; 
err(47) ->"羁绊已达满级"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(28801, _B0) ->
    {ok, {}};

read(28802, _B0) ->
    {ok, {}};

read(28803, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {P0_pkey, _B2} = proto:read_int32(_B1),
    {ok, {P0_type, P0_pkey}};

read(28804, _B0) ->
    {ok, {}};

read(28805, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {P0_pkey, _B2} = proto:read_int32(_B1),
    {P0_ret, _B3} = proto:read_int8(_B2),
    {ok, {P0_type, P0_pkey, P0_ret}};

read(28806, _B0) ->
    {ok, {}};

read(28810, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {ok, {P0_type}};

read(28811, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {P0_id, _B2} = proto:read_int8(_B1),
    {P0_invite_guild, _B3} = proto:read_int8(_B2),
    {P0_invite_friend, _B4} = proto:read_int8(_B3),
    {ok, {P0_type, P0_id, P0_invite_guild, P0_invite_friend}};

read(28812, _B0) ->
    {ok, {}};

read(28813, _B0) ->
    {ok, {}};

read(28814, _B0) ->
    {ok, {}};

read(28815, _B0) ->
    {ok, {}};

read(28816, _B0) ->
    {P0_type, _B1} = proto:read_int8(_B0),
    {ok, {P0_type}};

read(28817, _B0) ->
    {ok, {}};

read(28818, _B0) ->
    {P0_int32, _B1} = proto:read_int32(_B0),
    {ok, {P0_int32}};

read(28819, _B0) ->
    {ok, {}};

read(28820, _B0) ->
    {ok, {}};

read(28821, _B0) ->
    {ok, {}};

read(28822, _B0) ->
    {ok, {}};

read(28850, _B0) ->
    {ok, {}};

read(28851, _B0) ->
    {ok, {}};

read(28852, _B0) ->
    {ok, {}};

read(28853, _B0) ->
    {ok, {}};

read(28855, _B0) ->
    {ok, {}};

read(28856, _B0) ->
    {ok, {}};

read(28858, _B0) ->
    {ok, {}};

read(28859, _B0) ->
    {P0_id, _B1} = proto:read_uint8(_B0),
    {ok, {P0_id}};

read(28860, _B0) ->
    {ok, {}};

read(28861, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 婚姻信息 
write(28801, {P0_state, P0_mkey, P0_pkey, P0_nickname, P0_career, P0_sex, P0_avatar, P0_fashion_id, P0_head_id, P0_my_box, P0_couple_box, P0_des_id, P0_des_percent, P0_close, P0_love_stage, P0_love_lv, P0_ring_lv, P0_tree_lv, P0_left_time}) ->
    D_a_t_a = <<P0_state:8, (proto:write_string(P0_mkey))/binary, P0_pkey:32/signed, (proto:write_string(P0_nickname))/binary, P0_career:8, P0_sex:8, (proto:write_string(P0_avatar))/binary, P0_fashion_id:32/signed, P0_head_id:32/signed, P0_my_box:8, P0_couple_box:8, P0_des_id:32/signed, P0_des_percent:8/signed, P0_close:32, P0_love_stage:16, P0_love_lv:16, P0_ring_lv:16, P0_tree_lv:16, P0_left_time:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 28801:16,0:8, D_a_t_a/binary>>};


%% 结婚配置 
write(28802, {P0_ring_lv, P0_ring_type, P0_list}) ->
    D_a_t_a = <<P0_ring_lv:32/signed, P0_ring_type:32/signed, (length(P0_list)):16, (list_to_binary([<<P1_type:8, P1_price_type:8/signed, P1_price:32, P1_close:32, P1_cruise:8/signed, (length(P1_goods_list)):16, (list_to_binary([<<P2_goods_id:32/signed, P2_num:32/signed>> || [P2_goods_id, P2_num] <- P1_goods_list]))/binary>> || [P1_type, P1_price_type, P1_price, P1_close, P1_cruise, P1_goods_list] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 28802:16,0:8, D_a_t_a/binary>>};


%% 发起结婚请求 
write(28803, {P0_code, P0_close}) ->
    D_a_t_a = <<P0_code:8/signed, P0_close:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 28803:16,0:8, D_a_t_a/binary>>};


%% 收到结婚请求 
write(28804, {P0_type, P0_pkey, P0_nickname}) ->
    D_a_t_a = <<P0_type:8, P0_pkey:32/signed, (proto:write_string(P0_nickname))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 28804:16,0:8, D_a_t_a/binary>>};


%% 结婚应答 
write(28805, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 28805:16,0:8, D_a_t_a/binary>>};


%% 离婚 
write(28806, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 28806:16,0:8, D_a_t_a/binary>>};


%% 获取巡游时间表 
write(28810, {P0_times, P0_price, P0_time_list}) ->
    D_a_t_a = <<P0_times:8/signed, P0_price:16/signed, (length(P0_time_list)):16, (list_to_binary([<<P1_id:8/signed, P1_hour:8/signed, P1_min:8/signed, P1_state:8/signed>> || [P1_id, P1_hour, P1_min, P1_state] <- P0_time_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 28810:16,0:8, D_a_t_a/binary>>};


%% 预约巡游 
write(28811, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 28811:16,0:8, D_a_t_a/binary>>};


%% 巡游状态通知(图标) 
write(28812, {P0_state, P0_time}) ->
    D_a_t_a = <<P0_state:8/signed, P0_time:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 28812:16,0:8, D_a_t_a/binary>>};


%% 通知新人巡游开始 
write(28813, {P0_nickname}) ->
    D_a_t_a = <<(proto:write_string(P0_nickname))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 28813:16,0:8, D_a_t_a/binary>>};


%% 查看当前巡游新人信息 
write(28814, {P0_code, P0_time, P0_role_list}) ->
    D_a_t_a = <<P0_code:8/signed, P0_time:16/signed, (length(P0_role_list)):16, (list_to_binary([<<P1_pkey:32, (proto:write_string(P1_nickname))/binary, P1_career:8/signed, P1_sex:8/signed, (proto:write_string(P1_avatar))/binary>> || [P1_pkey, P1_nickname, P1_career, P1_sex, P1_avatar] <- P0_role_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 28814:16,0:8, D_a_t_a/binary>>};


%% 前往观礼/巡游 
write(28815, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 28815:16,0:8, D_a_t_a/binary>>};


%% 巡游互动 
write(28816, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 28816:16,0:8, D_a_t_a/binary>>};


%% R点信息 
write(28817, {P0_type, P0_nickname, P0_key, P0_time, P0_goods_id, P0_num, P0_point_h, P0_m_nickname, P0_point}) ->
    D_a_t_a = <<P0_type:8/signed, (proto:write_string(P0_nickname))/binary, P0_key:32/signed, P0_time:8/signed, P0_goods_id:32/signed, P0_num:8/signed, P0_point_h:8/signed, (proto:write_string(P0_m_nickname))/binary, P0_point:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 28817:16,0:8, D_a_t_a/binary>>};


%% R点 
write(28818, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 28818:16,0:8, D_a_t_a/binary>>};


%% R点最终结果 
write(28819, {P0_int32, P0_point, P0_nickname}) ->
    D_a_t_a = <<P0_int32:32/signed, P0_point:16/signed, (proto:write_string(P0_nickname))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 28819:16,0:8, D_a_t_a/binary>>};


%% 收到宾客送礼通知 
write(28820, {P0_nickname, P0_goods_id}) ->
    D_a_t_a = <<(proto:write_string(P0_nickname))/binary, P0_goods_id:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 28820:16,0:8, D_a_t_a/binary>>};


%% 广播婚车位置给新人 
write(28821, {P0_x, P0_y}) ->
    D_a_t_a = <<P0_x:8/signed, P0_y:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 28821:16,0:8, D_a_t_a/binary>>};


%% 购买巡游次数 
write(28822, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 28822:16,0:8, D_a_t_a/binary>>};


%% 获取结婚榜信息 
write(28850, {P0_leave_time, P0_rank, P0_state, P0_rank_list, P0_reward_list}) ->
    D_a_t_a = <<P0_leave_time:32, P0_rank:32, P0_state:8, (length(P0_rank_list)):16, (list_to_binary([<<P1_rank0:32, (proto:write_string(P1_bname))/binary, (proto:write_string(P1_bavatar))/binary, (proto:write_string(P1_gname))/binary, (proto:write_string(P1_gavatar))/binary>> || [P1_rank0, P1_bname, P1_bavatar, P1_gname, P1_gavatar] <- P0_rank_list]))/binary, (length(P0_reward_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_reward_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 28850:16,0:8, D_a_t_a/binary>>};


%% 领取结婚榜奖励 
write(28851, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 28851:16,0:8, D_a_t_a/binary>>};


%% 羁绊信息 
write(28852, {P0_stage, P0_cur_type, P0_my_lv, P0_couple_lv, P0_type_list, P0_cbp, P0_attr_list}) ->
    D_a_t_a = <<P0_stage:16, P0_cur_type:32/signed, P0_my_lv:32/signed, P0_couple_lv:32/signed, (length(P0_type_list)):16, (list_to_binary([<<P1_type:32/signed, P1_lv:32/signed>> || [P1_type, P1_lv] <- P0_type_list]))/binary, P0_cbp:32, (length(P0_attr_list)):16, (list_to_binary([<<P1_attr_type:8, P1_value:32>> || [P1_attr_type, P1_value] <- P0_attr_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 28852:16,0:8, D_a_t_a/binary>>};


%% 升级羁绊 
write(28853, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 28853:16,0:8, D_a_t_a/binary>>};


%% 获取戒指信息  
write(28855, {P0_stage, P0_couple_stage, P0_type, P0_exp, P0_max_exp, P0_cbp, P0_buff_id, P0_couple_name, P0_career, P0_sex, P0_wing_id, P0_wepon_id, P0_clothing_id, P0_light_wepon_id, P0_fashion_cloth_id, P0_fashion_head_id, P0_attribute_list}) ->
    D_a_t_a = <<P0_stage:16/signed, P0_couple_stage:16/signed, P0_type:16/signed, P0_exp:16/signed, P0_max_exp:32/signed, P0_cbp:32/signed, P0_buff_id:32/signed, (proto:write_string(P0_couple_name))/binary, P0_career:8, P0_sex:8, P0_wing_id:32, P0_wepon_id:32, P0_clothing_id:32, P0_light_wepon_id:32, P0_fashion_cloth_id:32, P0_fashion_head_id:32/signed, (length(P0_attribute_list)):16, (list_to_binary([<<P1_type:32, P1_value:32/signed>> || [P1_type, P1_value] <- P0_attribute_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 28855:16,0:8, D_a_t_a/binary>>};


%% 戒指升级 
write(28856, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 28856:16,0:8, D_a_t_a/binary>>};


%% 获取称号信息  
write(28858, {P0_ring_lv, P0_tree_lv, P0_heart_stage, P0_attribute_list}) ->
    D_a_t_a = <<P0_ring_lv:32/signed, P0_tree_lv:32/signed, P0_heart_stage:32/signed, (length(P0_attribute_list)):16, (list_to_binary([<<P1_id:8, P1_goods_id:32/signed, P1_state:8, P1_need_ring_lv:32/signed, P1_need_tree_lv:32/signed, P1_need_heart_stage:32/signed>> || [P1_id, P1_goods_id, P1_state, P1_need_ring_lv, P1_need_tree_lv, P1_need_heart_stage] <- P0_attribute_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 28858:16,0:8, D_a_t_a/binary>>};


%% 领取称号 
write(28859, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 28859:16,0:8, D_a_t_a/binary>>};


%% 结婚烟花使用 
write(28860, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 28860:16,0:8, D_a_t_a/binary>>};


%% 配偶上线 
write(28861, {P0_nickname}) ->
    D_a_t_a = <<(proto:write_string(P0_nickname))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 28861:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



