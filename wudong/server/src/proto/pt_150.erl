%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2018-05-03 14:26:34
%%----------------------------------------------------
-module(pt_150).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"背包空间不够"; 
err(3) ->"物品数量不足"; 
err(4) ->"元宝不足"; 
err(5) ->"该格子已经开启，无需再次购买"; 
err(6) ->"物品不存在"; 
err(7) ->"没有出战宠物"; 
err(8) ->"出战宠物等级已达上限"; 
err(9) ->"使用的物品数量过多"; 
err(10) ->"出战宠物光环等级已达上限"; 
err(11) ->"属性丹缺少配置"; 
err(12) ->"已经到了最大属性丹使用数量"; 
err(13) ->"你还未达到属性丹使用的要求，不用使用"; 
err(24) ->"该精魄石已到达上限"; 
err(25) ->"该精魄石已到达上限"; 
err(26) ->"该精魄石已到达上限"; 
err(27) ->"等级不足"; 
err(28) ->"该精魄石已到达上限"; 
err(29) ->"仓库空间不够"; 
err(30) ->"阶级不足,请先提升"; 
err(31) ->"该时装已激活,可拆分为碎片升级属性"; 
err(32) ->"该头饰已激活,可拆分为碎片升级属性"; 
err(33) ->"该泡泡已激活,可拆分为碎片升级属性"; 
err(34) ->"该称号已激活,可拆分为碎片升级属性"; 
err(35) ->"还没加入仙盟"; 
err(36) ->"没有在背包中"; 
err(37) ->"该物品不能拆分"; 
err(38) ->"物品数量不足"; 
err(39) ->"拆分配置不存在"; 
err(40) ->"未达到使用阶级"; 
err(41) ->"您未婚"; 
err(42) ->"该挂饰已激活,可拆分为碎片升级属性"; 
err(43) ->"神炼已满级"; 
err(44) ->"神炼材料不足"; 
err(45) ->"物品已锁定"; 
err(46) ->"物品未锁定"; 
err(47) ->"已经激活了子女"; 
err(48) ->"道具已过期，不能使用"; 
err(49) ->"你已有更好的装备"; 
err(50) ->"等级不足，85级可使用"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(15001, _B0) ->
    {ok, {}};

read(15002, _B0) ->
    {ok, {}};

read(15003, _B0) ->
    {ok, {}};

read(15004, _B0) ->
    {P0_key, _B1} = proto:read_key(_B0),
    {P0_num, _B2} = proto:read_uint16(_B1),
    {ok, {P0_key, P0_num}};

read(15005, _B0) ->
    {P0_list, _B4} = proto:read_array(_B0, fun(_B1) ->
        {P1_key, _B2} = proto:read_key(_B1),
        {P1_num, _B3} = proto:read_uint16(_B2),
        {[P1_key, P1_num], _B3}
    end),
    {ok, {P0_list}};

read(15006, _B0) ->
    {ok, {}};

read(15007, _B0) ->
    {P0_num, _B1} = proto:read_uint16(_B0),
    {ok, {P0_num}};

read(15008, _B0) ->
    {ok, {}};

read(15009, _B0) ->
    {P0_goods_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_goods_id}};

read(15010, _B0) ->
    {P0_goods_id_list, _B3} = proto:read_array(_B0, fun(_B1) ->
        {P1_goods_id, _B2} = proto:read_uint32(_B1),
        {P1_goods_id, _B2}
    end),
    {ok, {P0_goods_id_list}};

read(15011, _B0) ->
    {ok, {}};

read(15012, _B0) ->
    {ok, {}};

read(15013, _B0) ->
    {ok, {}};

read(15014, _B0) ->
    {P0_goods_key, _B1} = proto:read_key(_B0),
    {P0_num, _B2} = proto:read_uint32(_B1),
    {ok, {P0_goods_key, P0_num}};

read(15015, _B0) ->
    {P0_goods_key, _B1} = proto:read_key(_B0),
    {P0_num, _B2} = proto:read_uint32(_B1),
    {ok, {P0_goods_key, P0_num}};

read(15016, _B0) ->
    {ok, {}};

