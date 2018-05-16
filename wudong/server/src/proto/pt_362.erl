%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-11-01 17:40:37
%%----------------------------------------------------
-module(pt_362).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"已经到了最大阶数了"; 
err(3) ->"物品数量不够"; 
err(4) ->"玩家等级不够"; 
err(5) ->"元宝不足"; 
err(6) ->"未能获取自动购买价格"; 
err(7) ->"仙羽进阶成功"; 
err(8) ->"仙羽进阶成功"; 
err(9) ->"仙羽已经过期，不能穿戴"; 
err(10) ->"已经到了最大星了"; 
err(11) ->"该仙羽未永久激活，暂时不能升星"; 
err(12) ->"物品不存在"; 
err(13) ->"银币不足"; 
err(18) ->"装备不存在"; 
err(25) ->"该装备不能装备在仙羽上"; 
err(26) ->"只能强化处于穿戴状态的装备"; 
err(27) ->"该装备战力更高，不能被吞噬哦"; 
err(28) ->"原材料的部位不一致"; 
err(29) ->"仙羽阶数不足"; 
err(35) ->"技能已激活"; 
err(36) ->"技能不存在"; 
err(37) ->"仙羽阶数不足"; 
err(38) ->"物品不足,无法激活"; 
err(39) ->"技能未激活"; 
err(40) ->"物品不足,无法升级"; 
err(41) ->"技能已满级"; 
err(42) ->"成长丹已达到使用上限"; 
err(43) ->"未达到成长丹使用阶数"; 
err(44) ->"成长丹不足"; 
err(45) ->"仙羽不存在"; 
err(46) ->"灵脉已满级"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(36201, _B0) ->
    {ok, {}};

read(36202, _B0) ->
    {P0_auto_buy, _B1} = proto:read_uint8(_B0),
    {ok, {P0_auto_buy}};

read(36204, _B0) ->
    {P0_wing_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_wing_id}};

read(36207, _B0) ->
    {ok, {}};

read(36008, _B0) ->
    {ok, {}};

read(36209, _B0) ->
    {P0_wing_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_wing_id}};

read(36220, _B0) ->
    {P0_cell, _B1} = proto:read_uint8(_B0),
    {ok, {P0_cell}};

read(36221, _B0) ->
    {P0_cell, _B1} = proto:read_uint8(_B0),
    {ok, {P0_cell}};

read(36222, _B0) ->
    {ok, {}};

read(36223, _B0) ->
    {P0_goods_key, _B1} = proto:read_key(_B0),
    {ok, {P0_goods_key}};

read(36224, _B0) ->
    {ok, {}};

read(36225, _B0) ->
    {ok, {}};

read(36226, _B0) ->
    {ok, {}};

read(36227, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 获取玩家仙羽信息 
write(36201, {P0_stage, P0_exp, P0_bless_cd, P0_wing_id, P0_grow_num, P0_base_attr, P0_all_wing, P0_wing_star, P0_attribute_list, P0_equip_attribute, P0_fighting_value, P0_skill_list, P0_equip_list, P0_spirit_state}) ->
    D_a_t_a = <<P0_stage:16, P0_exp:32/signed, P0_bless_cd:32/signed, P0_wing_id:32, P0_grow_num:16, (length(P0_base_attr)):16, (list_to_binary([<<P1_attr_type:8, P1_value:32>> || [P1_attr_type, P1_value] <- P0_base_attr]))/binary, (length(P0_all_wing)):16, (list_to_binary([<<P1_wing_id:32, P1_time:32/signed>> || [P1_wing_id, P1_time] <- P0_all_wing]))/binary, (length(P0_wing_star)):16, (list_to_binary([<<P1_wing_id:32, P1_star:8/signed>> || [P1_wing_id, P1_star] <- P0_wing_star]))/binary, (length(P0_attribute_list)):16, (list_to_binary([<<P1_type:32, P1_value:32/signed>> || [P1_type, P1_value] <- P0_attribute_list]))/binary, (length(P0_equip_attribute)):16, (list_to_binary([<<P1_type:32, P1_value:32/signed>> || [P1_type, P1_value] <- P0_equip_attribute]))/binary, P0_fighting_value:32, (length(P0_skill_list)):16, (list_to_binary([<<P1_cell:8, P1_skill_id:32, P1_skill_state:8/signed>> || [P1_cell, P1_skill_id, P1_skill_state] <- P0_skill_list]))/binary, (length(P0_equip_list)):16, (list_to_binary([<<P1_subtype:16/signed, P1_equip_id:32>> || [P1_subtype, P1_equip_id] <- P0_equip_list]))/binary, P0_spirit_state:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 36201:16,0:8, D_a_t_a/binary>>};


%% 仙羽升级 
write(36202, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 36202:16,0:8, D_a_t_a/binary>>};


%% 选择已经激活仙羽的外观 
write(36204, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 36204:16,0:8, D_a_t_a/binary>>};


%% 获得了新仙羽 
write(36207, {P0_wing_id}) ->
    D_a_t_a = <<P0_wing_id:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 36207:16,0:8, D_a_t_a/binary>>};


%% 仙羽过期了 
write(36008, {P0_wing_id}) ->
    D_a_t_a = <<P0_wing_id:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 36008:16,0:8, D_a_t_a/binary>>};


%% 仙羽升星 
write(36209, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 36209:16,0:8, D_a_t_a/binary>>};


%% 激活技能 
write(36220, {P0_ret}) ->
    D_a_t_a = <<P0_ret:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 36220:16,0:8, D_a_t_a/binary>>};


%% 升级技能 
write(36221, {P0_ret}) ->
    D_a_t_a = <<P0_ret:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 36221:16,0:8, D_a_t_a/binary>>};


%% 技能列表更新 
write(36222, {P0_skill_list}) ->
    D_a_t_a = <<(length(P0_skill_list)):16, (list_to_binary([<<P1_cell:8, P1_skill_id:32, P1_skill_state:8/signed>> || [P1_cell, P1_skill_id, P1_skill_state] <- P0_skill_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 36222:16,0:8, D_a_t_a/binary>>};


%% 穿上装备 
write(36223, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 36223:16,0:8, D_a_t_a/binary>>};


%% 使用仙羽成长丹 
write(36224, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 36224:16,0:8, D_a_t_a/binary>>};


%% 领取仙羽 
write(36225, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 36225:16,0:8, D_a_t_a/binary>>};


%% 灵脉信息 
write(36226, {P0_stage, P0_cur_type, P0_type_list, P0_cbp, P0_attr_list, P0_spirit}) ->
    D_a_t_a = <<P0_stage:8, P0_cur_type:32/signed, (length(P0_type_list)):16, (list_to_binary([<<P1_type:32/signed, P1_lv:32/signed>> || [P1_type, P1_lv] <- P0_type_list]))/binary, P0_cbp:32, (length(P0_attr_list)):16, (list_to_binary([<<P1_attr_type:8, P1_value:32>> || [P1_attr_type, P1_value] <- P0_attr_list]))/binary, P0_spirit:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 36226:16,0:8, D_a_t_a/binary>>};


%% 升级灵脉 
write(36227, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 36227:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



