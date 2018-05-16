%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2018-03-23 11:28:51
%%----------------------------------------------------
-module(pt_120).
-export([read/2, write/2]).

-include("common.hrl").
-include("scene.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"掉落物品已拾取"; 
err(3) ->"物品太远不能拾取"; 
err(4) ->"目标不存在，传送失败"; 
err(5) ->"场景不存在，传送失败"; 
err(6) ->"普通场景才能传送，传送失败"; 
err(7) ->"目标不存在，传送失败"; 
err(8) ->"怪物不存在，传送失败"; 
err(9) ->"等级不足，传送失败"; 
err(10) ->"护送中，不能传送"; 
err(11) ->"已经处于该场景中"; 
err(12) ->"物品不属于你,无法拾取"; 
err(13) ->"你没有权限拾取"; 
err(14) ->"跨服场景未开放"; 
err(15) ->"当前处于共骑状态下，共骑者不能自由移动"; 
err(16) ->"同骑状态，副骑不能进入副本"; 
err(17) ->"主骑已经进入副本，同骑状态自动解散"; 
err(18) ->"没有飞行符，成为会员2级即可无限飞行"; 
err(19) ->"目标为障碍点，不可移动"; 
err(20) ->"20级才能使用飞行符"; 
err(21) ->"正在拾取道具.."; 
err(22) ->"该物品现在有掉落归属，您还不能拾取！"; 
err(23) ->"巡游中"; 
err(24) ->"疲劳过度，当前奖励不能领取"; 
err(25) ->"您今日拾取次数已达上限"; 
err(26) ->"您的等级过高，击杀掉落不可拾取"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(12001, _B0) ->
    {P0_x, _B1} = proto:read_uint8(_B0),
    {P0_y, _B2} = proto:read_uint8(_B1),
    {P0_type, _B3} = proto:read_uint8(_B2),
    {ok, {P0_x, P0_y, P0_type}};

read(12002, _B0) ->
    {ok, {}};

read(12003, _B0) ->
    {ok, {}};

read(12004, _B0) ->
    {ok, {}};

read(12005, _B0) ->
    {P0_scene, _B1} = proto:read_uint16(_B0),
    {P0_line, _B2} = proto:read_uint8(_B1),
    {ok, {P0_scene, P0_line}};

read(12006, _B0) ->
    {ok, {}};

read(12007, _B0) ->
    {ok, {}};

read(12008, _B0) ->
    {ok, {}};

read(12009, _B0) ->
    {ok, {}};

read(12010, _B0) ->
    {ok, {}};

read(12011, _B0) ->
    {ok, {}};

read(12012, _B0) ->
    {ok, {}};

read(12013, _B0) ->
    {ok, {}};

read(12014, _B0) ->
    {ok, {}};

read(12015, _B0) ->
    {P0_target_type, _B1} = proto:read_int8(_B0),
    {P0_target_id, _B2} = proto:read_int32(_B1),
    {P0_pos_type, _B3} = proto:read_int8(_B2),
    {ok, {P0_target_type, P0_target_id, P0_pos_type}};

read(12016, _B0) ->
    {ok, {}};

read(12017, _B0) ->
    {ok, {}};

read(12018, _B0) ->
    {ok, {}};

read(12019, _B0) ->
    {ok, {}};

read(12020, _B0) ->
    {ok, {}};

read(12021, _B0) ->
    {ok, {}};

read(12022, _B0) ->
    {ok, {}};

read(12023, _B0) ->
    {P0_pickuplist, _B3} = proto:read_array(_B0, fun(_B1) ->
        {P1_key, _B2} = proto:read_uint32(_B1),
        {P1_key, _B2}
    end),
    {ok, {P0_pickuplist}};

read(12024, _B0) ->
    {ok, {}};

read(12025, _B0) ->
    {ok, {}};

read(12026, _B0) ->
    {ok, {}};

read(12027, _B0) ->
    {ok, {}};

read(12028, _B0) ->
    {ok, {}};

read(12029, _B0) ->
    {ok, {}};

read(12030, _B0) ->
    {ok, {}};

read(12031, _B0) ->
    {ok, {}};

read(12032, _B0) ->
    {ok, {}};

read(12033, _B0) ->
    {ok, {}};

read(12034, _B0) ->
    {ok, {}};

read(12035, _B0) ->
    {ok, {}};

read(12036, _B0) ->
    {ok, {}};

read(12037, _B0) ->
    {ok, {}};

read(12038, _B0) ->
    {ok, {}};

read(12039, _B0) ->
    {ok, {}};

read(12040, _B0) ->
    {ok, {}};

read(12041, _B0) ->
    {ok, {}};

read(12042, _B0) ->
    {ok, {}};

read(12043, _B0) ->
    {ok, {}};

read(12044, _B0) ->
    {ok, {}};

read(12045, _B0) ->
    {ok, {}};

read(12046, _B0) ->
    {ok, {}};

read(12047, _B0) ->
    {P0_sid, _B1} = proto:read_uint16(_B0),
    {P0_x, _B2} = proto:read_uint8(_B1),
    {P0_y, _B3} = proto:read_uint8(_B2),
    {P0_copy, _B4} = proto:read_uint32(_B3),
    {P0_mon_id, _B5} = proto:read_uint32(_B4),
    {ok, {P0_sid, P0_x, P0_y, P0_copy, P0_mon_id}};

read(12048, _B0) ->
    {ok, {}};

read(12049, _B0) ->
    {P0_buff_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_buff_id}};

