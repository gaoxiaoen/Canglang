%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-12-06 03:49:13
%%----------------------------------------------------
-module(pt_170).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"背包空间不够"; 
err(3) ->"物品数量不够"; 
err(4) ->"玩家等级不够"; 
err(5) ->"元宝不足"; 
err(6) ->"坐骑已满阶"; 
err(7) ->"自动购买价格无法获取"; 
err(8) ->"坐骑升阶成功"; 
err(9) ->"护送中，不能上坐骑"; 
err(10) ->"坐骑需要进阶后才能继续升级"; 
err(11) ->"银币不足"; 
err(13) ->"装备不存在"; 
err(16) ->"该装备不能装备在坐骑上"; 
err(17) ->"职业不符合，不能装备"; 
err(18) ->"替换成功，原装备附加属性已经转移"; 
err(19) ->"坐骑阶数不够，不能穿戴该坐骑装备"; 
err(20) ->"该场景不能上坐骑"; 
err(21) ->"该皮肤未激活，不能幻化"; 
err(22) ->"该皮肤已经过期，不能幻化"; 
err(23) ->"已经升至最高星了"; 
err(24) ->"物品不存在"; 
err(25) ->"到达最大等级，经验将被存储"; 
err(26) ->"只能强化处于穿戴状态的装备"; 
err(27) ->"该装备战力更高，不能被吞噬哦"; 
err(28) ->"原材料的部位不一致"; 
err(29) ->"对方没有骑乘双人坐骑无法请求"; 
err(30) ->"骑乘双人坐骑才可邀请别人通乘"; 
err(31) ->"对方不在线,不能发出共骑邀请"; 
err(32) ->"你请求的玩家处于同骑中无法邀请"; 
err(33) ->"对方处于战斗等特殊状态无法邀请"; 
err(34) ->"不再同场景同一格内，无法共骑"; 
err(35) ->"技能已激活"; 
err(36) ->"技能不存在"; 
err(37) ->"坐骑阶数不足"; 
err(38) ->"物品不足,无法激活"; 
err(39) ->"技能未激活"; 
err(40) ->"物品不足,无法升级"; 
err(41) ->"技能已满级"; 
err(42) ->"成长丹已达到使用上限"; 
err(43) ->"未达到成长丹使用阶数"; 
err(44) ->"成长丹不足"; 
err(45) ->"当前场景不能共骑"; 
err(46) ->"坐骑不存在"; 
err(47) ->"灵脉已满级"; 
err(48) ->"已经激活"; 
err(49) ->"前暂无可激活阶段属性"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(17001, _B0) ->
    {ok, {}};

read(17002, _B0) ->
    {P0_auto_buy, _B1} = proto:read_uint8(_B0),
    {ok, {P0_auto_buy}};

read(17004, _B0) ->
    {P0_mount_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_mount_id}};

read(17005, _B0) ->
    {P0_mount_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_mount_id}};

read(17006, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {P0_mount_type, _B2} = proto:read_uint8(_B1),
    {ok, {P0_type, P0_mount_type}};

read(17007, _B0) ->
    {ok, {}};

read(17013, _B0) ->
    {P0_mount_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_mount_id}};

read(17015, _B0) ->
    {ok, {}};

read(17016, _B0) ->
    {ok, {}};

