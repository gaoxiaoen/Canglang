%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2018-05-14 18:44:11
%%----------------------------------------------------
-module(pt_130).
-export([read/2, write/2]).

-include("common.hrl").
-include("server.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"您还没跑分，不能分享"; 
err(3) ->"会员等级1以上才能分享跑分"; 
err(4) ->"跨服资料不可偷看喔"; 
err(5) ->"头像审核中"; 
err(6) ->"请输入6-12字节内的玩家昵称"; 
err(7) ->"名字已存在"; 
err(8) ->"请求过于频繁"; 
err(9) ->"包含敏感词"; 
err(10) ->"没有改名卡"; 
err(11) ->"每天只能改名1次,请明天再来"; 
err(12) ->"没有变性丹"; 
err(13) ->"野外场景才能打坐"; 
err(14) ->"已达觉醒上限"; 
err(15) ->"激活条件不足"; 
err(16) ->"觉醒条件不足"; 
err(17) ->"已达激活上限"; 
err(18) ->"已经认证身份证"; 
err(19) ->"无效证件"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(13001, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_pkey}};

read(13002, _B0) ->
    {ok, {}};

read(13003, _B0) ->
    {ok, {}};

read(13004, _B0) ->
    {ok, {}};

read(13005, _B0) ->
    {ok, {}};

read(13008, _B0) ->
    {ok, {}};

read(13009, _B0) ->
    {P0_key, _B1} = proto:read_string(_B0),
    {P0_value, _B2} = proto:read_uint32(_B1),
    {ok, {P0_key, P0_value}};

read(13010, _B0) ->
    {P0_id_list, _B3} = proto:read_array(_B0, fun(_B1) ->
        {P1_id, _B2} = proto:read_int16(_B1),
        {P1_id, _B2}
    end),
    {ok, {P0_id_list}};

read(13011, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_pkey}};

read(13013, _B0) ->
    {P0_sn, _B1} = proto:read_int32(_B0),
    {P0_pkey, _B2} = proto:read_uint32(_B1),
    {ok, {P0_sn, P0_pkey}};

read(13014, _B0) ->
    {P0_sn, _B1} = proto:read_int32(_B0),
    {P0_pkey, _B2} = proto:read_uint32(_B1),
    {ok, {P0_sn, P0_pkey}};