read(12050, _B0) ->
    {ok, {}};

read(12051, _B0) ->
    {ok, {}};

read(12052, _B0) ->
    {ok, {}};

read(12053, _B0) ->
    {ok, {}};

read(12054, _B0) ->
    {ok, {}};

read(12055, _B0) ->
    {ok, {}};

read(12056, _B0) ->
    {ok, {}};

read(12057, _B0) ->
    {ok, {}};

read(12058, _B0) ->
    {ok, {}};

read(12059, _B0) ->
    {ok, {}};

read(12060, _B0) ->
    {ok, {}};

read(12061, _B0) ->
    {ok, {}};

read(12062, _B0) ->
    {P0_target_id, _B1} = proto:read_int32(_B0),
    {P0_ID, _B2} = proto:read_int16(_B1),
    {ok, {P0_target_id, P0_ID}};

read(12063, _B0) ->
    {ok, {}};

read(12064, _B0) ->
    {ok, {}};

read(12065, _B0) ->
    {ok, {}};

read(12066, _B0) ->
    {ok, {}};

read(12067, _B0) ->
    {ok, {}};

read(12068, _B0) ->
    {ok, {}};

read(12069, _B0) ->
    {ok, {}};

read(12070, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 走路 
write(12001, {P0_pkey, P0_x, P0_y, P0_type}) ->
    D_a_t_a = <<P0_pkey:32, P0_x:8, P0_y:8, P0_type:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12001:16,0:8, D_a_t_a/binary>>};


%% 加载场景 
write(12002, {P0_elemlist, P0_monlist, P0_sceneplayer, P0_scenenpc}) ->
    D_a_t_a = zlib:compress(<<(pack_elem_list(P0_elemlist))/binary, (pack_mon_list(P0_monlist))/binary, (pack_scene_player_list(P0_sceneplayer))/binary, (pack_npc_list(P0_scenenpc))/binary>>),
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12002:16,1:8, D_a_t_a/binary>>};


%% 玩家进入场景通知 
write(12003, {P0_playerlist}) ->
    D_a_t_a = <<(pack_scene_player_list(P0_playerlist))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12003:16,0:8, D_a_t_a/binary>>};


%% 玩家离开场景 
write(12004, {P0_pkeylist}) ->
    D_a_t_a = <<(length(P0_pkeylist)):16, (list_to_binary([<<P1_pkey:32, P1_scene:32/signed>> || [P1_pkey, P1_scene] <- P0_pkeylist]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12004:16,0:8, D_a_t_a/binary>>};


%% 场景切换 
write(12005, {P0_scene, P0_x, P0_y, P0_resid, P0_name}) ->
    D_a_t_a = <<P0_scene:16, P0_x:8, P0_y:8, P0_resid:16, (proto:write_string(P0_name))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12005:16,0:8, D_a_t_a/binary>>};


%% 怪物进入场景通知 
write(12006, {P0_monlist}) ->
    D_a_t_a = <<(pack_mon_list(P0_monlist))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12006:16,0:8, D_a_t_a/binary>>};


