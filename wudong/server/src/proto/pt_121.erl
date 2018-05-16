%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-11-09 11:50:24
%%----------------------------------------------------
-module(pt_121).
-export([read/2, write/2]).

-include("common.hrl").
-include("dungeon.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"副本不存在"; 
err(3) ->"今日还没挑战过该副本"; 
err(4) ->"等级不足,副本未开放"; 
err(5) ->"有可扫荡次数,无需重置"; 
err(6) ->"今日副本次数已用完"; 
err(7) ->"会员等级不足"; 
err(8) ->"元宝不足"; 
err(9) ->"没有扫荡次数"; 
err(10) ->"没有波数可扫荡"; 
err(11) ->"奖励不存在"; 
err(12) ->"奖励未达成"; 
err(13) ->"奖励已领取"; 
err(14) ->"副本中,不能扫荡"; 
err(15) ->"没有副本可扫荡"; 
err(16) ->"没有层数可扫荡"; 
err(17) ->"永久钻石VIP才能一键扫荡"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(12101, _B0) ->
    {ok, {}};

read(12120, _B0) ->
    {P0_page, _B1} = proto:read_int8(_B0),
    {ok, {P0_page}};

read(12121, _B0) ->
    {ok, {}};

read(12122, _B0) ->
    {ok, {}};

read(12123, _B0) ->
    {ok, {}};

read(12124, _B0) ->
    {ok, {}};

read(12130, _B0) ->
    {ok, {}};

read(12131, _B0) ->
    {ok, {}};

read(12132, _B0) ->
    {ok, {}};

read(12133, _B0) ->
    {ok, {}};

read(12140, _B0) ->
    {P0_type, _B1} = proto:read_int8(_B0),
    {ok, {P0_type}};

read(12141, _B0) ->
    {P0_type, _B1} = proto:read_int8(_B0),
    {ok, {P0_type}};

read(12142, _B0) ->
    {ok, {}};

read(12143, _B0) ->
    {ok, {}};

read(12150, _B0) ->
    {ok, {}};

read(12151, _B0) ->
    {ok, {}};

read(12152, _B0) ->
    {ok, {}};

read(12153, _B0) ->
    {ok, {}};

read(12160, _B0) ->
    {ok, {}};

read(12161, _B0) ->
    {ok, {}};

read(12162, _B0) ->
    {ok, {}};

read(12163, _B0) ->
    {ok, {}};

read(12164, _B0) ->
    {ok, {}};

read(12165, _B0) ->
    {P0_dun_id, _B1} = proto:read_int32(_B0),
    {ok, {P0_dun_id}};

read(12170, _B0) ->
    {ok, {}};

read(12171, _B0) ->
    {ok, {}};

read(12172, _B0) ->
    {ok, {}};

read(12173, _B0) ->
    {P0_dun_id, _B1} = proto:read_int32(_B0),
    {ok, {P0_dun_id}};

read(12174, _B0) ->
    {P0_dun_id, _B1} = proto:read_int32(_B0),
    {ok, {P0_dun_id}};

read(12175, _B0) ->
    {P0_sweep, _B1} = proto:read_int16(_B0),
    {ok, {P0_sweep}};

read(12176, _B0) ->
    {ok, {}};

read(12180, _B0) ->
    {ok, {}};

read(12181, _B0) ->
    {ok, {}};

read(12182, _B0) ->
    {P0_pass_floor, _B1} = proto:read_uint8(_B0),
    {ok, {P0_pass_floor}};

read(12183, _B0) ->
    {ok, {}};

read(12184, _B0) ->
    {ok, {}};

read(12185, _B0) ->
    {ok, {}};

read(12186, _B0) ->
    {ok, {}};

read(12187, _B0) ->
    {ok, {}};

read(12190, _B0) ->
    {ok, {}};

read(12191, _B0) ->
    {ok, {}};

read(12192, _B0) ->
    {ok, {}};

read(12193, _B0) ->
    {ok, {}};

read(12194, _B0) ->
    {P0_dun_id, _B1} = proto:read_int32(_B0),
    {ok, {P0_dun_id}};

read(12195, _B0) ->
    {ok, {}};

read(12196, _B0) ->
    {ok, {}};

read(12197, _B0) ->
    {ok, {}};

read(12198, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 退出副本 
write(12101, {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12101:16,0:8, D_a_t_a/binary>>};


%% 九霄塔副本信息  
write(12120, {P0_now_page, P0_max_page, P0_sweep_layer, P0_dun_list}) ->
    D_a_t_a = <<P0_now_page:8/signed, P0_max_page:8/signed, P0_sweep_layer:16/signed, (length(P0_dun_list)):16, (list_to_binary([<<P1_layer:16/signed, P1_dun_id:32/signed, P1_state:8/signed, P1_star:8/signed, P1_is_sweep:8/signed>> || [P1_layer, P1_dun_id, P1_state, P1_star, P1_is_sweep] <- P0_dun_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12120:16,0:8, D_a_t_a/binary>>};


%% 九霄塔副本排行榜  
write(12121, {P0_rank_list}) ->
    D_a_t_a = <<(length(P0_rank_list)):16, (list_to_binary([<<P1_pkey:32, (proto:write_string(P1_nickname))/binary, P1_layer:16/signed, P1_use_time:16/signed>> || [P1_pkey, P1_nickname, P1_layer, P1_use_time] <- P0_rank_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12121:16,0:8, D_a_t_a/binary>>};


%% 九霄塔副本扫荡  
write(12122, {P0_code, P0_layer, P0_goods_list}) ->
    D_a_t_a = <<P0_code:8/signed, P0_layer:16/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12122:16,0:8, D_a_t_a/binary>>};


%% 活动副本目标 
write(12123, {P0_layer, P0_time}) ->
    D_a_t_a = <<P0_layer:16/signed, P0_time:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12123:16,0:8, D_a_t_a/binary>>};


%% 九霄塔副本结算 
write(12124, {P0_ret, P0_dun_id, P0_star, P0_goods_list}) ->
    D_a_t_a = <<P0_ret:8/signed, P0_dun_id:32/signed, P0_star:16/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12124:16,0:8, D_a_t_a/binary>>};


%% 经验副本信息 
write(12130, {P0_round, P0_max_round, P0_dun_list}) ->
    D_a_t_a = <<P0_round:16/signed, P0_max_round:16/signed, (length(P0_dun_list)):16, (list_to_binary([<<P1_dun_id:32/signed, P1_round_min:16/signed, P1_round_max:16/signed, P1_state:16/signed>> || [P1_dun_id, P1_round_min, P1_round_max, P1_state] <- P0_dun_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12130:16,0:8, D_a_t_a/binary>>};


%% 经验副本扫荡 
write(12131, {P0_code, P0_goods_list}) ->
    D_a_t_a = <<P0_code:16/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12131:16,0:8, D_a_t_a/binary>>};


%% 经验副本目标 
write(12132, {P0_time, P0_round, P0_max_round, P0_exp}) ->
    D_a_t_a = <<P0_time:16/signed, P0_round:16/signed, P0_max_round:16/signed, P0_exp:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12132:16,0:8, D_a_t_a/binary>>};


%% 经验副本结算 
write(12133, {P0_dun_id, P0_round, P0_goods_list}) ->
    D_a_t_a = <<P0_dun_id:32/signed, P0_round:16/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12133:16,0:8, D_a_t_a/binary>>};


%% 每日副本.剧情,神器,灵脉,仙器 
write(12140, {P0_sweep, P0_dun_list}) ->
    D_a_t_a = <<P0_sweep:8/signed, (length(P0_dun_list)):16, (list_to_binary([<<P1_dun_id:32/signed, P1_state:8/signed, P1_pass_state:8/signed>> || [P1_dun_id, P1_state, P1_pass_state] <- P0_dun_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12140:16,0:8, D_a_t_a/binary>>};


%% 副本扫荡 
write(12141, {P0_code, P0_list}) ->
    D_a_t_a = <<P0_code:16/signed, (length(P0_list)):16, (list_to_binary([<<P1_dun_id:32/signed, (length(P1_goods_list)):16, (list_to_binary([<<P2_goods_id:32/signed, P2_num:32/signed, P2_state:32/signed>> || [P2_goods_id, P2_num, P2_state] <- P1_goods_list]))/binary>> || [P1_dun_id, P1_goods_list] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12141:16,0:8, D_a_t_a/binary>>};


%% 副本目标 
write(12142, {P0_time, P0_is_pass}) ->
    D_a_t_a = <<P0_time:16/signed, P0_is_pass:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12142:16,0:8, D_a_t_a/binary>>};


%% 副本结算 
write(12143, {P0_ret, P0_dun_id, P0_goods_list}) ->
    D_a_t_a = <<P0_ret:8/signed, P0_dun_id:32/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed, P1_state:32/signed>> || [P1_goods_id, P1_num, P1_state] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12143:16,0:8, D_a_t_a/binary>>};


%% 获取神器副本信息,副本挑战走12005 
write(12150, {P0_cur_layer, P0_cur_round, P0_h_layer, P0_h_round, P0_is_sweep, P0_dun_list}) ->
    D_a_t_a = <<P0_cur_layer:8/signed, P0_cur_round:8/signed, P0_h_layer:8/signed, P0_h_round:8/signed, P0_is_sweep:8/signed, (length(P0_dun_list)):16, (list_to_binary([<<P1_layer:8/signed, P1_dun_id:32/signed>> || [P1_layer, P1_dun_id] <- P0_dun_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12150:16,0:8, D_a_t_a/binary>>};


%% 神器副本目标 
write(12151, {P0_time, P0_round, P0_max_round, P0_is_first, P0_mon_list}) ->
    D_a_t_a = <<P0_time:16/signed, P0_round:16/signed, P0_max_round:16/signed, P0_is_first:8/signed, (length(P0_mon_list)):16, (list_to_binary([<<P1_mid:32/signed, P1_need_num:32/signed, P1_cur_num:32/signed>> || [P1_mid, P1_need_num, P1_cur_num] <- P0_mon_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12151:16,0:8, D_a_t_a/binary>>};


%% 神器副本结算 
write(12152, {P0_dun_id, P0_next_dun_id, P0_goods_list}) ->
    D_a_t_a = <<P0_dun_id:32/signed, P0_next_dun_id:32/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12152:16,0:8, D_a_t_a/binary>>};


%% 神器副本扫荡 
write(12153, {P0_code, P0_goods_list}) ->
    D_a_t_a = <<P0_code:16/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12153:16,0:8, D_a_t_a/binary>>};


%% 主线副本目标 
write(12160, {P0_target_list, P0_time}) ->
    D_a_t_a = <<(length(P0_target_list)):16, (list_to_binary([<<(proto:write_string(P1_name))/binary, P1_cur_kill:16/signed, P1_need_kill:16/signed>> || [P1_name, P1_cur_kill, P1_need_kill] <- P0_target_list]))/binary, P0_time:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12160:16,0:8, D_a_t_a/binary>>};


%% 主线副本结算 
write(12161, {P0_ret, P0_exp, P0_coin, P0_goods_list}) ->
    D_a_t_a = <<P0_ret:8/signed, P0_exp:32/signed, P0_coin:16/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12161:16,0:8, D_a_t_a/binary>>};


%% vip副本信息 
write(12162, {P0_dun_list}) ->
    D_a_t_a = <<(length(P0_dun_list)):16, (list_to_binary([<<P1_dun_id:32/signed, P1_vip_lv:16/signed, P1_count:16/signed, P1_state:16/signed>> || [P1_dun_id, P1_vip_lv, P1_count, P1_state] <- P0_dun_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12162:16,0:8, D_a_t_a/binary>>};


%% vip副本结算 
write(12163, {P0_ret, P0_dun_id, P0_goods_list}) ->
    D_a_t_a = <<P0_ret:8/signed, P0_dun_id:32/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed, P1_state:32/signed>> || [P1_goods_id, P1_num, P1_state] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12163:16,0:8, D_a_t_a/binary>>};


%% vip副本目标 
write(12164, {P0_time, P0_target_list}) ->
    D_a_t_a = <<P0_time:16/signed, (length(P0_target_list)):16, (list_to_binary([<<(proto:write_string(P1_name))/binary, P1_cur_kill:16/signed, P1_need_kill:16/signed>> || [P1_name, P1_cur_kill, P1_need_kill] <- P0_target_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12164:16,0:8, D_a_t_a/binary>>};


%% vip副本扫荡 
write(12165, {P0_code, P0_goods_list}) ->
    D_a_t_a = <<P0_code:16/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed, P1_state:32/signed>> || [P1_goods_id, P1_num, P1_state] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12165:16,0:8, D_a_t_a/binary>>};

%% 材料副本次数 
write(12170, {P0_dungeon_list}) ->
    D_a_t_a = <<(length(P0_dungeon_list)):16, (list_to_binary([<<P1_dun_id:32/signed, P1_times:8/signed, P1_max_times:8/signed, P1_state:8/signed, P1_is_first:8/signed, P1_gold:8/signed>> || [P1_dun_id, P1_times, P1_max_times, P1_state, P1_is_first, P1_gold] <- P0_dungeon_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12170:16,0:8, D_a_t_a/binary>>};


%% 材料副本目标 
write(12171, {P0_time, P0_is_first}) ->
    D_a_t_a = <<P0_time:16/signed, P0_is_first:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12171:16,0:8, D_a_t_a/binary>>};


%% 材料副本结算 
write(12172, {P0_ret, P0_dun_id, P0_goods_list}) ->
    D_a_t_a = <<P0_ret:8/signed, P0_dun_id:32/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed, P1_state:32/signed>> || [P1_goods_id, P1_num, P1_state] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12172:16,0:8, D_a_t_a/binary>>};


%% 材料副本重置 
write(12173, {P0_code}) ->
    D_a_t_a = <<P0_code:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12173:16,0:8, D_a_t_a/binary>>};


%% 材料副本扫荡 
write(12174, {P0_code, P0_goods_list}) ->
    D_a_t_a = <<P0_code:16/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed, P1_state:32/signed>> || [P1_goods_id, P1_num, P1_state] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12174:16,0:8, D_a_t_a/binary>>};


%% 一键扫荡 
write(12175, {P0_code, P0_goods_list}) ->
    D_a_t_a = <<P0_code:16/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed, P1_state:32/signed>> || [P1_goods_id, P1_num, P1_state] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12175:16,0:8, D_a_t_a/binary>>};


%% 扫荡信息 
write(12176, {P0_free_time, P0_free_cost, P0_goods_list, P0_all_time, P0_all_cost, P0_goods_list2}) ->
    D_a_t_a = <<P0_free_time:16/signed, P0_free_cost:16/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed, P1_state:32/signed>> || [P1_goods_id, P1_num, P1_state] <- P0_goods_list]))/binary, P0_all_time:16/signed, P0_all_cost:16/signed, (length(P0_goods_list2)):16, (list_to_binary([<<P1_goods_id2:32/signed, P1_num_2:32/signed, P1_state:32/signed>> || [P1_goods_id2, P1_num_2, P1_state] <- P0_goods_list2]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12176:16,0:8, D_a_t_a/binary>>};


%% 获取守护副本目标 
write(12180, {P0_myfloor, P0_last_floor, P0_next_floor, P0_index_floor, P0_state, P0_daily_goods_list, P0_floor, P0_first_goods_list, P0_myrank, P0_rank_list}) ->
    D_a_t_a = <<P0_myfloor:8, P0_last_floor:8, P0_next_floor:8, P0_index_floor:8, P0_state:8, (length(P0_daily_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_daily_goods_list]))/binary, P0_floor:8, (length(P0_first_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_first_goods_list]))/binary, P0_myrank:16/signed, (length(P0_rank_list)):16, (list_to_binary([<<P1_rank:32/signed, P1_pkey:32, (proto:write_string(P1_name))/binary, P1_floor:8>> || [P1_rank, P1_pkey, P1_name, P1_floor] <- P0_rank_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12180:16,0:8, D_a_t_a/binary>>};


%% 守护副本目标 
write(12181, {P0_round, P0_mon_count, P0_end_time, P0_last_time, P0_goods_list}) ->
    D_a_t_a = <<P0_round:8/signed, P0_mon_count:16/signed, P0_end_time:16/signed, P0_last_time:16/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12181:16,0:8, D_a_t_a/binary>>};


%% 领取奖励 
write(12182, {P0_res, P0_pass_floor}) ->
    D_a_t_a = <<P0_res:8/signed, P0_pass_floor:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12182:16,0:8, D_a_t_a/binary>>};