read(13015, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {P0_type, _B2} = proto:read_int8(_B1),
    {ok, {P0_pkey, P0_type}};

read(13016, _B0) ->
    {ok, {}};

read(13019, _B0) ->
    {P0_url, _B1} = proto:read_string(_B0),
    {ok, {P0_url}};

read(13020, _B0) ->
    {P0_new_name, _B1} = proto:read_string(_B0),
    {P0_type, _B2} = proto:read_uint8(_B1),
    {ok, {P0_new_name, P0_type}};

read(13023, _B0) ->
    {P0_carrer, _B1} = proto:read_uint8(_B0),
    {ok, {P0_carrer}};

read(13024, _B0) ->
    {ok, {}};

read(13025, _B0) ->
    {ok, {}};

read(13026, _B0) ->
    {ok, {}};

read(13027, _B0) ->
    {ok, {}};

read(13028, _B0) ->
    {ok, {}};

read(13029, _B0) ->
    {ok, {}};

read(13030, _B0) ->
    {ok, {}};

read(13031, _B0) ->
    {ok, {}};

read(13032, _B0) ->
    {P0_id, _B1} = proto:read_int32(_B0),
    {ok, {P0_id}};

read(13033, _B0) ->
    {ok, {}};

read(13035, _B0) ->
    {ok, {}};

read(13036, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {ok, {P0_type}};

read(13037, _B0) ->
    {ok, {}};

read(13038, _B0) ->
    {P0_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_id}};

read(13039, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {ok, {P0_type}};

read(13041, _B0) ->
    {P0_sn, _B1} = proto:read_int32(_B0),
    {P0_pkey, _B2} = proto:read_uint32(_B1),
    {ok, {P0_sn, P0_pkey}};

read(13040, _B0) ->
    {ok, {}};

read(13042, _B0) ->
    {ok, {}};

read(13043, _B0) ->
    {ok, {}};

read(13044, _B0) ->
    {ok, {}};

read(13045, _B0) ->
    {ok, {}};

read(13046, _B0) ->
    {P0_name, _B1} = proto:read_string(_B0),
    {P0_card_id, _B2} = proto:read_string(_B1),
    {ok, {P0_name, P0_card_id}};

read(13047, _B0) ->
    {ok, {}};

read(13099, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {P0_val, _B2} = proto:read_string(_B1),
    {ok, {P0_type, P0_val}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 玩家信息协议 
write(13001, {P0_pkey, P0_sn, P0_sn_now, P0_sn_name, P0_pf, P0_name, P0_lv, P0_scene, P0_line, P0_x, P0_y, P0_career, P0_sex, P0_realm, P0_exp_lim, P0_exp, P0_diamond, P0_bdiamond, P0_coin, P0_bcoin, P0_exploit, P0_honour, P0_reiki, P0_sd_pt, P0_exploit_pri, P0_repute, P0_charm, P0_athletics, P0_star_luck, P0_xinghun, P0_guildkey, P0_guildname, P0_guildpos, P0_home_goods, P0_equip_part, P0_act_gold, P0_fairy_crystal, P0_vip, P0_vip_state, P0_sweet, P0_mount_id, P0_pkstate, P0_pkvalue, P0_pevil, P0_pevil_time, P0_pettypeid, P0_petfigure, P0_petname, P0_teamkey, P0_wing_id, P0_wepon_id, P0_clothing_id, P0_light_wepon_id, P0_fashion_cloth_id, P0_footprint_id, P0_designlist, P0_stren_lv, P0_stone_lv, P0_attlist, P0_convoy, P0_figure, P0_group, P0_bf_score, P0_double_hit, P0_scene_face, P0_sprite_lv, P0_role_create_time, P0_avatar, P0_crown, P0_sword_pool_figure, P0_magic_weapon_id, P0_god_weapon_id, P0_god_weapon_skill, P0_fashion_head_id, P0_pk_kill, P0_chivalry, P0_pet_weapon_id, P0_pk_protect_time, P0_is_view, P0_world_lv, P0_wlv_add, P0_cat_id, P0_marry_type, P0_couple_name, P0_couple_sex, P0_cruise_state, P0_golden_body_id, P0_jade_id, P0_god_treasure_id, P0_couple_key, P0_ring_lv, P0_sit_state, P0_fashion_decoration_id, P0_marry_ring_type, P0_couple_marry_ring_lv, P0_babytypeid, P0_babyfigure, P0_babyname, P0_baby_wing_id, P0_new_career, P0_dvip, P0_dvip_time, P0_baby_mount_id, P0_baby_weapon_id, P0_skill_effect, P0_xian_stage, P0_show_golden_body, P0_war_team_key, P0_war_team_name, P0_war_team_position, P0_jiandao_stage, P0_wear_element_list}) ->
    D_a_t_a = <<P0_pkey:32, P0_sn:16, P0_sn_now:32/signed, (proto:write_string(P0_sn_name))/binary, P0_pf:32, (proto:write_string(P0_name))/binary, P0_lv:16, P0_scene:16, P0_line:8, P0_x:8, P0_y:8, P0_career:8/signed, P0_sex:8, P0_realm:8/signed, (proto:write_string(P0_exp_lim))/binary, (proto:write_string(P0_exp))/binary, P0_diamond:32, P0_bdiamond:32, P0_coin:32, P0_bcoin:32, P0_exploit:32, P0_honour:32, P0_reiki:32, P0_sd_pt:32, P0_exploit_pri:32, P0_repute:32, P0_charm:32, P0_athletics:32, P0_star_luck:32, P0_xinghun:32, (proto:write_string(P0_guildkey))/binary, (proto:write_string(P0_guildname))/binary, P0_guildpos:8/signed, P0_home_goods:32, P0_equip_part:32, P0_act_gold:16, P0_fairy_crystal:16, P0_vip:16, P0_vip_state:16, P0_sweet:32/signed, P0_mount_id:32, P0_pkstate:8/signed, P0_pkvalue:32, P0_pevil:8, P0_pevil_time:8, P0_pettypeid:32, P0_petfigure:32, (proto:write_string(P0_petname))/binary, (proto:write_string(P0_teamkey))/binary, P0_wing_id:32, P0_wepon_id:32, P0_clothing_id:32, P0_light_wepon_id:32, P0_fashion_cloth_id:32, P0_footprint_id:32, (length(P0_designlist)):16, (list_to_binary([<<P1_designid:32>> || P1_designid <- P0_designlist]))/binary, P0_stren_lv:16, P0_stone_lv:16, (pack_attribute(P0_attlist))/binary, P0_convoy:8, P0_figure:32/signed, P0_group:8/signed, P0_bf_score:32/signed, P0_double_hit:16/signed, (proto:write_string(P0_scene_face))/binary, P0_sprite_lv:16, P0_role_create_time:32, (proto:write_string(P0_avatar))/binary, P0_crown:8/signed, P0_sword_pool_figure:32/signed, P0_magic_weapon_id:32/signed, P0_god_weapon_id:32/signed, P0_god_weapon_skill:32/signed, P0_fashion_head_id:32/signed, P0_pk_kill:32, P0_chivalry:32, P0_pet_weapon_id:32, P0_pk_protect_time:32/signed, P0_is_view:8/signed, P0_world_lv:16/signed, P0_wlv_add:16/signed, P0_cat_id:32, P0_marry_type:8, (proto:write_string(P0_couple_name))/binary, P0_couple_sex:8, P0_cruise_state:8, P0_golden_body_id:32, P0_jade_id:32, P0_god_treasure_id:32, P0_couple_key:32, P0_ring_lv:32, P0_sit_state:8, P0_fashion_decoration_id:32/signed, P0_marry_ring_type:32, P0_couple_marry_ring_lv:32, P0_babytypeid:32, P0_babyfigure:32, (proto:write_string(P0_babyname))/binary, P0_baby_wing_id:32, P0_new_career:8/signed, P0_dvip:8/signed, P0_dvip_time:32/signed, P0_baby_mount_id:32, P0_baby_weapon_id:32, P0_skill_effect:8, P0_xian_stage:8, P0_show_golden_body:8, (proto:write_string(P0_war_team_key))/binary, (proto:write_string(P0_war_team_name))/binary, P0_war_team_position:8/signed, P0_jiandao_stage:8, (length(P0_wear_element_list)):16, (list_to_binary([<<P1_race:32, P1_pos:8>> || [P1_race, P1_pos] <- P0_wear_element_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13001:16,0:8, D_a_t_a/binary>>};


%% 玩家属性推送 
write(13002, {P0_attr}) ->
    D_a_t_a = <<(pack_attribute(P0_attr))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13002:16,0:8, D_a_t_a/binary>>};


%% 玩家升级推送 
write(13003, {P0_exp, P0_addexp, P0_exptype, P0_lv, P0_uplv, P0_addlist}) ->
    D_a_t_a = <<(proto:write_string(P0_exp))/binary, (proto:write_string(P0_addexp))/binary, P0_exptype:8, P0_lv:16, P0_uplv:8, (length(P0_addlist)):16, (list_to_binary([<<P1_addtype:8, P1_addval:32>> || [P1_addtype, P1_addval] <- P0_addlist]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13003:16,0:8, D_a_t_a/binary>>};


%% 玩家银两元宝等数值更新 
write(13004, {P0_numerical}) ->
    D_a_t_a = <<(length(P0_numerical)):16, (list_to_binary([<<P1_addtype:8, P1_addval:32>> || [P1_addtype, P1_addval] <- P0_numerical]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13004:16,0:8, D_a_t_a/binary>>};


%% 玩法次数更新 
write(13005, {P0_play_list}) ->
    D_a_t_a = <<(length(P0_play_list)):16, (list_to_binary([<<P1_type:8, P1_sub_id:8, P1_current_times:8, P1_sum_times:8>> || [P1_type, P1_sub_id, P1_current_times, P1_sum_times] <- P0_play_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13005:16,0:8, D_a_t_a/binary>>};


%% 新手引导进度数据更新 
write(13008, {P0_guide_list}) ->
    D_a_t_a = <<(length(P0_guide_list)):16, (list_to_binary([<<(proto:write_string(P1_key))/binary, P1_value:32>> || [P1_key, P1_value] <- P0_guide_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13008:16,0:8, D_a_t_a/binary>>};


%% 设置新手引导数据 
write(13009, {P0_error_code, P0_key}) ->
    D_a_t_a = <<P0_error_code:8, (proto:write_string(P0_key))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13009:16,0:8, D_a_t_a/binary>>};


%% 获取提示大厅信息列表 
write(13010, {P0_id_list}) ->
    D_a_t_a = <<(length(P0_id_list)):16, (list_to_binary([<<P1_id:16/signed, P1_state:8/signed, (proto:write_string(P1_args1))/binary, (proto:write_string(P1_args2))/binary, (proto:write_string(P1_args3))/binary, (proto:write_string(P1_args4))/binary, (proto:write_string(P1_args5))/binary, (proto:write_string(P1_args6))/binary, (proto:write_string(P1_args7))/binary, (proto:write_string(P1_args8))/binary, (length(P1_dungeon_list)):16, (list_to_binary([<<P2_dungeon_id:8/signed>> || P2_dungeon_id <- P1_dungeon_list]))/binary>> || [P1_id, P1_state, P1_args1, P1_args2, P1_args3, P1_args4, P1_args5, P1_args6, P1_args7, P1_args8, P1_dungeon_list] <- P0_id_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13010:16,0:8, D_a_t_a/binary>>};


%% 查询某个玩家是否是自己的好友或者队友 
write(13011, {P0_pkey, P0_is_friend, P0_is_teammate, P0_name, P0_career, P0_lv, P0_cbp, P0_sn, P0_guild_name, P0_sex, P0_avatar}) ->
    D_a_t_a = <<P0_pkey:32, P0_is_friend:8/signed, P0_is_teammate:8/signed, (proto:write_string(P0_name))/binary, P0_career:8/signed, P0_lv:8/signed, P0_cbp:32/signed, P0_sn:32/signed, (proto:write_string(P0_guild_name))/binary, P0_sex:8/signed, (proto:write_string(P0_avatar))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13011:16,0:8, D_a_t_a/binary>>};


%% 其他玩家信息查询 
write(13013, {P0_error_code, P0_sn, P0_pkey, P0_attlist, P0_name, P0_lv, P0_career, P0_sex, P0_guildname, P0_viplv, P0_fighting_capacity, P0_mount_id, P0_wing_id, P0_wepon_id, P0_clothing_id, P0_light_wepon_id, P0_fashion_cloth_id, P0_footprint_id, P0_design_list, P0_goods_list, P0_stren_lv, P0_stone_lv, P0_typeid, P0_pet_name, P0_figure_id, P0_attr_dan, P0_avatar, P0_fashion_head_id, P0_pet_weapon_id, P0_exp_lim, P0_exp, P0_charm, P0_evil, P0_ach_lv, P0_ach_exp, P0_ach_exp_lim, P0_ach_score_list, P0_cat_id, P0_golden_body_id, P0_jade_id, P0_god_treasure_id, P0_ring_lv, P0_marry_ring_type, P0_couple_name, P0_couple_marry_ring_lv, P0_babytypeid, P0_babyfigure, P0_babyname, P0_new_career, P0_dvip, P0_dvip_time}) ->
    D_a_t_a = <<P0_error_code:8, P0_sn:32/signed, P0_pkey:32, (pack_attribute(P0_attlist))/binary, (proto:write_string(P0_name))/binary, P0_lv:16, P0_career:8/signed, P0_sex:8, (proto:write_string(P0_guildname))/binary, P0_viplv:16, P0_fighting_capacity:32, P0_mount_id:32, P0_wing_id:32, P0_wepon_id:32, P0_clothing_id:32, P0_light_wepon_id:32, P0_fashion_cloth_id:32, P0_footprint_id:32, (length(P0_design_list)):16, (list_to_binary([<<P1_design_id:32>> || P1_design_id <- P0_design_list]))/binary, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_strlen_lv:8, P1_star:8, P1_god_forging:32, P1_level:32, (length(P1_base_attr)):16, (list_to_binary([<<P2_attr_type:8, P2_value:16>> || [P2_attr_type, P2_value] <- P1_base_attr]))/binary, (length(P1_stone_info)):16, (list_to_binary([<<P2_hole_type:8, P2_value:32>> || [P2_hole_type, P2_value] <- P1_stone_info]))/binary, (length(P1_magic_attr)):16, (list_to_binary([<<P2_magic_lv:16, P2_magic_exp:16, P2_attr_type:8>> || [P2_magic_lv, P2_magic_exp, P2_attr_type] <- P1_magic_attr]))/binary>> || [P1_goods_id, P1_strlen_lv, P1_star, P1_god_forging, P1_level, P1_base_attr, P1_stone_info, P1_magic_attr] <- P0_goods_list]))/binary, P0_stren_lv:16, P0_stone_lv:16, P0_typeid:32, (proto:write_string(P0_pet_name))/binary, P0_figure_id:32, (length(P0_attr_dan)):16, (list_to_binary([<<P1_goods_id:32, P1_num:16>> || [P1_goods_id, P1_num] <- P0_attr_dan]))/binary, (proto:write_string(P0_avatar))/binary, P0_fashion_head_id:32/signed, P0_pet_weapon_id:32, (proto:write_string(P0_exp_lim))/binary, (proto:write_string(P0_exp))/binary, P0_charm:32, P0_evil:32, P0_ach_lv:16/signed, P0_ach_exp:32/signed, P0_ach_exp_lim:32/signed, (length(P0_ach_score_list)):16, (list_to_binary([<<P1_ach_type:8/signed, P1_ach_score:32, P1_ach_score_total:32>> || [P1_ach_type, P1_ach_score, P1_ach_score_total] <- P0_ach_score_list]))/binary, P0_cat_id:32, P0_golden_body_id:32, P0_jade_id:32, P0_god_treasure_id:32, P0_ring_lv:32, P0_marry_ring_type:32, (proto:write_string(P0_couple_name))/binary, P0_couple_marry_ring_lv:32, P0_babytypeid:32, P0_babyfigure:32, (proto:write_string(P0_babyname))/binary, P0_new_career:8/signed, P0_dvip:8/signed, P0_dvip_time:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13013:16,0:8, D_a_t_a/binary>>};


%% 查看人物形象 
write(13014, {P0_sn, P0_pkey, P0_name, P0_career, P0_sex, P0_vip, P0_wing_id, P0_wepon_id, P0_clothing_id, P0_light_wepon_id, P0_fashion_cloth_id, P0_pet_type_id, P0_pet_figure, P0_pet_name, P0_fashion_head_id, P0_pet_weapon_id, P0_cat_id, P0_golden_body_id, P0_jade_id, P0_god_treasure_id, P0_babytypeid, P0_babyfigure, P0_babyname, P0_dvip, P0_dvip_time}) ->
    D_a_t_a = <<P0_sn:32/signed, P0_pkey:32, (proto:write_string(P0_name))/binary, P0_career:8/signed, P0_sex:8, P0_vip:8/signed, P0_wing_id:32, P0_wepon_id:32, P0_clothing_id:32, P0_light_wepon_id:32, P0_fashion_cloth_id:32, P0_pet_type_id:32, P0_pet_figure:32, (proto:write_string(P0_pet_name))/binary, P0_fashion_head_id:32/signed, P0_pet_weapon_id:32, P0_cat_id:32, P0_golden_body_id:32, P0_jade_id:32, P0_god_treasure_id:32, P0_babytypeid:32, P0_babyfigure:32, (proto:write_string(P0_babyname))/binary, P0_dvip:8/signed, P0_dvip_time:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13014:16,0:8, D_a_t_a/binary>>};


%% 查看其它玩家外观信息 
write(13015, {P0_type, P0_stage, P0_cbp, P0_attr, P0_skill_list, P0_equip_list, P0_grow_num, P0_goods_list}) ->
    D_a_t_a = <<P0_type:8/signed, P0_stage:16, P0_cbp:32, (length(P0_attr)):16, (list_to_binary([<<P1_attr_type:8, P1_value:32>> || [P1_attr_type, P1_value] <- P0_attr]))/binary, (length(P0_skill_list)):16, (list_to_binary([<<P1_cell:8, P1_skill_id:32, P1_skill_state:8/signed>> || [P1_cell, P1_skill_id, P1_skill_state] <- P0_skill_list]))/binary, (length(P0_equip_list)):16, (list_to_binary([<<P1_subtype:16/signed, P1_equip_id:32>> || [P1_subtype, P1_equip_id] <- P0_equip_list]))/binary, P0_grow_num:16, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_num:16>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13015:16,0:8, D_a_t_a/binary>>};


%% 属性丹物品使用数量 
write(13016, {P0_goods_list}) ->
    D_a_t_a = <<(length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_num:16>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13016:16,0:8, D_a_t_a/binary>>};


%% 设置头像 
write(13019, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13019:16,0:8, D_a_t_a/binary>>};


%% 改名 
write(13020, {P0_code, P0_type}) ->
    D_a_t_a = <<P0_code:8, P0_type:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13020:16,0:8, D_a_t_a/binary>>};


%% 职业转换 
write(13023, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13023:16,0:8, D_a_t_a/binary>>};


%% 功能祝福列表信息 
write(13024, {P0_bless_list}) ->
    D_a_t_a = <<(length(P0_bless_list)):16, (list_to_binary([<<P1_type:8, P1_time:32>> || [P1_type, P1_time] <- P0_bless_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13024:16,0:8, D_a_t_a/binary>>};


%% 外观开启推送 
write(13025, {P0_type, P0_id}) ->
    D_a_t_a = <<P0_type:8, P0_id:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13025:16,0:8, D_a_t_a/binary>>};


%% 游戏内购通知 
write(13026, {P0_goods_id, P0_goods_num, P0_gold_cost, P0_bgold_cost, P0_gold, P0_bgold}) ->
    D_a_t_a = <<P0_goods_id:32/signed, P0_goods_num:32, P0_gold_cost:32, P0_bgold_cost:32, P0_gold:32, P0_bgold:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13026:16,0:8, D_a_t_a/binary>>};


%% 更新世界等级经验加成 
write(13027, {P0_world_lv, P0_wlv_add}) ->
    D_a_t_a = <<P0_world_lv:16/signed, P0_wlv_add:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13027:16,0:8, D_a_t_a/binary>>};


%% 使用变性丹 
write(13028, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13028:16,0:8, D_a_t_a/binary>>};


%% 玩家性别变更 
write(13029, {P0_pkey, P0_sex}) ->
    D_a_t_a = <<P0_pkey:32, P0_sex:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13029:16,0:8, D_a_t_a/binary>>};


%% 进入打坐 
write(13030, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13030:16,0:8, D_a_t_a/binary>>};


%% 打坐经验更新 
write(13031, {P0_exp}) ->
    D_a_t_a = <<(proto:write_string(P0_exp))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13031:16,0:8, D_a_t_a/binary>>};


%% 查询功能是否可开启 
write(13032, {P0_ret}) ->
    D_a_t_a = <<P0_ret:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13032:16,0:8, D_a_t_a/binary>>};


