%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2018-04-19 18:30:21
%%----------------------------------------------------
-module(pt_160).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"背包空间不足"; 
err(3) ->"所需物品不足"; 
err(4) ->"玩家等级不足"; 
err(5) ->"银币不足"; 
err(6) ->"物品不存在"; 
err(7) ->"配置问题"; 
err(8) ->"该位置已经镶嵌了更高等级的灵石"; 
err(9) ->"灵石类型与孔类型不匹配"; 
err(10) ->"该孔没有镶嵌的灵石，无法拆除"; 
err(11) ->"该位置没有镶嵌灵石，无法升级"; 
err(12) ->"已经到了最大强化等级"; 
err(13) ->"该装备已经到了最大洗练条数"; 
err(14) ->"灵石已经到达最高等级"; 
err(15) ->"元宝不足"; 
err(16) ->"洗练来源必须为有洗练属性的装备"; 
err(17) ->"职业不符合，不能装备"; 
err(18) ->"装备替换成功，原装备附加属性已经转移到新装备中"; 
err(19) ->"强化失败掉级"; 
err(20) ->"已经到了最大星级"; 
err(21) ->"升级后装备穿戴等级不能大于人物等级"; 
err(22) ->"不提示错误"; 
err(23) ->"强化成功"; 
err(24) ->"属性石已达上限，请提升坐骑阶级"; 
err(25) ->"属性石已达上限，请提升光翼阶级"; 
err(26) ->"属性石已达上限，请提升宠物阶级"; 
err(27) ->"该类型最大只允许合成1个"; 
err(28) ->"你已经拥有该坐骑，无须继续合成，剩余碎片可以用于在坐骑面板升星该坐骑"; 
err(29) ->"你已经拥有该翅膀，无须继续合成，剩余碎片可以用于在坐骑面板升星该翅膀"; 
err(30) ->"当前灵石已强化至最高等级"; 
err(31) ->"强化出现了暴击"; 
err(32) ->"装备强化等级提升"; 
err(33) ->"强化出现了幸运一击"; 
err(34) ->"该类型灵石已经到达最大等级"; 
err(35) ->"材料不足以升级灵石"; 
err(36) ->"玩家等级不足,不能升级"; 
err(37) ->"元宝不足"; 
err(38) ->"等级不足,无法洗练"; 
err(39) ->"自动购买价格错误"; 
err(40) ->"已达精炼上限"; 
err(41) ->"物品不足"; 
err(42) ->"图纸合成材料不足"; 
err(43) ->"非红装不可附魔"; 
err(44) ->"已达附魔上限"; 
err(45) ->"合成材料不足"; 
err(46) ->"武魂装备位置有误"; 
err(47) ->"武魂装备不存在"; 
err(48) ->"该位置武魂未开启"; 
err(49) ->"已达神炼上限"; 
err(50) ->"武魂位置已经开启"; 
err(51) ->"非红装不可神炼"; 
err(52) ->"不可镶嵌同类武魂"; 
err(53) ->"你已有更好的装备"; 
err(54) ->"未达成"; 
err(55) ->"已激活"; 
err(56) ->"已达升级上限"; 
err(57) ->"装备碎片不足"; 
err(58) ->"已达兑换上限"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(16001, _B0) ->
    {P0_goods_key, _B1} = proto:read_key(_B0),
    {ok, {P0_goods_key}};

read(16002, _B0) ->
    {P0_goods_key, _B1} = proto:read_key(_B0),
    {ok, {P0_goods_key}};

read(16003, _B0) ->
    {P0_goods_key, _B1} = proto:read_key(_B0),
    {P0_auto_buy, _B2} = proto:read_uint8(_B1),
    {ok, {P0_goods_key, P0_auto_buy}};

read(16004, _B0) ->
    {P0_main_goods_key, _B1} = proto:read_key(_B0),
    {P0_minor_goods_key, _B2} = proto:read_key(_B1),
    {P0_where, _B3} = proto:read_uint8(_B2),
    {ok, {P0_main_goods_key, P0_minor_goods_key, P0_where}};