read(17017, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {P0_type, _B2} = proto:read_uint8(_B1),
    {ok, {P0_pkey, P0_type}};

read(17018, _B0) ->
    {ok, {}};

read(17019, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {P0_type, _B2} = proto:read_uint8(_B1),
    {P0_state, _B3} = proto:read_uint8(_B2),
    {ok, {P0_pkey, P0_type, P0_state}};

read(17020, _B0) ->
    {ok, {}};

read(17021, _B0) ->
    {ok, {}};

read(17030, _B0) ->
    {P0_cell, _B1} = proto:read_uint8(_B0),
    {ok, {P0_cell}};

read(17031, _B0) ->
    {P0_cell, _B1} = proto:read_uint8(_B0),
    {ok, {P0_cell}};

read(17032, _B0) ->
    {ok, {}};

read(17033, _B0) ->
    {P0_goods_key, _B1} = proto:read_key(_B0),
    {ok, {P0_goods_key}};

read(17034, _B0) ->
    {ok, {}};

read(17035, _B0) ->
    {ok, {}};

read(17036, _B0) ->
    {ok, {}};

read(17037, _B0) ->
    {ok, {}};

read(17038, _B0) ->
    {ok, {}};

read(17039, _B0) ->
    {ok, {}};

read(17040, _B0) ->
    {P0_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_id}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 获取玩家坐骑信息 
write(17001, {P0_stage, P0_exp, P0_cd, P0_mount_id, P0_old_mount_id, P0_fight_value, P0_grow_num, P0_mount_attr, P0_image_list, P0_star_list, P0_skill_list, P0_equip_list, P0_spirit_state}) ->
    D_a_t_a = <<P0_stage:16, P0_exp:32, P0_cd:32, P0_mount_id:32, P0_old_mount_id:32, P0_fight_value:32, P0_grow_num:16, (length(P0_mount_attr)):16, (list_to_binary([<<P1_attr_type:8, P1_value:32>> || [P1_attr_type, P1_value] <- P0_mount_attr]))/binary, (length(P0_image_list)):16, (list_to_binary([<<P1_mount_id:32, P1_time:32/signed>> || [P1_mount_id, P1_time] <- P0_image_list]))/binary, (length(P0_star_list)):16, (list_to_binary([<<P1_mount_id:32, P1_star:8/signed>> || [P1_mount_id, P1_star] <- P0_star_list]))/binary, (length(P0_skill_list)):16, (list_to_binary([<<P1_cell:8, P1_skill_id:32, P1_skill_state:8/signed>> || [P1_cell, P1_skill_id, P1_skill_state] <- P0_skill_list]))/binary, (length(P0_equip_list)):16, (list_to_binary([<<P1_subtype:16/signed, P1_equip_id:32>> || [P1_subtype, P1_equip_id] <- P0_equip_list]))/binary, P0_spirit_state:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 17001:16,0:8, D_a_t_a/binary>>};


%% 坐骑升级 
write(17002, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 17002:16,0:8, D_a_t_a/binary>>};


%% 选择已经激活坐骑的外观 
write(17004, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 17004:16,0:8, D_a_t_a/binary>>};


%% 通过道具激活新坐骑 
write(17005, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 17005:16,0:8, D_a_t_a/binary>>};


%% 上下坐骑 
write(17006, {P0_error_code, P0_mount_id}) ->
    D_a_t_a = <<P0_error_code:8, P0_mount_id:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 17006:16,0:8, D_a_t_a/binary>>};


%% 获取已激活的图鉴 
write(17007, {P0_star_list}) ->
    D_a_t_a = <<(length(P0_star_list)):16, (list_to_binary([<<P1_mount_id:32, P1_star:8/signed>> || [P1_mount_id, P1_star] <- P0_star_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 17007:16,0:8, D_a_t_a/binary>>};


%% 坐骑升星 
write(17013, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 17013:16,0:8, D_a_t_a/binary>>};


%% 使用坐骑进阶丹后消息提示 
write(17015, {P0_add_exp, P0_add_mount}) ->
    D_a_t_a = <<P0_add_exp:32, P0_add_mount:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 17015:16,0:8, D_a_t_a/binary>>};


%% 查询坐骑功能是否开启 
write(17016, {P0_is_open}) ->
    D_a_t_a = <<P0_is_open:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 17016:16,0:8, D_a_t_a/binary>>};


%% 邀请其他玩家共乘 
write(17017, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 17017:16,0:8, D_a_t_a/binary>>};


