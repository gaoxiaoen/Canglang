%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-04-06 17:14:24
%%----------------------------------------------------
-module(pt_122).
-export([read/2, write/2]).

-include("common.hrl").
-include("dungeon.hrl").
-compile(export_all).

err(1) ->"成功"; 
err(2) ->"房间不存在"; 
err(3) ->"玩家不在房间中"; 
err(4) ->"野外普通场景才能挑战"; 
err(5) ->"你已经在房间中"; 
err(6) ->"副本不存在"; 
err(7) ->"该副本今日次数已用完"; 
err(8) ->"等级不足,不能挑战"; 
err(9) ->"护送中,不能挑战"; 
err(10) ->"等级差大,不能挑战"; 
err(11) ->"房间人数已满"; 
err(12) ->"等级不足，不能加入"; 
err(13) ->"等级差大于16级,不能加入"; 
err(14) ->"护送中,不能加入"; 
err(15) ->"副本可收益次数为0，副本关闭后将退出房间"; 
err(16) ->"翻牌数据不存在"; 
err(17) ->"没有牌可翻了"; 
err(18) ->"元宝不足以支付翻牌"; 
err(19) ->"该牌不存在"; 
err(20) ->"该牌已翻"; 
err(21) ->"没有免费牌可翻"; 
err(22) ->"匹配中"; 
err(23) ->"您正处于匹配队列中无法进入"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(12201, _B0) ->
    {ok, {}};

read(12202, _B0) ->
    {P0_key, _B1} = proto:read_key(_B0),
    {ok, {P0_key}};

read(12203, _B0) ->
    {P0_dun_id, _B1} = proto:read_int32(_B0),
    {ok, {P0_dun_id}};

read(12204, _B0) ->
    {ok, {}};

read(12205, _B0) ->
    {ok, {}};

read(12206, _B0) ->
    {P0_key_list, _B3} = proto:read_array(_B0, fun(_B1) ->
        {P1_pkey, _B2} = proto:read_uint32(_B1),
        {P1_pkey, _B2}
    end),
    {ok, {P0_key_list}};

read(12207, _B0) ->
    {ok, {}};

read(12208, _B0) ->
    {P0_rkey, _B1} = proto:read_key(_B0),
    {P0_dun_id, _B2} = proto:read_int32(_B1),
    {ok, {P0_rkey, P0_dun_id}};

read(12209, _B0) ->
    {P0_rkey, _B1} = proto:read_key(_B0),
    {ok, {P0_rkey}};

read(12210, _B0) ->
    {ok, {}};

read(12211, _B0) ->
    {P0_rkey, _B1} = proto:read_key(_B0),
    {ok, {P0_rkey}};

read(12212, _B0) ->
    {ok, {}};

read(12213, _B0) ->
    {ok, {}};

read(12214, _B0) ->
    {ok, {}};

read(12215, _B0) ->
    {P0_pos, _B1} = proto:read_int8(_B0),
    {ok, {P0_pos}};

read(12216, _B0) ->
    {ok, {}};

read(12217, _B0) ->
    {P0_dun_id, _B1} = proto:read_int32(_B0),
    {ok, {P0_dun_id}};

read(12218, _B0) ->
    {ok, {}};

read(12220, _B0) ->
    {ok, {}};

read(12221, _B0) ->
    {ok, {}};

read(12222, _B0) ->
    {ok, {}};

read(12223, _B0) ->
    {ok, {}};

read(12230, _B0) ->
    {ok, {}};

read(12231, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 检查是否在组队副本房间中 
write(12201, {P0_state, P0_key}) ->
    D_a_t_a = <<P0_state:8/signed, (proto:write_string(P0_key))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12201:16,0:8, D_a_t_a/binary>>};


%% 获取个人组队副本房间信息 
write(12202, {P0_code, P0_key, P0_dun_id, P0_qmd_percent, P0_mb_list}) ->
    D_a_t_a = <<P0_code:16/signed, (proto:write_string(P0_key))/binary, P0_dun_id:32/signed, P0_qmd_percent:8/signed, (length(P0_mb_list)):16, (list_to_binary([<<P1_pkey:32, (proto:write_string(P1_name))/binary, P1_career:8/signed, P1_vip:8/signed, P1_leader:8/signed, P1_pet_type_id:32/signed, P1_power:32/signed, P1_fashion_cloth_id:32/signed, P1_light_weaponid:32/signed, P1_wing_id:32/signed, P1_clothing_id:32/signed, P1_weapon_id:32/signed, P1_petfigure:32/signed, (proto:write_string(P1_pet_name))/binary, P1_qmd:32/signed>> || [P1_pkey, P1_name, P1_career, P1_vip, P1_leader, P1_pet_type_id, P1_power, P1_fashion_cloth_id, P1_light_weaponid, P1_wing_id, P1_clothing_id, P1_weapon_id, P1_petfigure, P1_pet_name, P1_qmd] <- P0_mb_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12202:16,0:8, D_a_t_a/binary>>};


%% 挑战,进入房间 
write(12203, {P0_state, P0_key}) ->
    D_a_t_a = <<P0_state:16/signed, (proto:write_string(P0_key))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12203:16,0:8, D_a_t_a/binary>>};


%% 开始匹配,匹配离线玩家 
write(12204, {P0_state}) ->
    D_a_t_a = <<P0_state:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12204:16,0:8, D_a_t_a/binary>>};