read(16005, _B0) ->
    {ok, {}};

read(16006, _B0) ->
    {P0_subtype, _B1} = proto:read_int16(_B0),
    {ok, {P0_subtype}};

read(16007, _B0) ->
    {P0_goods_key, _B1} = proto:read_key(_B0),
    {P0_gem_type, _B2} = proto:read_uint16(_B1),
    {ok, {P0_goods_key, P0_gem_type}};

read(16008, _B0) ->
    {ok, {}};

read(16009, _B0) ->
    {ok, {}};

read(16011, _B0) ->
    {P0_goods_key_ist, _B3} = proto:read_array(_B0, fun(_B1) ->
        {P1_goods_key, _B2} = proto:read_key(_B1),
        {P1_goods_key, _B2}
    end),
    {ok, {P0_goods_key_ist}};

read(16012, _B0) ->
    {ok, {}};

read(16013, _B0) ->
    {P0_goods_key1, _B1} = proto:read_key(_B0),
    {P0_goods_key2, _B2} = proto:read_key(_B1),
    {ok, {P0_goods_key1, P0_goods_key2}};

read(16014, _B0) ->
    {P0_goods_key, _B1} = proto:read_key(_B0),
    {ok, {P0_goods_key}};

read(16015, _B0) ->
    {P0_goods_key, _B1} = proto:read_key(_B0),
    {ok, {P0_goods_key}};

read(16016, _B0) ->
    {P0_auto_buy, _B1} = proto:read_uint8(_B0),
    {P0_goods_key, _B2} = proto:read_key(_B1),
    {P0_lock, _B5} = proto:read_array(_B2, fun(_B3) ->
        {P1_pos, _B4} = proto:read_uint8(_B3),
        {P1_pos, _B4}
    end),
    {ok, {P0_auto_buy, P0_goods_key, P0_lock}};

read(16017, _B0) ->
    {P0_goods_key, _B1} = proto:read_key(_B0),
    {ok, {P0_goods_key}};

read(16018, _B0) ->
    {ok, {}};

read(16019, _B0) ->
    {P0_id, _B1} = proto:read_uint32(_B0),
    {P0_num, _B2} = proto:read_uint16(_B1),
    {ok, {P0_id, P0_num}};

read(16020, _B0) ->
    {ok, {}};

read(16022, _B0) ->
    {P0_goods_key, _B1} = proto:read_key(_B0),
    {ok, {P0_goods_key}};

read(16023, _B0) ->
    {P0_goods_id, _B1} = proto:read_uint32(_B0),
    {P0_num, _B2} = proto:read_uint8(_B1),
    {ok, {P0_goods_id, P0_num}};

read(16026, _B0) ->
    {P0_goods_key, _B1} = proto:read_key(_B0),
    {ok, {P0_goods_key}};

read(16029, _B0) ->
    {P0_goods_key, _B1} = proto:read_key(_B0),
    {ok, {P0_goods_key}};

read(16035, _B0) ->
    {P0_goods_key, _B1} = proto:read_key(_B0),
    {ok, {P0_goods_key}};

read(16037, _B0) ->
    {P0_goods_key, _B1} = proto:read_key(_B0),
    {P0_location, _B2} = proto:read_uint8(_B1),
    {P0_goods_id, _B3} = proto:read_uint32(_B2),
    {ok, {P0_goods_key, P0_location, P0_goods_id}};

read(16038, _B0) ->
    {P0_goods_key, _B1} = proto:read_key(_B0),
    {P0_location, _B2} = proto:read_uint8(_B1),
    {ok, {P0_goods_key, P0_location}};

read(16039, _B0) ->
    {P0_goods_id, _B1} = proto:read_uint32(_B0),
    {P0_goods_num, _B2} = proto:read_uint32(_B1),
    {ok, {P0_goods_id, P0_goods_num}};

read(16040, _B0) ->
    {P0_goods_key, _B1} = proto:read_key(_B0),
    {ok, {P0_goods_key}};

read(16041, _B0) ->
    {ok, {}};

