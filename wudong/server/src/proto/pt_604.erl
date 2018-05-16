%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2018-05-11 12:41:21
%%----------------------------------------------------
-module(pt_604).
-export([read/2, write/2]).

-include("common.hrl").
-include("lucky_pool.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"矿点不存在"; 
err(3) ->"战力不足"; 
err(4) ->"此处矿点已被掠夺过度，不剩下什么资源了"; 
err(5) ->"进攻成功，未占领"; 
err(6) ->"掠夺成功"; 
err(7) ->"小偷不存在"; 
err(8) ->"战力不足，进攻失败"; 
err(9) ->"矿点未被您占领"; 
err(10) ->"未进入收获期，不可领取"; 
err(11) ->"不可进攻自身矿点"; 
err(12) ->"进攻冷却中,请稍等一会"; 
err(13) ->"今日进攻次数已用完"; 
err(14) ->"占领数量已达上限"; 
err(15) ->"今日挑战上限已满"; 
err(16) ->"仙晶不足"; 
err(17) ->"材料不足"; 
err(18) ->"攻击队列已达上限"; 
err(19) ->"对方不是您好友"; 
err(20) ->"对方不是您仙盟成员"; 
err(21) ->"今日援助已达上限"; 
err(22) ->"今日进攻援助已达上限"; 
err(23) ->"超过可援助数量"; 
err(24) ->"已经协助"; 
err(25) ->"元宝不足"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(60401, _B0) ->
    {P0_type, _B1} = proto:read_uint32(_B0),
    {P0_page, _B2} = proto:read_uint32(_B1),
    {ok, {P0_type, P0_page}};

read(60402, _B0) ->
    {ok, {}};

read(60403, _B0) ->
    {P0_type, _B1} = proto:read_uint32(_B0),
    {P0_page, _B2} = proto:read_uint32(_B1),
    {P0_id, _B3} = proto:read_int32(_B2),
    {P0_id_list, _B6} = proto:read_array(_B3, fun(_B4) ->
        {P1_id, _B5} = proto:read_uint32(_B4),
        {P1_id, _B5}
    end),
    {ok, {P0_type, P0_page, P0_id, P0_id_list}};

read(60404, _B0) ->
    {P0_type, _B1} = proto:read_uint32(_B0),
    {P0_page, _B2} = proto:read_uint32(_B1),
    {P0_id, _B3} = proto:read_int32(_B2),
    {ok, {P0_type, P0_page, P0_id}};

read(60405, _B0) ->
    {P0_type, _B1} = proto:read_uint32(_B0),
    {P0_page, _B2} = proto:read_uint32(_B1),
    {P0_id, _B3} = proto:read_int32(_B2),
    {ok, {P0_type, P0_page, P0_id}};

read(60406, _B0) ->
    {P0_type, _B1} = proto:read_uint32(_B0),
    {P0_page, _B2} = proto:read_uint32(_B1),
    {P0_id, _B3} = proto:read_int32(_B2),
    {ok, {P0_type, P0_page, P0_id}};

read(60407, _B0) ->
    {P0_type, _B1} = proto:read_uint32(_B0),
    {P0_page, _B2} = proto:read_uint32(_B1),
    {ok, {P0_type, P0_page}};

read(60408, _B0) ->
    {P0_type, _B1} = proto:read_uint32(_B0),
    {P0_page, _B2} = proto:read_uint32(_B1),
    {P0_id, _B3} = proto:read_int32(_B2),
    {ok, {P0_type, P0_page, P0_id}};

read(60409, _B0) ->
    {P0_type, _B1} = proto:read_uint32(_B0),
    {P0_page, _B2} = proto:read_uint32(_B1),
    {P0_id, _B3} = proto:read_int32(_B2),
    {ok, {P0_type, P0_page, P0_id}};

read(60410, _B0) ->
    {ok, {}};

read(60411, _B0) ->
    {ok, {}};

read(60412, _B0) ->
    {ok, {}};

read(60413, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_pkey}};

read(60414, _B0) ->
    {ok, {}};

read(60415, _B0) ->
    {ok, {}};

read(60416, _B0) ->
    {ok, {}};

read(60417, _B0) ->
    {ok, {}};

read(60418, _B0) ->
    {ok, {}};

read(60419, _B0) ->
    {P0_id, _B1} = proto:read_int32(_B0),
    {P0_type, _B2} = proto:read_int32(_B1),
    {ok, {P0_id, P0_type}};