%% 重置 
write(12183, {P0_res}) ->
    D_a_t_a = <<P0_res:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12183:16,0:8, D_a_t_a/binary>>};


%% 守护副本结算 
write(12184, {P0_ret, P0_floor, P0_goods_list}) ->
    D_a_t_a = <<P0_ret:8, P0_floor:32/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12184:16,0:8, D_a_t_a/binary>>};


%% 守护副本扫荡 
write(12185, {P0_res, P0_floor, P0_goods_list}) ->
    D_a_t_a = <<P0_res:8/signed, P0_floor:8/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12185:16,0:8, D_a_t_a/binary>>};


%% 一键领取 
write(12186, {P0_res}) ->
    D_a_t_a = <<P0_res:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12186:16,0:8, D_a_t_a/binary>>};


%% 技能信息 
write(12187, {P0_skill_list}) ->
    D_a_t_a = <<(length(P0_skill_list)):16, (list_to_binary([<<P1_skillid:32/signed, P1_num:8/signed, P1_cd_time:32/signed>> || [P1_skillid, P1_num, P1_cd_time] <- P0_skill_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12187:16,0:8, D_a_t_a/binary>>};


%% 单人boss副本挑战列表 
write(12190, {P0_double_times, P0_max_double_times, P0_dungeon_list}) ->
    D_a_t_a = <<P0_double_times:8/signed, P0_max_double_times:8/signed, (length(P0_dungeon_list)):16, (list_to_binary([<<P1_hard:8/signed, P1_dun_id:32/signed, P1_mid:32/signed, P1_cd:32/signed, P1_gold:32/signed, P1_times:8/signed, P1_times_lim:8/signed>> || [P1_hard, P1_dun_id, P1_mid, P1_cd, P1_gold, P1_times, P1_times_lim] <- P0_dungeon_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12190:16,0:8, D_a_t_a/binary>>};


%% 单人boss副本目标 
write(12191, {P0_time, P0_target_list}) ->
    D_a_t_a = <<P0_time:16/signed, (length(P0_target_list)):16, (list_to_binary([<<(proto:write_string(P1_name))/binary, P1_cur_kill:16/signed, P1_need_kill:16/signed>> || [P1_name, P1_cur_kill, P1_need_kill] <- P0_target_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12191:16,0:8, D_a_t_a/binary>>};


%% 单人boss副本结算 
write(12192, {P0_ret, P0_dun_id, P0_use_time, P0_double_times, P0_max_double_times, P0_double_gold, P0_goods_list}) ->
    D_a_t_a = <<P0_ret:8/signed, P0_dun_id:32/signed, P0_use_time:16/signed, P0_double_times:8/signed, P0_max_double_times:8/signed, P0_double_gold:32/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12192:16,0:8, D_a_t_a/binary>>};


%% 领取单人boss双倍奖励 
write(12193, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12193:16,0:8, D_a_t_a/binary>>};


%% 清除单人boss挑战CD 
write(12194, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12194:16,0:8, D_a_t_a/binary>>};


%% 守护副本公告推送 
write(12195, {P0_notice_list}) ->
    D_a_t_a = <<(length(P0_notice_list)):16, (list_to_binary([<<P1_mon_id:32/signed, P1_way:32/signed>> || [P1_mon_id, P1_way] <- P0_notice_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12195:16,0:8, D_a_t_a/binary>>};


%% 守护副本无怪推送 
write(12196, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12196:16,0:8, D_a_t_a/binary>>};


%% 转职副本结算 
write(12197, {P0_ret, P0_dun_id, P0_goods_list}) ->
    D_a_t_a = <<P0_ret:8/signed, P0_dun_id:32/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed, P1_state:32/signed>> || [P1_goods_id, P1_num, P1_state] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12197:16,0:8, D_a_t_a/binary>>};


%% 转职副本目标 
write(12198, {P0_time, P0_target_list}) ->
    D_a_t_a = <<P0_time:16/signed, (length(P0_target_list)):16, (list_to_binary([<<(proto:write_string(P1_name))/binary, P1_cur_kill:16/signed, P1_need_kill:16/signed>> || [P1_name, P1_cur_kill, P1_need_kill] <- P0_target_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12198:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