%% 获取可邀请玩家列表 
write(12205, {P0_friend_list}) ->
    D_a_t_a = <<(length(P0_friend_list)):16, (list_to_binary([<<P1_pkey:32, (proto:write_string(P1_nickname))/binary, P1_career:8/signed, P1_vip:8/signed, P1_lv:8/signed, P1_cbp:32/signed, P1_qmd:32/signed, (proto:write_string(P1_avatar))/binary>> || [P1_pkey, P1_nickname, P1_career, P1_vip, P1_lv, P1_cbp, P1_qmd, P1_avatar] <- P0_friend_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12205:16,0:8, D_a_t_a/binary>>};


%% 邀请玩家 
write(12206, {P0_code, P0_key_list}) ->
    D_a_t_a = <<P0_code:16/signed, (length(P0_key_list)):16, (list_to_binary([<<P1_pkey:32>> || P1_pkey <- P0_key_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12206:16,0:8, D_a_t_a/binary>>};


%% 收到邀请 
write(12207, {P0_rkey, P0_dun_id, P0_name}) ->
    D_a_t_a = <<(proto:write_string(P0_rkey))/binary, P0_dun_id:32/signed, (proto:write_string(P0_name))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12207:16,0:8, D_a_t_a/binary>>};


%% 加入房间 
write(12208, {P0_code, P0_rkey}) ->
    D_a_t_a = <<P0_code:16/signed, (proto:write_string(P0_rkey))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12208:16,0:8, D_a_t_a/binary>>};


%% 退出房间 
write(12209, {P0_code}) ->
    D_a_t_a = <<P0_code:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12209:16,0:8, D_a_t_a/binary>>};


%% 通知副本开启倒计时 
write(12210, {P0_state, P0_time}) ->
    D_a_t_a = <<P0_state:8/signed, P0_time:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12210:16,0:8, D_a_t_a/binary>>};


%% 手动开启副本 
write(12211, {P0_code}) ->
    D_a_t_a = <<P0_code:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12211:16,0:8, D_a_t_a/binary>>};