read(15017, _B0) ->
    {P0_num, _B1} = proto:read_uint8(_B0),
    {ok, {P0_num}};

read(15018, _B0) ->
    {P0_key, _B1} = proto:read_key(_B0),
    {P0_num, _B2} = proto:read_uint16(_B1),
    {ok, {P0_key, P0_num}};

read(15019, _B0) ->
    {ok, {}};

read(15020, _B0) ->
    {P0_goods_key, _B1} = proto:read_key(_B0),
    {ok, {P0_goods_key}};

read(15021, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {ok, {P0_type}};

read(15022, _B0) ->
    {P0_goods_id, _B1} = proto:read_uint32(_B0),
    {P0_num, _B2} = proto:read_uint16(_B1),
    {P0_player_list, _B6} = proto:read_array(_B2, fun(_B3) ->
        {P1_key, _B4} = proto:read_uint32(_B3),
        {P1_type, _B5} = proto:read_uint8(_B4),
        {[P1_key, P1_type], _B5}
    end),
    {ok, {P0_goods_id, P0_num, P0_player_list}};

read(15023, _B0) ->
    {P0_goods_key, _B1} = proto:read_key(_B0),
    {P0_num, _B2} = proto:read_uint16(_B1),
    {ok, {P0_goods_key, P0_num}};

read(15025, _B0) ->
    {ok, {}};

read(15026, _B0) ->
    {P0_goods_key, _B1} = proto:read_key(_B0),
    {ok, {P0_goods_key}};

read(15027, _B0) ->
    {P0_goods_key, _B1} = proto:read_key(_B0),
    {ok, {P0_goods_key}};

read(15028, _B0) ->
    {P0_goods_key, _B1} = proto:read_key(_B0),
    {ok, {P0_goods_key}};

read(15029, _B0) ->
    {P0_key, _B1} = proto:read_key(_B0),
    {P0_num, _B2} = proto:read_uint16(_B1),
    {P0_slist, _B6} = proto:read_array(_B2, fun(_B3) ->
        {P1_goods_id, _B4} = proto:read_uint32(_B3),
        {P1_goods_num, _B5} = proto:read_uint32(_B4),
        {[P1_goods_id, P1_goods_num], _B5}
    end),
    {ok, {P0_key, P0_num, P0_slist}};

read(15030, _B0) ->
    {ok, {}};

read(15031, _B0) ->
    {P0_gid, _B1} = proto:read_uint32(_B0),
    {P0_num, _B2} = proto:read_uint16(_B1),
    {P0_slist, _B6} = proto:read_array(_B2, fun(_B3) ->
        {P1_goods_id, _B4} = proto:read_uint32(_B3),
        {P1_goods_num, _B5} = proto:read_uint32(_B4),
        {[P1_goods_id, P1_goods_num], _B5}
    end),
    {ok, {P0_gid, P0_num, P0_slist}};

read(15032, _B0) ->
    {P0_location, _B1} = proto:read_uint32(_B0),
    {ok, {P0_location}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 获取玩家背包基础信息 
write(15001, {P0_max_cell_num, P0_goods_list}) ->
    D_a_t_a = zlib:compress(<<P0_max_cell_num:16, (length(P0_goods_list)):16, (list_to_binary([<<(proto:write_string(P1_key))/binary, P1_location:8, P1_goods_id:32, P1_num:32, P1_is_bind:8, P1_expire_date:32, P1_goods_lv:16, P1_strlen_lv:8, P1_star:8, P1_exp:32, P1_god_forging:32, P1_level:32, P1_cell:8, P1_lock:8, (proto:write_string(P1_wear_key))/binary, (length(P1_base_attr)):16, (list_to_binary([<<P2_attr_type:8, P2_value:16>> || [P2_attr_type, P2_value] <- P1_base_attr]))/binary, (length(P1_refine_attr)):16, (list_to_binary([<<P2_attr_type:8, P2_value:16, P2_num:16>> || [P2_attr_type, P2_value, P2_num] <- P1_refine_attr]))/binary, (length(P1_stone_info)):16, (list_to_binary([<<P2_hole_type:8, P2_value:32>> || [P2_hole_type, P2_value] <- P1_stone_info]))/binary, (length(P1_magic_attr)):16, (list_to_binary([<<P2_magic_lv:16, P2_magic_exp:16, P2_attr_type:16>> || [P2_magic_lv, P2_magic_exp, P2_attr_type] <- P1_magic_attr]))/binary, (length(P1_soul_attr)):16, (list_to_binary([<<P2_location:8, P2_state:16, P2_goods_id:32>> || [P2_location, P2_state, P2_goods_id] <- P1_soul_attr]))/binary, P1_color:8, P1_sex:8, P1_power:32/signed, (length(P1_fix_attr)):16, (list_to_binary([<<P2_attr_type:8, P2_value:16>> || [P2_attr_type, P2_value] <- P1_fix_attr]))/binary, (length(P1_random_attr)):16, (list_to_binary([<<P2_attr_type:8, P2_value:16>> || [P2_attr_type, P2_value] <- P1_random_attr]))/binary, (length(P1_xian_lian_attr)):16, (list_to_binary([<<P2_attr_type:8, P2_value:16, P2_attr_color:8>> || [P2_attr_type, P2_value, P2_attr_color] <- P1_xian_lian_attr]))/binary, (length(P1_god_soul_attr)):16, (list_to_binary([<<P2_attr_type:8, P2_value:16>> || [P2_attr_type, P2_value] <- P1_god_soul_attr]))/binary>> || [P1_key, P1_location, P1_goods_id, P1_num, P1_is_bind, P1_expire_date, P1_goods_lv, P1_strlen_lv, P1_star, P1_exp, P1_god_forging, P1_level, P1_cell, P1_lock, P1_wear_key, P1_base_attr, P1_refine_attr, P1_stone_info, P1_magic_attr, P1_soul_attr, P1_color, P1_sex, P1_power, P1_fix_attr, P1_random_attr, P1_xian_lian_attr, P1_god_soul_attr] <- P0_goods_list]))/binary>>),
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15001:16,1:8, D_a_t_a/binary>>};


%% 物品列表更新 
write(15002, {P0_goods_list}) ->
    D_a_t_a = <<(length(P0_goods_list)):16, (list_to_binary([<<(proto:write_string(P1_key))/binary, P1_location:8, P1_goods_id:32, P1_num:32, P1_is_bind:8, P1_expire_date:32, P1_goods_lv:16, P1_strlen_lv:8, P1_star:8, P1_exp:32, P1_god_forging:32, P1_level:32, P1_cell:8, P1_lock:8, (proto:write_string(P1_wear_key))/binary, (length(P1_base_attr)):16, (list_to_binary([<<P2_attr_type:8, P2_value:16>> || [P2_attr_type, P2_value] <- P1_base_attr]))/binary, (length(P1_refine_attr)):16, (list_to_binary([<<P2_attr_type:8, P2_value:16, P2_num:16>> || [P2_attr_type, P2_value, P2_num] <- P1_refine_attr]))/binary, (length(P1_stone_info)):16, (list_to_binary([<<P2_hole_type:8, P2_value:32>> || [P2_hole_type, P2_value] <- P1_stone_info]))/binary, (length(P1_magic_attr)):16, (list_to_binary([<<P2_magic_lv:16, P2_magic_exp:16, P2_attr_type:8>> || [P2_magic_lv, P2_magic_exp, P2_attr_type] <- P1_magic_attr]))/binary, (length(P1_soul_attr)):16, (list_to_binary([<<P2_location:8, P2_state:16, P2_goods_id:32>> || [P2_location, P2_state, P2_goods_id] <- P1_soul_attr]))/binary, P1_color:8, P1_sex:8, P1_power:32/signed, (length(P1_fix_attr)):16, (list_to_binary([<<P2_attr_type:8, P2_value:16>> || [P2_attr_type, P2_value] <- P1_fix_attr]))/binary, (length(P1_random_attr)):16, (list_to_binary([<<P2_attr_type:8, P2_value:16>> || [P2_attr_type, P2_value] <- P1_random_attr]))/binary, (length(P1_xian_lian_attr)):16, (list_to_binary([<<P2_attr_type:8, P2_value:16, P2_attr_color:8>> || [P2_attr_type, P2_value, P2_attr_color] <- P1_xian_lian_attr]))/binary, (length(P1_god_soul_attr)):16, (list_to_binary([<<P2_attr_type:8, P2_value:16>> || [P2_attr_type, P2_value] <- P1_god_soul_attr]))/binary>> || [P1_key, P1_location, P1_goods_id, P1_num, P1_is_bind, P1_expire_date, P1_goods_lv, P1_strlen_lv, P1_star, P1_exp, P1_god_forging, P1_level, P1_cell, P1_lock, P1_wear_key, P1_base_attr, P1_refine_attr, P1_stone_info, P1_magic_attr, P1_soul_attr, P1_color, P1_sex, P1_power, P1_fix_attr, P1_random_attr, P1_xian_lian_attr, P1_god_soul_attr] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15002:16,0:8, D_a_t_a/binary>>};


%% 物品数量更新 
write(15003, {P0_goods_list}) ->
    D_a_t_a = <<(length(P0_goods_list)):16, (list_to_binary([<<(proto:write_string(P1_key))/binary, P1_num:32>> || [P1_key, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15003:16,0:8, D_a_t_a/binary>>};


%% 使用物品 
write(15004, {P0_errcode}) ->
    D_a_t_a = <<P0_errcode:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15004:16,0:8, D_a_t_a/binary>>};


%% 删除物品 
write(15005, {P0_errcode}) ->
    D_a_t_a = <<P0_errcode:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15005:16,0:8, D_a_t_a/binary>>};


%% 物品不足提示 
write(15006, {P0_goods_id, P0_num, P0_from}) ->
    D_a_t_a = <<P0_goods_id:32, P0_num:32, P0_from:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15006:16,0:8, D_a_t_a/binary>>};


%% 元宝开启格子 
write(15007, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15007:16,0:8, D_a_t_a/binary>>};


%% 背包格子数量更新 
write(15008, {P0_num}) ->
    D_a_t_a = <<P0_num:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15008:16,0:8, D_a_t_a/binary>>};


%% 礼包拥有物品查询 
write(15009, {P0_goods_id, P0_must_get_goods, P0_random_num, P0_random_get_goods}) ->
    D_a_t_a = <<P0_goods_id:32, (length(P0_must_get_goods)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32>> || [P1_goods_id, P1_num] <- P0_must_get_goods]))/binary, P0_random_num:16, (length(P0_random_get_goods)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32>> || [P1_goods_id, P1_num] <- P0_random_get_goods]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15009:16,0:8, D_a_t_a/binary>>};