read(16042, _B0) ->
    {P0_goods_key, _B1} = proto:read_key(_B0),
    {P0_location, _B2} = proto:read_uint8(_B1),
    {P0_goods_id, _B3} = proto:read_int32(_B2),
    {ok, {P0_goods_key, P0_location, P0_goods_id}};

read(16050, _B0) ->
    {P0_goods_id, _B1} = proto:read_uint32(_B0),
    {P0_consume_list, _B5} = proto:read_array(_B1, fun(_B2) ->
        {P1_goods_key, _B3} = proto:read_uint32(_B2),
        {P1_cost_num, _B4} = proto:read_uint16(_B3),
        {[P1_goods_key, P1_cost_num], _B4}
    end),
    {ok, {P0_goods_id, P0_consume_list}};

read(16055, _B0) ->
    {ok, {}};

read(16056, _B0) ->
    {P0_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_id}};

read(16057, _B0) ->
    {P0_goods_key, _B1} = proto:read_key(_B0),
    {ok, {P0_goods_key}};

read(16058, _B0) ->
    {P0_type, _B1} = proto:read_uint32(_B0),
    {ok, {P0_type}};

read(16059, _B0) ->
    {P0_type, _B1} = proto:read_uint32(_B0),
    {P0_id, _B2} = proto:read_uint16(_B1),
    {ok, {P0_type, P0_id}};

read(16060, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 穿戴装备 
write(16001, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16001:16,0:8, D_a_t_a/binary>>};


%% 卸下装备 
write(16002, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16002:16,0:8, D_a_t_a/binary>>};


%% 装备强化 
write(16003, {P0_goods_key, P0_error_code}) ->
    D_a_t_a = <<(proto:write_string(P0_goods_key))/binary, P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16003:16,0:8, D_a_t_a/binary>>};


%% 装备洗练 
write(16004, {P0_errcode, P0_attr_type1, P0_attr_value1, P0_attr_type2, P0_attr_value3}) ->
    D_a_t_a = <<P0_errcode:8, P0_attr_type1:8, P0_attr_value1:16, P0_attr_type2:8, P0_attr_value3:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16004:16,0:8, D_a_t_a/binary>>};


%% 装备洗练恢复 
write(16005, {P0_errcode}) ->
    D_a_t_a = <<P0_errcode:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16005:16,0:8, D_a_t_a/binary>>};


%% 获取装备强化经验 
write(16006, {P0_subtype, P0_exp}) ->
    D_a_t_a = <<P0_subtype:16/signed, P0_exp:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16006:16,0:8, D_a_t_a/binary>>};


%% 装备镶嵌 
write(16007, {P0_errcode}) ->
    D_a_t_a = <<P0_errcode:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16007:16,0:8, D_a_t_a/binary>>};


%% 强化套装属性 
write(16008, {P0_strength, P0_cbp, P0_attrlist, P0_is_max, P0_next_strength, P0_active_num, P0_num_lim, P0_next_cbp, P0_nextattrlist}) ->
    D_a_t_a = <<P0_strength:16/signed, P0_cbp:32/signed, (length(P0_attrlist)):16, (list_to_binary([<<P1_attr_type:8, P1_value:16>> || [P1_attr_type, P1_value] <- P0_attrlist]))/binary, P0_is_max:8/signed, P0_next_strength:16/signed, P0_active_num:8/signed, P0_num_lim:8/signed, P0_next_cbp:32/signed, (length(P0_nextattrlist)):16, (list_to_binary([<<P1_next_attr_type:8, P1_next_value:16>> || [P1_next_attr_type, P1_next_value] <- P0_nextattrlist]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16008:16,0:8, D_a_t_a/binary>>};


%% 镶嵌套装属性 
write(16009, {P0_stone_lv, P0_cbp, P0_attrlist, P0_is_max, P0_next_stone_lv, P0_active_num, P0_num_lim, P0_next_cbp, P0_nextattrlist}) ->
    D_a_t_a = <<P0_stone_lv:16/signed, P0_cbp:32/signed, (length(P0_attrlist)):16, (list_to_binary([<<P1_attr_type:8, P1_value:16>> || [P1_attr_type, P1_value] <- P0_attrlist]))/binary, P0_is_max:8/signed, P0_next_stone_lv:16/signed, P0_active_num:8/signed, P0_num_lim:8/signed, P0_next_cbp:32/signed, (length(P0_nextattrlist)):16, (list_to_binary([<<P1_next_attr_type:8, P1_next_value:16>> || [P1_next_attr_type, P1_next_value] <- P0_nextattrlist]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16009:16,0:8, D_a_t_a/binary>>};


%% 装备熔炼 
write(16011, {P0_errcode, P0_new_goods_id}) ->
    D_a_t_a = <<P0_errcode:8, P0_new_goods_id:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16011:16,0:8, D_a_t_a/binary>>};


%% 熔炼值更新 
write(16012, {P0_smelt_value}) ->
    D_a_t_a = <<P0_smelt_value:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16012:16,0:8, D_a_t_a/binary>>};