%% 怪物消失 
write(12007, {P0_mkeylist}) ->
    D_a_t_a = <<(length(P0_mkeylist)):16, (list_to_binary([<<P1_mkey:32>> || P1_mkey <- P0_mkeylist]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12007:16,0:8, D_a_t_a/binary>>};


%% 怪物移动 
write(12008, {P0_mkey, P0_x, P0_y, P0_move_type}) ->
    D_a_t_a = <<P0_mkey:32, P0_x:8, P0_y:8, P0_move_type:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12008:16,0:8, D_a_t_a/binary>>};


%% 9宫格玩家信息 
write(12009, {P0_inplayerlist, P0_outkeylist}) ->
    D_a_t_a = <<(pack_scene_player_list(P0_inplayerlist))/binary, (length(P0_outkeylist)):16, (list_to_binary([<<P1_pkey:32>> || P1_pkey <- P0_outkeylist]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12009:16,0:8, D_a_t_a/binary>>};


%% 9宫格怪物信息 
write(12010, {P0_inmonlist, P0_outkeylist}) ->
    D_a_t_a = <<(pack_mon_list(P0_inmonlist))/binary, (length(P0_outkeylist)):16, (list_to_binary([<<P1_mkey:32>> || P1_mkey <- P0_outkeylist]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12010:16,0:8, D_a_t_a/binary>>};


%% 玩家仙盟信息更新 
write(12011, {P0_key, P0_guild_key, P0_guild_name, P0_position}) ->
    D_a_t_a = <<P0_key:32, (proto:write_string(P0_guild_key))/binary, (proto:write_string(P0_guild_name))/binary, P0_position:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12011:16,0:8, D_a_t_a/binary>>};


%% 坐骑形象更新 
write(12012, {P0_playerkey, P0_mount_id}) ->
    D_a_t_a = <<P0_playerkey:32, P0_mount_id:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12012:16,0:8, D_a_t_a/binary>>};


%% 玩家组队信息更新 
write(12013, {P0_key, P0_team_key, P0_leader}) ->
    D_a_t_a = <<P0_key:32, (proto:write_string(P0_team_key))/binary, P0_leader:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12013:16,0:8, D_a_t_a/binary>>};


%% 玩家宠物信息更新 
write(12014, {P0_key, P0_pettypeid, P0_petfigure, P0_petname}) ->
    D_a_t_a = <<P0_key:32, P0_pettypeid:32, P0_petfigure:32, (proto:write_string(P0_petname))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12014:16,0:8, D_a_t_a/binary>>};


%% 场景目标传送 
write(12015, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12015:16,0:8, D_a_t_a/binary>>};


%% 增加传送门 
write(12016, {P0_sid, P0_name, P0_x, P0_y}) ->
    D_a_t_a = <<P0_sid:32/signed, (proto:write_string(P0_name))/binary, P0_x:8/signed, P0_y:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12016:16,0:8, D_a_t_a/binary>>};


%% 传送门消失 
write(12017, {P0_sid}) ->
    D_a_t_a = <<P0_sid:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12017:16,0:8, D_a_t_a/binary>>};


%% 翅膀更新 
write(12018, {P0_key, P0_wing_id}) ->
    D_a_t_a = <<P0_key:32, P0_wing_id:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12018:16,0:8, D_a_t_a/binary>>};


%% 装备更新 
write(12019, {P0_key, P0_weapon_id, P0_clothing_id}) ->
    D_a_t_a = <<P0_key:32, P0_weapon_id:32, P0_clothing_id:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12019:16,0:8, D_a_t_a/binary>>};


%% 时装信息更新 
write(12020, {P0_key, P0_fashion_cloth_id, P0_fashion_head_id}) ->
    D_a_t_a = <<P0_key:32, P0_fashion_cloth_id:32, P0_fashion_head_id:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12020:16,0:8, D_a_t_a/binary>>};