%% 物品表详细查询 
write(15010, {P0_goods_id_list, P0_udef_list}) ->
    D_a_t_a = <<(length(P0_goods_id_list)):16, (list_to_binary([<<P1_goods_id:32, P1_display:8, P1_goods_icon:32, (proto:write_string(P1_goods_name))/binary, (proto:write_string(P1_describe))/binary, P1_type:16, P1_subtype:16, P1_is_rarity:8, P1_color:8, P1_sex:8, P1_career:8, P1_need_lv:8, P1_equip_lv:8, P1_need_forza:16, P1_need_thew:16, P1_max_overlap:16, P1_use_panel:16, P1_sell_price:32, P1_expire_time:32, (proto:write_string(P1_special_param_list))/binary, P1_max_wash_hole:8, P1_max_gstone_hole:8, (length(P1_attr_list)):16, (list_to_binary([<<(proto:write_string(P2_type))/binary, P2_value:32>> || [P2_type, P2_value] <- P1_attr_list]))/binary>> || [P1_goods_id, P1_display, P1_goods_icon, P1_goods_name, P1_describe, P1_type, P1_subtype, P1_is_rarity, P1_color, P1_sex, P1_career, P1_need_lv, P1_equip_lv, P1_need_forza, P1_need_thew, P1_max_overlap, P1_use_panel, P1_sell_price, P1_expire_time, P1_special_param_list, P1_max_wash_hole, P1_max_gstone_hole, P1_attr_list] <- P0_goods_id_list]))/binary, (length(P0_udef_list)):16, (list_to_binary([<<P1_goods_id:32>> || P1_goods_id <- P0_udef_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15010:16,0:8, D_a_t_a/binary>>};


%% 玩家获得不进入背包的物品飘字 
write(15011, {P0_type, P0_id}) ->
    D_a_t_a = <<P0_type:8, P0_id:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15011:16,0:8, D_a_t_a/binary>>};


%% 获取玩家仓库物品信息 
write(15012, {P0_max_cell_num, P0_goods_list}) ->
    D_a_t_a = <<P0_max_cell_num:16, (length(P0_goods_list)):16, (list_to_binary([<<(proto:write_string(P1_key))/binary, P1_location:8, P1_goods_id:32, P1_num:32, P1_is_bind:8, P1_expire_time:32, P1_goods_lv:16, P1_strlen_lv:8, P1_star:8, P1_exp:32, P1_god_forging:32, P1_cell:8, P1_lock:8, (proto:write_string(P1_wear_key))/binary, (length(P1_base_attr)):16, (list_to_binary([<<P2_attr_type:8, P2_value:16>> || [P2_attr_type, P2_value] <- P1_base_attr]))/binary, (length(P1_refine_attr)):16, (list_to_binary([<<P2_attr_type:8, P2_value:16, P2_num:16>> || [P2_attr_type, P2_value, P2_num] <- P1_refine_attr]))/binary, (length(P1_stone_info)):16, (list_to_binary([<<P2_hole_type:8, P2_value:32>> || [P2_hole_type, P2_value] <- P1_stone_info]))/binary, (length(P1_magic_attr)):16, (list_to_binary([<<P2_magic_lv:16, P2_magic_exp:16, P2_attr_type:8>> || [P2_magic_lv, P2_magic_exp, P2_attr_type] <- P1_magic_attr]))/binary, (length(P1_soul_attr)):16, (list_to_binary([<<P2_location:8, P2_state:16, P2_goods_id:32>> || [P2_location, P2_state, P2_goods_id] <- P1_soul_attr]))/binary, P1_color:8, P1_sex:8, P1_power:32/signed, (length(P1_fix_attr)):16, (list_to_binary([<<P2_attr_type:8, P2_value:16>> || [P2_attr_type, P2_value] <- P1_fix_attr]))/binary, (length(P1_random_attr)):16, (list_to_binary([<<P2_attr_type:8, P2_value:16>> || [P2_attr_type, P2_value] <- P1_random_attr]))/binary, (length(P1_xian_lian_attr)):16, (list_to_binary([<<P2_attr_type:8, P2_value:16, P2_attr_color:8>> || [P2_attr_type, P2_value, P2_attr_color] <- P1_xian_lian_attr]))/binary, (length(P1_god_soul_attr)):16, (list_to_binary([<<P2_attr_type:8, P2_value:16>> || [P2_attr_type, P2_value] <- P1_god_soul_attr]))/binary>> || [P1_key, P1_location, P1_goods_id, P1_num, P1_is_bind, P1_expire_time, P1_goods_lv, P1_strlen_lv, P1_star, P1_exp, P1_god_forging, P1_cell, P1_lock, P1_wear_key, P1_base_attr, P1_refine_attr, P1_stone_info, P1_magic_attr, P1_soul_attr, P1_color, P1_sex, P1_power, P1_fix_attr, P1_random_attr, P1_xian_lian_attr, P1_god_soul_attr] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15012:16,0:8, D_a_t_a/binary>>};


%% 仓库物品列表更新 
write(15013, {P0_goods_list}) ->
    D_a_t_a = <<(length(P0_goods_list)):16, (list_to_binary([<<(proto:write_string(P1_key))/binary, P1_location:8, P1_goods_id:32, P1_num:32, P1_is_bind:8, P1_expire_time:32, P1_goods_lv:16, P1_strlen_lv:8, P1_star:8, P1_exp:32, P1_god_forging:32, P1_cell:8, P1_lock:8, (proto:write_string(P1_wear_key))/binary, (length(P1_base_attr)):16, (list_to_binary([<<P2_attr_type:8, P2_value:16>> || [P2_attr_type, P2_value] <- P1_base_attr]))/binary, (length(P1_refine_attr)):16, (list_to_binary([<<P2_attr_type:8, P2_value:16, P2_num:16>> || [P2_attr_type, P2_value, P2_num] <- P1_refine_attr]))/binary, (length(P1_stone_info)):16, (list_to_binary([<<P2_hole_type:8, P2_value:32>> || [P2_hole_type, P2_value] <- P1_stone_info]))/binary, (length(P1_magic_attr)):16, (list_to_binary([<<P2_magic_lv:16, P2_magic_exp:16, P2_attr_type:8>> || [P2_magic_lv, P2_magic_exp, P2_attr_type] <- P1_magic_attr]))/binary, (length(P1_soul_attr)):16, (list_to_binary([<<P2_location:8, P2_state:16, P2_goods_id:32>> || [P2_location, P2_state, P2_goods_id] <- P1_soul_attr]))/binary, P1_color:8, P1_sex:8, P1_power:32/signed, (length(P1_fix_attr)):16, (list_to_binary([<<P2_attr_type:8, P2_value:16>> || [P2_attr_type, P2_value] <- P1_fix_attr]))/binary, (length(P1_random_attr)):16, (list_to_binary([<<P2_attr_type:8, P2_value:16>> || [P2_attr_type, P2_value] <- P1_random_attr]))/binary, (length(P1_xian_lian_attr)):16, (list_to_binary([<<P2_attr_type:8, P2_value:16, P2_attr_color:8>> || [P2_attr_type, P2_value, P2_attr_color] <- P1_xian_lian_attr]))/binary, (length(P1_god_soul_attr)):16, (list_to_binary([<<P2_attr_type:8, P2_value:16>> || [P2_attr_type, P2_value] <- P1_god_soul_attr]))/binary>> || [P1_key, P1_location, P1_goods_id, P1_num, P1_is_bind, P1_expire_time, P1_goods_lv, P1_strlen_lv, P1_star, P1_exp, P1_god_forging, P1_cell, P1_lock, P1_wear_key, P1_base_attr, P1_refine_attr, P1_stone_info, P1_magic_attr, P1_soul_attr, P1_color, P1_sex, P1_power, P1_fix_attr, P1_random_attr, P1_xian_lian_attr, P1_god_soul_attr] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15013:16,0:8, D_a_t_a/binary>>};


%% 仓库存入物品 
write(15014, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15014:16,0:8, D_a_t_a/binary>>};


%% 仓库取出物品 
write(15015, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15015:16,0:8, D_a_t_a/binary>>};


%% 仓库背包格子数量 
write(15016, {P0_num}) ->
    D_a_t_a = <<P0_num:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15016:16,0:8, D_a_t_a/binary>>};


%% 仓库开格子 
write(15017, {P0_error_code, P0_num}) ->
    D_a_t_a = <<P0_error_code:8, P0_num:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15017:16,0:8, D_a_t_a/binary>>};


%% 根据goods_id使用物品 
write(15018, {P0_errcode}) ->
    D_a_t_a = <<P0_errcode:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15018:16,0:8, D_a_t_a/binary>>};


%% 重复获得碎片提示 
write(15019, {P0_goods_id1, P0_goods_id2, P0_num}) ->
    D_a_t_a = <<P0_goods_id1:32, P0_goods_id2:32, P0_num:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15019:16,0:8, D_a_t_a/binary>>};


%% 查看装备详细信息 
write(15020, {P0_error_code, P0_goods_id, P0_strlen_lv, P0_star, P0_god_forging, P0_base_attr, P0_refine_attr, P0_stone_info, P0_magic_attr, P0_soul_attr, P0_color, P0_sex, P0_power, P0_fix_attr, P0_random_attr, P0_xian_lian_attr, P0_god_soul_attr}) ->
    D_a_t_a = <<P0_error_code:8, P0_goods_id:32, P0_strlen_lv:8, P0_star:8, P0_god_forging:32, (length(P0_base_attr)):16, (list_to_binary([<<P1_attr_type:8, P1_value:16>> || [P1_attr_type, P1_value] <- P0_base_attr]))/binary, (length(P0_refine_attr)):16, (list_to_binary([<<P1_attr_type:8, P1_value:16, P1_num:16>> || [P1_attr_type, P1_value, P1_num] <- P0_refine_attr]))/binary, (length(P0_stone_info)):16, (list_to_binary([<<P1_hole_type:8, P1_value:32>> || [P1_hole_type, P1_value] <- P0_stone_info]))/binary, (length(P0_magic_attr)):16, (list_to_binary([<<P1_magic_lv:16, P1_magic_exp:16, P1_attr_type:8>> || [P1_magic_lv, P1_magic_exp, P1_attr_type] <- P0_magic_attr]))/binary, (length(P0_soul_attr)):16, (list_to_binary([<<P1_location:8, P1_state:16, P1_goods_id:32>> || [P1_location, P1_state, P1_goods_id] <- P0_soul_attr]))/binary, P0_color:8, P0_sex:8, P0_power:32/signed, (length(P0_fix_attr)):16, (list_to_binary([<<P1_attr_type:8, P1_value:16>> || [P1_attr_type, P1_value] <- P0_fix_attr]))/binary, (length(P0_random_attr)):16, (list_to_binary([<<P1_attr_type:8, P1_value:16>> || [P1_attr_type, P1_value] <- P0_random_attr]))/binary, (length(P0_xian_lian_attr)):16, (list_to_binary([<<P1_attr_type:8, P1_value:16, P1_attr_color:8>> || [P1_attr_type, P1_value, P1_attr_color] <- P0_xian_lian_attr]))/binary, (length(P0_god_soul_attr)):16, (list_to_binary([<<P1_attr_type:8, P1_value:16>> || [P1_attr_type, P1_value] <- P0_god_soul_attr]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15020:16,0:8, D_a_t_a/binary>>};


%% 自动购买银两 
write(15021, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15021:16,0:8, D_a_t_a/binary>>};


%% 使用特效物品 
write(15022, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15022:16,0:8, D_a_t_a/binary>>};


%% 拆分时装 
write(15023, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15023:16,0:8, D_a_t_a/binary>>};


%% 获得符文列表 
write(15025, {P0_base_goods_id, P0_list}) ->
    D_a_t_a = <<P0_base_goods_id:32, (length(P0_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:16>> || [P1_goods_id, P1_goods_num] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15025:16,0:8, D_a_t_a/binary>>};


%% 锁定物品 
write(15026, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15026:16,0:8, D_a_t_a/binary>>};


%% 物品解锁 
write(15027, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15027:16,0:8, D_a_t_a/binary>>};


%% 物品随机属性信息 
write(15028, {P0_color, P0_sex, P0_power, P0_fix_attr, P0_random_attr}) ->
    D_a_t_a = <<P0_color:8, P0_sex:8, P0_power:32/signed, (length(P0_fix_attr)):16, (list_to_binary([<<P1_attr_type:8, P1_value:16>> || [P1_attr_type, P1_value] <- P0_fix_attr]))/binary, (length(P0_random_attr)):16, (list_to_binary([<<P1_attr_type:8, P1_value:16>> || [P1_attr_type, P1_value] <- P0_random_attr]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15028:16,0:8, D_a_t_a/binary>>};


%% 使用选择礼包 
write(15029, {P0_errcode}) ->
    D_a_t_a = <<P0_errcode:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15029:16,0:8, D_a_t_a/binary>>};


%% 外观类灵力增加通知 
write(15030, {P0_goods_id, P0_num}) ->
    D_a_t_a = <<P0_goods_id:32, P0_num:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15030:16,0:8, D_a_t_a/binary>>};


%% 批量使用选择礼包 
write(15031, {P0_errcode}) ->
    D_a_t_a = <<P0_errcode:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15031:16,0:8, D_a_t_a/binary>>};


%% 整理背包 
write(15032, {P0_code}) ->
    D_a_t_a = <<P0_code:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 15032:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