%% 洗练转移 
write(16013, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16013:16,0:8, D_a_t_a/binary>>};


%% 装备升级 
write(16014, {P0_error_code, P0_befor_goods_id, P0_after_goods_id, P0_befor_pb, P0_after_pb, P0_stren_lv, P0_star, P0_befor_attr, P0_after_attr}) ->
    D_a_t_a = <<P0_error_code:8, P0_befor_goods_id:32, P0_after_goods_id:32, P0_befor_pb:32, P0_after_pb:32, P0_stren_lv:16, P0_star:8, (length(P0_befor_attr)):16, (list_to_binary([<<P1_attr_type:8, P1_value:16>> || [P1_attr_type, P1_value] <- P0_befor_attr]))/binary, (length(P0_after_attr)):16, (list_to_binary([<<P1_attr_type:8, P1_value:16>> || [P1_attr_type, P1_value] <- P0_after_attr]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16014:16,0:8, D_a_t_a/binary>>};


%% 装备升星 
write(16015, {P0_error_code, P0_goods_id, P0_befor_star, P0_after_star, P0_befor_pb, P0_after_pb, P0_stren_lv, P0_befor_attr, P0_after_attr}) ->
    D_a_t_a = <<P0_error_code:8, P0_goods_id:32, P0_befor_star:32, P0_after_star:32, P0_befor_pb:32, P0_after_pb:32, P0_stren_lv:16, (length(P0_befor_attr)):16, (list_to_binary([<<P1_attr_type:8, P1_value:16>> || [P1_attr_type, P1_value] <- P0_befor_attr]))/binary, (length(P0_after_attr)):16, (list_to_binary([<<P1_attr_type:8, P1_value:16>> || [P1_attr_type, P1_value] <- P0_after_attr]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16015:16,0:8, D_a_t_a/binary>>};


%% 装备洗练 
write(16016, {P0_error_code, P0_new_wash}) ->
    D_a_t_a = <<P0_error_code:8, (length(P0_new_wash)):16, (list_to_binary([<<P1_attr_type:8, P1_value:16>> || [P1_attr_type, P1_value] <- P0_new_wash]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16016:16,0:8, D_a_t_a/binary>>};


%% 装备洗练替换 
write(16017, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16017:16,0:8, D_a_t_a/binary>>};


%% 请求断线保存的洗练属性 
write(16018, {P0_wash_attr}) ->
    D_a_t_a = <<(length(P0_wash_attr)):16, (list_to_binary([<<P1_subtype:8, (length(P1_new_wash)):16, (list_to_binary([<<P2_attr_type:8, P2_value:16>> || [P2_attr_type, P2_value] <- P1_new_wash]))/binary>> || [P1_subtype, P1_new_wash] <- P0_wash_attr]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16018:16,0:8, D_a_t_a/binary>>};


%% 物品合成 
write(16019, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16019:16,0:8, D_a_t_a/binary>>};


%% 灵石经验 
write(16020, {P0_stone_exp}) ->
    D_a_t_a = <<(length(P0_stone_exp)):16, (list_to_binary([<<P1_goods_id:32, P1_exp:16>> || [P1_goods_id, P1_exp] <- P0_stone_exp]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16020:16,0:8, D_a_t_a/binary>>};


%% 婚戒升级 
write(16022, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16022:16,0:8, D_a_t_a/binary>>};


%% 婚戒兑换 
write(16023, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16023:16,0:8, D_a_t_a/binary>>};


%% 装备神炼 
write(16026, {P0_goods_key, P0_error_code}) ->
    D_a_t_a = <<(proto:write_string(P0_goods_key))/binary, P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16026:16,0:8, D_a_t_a/binary>>};


%% 装备附魔 
write(16029, {P0_error_code, P0_index}) ->
    D_a_t_a = <<P0_error_code:8, P0_index:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16029:16,0:8, D_a_t_a/binary>>};


%% 装备精炼 
write(16035, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16035:16,0:8, D_a_t_a/binary>>};


%% 武魂镶嵌 
write(16037, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16037:16,0:8, D_a_t_a/binary>>};


%% 取下武魂 
write(16038, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16038:16,0:8, D_a_t_a/binary>>};


%% 武魂合成 
write(16039, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16039:16,0:8, D_a_t_a/binary>>};


%% 武魂开启 
write(16040, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16040:16,0:8, D_a_t_a/binary>>};


%% 武魂套装属性 
write(16041, {P0_cost, P0_soul_lv, P0_cbp, P0_attrlist, P0_is_max, P0_next_soul_lv, P0_active_num, P0_num_lim, P0_next_cbp, P0_nextattrlist}) ->
    D_a_t_a = <<P0_cost:32/signed, P0_soul_lv:16/signed, P0_cbp:32/signed, (length(P0_attrlist)):16, (list_to_binary([<<P1_attr_type:8, P1_value:16>> || [P1_attr_type, P1_value] <- P0_attrlist]))/binary, P0_is_max:8/signed, P0_next_soul_lv:16/signed, P0_active_num:8/signed, P0_num_lim:8/signed, P0_next_cbp:32/signed, (length(P0_nextattrlist)):16, (list_to_binary([<<P1_next_attr_type:8, P1_next_value:16>> || [P1_next_attr_type, P1_next_value] <- P0_nextattrlist]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16041:16,0:8, D_a_t_a/binary>>};


%% 武魂升级 
write(16042, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16042:16,0:8, D_a_t_a/binary>>};


%% 装备合成 
write(16050, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16050:16,0:8, D_a_t_a/binary>>};


%% 装备套装激活ids 
write(16055, {P0_ids}) ->
    D_a_t_a = <<(length(P0_ids)):16, (list_to_binary([<<P1_id:32>> || P1_id <- P0_ids]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16055:16,0:8, D_a_t_a/binary>>};


%% 激活id 
write(16056, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16056:16,0:8, D_a_t_a/binary>>};


%% 装备升级 
write(16057, {P0_goods_key, P0_error_code}) ->
    D_a_t_a = <<(proto:write_string(P0_goods_key))/binary, P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16057:16,0:8, D_a_t_a/binary>>};


%% 获取模具商店信息 
write(16058, {P0_consume_list}) ->
    D_a_t_a = <<(length(P0_consume_list)):16, (list_to_binary([<<P1_type:32, P1_id:16, P1_goods_id:32, P1_goods_num:32, P1_cost:32, P1_limit:16, (length(P1_cost_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:16>> || [P2_goods_id, P2_goods_num] <- P1_cost_list]))/binary>> || [P1_type, P1_id, P1_goods_id, P1_goods_num, P1_cost, P1_limit, P1_cost_list] <- P0_consume_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16058:16,0:8, D_a_t_a/binary>>};


%% 模具商店购买 
write(16059, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16059:16,0:8, D_a_t_a/binary>>};


%% 模具商店类型列表 
write(16060, {P0_types}) ->
    D_a_t_a = <<(length(P0_types)):16, (list_to_binary([<<P1_type:16>> || P1_type <- P0_types]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 16060:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