%% 收到共乘请求或者邀请 
write(17018, {P0_pkey, P0_nickname, P0_type}) ->
    D_a_t_a = <<P0_pkey:32, (proto:write_string(P0_nickname))/binary, P0_type:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 17018:16,0:8, D_a_t_a/binary>>};


%% 同意共乘请求或者邀请 
write(17019, {P0_type, P0_nickname, P0_error_code}) ->
    D_a_t_a = <<P0_type:8, (proto:write_string(P0_nickname))/binary, P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 17019:16,0:8, D_a_t_a/binary>>};


%% 共乘下马 
write(17020, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 17020:16,0:8, D_a_t_a/binary>>};


%% 对方拒绝了你的请求或者邀请 
write(17021, {P0_name, P0_type}) ->
    D_a_t_a = <<(proto:write_string(P0_name))/binary, P0_type:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 17021:16,0:8, D_a_t_a/binary>>};


%% 激活技能 
write(17030, {P0_ret}) ->
    D_a_t_a = <<P0_ret:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 17030:16,0:8, D_a_t_a/binary>>};


%% 升级技能 
write(17031, {P0_ret}) ->
    D_a_t_a = <<P0_ret:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 17031:16,0:8, D_a_t_a/binary>>};


%% 技能列表更新 
write(17032, {P0_skill_list}) ->
    D_a_t_a = <<(length(P0_skill_list)):16, (list_to_binary([<<P1_cell:8, P1_skill_id:32, P1_skill_state:8/signed>> || [P1_cell, P1_skill_id, P1_skill_state] <- P0_skill_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 17032:16,0:8, D_a_t_a/binary>>};


%% 穿上装备 
write(17033, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 17033:16,0:8, D_a_t_a/binary>>};


%% 使用坐骑成长丹 
write(17034, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 17034:16,0:8, D_a_t_a/binary>>};


%% 领取坐骑 
write(17035, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 17035:16,0:8, D_a_t_a/binary>>};


%% 灵脉信息 
write(17036, {P0_stage, P0_cur_type, P0_type_list, P0_cbp, P0_attr_list, P0_spirit}) ->
    D_a_t_a = <<P0_stage:8, P0_cur_type:32/signed, (length(P0_type_list)):16, (list_to_binary([<<P1_type:32/signed, P1_lv:32/signed>> || [P1_type, P1_lv] <- P0_type_list]))/binary, P0_cbp:32, (length(P0_attr_list)):16, (list_to_binary([<<P1_attr_type:8, P1_value:32>> || [P1_attr_type, P1_value] <- P0_attr_list]))/binary, P0_spirit:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 17036:16,0:8, D_a_t_a/binary>>};


%% 升级灵脉 
write(17037, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 17037:16,0:8, D_a_t_a/binary>>};


%% 获取附近玩家信息 
write(17038, {P0_player_list}) ->
    D_a_t_a = <<(length(P0_player_list)):16, (list_to_binary([<<P1_pkey:32, (proto:write_string(P1_name))/binary, P1_lv:16, (proto:write_string(P1_avatar))/binary, P1_sex:16, P1_type:16>> || [P1_pkey, P1_name, P1_lv, P1_avatar, P1_sex, P1_type] <- P0_player_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 17038:16,0:8, D_a_t_a/binary>>};


%% 获取好友信息 
write(17039, {P0_player_list}) ->
    D_a_t_a = <<(length(P0_player_list)):16, (list_to_binary([<<P1_pkey:32, (proto:write_string(P1_name))/binary, P1_lv:16, (proto:write_string(P1_avatar))/binary, P1_sex:16, P1_type:16, P1_state:16>> || [P1_pkey, P1_name, P1_lv, P1_avatar, P1_sex, P1_type, P1_state] <- P0_player_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 17039:16,0:8, D_a_t_a/binary>>};


%% 激活等级加成 
write(17040, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 17040:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