read(60420, _B0) ->
    {P0_type, _B1} = proto:read_uint32(_B0),
    {P0_page, _B2} = proto:read_uint32(_B1),
    {P0_id, _B3} = proto:read_int32(_B2),
    {P0_pkey, _B4} = proto:read_int32(_B3),
    {ok, {P0_type, P0_page, P0_id, P0_pkey}};

read(60421, _B0) ->
    {ok, {}};

read(60422, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 获取矿洞信息 
write(60401, {P0_max_page, P0_type, P0_page, P0_next_time_h, P0_next_time_m, P0_key_list, P0_mine_list}) ->
    D_a_t_a = <<P0_max_page:32, P0_type:32, P0_page:32, P0_next_time_h:32, P0_next_time_m:32, (length(P0_key_list)):16, (list_to_binary([<<P1_pkey:32/signed>> || P1_pkey <- P0_key_list]))/binary, (length(P0_mine_list)):16, (list_to_binary([<<P1_mtype:16, P1_id:32/signed, P1_pkey:32/signed, (proto:write_string(P1_pname))/binary, (proto:write_string(P1_pguild_name))/binary, P1_hp:32, P1_meet_time:32, P1_thief_time:32, P1_is_ripe:32, P1_hold_time:32, P1_ripe_time:32, P1_is_help:32>> || [P1_mtype, P1_id, P1_pkey, P1_pname, P1_pguild_name, P1_hp, P1_meet_time, P1_thief_time, P1_is_ripe, P1_hold_time, P1_ripe_time, P1_is_help] <- P0_mine_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60401:16,0:8, D_a_t_a/binary>>};


%% 获取我的矿洞 
write(60402, {P0_att_cd, P0_my_mine_list}) ->
    D_a_t_a = <<P0_att_cd:32/signed, (length(P0_my_mine_list)):16, (list_to_binary([<<P1_mtype:16, P1_type:32/signed, P1_page:32/signed, P1_id:32/signed, P1_hold_time:32/signed, P1_is_meet:32/signed, (length(P1_goods_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32/signed>> || [P2_goods_id, P2_goods_num] <- P1_goods_list]))/binary>> || [P1_mtype, P1_type, P1_page, P1_id, P1_hold_time, P1_is_meet, P1_goods_list] <- P0_my_mine_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60402:16,0:8, D_a_t_a/binary>>};


%% 进攻矿点 
write(60403, {P0_error_code, P0_remain_hp}) ->
    D_a_t_a = <<P0_error_code:8, P0_remain_hp:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60403:16,0:8, D_a_t_a/binary>>};


%% 进攻小偷 
write(60404, {P0_error_code, P0_goods_list}) ->
    D_a_t_a = <<P0_error_code:8, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32/signed>> || [P1_goods_id, P1_goods_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60404:16,0:8, D_a_t_a/binary>>};


%% 领取奖励 
write(60405, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60405:16,0:8, D_a_t_a/binary>>};


%% 分享 
write(60406, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60406:16,0:8, D_a_t_a/binary>>};


%% 离开矿洞 
write(60407, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60407:16,0:8, D_a_t_a/binary>>};


%% 获取进攻信息 
write(60408, {P0_pkey, P0_pname, P0_psex, P0_psn, P0_pavatar, P0_cbp, P0_pguild_name, P0_hp, P0_hp_lim, P0_cbp_hp_add, P0_can_hold_time, P0_att_hp, P0_cbp_att_hp, P0_help_hp_add, P0_att_up, P0_out_put_time, P0_out_put_reward, P0_att_reward, P0_help_list}) ->
    D_a_t_a = <<P0_pkey:32/signed, (proto:write_string(P0_pname))/binary, P0_psex:32/signed, P0_psn:32/signed, (proto:write_string(P0_pavatar))/binary, (proto:write_string(P0_cbp))/binary, (proto:write_string(P0_pguild_name))/binary, P0_hp:32/signed, P0_hp_lim:32/signed, P0_cbp_hp_add:32/signed, P0_can_hold_time:32, P0_att_hp:32, P0_cbp_att_hp:32, P0_help_hp_add:32, P0_att_up:32, P0_out_put_time:32, (length(P0_out_put_reward)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32/signed>> || [P1_goods_id, P1_goods_num] <- P0_out_put_reward]))/binary, (length(P0_att_reward)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32/signed>> || [P1_goods_id, P1_goods_num] <- P0_att_reward]))/binary, (length(P0_help_list)):16, (list_to_binary([<<P1_pkey:32/signed, (proto:write_string(P1_pname))/binary, P1_psex:32/signed, (proto:write_string(P1_pavatar))/binary, P1_cbp:32/signed>> || [P1_pkey, P1_pname, P1_psex, P1_pavatar, P1_cbp] <- P0_help_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60408:16,0:8, D_a_t_a/binary>>};


%% 矿点信息刷新 
write(60409, {P0_type, P0_page, P0_mtype, P0_id, P0_pkey, P0_pname, P0_pguild_name, P0_hp, P0_meet_time, P0_thief_time, P0_is_ripe, P0_hold_time, P0_ripe_time, P0_is_help}) ->
    D_a_t_a = <<P0_type:32, P0_page:32, P0_mtype:16, P0_id:32/signed, P0_pkey:32/signed, (proto:write_string(P0_pname))/binary, (proto:write_string(P0_pguild_name))/binary, P0_hp:32, P0_meet_time:32, P0_thief_time:32, P0_is_ripe:32, P0_hold_time:32, P0_ripe_time:32, P0_is_help:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60409:16,0:8, D_a_t_a/binary>>};


%% 获取个人日志 
write(60410, {P0_meet_count, P0_meet_limit, P0_thief_count, P0_thief_limit, P0_event_list, P0_att_list, P0_def_list}) ->
    D_a_t_a = <<P0_meet_count:32/signed, P0_meet_limit:32/signed, P0_thief_count:32/signed, P0_thief_limit:32/signed, (length(P0_event_list)):16, (list_to_binary([<<P1_event_type:32, P1_pkey:32, (proto:write_string(P1_pname))/binary, P1_type:32, P1_page:32, P1_id:32/signed, P1_mtype:16, P1_time:32/signed, (length(P1_reward_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32/signed>> || [P2_goods_id, P2_goods_num] <- P1_reward_list]))/binary>> || [P1_event_type, P1_pkey, P1_pname, P1_type, P1_page, P1_id, P1_mtype, P1_time, P1_reward_list] <- P0_event_list]))/binary, (length(P0_att_list)):16, (list_to_binary([<<P1_pkey:32, (proto:write_string(P1_pname))/binary, P1_type:32, P1_page:32, P1_id:32/signed, P1_state:32/signed, P1_time:32/signed, (length(P1_reward_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32/signed>> || [P2_goods_id, P2_goods_num] <- P1_reward_list]))/binary>> || [P1_pkey, P1_pname, P1_type, P1_page, P1_id, P1_state, P1_time, P1_reward_list] <- P0_att_list]))/binary, (length(P0_def_list)):16, (list_to_binary([<<P1_pkey:32, (proto:write_string(P1_pname))/binary, P1_type:32, P1_page:32, P1_id:32/signed, P1_state:32/signed, P1_time:32/signed, (length(P1_reward_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32/signed>> || [P2_goods_id, P2_goods_num] <- P1_reward_list]))/binary>> || [P1_pkey, P1_pname, P1_type, P1_page, P1_id, P1_state, P1_time, P1_reward_list] <- P0_def_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60410:16,0:8, D_a_t_a/binary>>};


%% 矿洞刷新 
write(60411, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60411:16,0:8, D_a_t_a/binary>>};


%% 矿点成熟推送 
write(60412, {P0_type, P0_page, P0_id}) ->
    D_a_t_a = <<P0_type:32, P0_page:32, P0_id:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60412:16,0:8, D_a_t_a/binary>>};