%% 物品掉落列表 
write(12021, {P0_droplist}) ->
    D_a_t_a = <<(length(P0_droplist)):16, (list_to_binary([<<P1_key:32, P1_goodstype:32, P1_num:32, P1_x:8, P1_y:8>> || [P1_key, P1_goodstype, P1_num, P1_x, P1_y] <- P0_droplist]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12021:16,0:8, D_a_t_a/binary>>};


%% 移除掉落物品列表 
write(12022, {P0_removelist}) ->
    D_a_t_a = <<(length(P0_removelist)):16, (list_to_binary([<<P1_key:32>> || P1_key <- P0_removelist]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12022:16,0:8, D_a_t_a/binary>>};


%% 拾取掉落物品 
write(12023, {P0_code, P0_key, P0_goodstype, P0_dropx, P0_dropy}) ->
    D_a_t_a = <<P0_code:8, P0_key:32, P0_goodstype:32, P0_dropx:8, P0_dropy:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12023:16,0:8, D_a_t_a/binary>>};


%% 光武信息更新 
write(12024, {P0_key, P0_light_weapon_id}) ->
    D_a_t_a = <<P0_key:32, P0_light_weapon_id:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12024:16,0:8, D_a_t_a/binary>>};


%% 变身形象更新 
write(12025, {P0_key, P0_figure, P0_pevil}) ->
    D_a_t_a = <<P0_key:32, P0_figure:32, P0_pevil:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12025:16,0:8, D_a_t_a/binary>>};


%% 护送状态 
write(12026, {P0_key, P0_convoy}) ->
    D_a_t_a = <<P0_key:32, P0_convoy:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12026:16,0:8, D_a_t_a/binary>>};


%% 战斗分组更新 
write(12027, {P0_key, P0_group}) ->
    D_a_t_a = <<P0_key:32, P0_group:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12027:16,0:8, D_a_t_a/binary>>};


%% 称号更新 
write(12028, {P0_key, P0_designlist}) ->
    D_a_t_a = <<P0_key:32, (length(P0_designlist)):16, (list_to_binary([<<P1_designid:32>> || P1_designid <- P0_designlist]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12028:16,0:8, D_a_t_a/binary>>};


%% 采集标记 
write(12029, {P0_key, P0_flag}) ->
    D_a_t_a = <<P0_key:32, P0_flag:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12029:16,0:8, D_a_t_a/binary>>};


%% vip更新 
write(12030, {P0_key, P0_viplv, P0_vip_state}) ->
    D_a_t_a = <<P0_key:32, P0_viplv:8/signed, P0_vip_state:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12030:16,0:8, D_a_t_a/binary>>};


%% 玩家升级 
write(12031, {P0_key, P0_lv}) ->
    D_a_t_a = <<P0_key:32, P0_lv:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12031:16,0:8, D_a_t_a/binary>>};


%% 战场信息更新 
write(12032, {P0_key, P0_group, P0_score, P0_double_hit}) ->
    D_a_t_a = <<P0_key:32, P0_group:8/signed, P0_score:32/signed, P0_double_hit:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12032:16,0:8, D_a_t_a/binary>>};


%% 玩家总强化等级更新 
write(12033, {P0_key, P0_stren_lv}) ->
    D_a_t_a = <<P0_key:32, P0_stren_lv:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12033:16,0:8, D_a_t_a/binary>>};


%% 完成场景表情更新 
write(12034, {P0_key, P0_scene_face}) ->
    D_a_t_a = <<P0_key:32, (proto:write_string(P0_scene_face))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12034:16,0:8, D_a_t_a/binary>>};


%% 玩家改名 
write(12035, {P0_key, P0_new_name}) ->
    D_a_t_a = <<P0_key:32, (proto:write_string(P0_new_name))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12035:16,0:8, D_a_t_a/binary>>};


%% 更新城战皇冠信息 
write(12036, {P0_key, P0_crown}) ->
    D_a_t_a = <<P0_key:32, P0_crown:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12036:16,0:8, D_a_t_a/binary>>};


%% 更新坐骑共乘信息 
write(12037, {P0_main_key, P0_common_key, P0_state}) ->
    D_a_t_a = <<P0_main_key:32, P0_common_key:32, P0_state:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12037:16,0:8, D_a_t_a/binary>>};


%% 场景错误信息 
write(12038, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12038:16,0:8, D_a_t_a/binary>>};


%% 更新剑池形象 
write(12039, {P0_key, P0_sword_pool_figure}) ->
    D_a_t_a = <<P0_key:32, P0_sword_pool_figure:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12039:16,0:8, D_a_t_a/binary>>};


