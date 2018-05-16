%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-12-06 03:36:20
%%----------------------------------------------------
-module(pt_360).
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
err(47) ->"已经拥有仙羽"; 
err(48) ->"已经超过续费时间"; 
err(49) ->"已经激活"; 
err(50) ->"激活阶数不存在"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(36001, _B0) ->
    {ok, {}};

read(36002, _B0) ->
    {P0_auto_buy, _B1} = proto:read_uint8(_B0),
    {ok, {P0_auto_buy}};

read(36003, _B0) ->
    {ok, {}};

read(36004, _B0) ->
    {P0_wing_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_wing_id}};

read(36007, _B0) ->
    {ok, {}};

read(36008, _B0) ->
    {ok, {}};

read(36009, _B0) ->
    {P0_wing_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_wing_id}};

read(36020, _B0) ->
    {P0_cell, _B1} = proto:read_uint8(_B0),
    {ok, {P0_cell}};

read(36021, _B0) ->
    {P0_cell, _B1} = proto:read_uint8(_B0),
    {ok, {P0_cell}};

read(36022, _B0) ->
    {ok, {}};

read(36023, _B0) ->
    {P0_goods_key, _B1} = proto:read_key(_B0),
    {ok, {P0_goods_key}};

read(36024, _B0) ->
    {ok, {}};

read(36025, _B0) ->
    {ok, {}};

read(36026, _B0) ->
    {ok, {}};

read(36027, _B0) ->
    {ok, {}};

read(36028, _B0) ->
    {ok, {}};

read(36029, _B0) ->
    {ok, {}};

read(36030, _B0) ->
    {ok, {}};

read(36031, _B0) ->
    {P0_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_id}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 获取玩家仙羽信息 
write(36001, {P0_stage, P0_exp, P0_bless_cd, P0_wing_id, P0_grow_num, P0_base_attr, P0_all_wing, P0_wing_star, P0_attribute_list, P0_equip_attribute, P0_fighting_value, P0_skill_list, P0_equip_list, P0_spirit_state}) ->
    D_a_t_a = <<P0_stage:16, P0_exp:32/signed, P0_bless_cd:32/signed, P0_wing_id:32, P0_grow_num:16, (length(P0_base_attr)):16, (list_to_binary([<<P1_attr_type:8, P1_value:32>> || [P1_attr_type, P1_value] <- P0_base_attr]))/binary, (length(P0_all_wing)):16, (list_to_binary([<<P1_wing_id:32, P1_time:32/signed>> || [P1_wing_id, P1_time] <- P0_all_wing]))/binary, (length(P0_wing_star)):16, (list_to_binary([<<P1_wing_id:32, P1_star:8/signed>> || [P1_wing_id, P1_star] <- P0_wing_star]))/binary, (length(P0_attribute_list)):16, (list_to_binary([<<P1_type:32, P1_value:32/signed>> || [P1_type, P1_value] <- P0_attribute_list]))/binary, (length(P0_equip_attribute)):16, (list_to_binary([<<P1_type:32, P1_value:32/signed>> || [P1_type, P1_value] <- P0_equip_attribute]))/binary, P0_fighting_value:32, (length(P0_skill_list)):16, (list_to_binary([<<P1_cell:8, P1_skill_id:32, P1_skill_state:8/signed>> || [P1_cell, P1_skill_id, P1_skill_state] <- P0_skill_list]))/binary, (length(P0_equip_list)):16, (list_to_binary([<<P1_subtype:16/signed, P1_equip_id:32>> || [P1_subtype, P1_equip_id] <- P0_equip_list]))/binary, P0_spirit_state:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 36001:16,0:8, D_a_t_a/binary>>};


%% 仙羽升级 
write(36002, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 36002:16,0:8, D_a_t_a/binary>>};


%% 图鉴列表 
write(36003, {P0_wing_star}) ->
    D_a_t_a = <<(length(P0_wing_star)):16, (list_to_binary([<<P1_wing_id:32, P1_star:8/signed>> || [P1_wing_id, P1_star] <- P0_wing_star]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 36003:16,0:8, D_a_t_a/binary>>};


%% 选择已经激活仙羽的外观 
write(36004, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 36004:16,0:8, D_a_t_a/binary>>};


%% 获得了新仙羽 
write(36007, {P0_wing_id}) ->
    D_a_t_a = <<P0_wing_id:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 36007:16,0:8, D_a_t_a/binary>>};


%% 仙羽过期了 
write(36008, {P0_wing_id}) ->
    D_a_t_a = <<P0_wing_id:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 36008:16,0:8, D_a_t_a/binary>>};


%% 仙羽升星 
write(36009, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 36009:16,0:8, D_a_t_a/binary>>};


%% 激活技能 
write(36020, {P0_ret}) ->
    D_a_t_a = <<P0_ret:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 36020:16,0:8, D_a_t_a/binary>>};


%% 升级技能 
write(36021, {P0_ret}) ->
    D_a_t_a = <<P0_ret:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 36021:16,0:8, D_a_t_a/binary>>};


%% 技能列表更新 
write(36022, {P0_skill_list}) ->
    D_a_t_a = <<(length(P0_skill_list)):16, (list_to_binary([<<P1_cell:8, P1_skill_id:32, P1_skill_state:8/signed>> || [P1_cell, P1_skill_id, P1_skill_state] <- P0_skill_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 36022:16,0:8, D_a_t_a/binary>>};


%% 穿上装备 
write(36023, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 36023:16,0:8, D_a_t_a/binary>>};


%% 使用仙羽成长丹 
write(36024, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 36024:16,0:8, D_a_t_a/binary>>};


%% 领取仙羽 
write(36025, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 36025:16,0:8, D_a_t_a/binary>>};


%% 灵脉信息 
write(36026, {P0_stage, P0_cur_type, P0_type_list, P0_cbp, P0_attr_list, P0_spirit}) ->
    D_a_t_a = <<P0_stage:8, P0_cur_type:32/signed, (length(P0_type_list)):16, (list_to_binary([<<P1_type:32/signed, P1_lv:32/signed>> || [P1_type, P1_lv] <- P0_type_list]))/binary, P0_cbp:32, (length(P0_attr_list)):16, (list_to_binary([<<P1_attr_type:8, P1_value:32>> || [P1_attr_type, P1_value] <- P0_attr_list]))/binary, P0_spirit:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 36026:16,0:8, D_a_t_a/binary>>};


%% 升级灵脉 
write(36027, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 36027:16,0:8, D_a_t_a/binary>>};


%% 限时翅膀状态 
write(36028, {P0_state, P0_leave_time, P0_cost}) ->
    D_a_t_a = <<P0_state:8/signed, P0_leave_time:32/signed, P0_cost:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 36028:16,0:8, D_a_t_a/binary>>};


%% 限时翅膀续费 
write(36029, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 36029:16,0:8, D_a_t_a/binary>>};


%% 限时翅膀开启 
write(36030, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 36030:16,0:8, D_a_t_a/binary>>};


%% 激活等级加成 
write(36031, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 36031:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