%% 获取其他玩家矿点列表 
write(60413, {P0_mine_list}) ->
    D_a_t_a = <<(length(P0_mine_list)):16, (list_to_binary([<<P1_mtype:16, P1_type:32/signed, P1_page:32/signed, P1_id:32/signed>> || [P1_mtype, P1_type, P1_page, P1_id] <- P0_mine_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60413:16,0:8, D_a_t_a/binary>>};


%% 获取全服日志 
write(60414, {P0_event_list, P0_def_list}) ->
    D_a_t_a = <<(length(P0_event_list)):16, (list_to_binary([<<P1_event_type:32, P1_pkey:32, (proto:write_string(P1_pname))/binary, P1_type:32, P1_page:32, P1_id:32/signed, P1_mtype:16, P1_time:32/signed, (length(P1_reward_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32/signed>> || [P2_goods_id, P2_goods_num] <- P1_reward_list]))/binary>> || [P1_event_type, P1_pkey, P1_pname, P1_type, P1_page, P1_id, P1_mtype, P1_time, P1_reward_list] <- P0_event_list]))/binary, (length(P0_def_list)):16, (list_to_binary([<<P1_pkey:32, (proto:write_string(P1_pname))/binary, P1_type:32, P1_page:32, P1_id:32/signed, P1_state:32/signed, P1_time:32/signed, (length(P1_reward_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32/signed>> || [P2_goods_id, P2_goods_num] <- P1_reward_list]))/binary>> || [P1_pkey, P1_pname, P1_type, P1_page, P1_id, P1_state, P1_time, P1_reward_list] <- P0_def_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60414:16,0:8, D_a_t_a/binary>>};


%% 全服日志刷新 
write(60415, {P0_event_type, P0_pkey, P0_pname, P0_type, P0_page, P0_id, P0_mtype, P0_time, P0_reward_list}) ->
    D_a_t_a = <<P0_event_type:32, P0_pkey:32, (proto:write_string(P0_pname))/binary, P0_type:32, P0_page:32, P0_id:32/signed, P0_mtype:16, P0_time:32/signed, (length(P0_reward_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32/signed>> || [P1_goods_id, P1_goods_num] <- P0_reward_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60415:16,0:8, D_a_t_a/binary>>};


%% 防御日志刷新 
write(60416, {P0_pkey, P0_pname, P0_type, P0_page, P0_id, P0_state, P0_time, P0_reward_list}) ->
    D_a_t_a = <<P0_pkey:32, (proto:write_string(P0_pname))/binary, P0_type:32, P0_page:32, P0_id:32/signed, P0_state:32/signed, P0_time:32/signed, (length(P0_reward_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32/signed>> || [P1_goods_id, P1_goods_num] <- P0_reward_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60416:16,0:8, D_a_t_a/binary>>};


%% 获取排行信息 
write(60417, {P0_my_rank, P0_my_score, P0_next_time, P0_info_list}) ->
    D_a_t_a = <<P0_my_rank:32, P0_my_score:32, P0_next_time:32, (length(P0_info_list)):16, (list_to_binary([<<P1_pkey:32, P1_sn:32, (proto:write_string(P1_pname))/binary, P1_cbp:32, P1_score:32, P1_vip:32, P1_dvip:32>> || [P1_pkey, P1_sn, P1_pname, P1_cbp, P1_score, P1_vip, P1_dvip] <- P0_info_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60417:16,0:8, D_a_t_a/binary>>};


%% 获取进攻援助信息 
write(60418, {P0_att_num, P0_att_limit, P0_reset_cost, P0_help_count, P0_help_count_all, P0_cbp_ratio, P0_my_help_list, P0_help_list}) ->
    D_a_t_a = <<P0_att_num:32/signed, P0_att_limit:32/signed, P0_reset_cost:32/signed, P0_help_count:32/signed, P0_help_count_all:32/signed, P0_cbp_ratio:32/signed, (length(P0_my_help_list)):16, (list_to_binary([<<P1_id:32/signed, P1_pkey:32/signed, (proto:write_string(P1_pname))/binary, P1_psex:32/signed, P1_vip:32/signed, P1_dvip:32/signed, (proto:write_string(P1_pavatar))/binary, P1_cbp:32/signed>> || [P1_id, P1_pkey, P1_pname, P1_psex, P1_vip, P1_dvip, P1_pavatar, P1_cbp] <- P0_my_help_list]))/binary, (length(P0_help_list)):16, (list_to_binary([<<P1_id:32/signed, P1_pkey:32/signed, (proto:write_string(P1_pname))/binary, P1_psex:32/signed, P1_vip:32/signed, P1_dvip:32/signed, (proto:write_string(P1_pavatar))/binary, P1_cbp:32/signed, P1_goods_cost:32/signed, P1_cost:32/signed>> || [P1_id, P1_pkey, P1_pname, P1_psex, P1_vip, P1_dvip, P1_pavatar, P1_cbp, P1_goods_cost, P1_cost] <- P0_help_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60418:16,0:8, D_a_t_a/binary>>};


%% 购买镜像 
write(60419, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60419:16,0:8, D_a_t_a/binary>>};


%% 援助矿点 
write(60420, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60420:16,0:8, D_a_t_a/binary>>};


%% 排行榜奖励 
write(60421, {P0_rank_list}) ->
    D_a_t_a = <<(length(P0_rank_list)):16, (list_to_binary([<<P1_top:32/signed, P1_down:32/signed, (length(P1_goods_list)):16, (list_to_binary([<<P2_goods_id:32/signed, P2_goods_num:32/signed>> || [P2_goods_id, P2_goods_num] <- P1_goods_list]))/binary>> || [P1_top, P1_down, P1_goods_list] <- P0_rank_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60421:16,0:8, D_a_t_a/binary>>};


%% 刷新援助列表 
write(60422, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60422:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