%% 更新法宝形象 
write(12040, {P0_key, P0_magic_weapon_id}) ->
    D_a_t_a = <<P0_key:32, P0_magic_weapon_id:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12040:16,0:8, D_a_t_a/binary>>};


%% 更新神器形象 
write(12041, {P0_key, P0_god_weapon_id, P0_god_weapon_skill}) ->
    D_a_t_a = <<P0_key:32, P0_god_weapon_id:32/signed, P0_god_weapon_skill:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12041:16,0:8, D_a_t_a/binary>>};


%% 更新怪物名字 
write(12042, {P0_key, P0_name}) ->
    D_a_t_a = <<P0_key:32, (proto:write_string(P0_name))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12042:16,0:8, D_a_t_a/binary>>};


%% 更新玩家是否场景隐身 
write(12043, {P0_sign, P0_key, P0_is_view}) ->
    D_a_t_a = <<P0_sign:8/signed, P0_key:32, P0_is_view:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12043:16,0:8, D_a_t_a/binary>>};


%% 更新玩家足迹  
write(12044, {P0_key, P0_footprint_id}) ->
    D_a_t_a = <<P0_key:32, P0_footprint_id:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12044:16,0:8, D_a_t_a/binary>>};


%% 更新罪恶值 
write(12045, {P0_key, P0_pk_value, P0_pk_kill, P0_chivalry, P0_pk, P0_pk_protect_time}) ->
    D_a_t_a = <<P0_key:32, P0_pk_value:32/signed, P0_pk_kill:32, P0_chivalry:32/signed, P0_pk:8/signed, P0_pk_protect_time:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12045:16,0:8, D_a_t_a/binary>>};


%% 妖灵信息更新 
write(12046, {P0_key, P0_pet_weapon_id}) ->
    D_a_t_a = <<P0_key:32, P0_pet_weapon_id:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12046:16,0:8, D_a_t_a/binary>>};


%% 飞鞋移动 
write(12047, {P0_res, P0_is_fly, P0_sid, P0_x, P0_y}) ->
    D_a_t_a = <<P0_res:8, P0_is_fly:8, P0_sid:16, P0_x:8, P0_y:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12047:16,0:8, D_a_t_a/binary>>};


%% 使用特效道具 
write(12048, {P0_key, P0_goods_id, P0_player_list}) ->
    D_a_t_a = <<P0_key:32, P0_goods_id:32, (length(P0_player_list)):16, (list_to_binary([<<P1_key:32, P1_type:8>> || [P1_key, P1_type] <- P0_player_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12048:16,0:8, D_a_t_a/binary>>};


%% 取消特效buff 
write(12049, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12049:16,0:8, D_a_t_a/binary>>};


%% 温泉信息更新 
write(12050, {P0_key, P0_hw_st, P0_hw_pkey}) ->
    D_a_t_a = <<P0_key:32, P0_hw_st:8, P0_hw_pkey:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12050:16,0:8, D_a_t_a/binary>>};


%% 传送状态修改 
write(12051, {P0_res}) ->
    D_a_t_a = <<P0_res:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12051:16,0:8, D_a_t_a/binary>>};


%% 灵猫信息更新 
write(12052, {P0_key, P0_cat_id}) ->
    D_a_t_a = <<P0_key:32, P0_cat_id:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12052:16,0:8, D_a_t_a/binary>>};


%% 结婚信息更新 
write(12053, {P0_key, P0_marry_type, P0_couple_name, P0_couple_sex, P0_couple_key}) ->
    D_a_t_a = <<P0_key:32, P0_marry_type:8, (proto:write_string(P0_couple_name))/binary, P0_couple_sex:8, P0_couple_key:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12053:16,0:8, D_a_t_a/binary>>};


%% 巡游状态更新 
write(12054, {P0_key, P0_cruise_state}) ->
    D_a_t_a = <<P0_key:32, P0_cruise_state:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12054:16,0:8, D_a_t_a/binary>>};


%% 法身信息更新 
write(12055, {P0_key, P0_golden_body_id}) ->
    D_a_t_a = <<P0_key:32, P0_golden_body_id:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12055:16,0:8, D_a_t_a/binary>>};


%% 结婚戒指信息更新 
write(12056, {P0_key, P0_ring_lv}) ->
    D_a_t_a = <<P0_key:32, P0_ring_lv:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12056:16,0:8, D_a_t_a/binary>>};