%% 图鉴总览 
write(13033, {P0_star_list2}) ->
    D_a_t_a = <<(length(P0_star_list2)):16, (list_to_binary([<<P1_type:32, P1_id:32, (length(P1_star_list1)):16, (list_to_binary([<<P2_id:32, P2_star:8/signed, (length(P2_activation_list)):16, (list_to_binary([<<P3_act_star:32>> || P3_act_star <- P2_activation_list]))/binary>> || [P2_id, P2_star, P2_activation_list] <- P1_star_list1]))/binary>> || [P1_type, P1_id, P1_star_list1] <- P0_star_list2]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13033:16,0:8, D_a_t_a/binary>>};


%% 付费礼包推送 
write(13035, {P0_goods_list}) ->
    D_a_t_a = <<(length(P0_goods_list)):16, (list_to_binary([<<P1_id:32, P1_num:32>> || [P1_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13035:16,0:8, D_a_t_a/binary>>};


%% 修改打坐法身状态 
write(13036, {P0_ret}) ->
    D_a_t_a = <<P0_ret:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13036:16,0:8, D_a_t_a/binary>>};


%% 获取人物属性丹信息 
write(13037, {P0_info_list}) ->
    D_a_t_a = <<(length(P0_info_list)):16, (list_to_binary([<<P1_type:8, P1_id:16, P1_goods_id:32, P1_daily_count:32, P1_daily_count_limit:32, P1_use_count:32, P1_max_count_limit:32, P1_cbp:32, (length(P1_base_attr)):16, (list_to_binary([<<P2_attr_type:8, P2_value:16>> || [P2_attr_type, P2_value] <- P1_base_attr]))/binary>> || [P1_type, P1_id, P1_goods_id, P1_daily_count, P1_daily_count_limit, P1_use_count, P1_max_count_limit, P1_cbp, P1_base_attr] <- P0_info_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13037:16,0:8, D_a_t_a/binary>>};


%% 获取单个属性丹信息 
write(13038, {P0_daily_count, P0_daily_count_limit, P0_max_count_limit}) ->
    D_a_t_a = <<P0_daily_count:32, P0_daily_count_limit:32, P0_max_count_limit:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13038:16,0:8, D_a_t_a/binary>>};


%% 一键使用 
write(13039, {P0_ret}) ->
    D_a_t_a = <<P0_ret:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13039:16,0:8, D_a_t_a/binary>>};


%% 其他玩家子女信息查询 
write(13041, {P0_pkey, P0_sn, P0_babytypeid, P0_babyfigure, P0_babyname, P0_babystep, P0_babylv, P0_skill_list, P0_attrs, P0_goods_list}) ->
    D_a_t_a = <<P0_pkey:32, P0_sn:32/signed, P0_babytypeid:32, P0_babyfigure:32, (proto:write_string(P0_babyname))/binary, P0_babystep:32, P0_babylv:32, (length(P0_skill_list)):16, (list_to_binary([<<P1_cell:8/signed, P1_skill_id:32/signed, P1_state:8/signed, P1_step:8/signed>> || [P1_cell, P1_skill_id, P1_state, P1_step] <- P0_skill_list]))/binary, (length(P0_attrs)):16, (list_to_binary([<<P1_attr_type:8, P1_value:16>> || [P1_attr_type, P1_value] <- P0_attrs]))/binary, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_color:8, P1_sex:8, P1_power:32, (length(P1_fix_attr)):16, (list_to_binary([<<P2_attr_type:8, P2_value:16>> || [P2_attr_type, P2_value] <- P1_fix_attr]))/binary, (length(P1_random_attr)):16, (list_to_binary([<<P2_attr_type:8, P2_value:16>> || [P2_attr_type, P2_value] <- P1_random_attr]))/binary>> || [P1_goods_id, P1_color, P1_sex, P1_power, P1_fix_attr, P1_random_attr] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13041:16,0:8, D_a_t_a/binary>>};


%% 防沉迷提醒 
write(13040, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13040:16,0:8, D_a_t_a/binary>>};


%% 获取天命觉醒信息 
write(13042, {P0_curtype, P0_cell, P0_awake_limit, P0_awake_list}) ->
    D_a_t_a = <<P0_curtype:32, P0_cell:32, (length(P0_awake_limit)):16, (list_to_binary([<<P1_type:32, P1_num:32, P1_limit:32>> || [P1_type, P1_num, P1_limit] <- P0_awake_limit]))/binary, (length(P0_awake_list)):16, (list_to_binary([<<P1_cell:8/signed, (length(P1_up_limit1)):16, (list_to_binary([<<P2_goods_id:32, (proto:write_string(P2_goods_num))/binary>> || [P2_goods_id, P2_goods_num] <- P1_up_limit1]))/binary, (length(P1_up_limit2)):16, (list_to_binary([<<P2_goods_id:32, (proto:write_string(P2_goods_num))/binary>> || [P2_goods_id, P2_goods_num] <- P1_up_limit2]))/binary, (length(P1_attr_list)):16, (list_to_binary([<<P2_attr_type:8, P2_value:32>> || [P2_attr_type, P2_value] <- P1_attr_list]))/binary>> || [P1_cell, P1_up_limit1, P1_up_limit2, P1_attr_list] <- P0_awake_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13042:16,0:8, D_a_t_a/binary>>};


%% 点亮天命 
write(13043, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13043:16,0:8, D_a_t_a/binary>>};


%% 天命觉醒 
write(13044, {P0_code, P0_new_career}) ->
    D_a_t_a = <<P0_code:8, P0_new_career:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13044:16,0:8, D_a_t_a/binary>>};


%% 身份认证状态(服务器推送) 
write(13045, {P0_status}) ->
    D_a_t_a = <<P0_status:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13045:16,0:8, D_a_t_a/binary>>};


%% 身份认证 
write(13046, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13046:16,0:8, D_a_t_a/binary>>};


%% 防沉迷状态(服务器推送) 
write(13047, {P0_type}) ->
    D_a_t_a = <<P0_type:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13047:16,0:8, D_a_t_a/binary>>};


%% 机器人通信协议(特殊) 
write(13099, {P0_type, P0_ret1, P0_ret2, P0_ret3, P0_ret4}) ->
    D_a_t_a = <<P0_type:8, (proto:write_string(P0_ret1))/binary, (proto:write_string(P0_ret2))/binary, (proto:write_string(P0_ret3))/binary, (proto:write_string(P0_ret4))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13099:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------

pack_attribute([P0_hp_lim, P0_hp, P0_mp_lim, P0_mp, P0_att, P0_def, P0_attarea, P0_speed, P0_attspeed, P0_prepare, P0_dodge, P0_hit, P0_crit, P0_ten, P0_crit_inc, P0_crit_dec, P0_hurt_inc, P0_hurt_dec, P0_hurt_fix, P0_crit_ratio, P0_hit_ratio, P0_hp_lim_inc, P0_recover, P0_recover_hit, P0_size, P0_cure, P0_combatpower, P0_pvp_inc, P0_pvp_dec]) ->
    D_a_t_a = <<P0_hp_lim:32, P0_hp:32, P0_mp_lim:32, P0_mp:32, P0_att:32, P0_def:32, P0_attarea:8, P0_speed:16, P0_attspeed:16, P0_prepare:8, P0_dodge:32, P0_hit:32, P0_crit:32, P0_ten:32, P0_crit_inc:32, P0_crit_dec:32, P0_hurt_inc:32, P0_hurt_dec:32, P0_hurt_fix:32, P0_crit_ratio:16, P0_hit_ratio:16, P0_hp_lim_inc:16, P0_recover:32, P0_recover_hit:32, P0_size:8/signed, P0_cure:16, P0_combatpower:32, P0_pvp_inc:32, P0_pvp_dec:32>>,
    <<D_a_t_a/binary>>.