%% 查询副本次数 
write(12212, {P0_double_reward_times, P0_max_double_reward_times, P0_dun_list}) ->
    D_a_t_a = <<P0_double_reward_times:8/signed, P0_max_double_reward_times:8/signed, (length(P0_dun_list)):16, (list_to_binary([<<P1_dunid:32/signed, P1_times:8/signed, P1_max_times:8/signed, P1_sweep:8/signed>> || [P1_dunid, P1_times, P1_max_times, P1_sweep] <- P0_dun_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12212:16,0:8, D_a_t_a/binary>>};


%% 获取组队副本目标 
write(12213, {P0_round, P0_max_round, P0_exp, P0_vip_exp, P0_qmd_percent, P0_qmd_exp, P0_time, P0_total_time}) ->
    D_a_t_a = <<P0_round:8/signed, P0_max_round:8/signed, P0_exp:32/signed, P0_vip_exp:32/signed, P0_qmd_percent:8/signed, P0_qmd_exp:32/signed, P0_time:16/signed, P0_total_time:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12213:16,0:8, D_a_t_a/binary>>};


%% 组队副本结算 
write(12214, {P0_dunid, P0_room_key, P0_ret, P0_score, P0_exp, P0_exp_vip, P0_exp_qmd, P0_coin, P0_time, P0_free, P0_onekey_gold, P0_double_reward_times, P0_max_double_reward_times, P0_turnover}) ->
    D_a_t_a = <<P0_dunid:32/signed, (proto:write_string(P0_room_key))/binary, P0_ret:8/signed, P0_score:8/signed, P0_exp:32/signed, P0_exp_vip:32/signed, P0_exp_qmd:32/signed, P0_coin:32/signed, P0_time:16/signed, P0_free:8/signed, P0_onekey_gold:16/signed, P0_double_reward_times:8/signed, P0_max_double_reward_times:8/signed, (length(P0_turnover)):16, (list_to_binary([<<P1_pos:8/signed, P1_goods_id:32/signed, P1_num:32/signed, P1_gold:16/signed, P1_mult:8/signed>> || [P1_pos, P1_goods_id, P1_num, P1_gold, P1_mult] <- P0_turnover]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12214:16,0:8, D_a_t_a/binary>>};


%% 组队副本翻牌 
write(12215, {P0_code, P0_free, P0_onekey_gold, P0_isDouble, P0_double_reward_times, P0_max_double_reward_times, P0_turnover}) ->
    D_a_t_a = <<P0_code:16/signed, P0_free:8/signed, P0_onekey_gold:16/signed, P0_isDouble:8/signed, P0_double_reward_times:8/signed, P0_max_double_reward_times:8/signed, (length(P0_turnover)):16, (list_to_binary([<<P1_pos:8/signed, P1_goods_id:32/signed, P1_num:32/signed, P1_gold:16/signed, P1_mult:8/signed>> || [P1_pos, P1_goods_id, P1_num, P1_gold, P1_mult] <- P0_turnover]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12215:16,0:8, D_a_t_a/binary>>};


%% 一键免费翻牌 
write(12216, {P0_code, P0_free, P0_onekey_gold, P0_turnover}) ->
    D_a_t_a = <<P0_code:16/signed, P0_free:8/signed, P0_onekey_gold:16/signed, (length(P0_turnover)):16, (list_to_binary([<<P1_pos:8/signed, P1_goods_id:32/signed, P1_num:8/signed, P1_gold:16/signed, P1_mult:8/signed>> || [P1_pos, P1_goods_id, P1_num, P1_gold, P1_mult] <- P0_turnover]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12216:16,0:8, D_a_t_a/binary>>};


%% 扫荡 
write(12217, {P0_code}) ->
    D_a_t_a = <<P0_code:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12217:16,0:8, D_a_t_a/binary>>};


%% 扫荡结果 
write(12218, {P0_dunid, P0_times, P0_ret, P0_score, P0_exp, P0_exp_vip, P0_coin, P0_time, P0_free, P0_onekey_gold, P0_double_reward_times, P0_max_double_reward_times, P0_turnover}) ->
    D_a_t_a = <<P0_dunid:32/signed, P0_times:8/signed, P0_ret:8/signed, P0_score:8/signed, P0_exp:32/signed, P0_exp_vip:32/signed, P0_coin:32/signed, P0_time:16/signed, P0_free:8/signed, P0_onekey_gold:16/signed, P0_double_reward_times:8/signed, P0_max_double_reward_times:8/signed, (length(P0_turnover)):16, (list_to_binary([<<P1_pos:8/signed, P1_goods_id:32/signed, P1_num:32/signed, P1_gold:16/signed, P1_mult:8/signed>> || [P1_pos, P1_goods_id, P1_num, P1_gold, P1_mult] <- P0_turnover]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12218:16,0:8, D_a_t_a/binary>>};


%% 王城守卫状态信息 
write(12220, {P0_state, P0_time}) ->
    D_a_t_a = <<P0_state:8/signed, P0_time:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12220:16,0:8, D_a_t_a/binary>>};


%% 怪物刷新通知 
write(12221, {P0_floor, P0_time}) ->
    D_a_t_a = <<P0_floor:8/signed, P0_time:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12221:16,0:8, D_a_t_a/binary>>};


%% 战意通知 
write(12222, {P0_buff_list}) ->
    D_a_t_a = <<(length(P0_buff_list)):16, (list_to_binary([<<P1_type:8/signed, (proto:write_string(P1_name))/binary>> || [P1_type, P1_name] <- P0_buff_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12222:16,0:8, D_a_t_a/binary>>};


%% 获取王城守卫副本目标信息 
write(12223, {P0_floor, P0_max_floor, P0_goods_list, P0_next_time, P0_leave_time, P0_buff_list}) ->
    D_a_t_a = <<P0_floor:8/signed, P0_max_floor:8/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_goods_num:32/signed>> || [P1_goods_id, P1_goods_num] <- P0_goods_list]))/binary, P0_next_time:32/signed, P0_leave_time:32/signed, (length(P0_buff_list)):16, (list_to_binary([<<P1_type:8/signed, (proto:write_string(P1_name))/binary, P1_state:8/signed>> || [P1_type, P1_name, P1_state] <- P0_buff_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12223:16,0:8, D_a_t_a/binary>>};


%% 获取妖魔入侵副本目标信息 
write(12230, {P0_floor, P0_max_floor, P0_pass_num, P0_reduce, P0_leave_time, P0_add, P0_mon_list, P0_round_exp, P0_sum_exp}) ->
    D_a_t_a = <<P0_floor:8/signed, P0_max_floor:8/signed, P0_pass_num:16/signed, P0_reduce:16/signed, P0_leave_time:32/signed, P0_add:16/signed, (length(P0_mon_list)):16, (list_to_binary([<<P1_mon_id:32/signed, P1_max_mon_num:32/signed, P1_mon_num:32/signed>> || [P1_mon_id, P1_max_mon_num, P1_mon_num] <- P0_mon_list]))/binary, P0_round_exp:32/signed, P0_sum_exp:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12230:16,0:8, D_a_t_a/binary>>};


%% 妖魔入侵副本结算 
write(12231, {P0_state, P0_goods_list}) ->
    D_a_t_a = <<P0_state:8/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12231:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