%% 烟花广播 
write(12057, {P0_x, P0_y}) ->
    D_a_t_a = <<P0_x:8, P0_y:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12057:16,0:8, D_a_t_a/binary>>};


%% 更新怪物采集次数 
write(12058, {P0_mkey, P0_collect_count}) ->
    D_a_t_a = <<P0_mkey:32, P0_collect_count:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12058:16,0:8, D_a_t_a/binary>>};


%% 打坐更新 
write(12059, {P0_pkey, P0_sit_state, P0_show_golden_body}) ->
    D_a_t_a = <<P0_pkey:32, P0_sit_state:8/signed, P0_show_golden_body:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12059:16,0:8, D_a_t_a/binary>>};


%% 玩家宝宝信息更新 
write(12060, {P0_key, P0_babytypeid, P0_babyfigure, P0_babyname}) ->
    D_a_t_a = <<P0_key:32, P0_babytypeid:32, P0_babyfigure:32, (proto:write_string(P0_babyname))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12060:16,0:8, D_a_t_a/binary>>};


%% 子女翅膀更新 
write(12061, {P0_key, P0_baby_wing_id}) ->
    D_a_t_a = <<P0_key:32, P0_baby_wing_id:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12061:16,0:8, D_a_t_a/binary>>};


%% 场景内位置传送 
write(12062, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12062:16,0:8, D_a_t_a/binary>>};


%% 玩家职业更新 
write(12063, {P0_key, P0_new_career}) ->
    D_a_t_a = <<P0_key:32, P0_new_career:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12063:16,0:8, D_a_t_a/binary>>};


%% 场景钻石vip更新 
write(12064, {P0_key, P0_d_vip}) ->
    D_a_t_a = <<P0_key:32, P0_d_vip:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12064:16,0:8, D_a_t_a/binary>>};


%% 子女坐骑更新 
write(12065, {P0_key, P0_baby_mount_id}) ->
    D_a_t_a = <<P0_key:32, P0_baby_mount_id:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12065:16,0:8, D_a_t_a/binary>>};


%% 子女武器更新 
write(12066, {P0_key, P0_baby_weapon_id}) ->
    D_a_t_a = <<P0_key:32, P0_baby_weapon_id:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12066:16,0:8, D_a_t_a/binary>>};


%% 玩家战队信息更新 
write(12067, {P0_key, P0_war_team_key, P0_war_team_name, P0_position}) ->
    D_a_t_a = <<P0_key:32, (proto:write_string(P0_war_team_key))/binary, (proto:write_string(P0_war_team_name))/binary, P0_position:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12067:16,0:8, D_a_t_a/binary>>};


%% 擂主标记更新 
write(12068, {P0_key, P0_flag}) ->
    D_a_t_a = <<P0_key:32, P0_flag:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12068:16,0:8, D_a_t_a/binary>>};


%% 剑道阶级更新 
write(12069, {P0_key, P0_jiandao_stage}) ->
    D_a_t_a = <<P0_key:32, P0_jiandao_stage:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12069:16,0:8, D_a_t_a/binary>>};


%% 穿戴元素更新 
write(12070, {P0_key, P0_wear_element_list}) ->
    D_a_t_a = <<P0_key:32, (length(P0_wear_element_list)):16, (list_to_binary([<<P1_race:32, P1_pos:8>> || [P1_race, P1_pos] <- P0_wear_element_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12070:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------

pack_elem_list(P0_elem_list) ->
    D_a_t_a = <<(length(P0_elem_list)):16, (list_to_binary([<<P1_sid:16, (proto:write_string(P1_name))/binary, P1_x:8, P1_y:8>> || [P1_sid, P1_name, P1_x, P1_y] <- P0_elem_list]))/binary>>,
    <<D_a_t_a/binary>>.


pack_npc_list(P0_npc_list) ->
    D_a_t_a = <<(length(P0_npc_list)):16, (list_to_binary([<<P1_nkey:32, P1_mid:16, P1_x:8, P1_y:8, (proto:write_string(P1_name))/binary, P1_icon:32, P1_image:32, P1_realm:8, (proto:write_string(P1_guild_name))/binary>> || [P1_nkey, P1_mid, P1_x, P1_y, P1_name, P1_icon, P1_image, P1_realm, P1_guild_name] <- P0_npc_list]))/binary>>,
    <<D_a_t_a/binary>>.


pack_mon_list(P0_mon_list) ->
    D_a_t_a = <<(length(P0_mon_list)):16, (list_to_binary([<<P1_mkey:32, P1_mid:16, P1_x:8, P1_y:8, P1_hp_lim:32, P1_hp:32, P1_lv:16, (proto:write_string(P1_name))/binary, P1_speed:16, P1_icon:32, P1_kind:8, P1_color:8, P1_group:8, P1_boss:8, P1_collecttime:8, (proto:write_string(P1_guildkey))/binary, P1_show_time:32/signed, (proto:write_string(P1_party_key))/binary, P1_collect_count:32/signed, P1_collect_num:32/signed, P1_shadow_key:32, (length(P1_shadow_info)):16, (list_to_binary([<<P2_mount_id:32, P2_career:8/signed, P2_vip:8/signed, (proto:write_string(P2_g_name))/binary, P2_wing_id:32, P2_wepon_id:32, P2_clothing_id:32, P2_light_wepon_id:32, P2_fashion_cloth_id:32, P2_footprint_id:32, P2_stren_lv:16, P2_pettypeid:32/signed, P2_petfigure:32/signed, (proto:write_string(P2_petname))/binary, (length(P2_designlist)):16, (list_to_binary([<<P3_designid:32>> || P3_designid <- P2_designlist]))/binary, P2_fashion_head_id:32/signed, P2_sword_pool_figure:32/signed, P2_magic_weapon_id:32/signed, P2_god_weapon_id:32/signed, P2_sex:8/signed, P2_pet_weapon_id:32, P2_cat_id:32, P2_golden_body_id:32, P2_jade_id:32, P2_god_treasure_id:32, P2_babytypeid:32/signed, P2_babyfigure:32/signed, (proto:write_string(P2_babyname))/binary, P2_xian_stage:8>> || [P2_mount_id, P2_career, P2_vip, P2_g_name, P2_wing_id, P2_wepon_id, P2_clothing_id, P2_light_wepon_id, P2_fashion_cloth_id, P2_footprint_id, P2_stren_lv, P2_pettypeid, P2_petfigure, P2_petname, P2_designlist, P2_fashion_head_id, P2_sword_pool_figure, P2_magic_weapon_id, P2_god_weapon_id, P2_sex, P2_pet_weapon_id, P2_cat_id, P2_golden_body_id, P2_jade_id, P2_god_treasure_id, P2_babytypeid, P2_babyfigure, P2_babyname, P2_xian_stage] <- P1_shadow_info]))/binary>> || [P1_mkey, P1_mid, P1_x, P1_y, P1_hp_lim, P1_hp, P1_lv, P1_name, P1_speed, P1_icon, P1_kind, P1_color, P1_group, P1_boss, P1_collecttime, P1_guildkey, P1_show_time, P1_party_key, P1_collect_count, P1_collect_num, P1_shadow_key, P1_shadow_info] <- P0_mon_list]))/binary>>,
    <<D_a_t_a/binary>>.


pack_scene_player_list(P0_player_list) ->
    D_a_t_a = <<(length(P0_player_list)):16, (list_to_binary([<<P1_pkey:32, (proto:write_string(P1_name))/binary, P1_sn:16, P1_sn_now:16, (proto:write_string(P1_sn_name))/binary, P1_pf:32, P1_x:8, P1_y:8, P1_hp_lim:32, P1_hp:32, P1_mp_lim:32, P1_mp:32, P1_lv:16, P1_vip:8, P1_vip_state:16, P1_stren_lv:16, P1_speed:16, P1_cbp:32, P1_group:8, P1_convoy:8, (proto:write_string(P1_teamkey))/binary, P1_career:8/signed, P1_sex:8, P1_realm:8/signed, P1_pkstate:8, P1_pkvalue:32, P1_wing_id:32, P1_wepon_id:32, P1_clothing_id:32, P1_light_wepon_id:32, P1_fashion_cloth_id:32, P1_footprint_id:32, P1_mount_id:32, P1_pettypeid:32, P1_petfigure:32, (proto:write_string(P1_petname))/binary, (proto:write_string(P1_guildkey))/binary, (proto:write_string(P1_guildname))/binary, P1_figure:32/signed, P1_bf_score:32/signed, P1_double_hit:16/signed, P1_guildpos:8/signed, (proto:write_string(P1_scene_face))/binary, P1_sprite_lv:16, P1_crown:8, P1_common_mount_state:8, P1_main_mount_pkey:32, P1_common_mount_pkey:32, P1_sword_pool_figure:32/signed, P1_magic_weapon_id:32/signed, P1_god_weapon_id:32/signed, P1_fashion_head_id:32/signed, P1_pk_kill:32, P1_chivalry:32/signed, P1_pet_weapon_id:32, P1_pk_protect_time:32/signed, (proto:write_string(P1_avatar))/binary, P1_is_view:8/signed, P1_hw_st:8/signed, P1_hw_pkey:32, P1_cat_id:32, P1_marry_type:8, (proto:write_string(P1_couple_name))/binary, P1_couple_sex:8, P1_couple_key:32, P1_ring_lv:32, P1_cruise_state:8, P1_golden_body_id:32, P1_jade_id:32, P1_god_treasure_id:32, P1_sit_state:8, P1_dvip:8, P1_babytypeid:32, P1_babyfigure:32, (proto:write_string(P1_babyname))/binary, P1_baby_wing_id:32, P1_baby_mount_id:32, P1_baby_weapon_id:32, P1_xian_stage:8, P1_show_golden_body:8, (proto:write_string(P1_war_team_key))/binary, (proto:write_string(P1_war_team_name))/binary, P1_war_team_position:8/signed, (pack_buff_list(P1_bufflist))/binary, (length(P1_designlist)):16, (list_to_binary([<<P2_designid:32>> || P2_designid <- P1_designlist]))/binary, P1_jiandao_stage:8, (length(P1_wear_element_list)):16, (list_to_binary([<<P2_race:8, P2_pos:8>> || [P2_race, P2_pos] <- P1_wear_element_list]))/binary>> || [P1_pkey, P1_name, P1_sn, P1_sn_now, P1_sn_name, P1_pf, P1_x, P1_y, P1_hp_lim, P1_hp, P1_mp_lim, P1_mp, P1_lv, P1_vip, P1_vip_state, P1_stren_lv, P1_speed, P1_cbp, P1_group, P1_convoy, P1_teamkey, P1_career, P1_sex, P1_realm, P1_pkstate, P1_pkvalue, P1_wing_id, P1_wepon_id, P1_clothing_id, P1_light_wepon_id, P1_fashion_cloth_id, P1_footprint_id, P1_mount_id, P1_pettypeid, P1_petfigure, P1_petname, P1_guildkey, P1_guildname, P1_figure, P1_bf_score, P1_double_hit, P1_guildpos, P1_scene_face, P1_sprite_lv, P1_crown, P1_common_mount_state, P1_main_mount_pkey, P1_common_mount_pkey, P1_sword_pool_figure, P1_magic_weapon_id, P1_god_weapon_id, P1_fashion_head_id, P1_pk_kill, P1_chivalry, P1_pet_weapon_id, P1_pk_protect_time, P1_avatar, P1_is_view, P1_hw_st, P1_hw_pkey, P1_cat_id, P1_marry_type, P1_couple_name, P1_couple_sex, P1_couple_key, P1_ring_lv, P1_cruise_state, P1_golden_body_id, P1_jade_id, P1_god_treasure_id, P1_sit_state, P1_dvip, P1_babytypeid, P1_babyfigure, P1_babyname, P1_baby_wing_id, P1_baby_mount_id, P1_baby_weapon_id, P1_xian_stage, P1_show_golden_body, P1_war_team_key, P1_war_team_name, P1_war_team_position, P1_bufflist, P1_designlist, P1_jiandao_stage, P1_wear_element_list] <- P0_player_list]))/binary>>,
    <<D_a_t_a/binary>>.


pack_buff_list(P0_buff_list) ->
    D_a_t_a = <<(length(P0_buff_list)):16, (list_to_binary([<<P1_buffid:16, P1_skillid:32, P1_stack:8, P1_time:16>> || [P1_buffid, P1_skillid, P1_stack, P1_time] <- P0_buff_list]))/binary>>,
    <<D_a_t_a/binary>>.




