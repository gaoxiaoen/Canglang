%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-11-10 14:22:41
%%----------------------------------------------------
-module(pt_585).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"已拥有战队"; 
err(3) ->"已有战队取该名字"; 
err(4) ->"绑定元宝不足"; 
err(5) ->"战队不存在"; 
err(6) ->"该战队可申请名额已满"; 
err(7) ->"已经申请加入该战队"; 
err(8) ->"跨服战队不可申请"; 
err(9) ->"战队人数已满"; 
err(10) ->"该玩家没有申请你所在的战队"; 
err(11) ->"%s不在野外场景,不能匹配"; 
err(12) ->"%s正在匹配中"; 
err(13) ->"战队名字长度不符合"; 
err(14) ->"战队名字含有非法字符"; 
err(15) ->"该玩家已经加入了其他战队"; 
err(16) ->"审批参数错误"; 
err(17) ->"玩家不在线"; 
err(18) ->"玩家已拥有战队"; 
err(19) ->"该玩家和您不在同一战队"; 
err(20) ->"您不是战队队长"; 
err(21) ->"未加入战队"; 
err(22) ->"护送中"; 
err(23) ->"您正处于匹配队列中"; 
err(24) ->"巡游中 "; 
err(25) ->"野外场景才能参加"; 
err(26) ->"%s不在线,不能匹配"; 
err(27) ->"战队人数不足"; 
err(28) ->"活动未开启"; 
err(29) ->"活动期间不可操作"; 
err(30) ->"开服三天后才可参加"; 
err(31) ->"	%s 离线，精英赛匹配取消"; 
err(32) ->"今日申请次数不足"; 
err(33) ->"对方等级不足"; 
err(34) ->"此比赛轮空不可投注"; 
err(35) ->"已经下注该场比赛"; 
err(36) ->"银币不足"; 
err(37) ->"已超过投注时间"; 
err(38) ->"赛程不存在"; 
err(122) ->"权限不足"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(58501, _B0) ->
    {ok, {}};

read(58502, _B0) ->
    {ok, {}};

read(58503, _B0) ->
    {ok, {}};

read(58504, _B0) ->
    {P0_name, _B1} = proto:read_string(_B0),
    {ok, {P0_name}};

read(58505, _B0) ->
    {P0_type, _B1} = proto:read_uint32(_B0),
    {ok, {P0_type}};

read(58506, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_pkey}};

read(58507, _B0) ->
    {ok, {}};

read(58508, _B0) ->
    {P0_wtkey, _B1} = proto:read_key(_B0),
    {P0_type, _B2} = proto:read_uint8(_B1),
    {ok, {P0_wtkey, P0_type}};

read(58509, _B0) ->
    {ok, {}};

read(58510, _B0) ->
    {P0_page, _B1} = proto:read_int8(_B0),
    {ok, {P0_page}};

read(58511, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {P0_ret, _B2} = proto:read_int8(_B1),
    {ok, {P0_pkey, P0_ret}};

read(58512, _B0) ->
    {ok, {}};

read(58513, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_pkey}};

read(58514, _B0) ->
    {P0_wtkey, _B1} = proto:read_key(_B0),
    {ok, {P0_wtkey}};

read(58515, _B0) ->
    {ok, {}};

read(58516, _B0) ->
    {ok, {}};

read(58517, _B0) ->
    {ok, {}};

read(58518, _B0) ->
    {P0_page, _B1} = proto:read_int8(_B0),
    {P0_type, _B2} = proto:read_uint8(_B1),
    {ok, {P0_page, P0_type}};

read(58519, _B0) ->
    {ok, {}};

read(58520, _B0) ->
    {ok, {}};

read(58521, _B0) ->
    {P0_mkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_mkey}};

read(58522, _B0) ->
    {ok, {}};

read(58523, _B0) ->
    {ok, {}};

read(58524, _B0) ->
    {ok, {}};

read(58525, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {ok, {P0_type}};

read(58526, _B0) ->
    {ok, {}};

read(58528, _B0) ->
    {ok, {}};

read(58529, _B0) ->
    {ok, {}};

read(58530, _B0) ->
    {ok, {}};

read(58531, _B0) ->
    {ok, {}};

read(58532, _B0) ->
    {ok, {}};

read(58533, _B0) ->
    {ok, {}};

read(58534, _B0) ->
    {ok, {}};

read(58535, _B0) ->
    {P0_id, _B1} = proto:read_int32(_B0),
    {ok, {P0_id}};

read(58536, _B0) ->
    {P0_id, _B1} = proto:read_int32(_B0),
    {P0_wtkey, _B2} = proto:read_key(_B1),
    {P0_bet_id, _B3} = proto:read_int32(_B2),
    {ok, {P0_id, P0_wtkey, P0_bet_id}};

read(58537, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 活动状态 
write(58501, {P0_state, P0_time}) ->
    D_a_t_a = <<P0_state:8, P0_time:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58501:16,0:8, D_a_t_a/binary>>};


%% 获取精英赛页面信息 
write(58502, {P0_state, P0_wtkey, P0_name, P0_score, P0_team_rank, P0_win, P0_lose, P0_list}) ->
    D_a_t_a = <<P0_state:8, (proto:write_string(P0_wtkey))/binary, (proto:write_string(P0_name))/binary, P0_score:32, P0_team_rank:32, P0_win:16, P0_lose:16, (length(P0_list)):16, (list_to_binary([<<P1_pkey:32, P1_position:32, (proto:write_string(P1_nickname))/binary, P1_career:8/signed, P1_sex:8/signed, (proto:write_string(P1_avatar))/binary, P1_war_count:16/signed, P1_att_all:32/signed, P1_der_all:32/signed, P1_rank:32/signed, P1_role:16/signed, P1_wing_id:32, P1_wepon_id:32, P1_clothing_id:32, P1_light_wepon_id:32, P1_fashion_cloth_id:32, P1_fashion_head_id:32/signed>> || [P1_pkey, P1_position, P1_nickname, P1_career, P1_sex, P1_avatar, P1_war_count, P1_att_all, P1_der_all, P1_rank, P1_role, P1_wing_id, P1_wepon_id, P1_clothing_id, P1_light_wepon_id, P1_fashion_cloth_id, P1_fashion_head_id] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58502:16,0:8, D_a_t_a/binary>>};


%% 获取战队创建信息 
write(58503, {P0_cost}) ->
    D_a_t_a = <<P0_cost:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58503:16,0:8, D_a_t_a/binary>>};


%% 创建战队 
write(58504, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58504:16,0:8, D_a_t_a/binary>>};


%% 获取可邀请列表 
write(58505, {P0_list}) ->
    D_a_t_a = <<(length(P0_list)):16, (list_to_binary([<<P1_pkey:32, (proto:write_string(P1_nickname))/binary, P1_rank:32/signed>> || [P1_pkey, P1_nickname, P1_rank] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58505:16,0:8, D_a_t_a/binary>>};


%% 邀请加入战队 
write(58506, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58506:16,0:8, D_a_t_a/binary>>};


%% 收到战队邀请 
write(58507, {P0_nickname, P0_wt_name, P0_wtkey}) ->
    D_a_t_a = <<(proto:write_string(P0_nickname))/binary, (proto:write_string(P0_wt_name))/binary, (proto:write_string(P0_wtkey))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58507:16,0:8, D_a_t_a/binary>>};


%% 战队邀请回应 
write(58508, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58508:16,0:8, D_a_t_a/binary>>};


%% 战队成员变更 
write(58509, {P0_nickname, P0_type}) ->
    D_a_t_a = <<(proto:write_string(P0_nickname))/binary, P0_type:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58509:16,0:8, D_a_t_a/binary>>};


%% 获取战队申请列表 
write(58510, {P0_page, P0_max_page, P0_war_team_apply_list}) ->
    D_a_t_a = <<P0_page:8/signed, P0_max_page:8/signed, (pack_war_team_apply_list(P0_war_team_apply_list))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58510:16,0:8, D_a_t_a/binary>>};


%% 战队审批 
write(58511, {P0_code, P0_pkey}) ->
    D_a_t_a = <<P0_code:16/signed, P0_pkey:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58511:16,0:8, D_a_t_a/binary>>};


%% 退出战队 
write(58512, {P0_code}) ->
    D_a_t_a = <<P0_code:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58512:16,0:8, D_a_t_a/binary>>};


%% 开除战队成员 
write(58513, {P0_code}) ->
    D_a_t_a = <<P0_code:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58513:16,0:8, D_a_t_a/binary>>};


%% 申请加入战队 
write(58514, {P0_code, P0_wtkey}) ->
    D_a_t_a = <<P0_code:16/signed, (proto:write_string(P0_wtkey))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58514:16,0:8, D_a_t_a/binary>>};


%% 申请通知 
write(58515, {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58515:16,0:8, D_a_t_a/binary>>};


%% 邀请反馈 
write(58516, {P0_ret, P0_pkey}) ->
    D_a_t_a = <<P0_ret:8/signed, P0_pkey:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58516:16,0:8, D_a_t_a/binary>>};


%% 发起匹配 
write(58517, {P0_code, P0_nickname}) ->
    D_a_t_a = <<P0_code:8, (proto:write_string(P0_nickname))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58517:16,0:8, D_a_t_a/binary>>};


%% 获取战队列表 
write(58518, {P0_index, P0_page, P0_max_page, P0_pack_war_team_list}) ->
    D_a_t_a = <<P0_index:8, P0_page:8/signed, P0_max_page:8/signed, (pack_war_team_list(P0_pack_war_team_list))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58518:16,0:8, D_a_t_a/binary>>};


%% 匹配成功,推送双方挑战信息 
write(58519, {P0_time, P0_list}) ->
    D_a_t_a = <<P0_time:16, (length(P0_list)):16, (list_to_binary([<<P1_sn:32, P1_pkey:32, (proto:write_string(P1_wt_name))/binary, P1_position:32, (proto:write_string(P1_nickname))/binary, P1_career:8/signed, P1_sex:8/signed, (proto:write_string(P1_avatar))/binary, P1_s_career:8/signed, P1_group:8/signed>> || [P1_sn, P1_pkey, P1_wt_name, P1_position, P1_nickname, P1_career, P1_sex, P1_avatar, P1_s_career, P1_group] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58519:16,0:8, D_a_t_a/binary>>};


%% 乱斗统计 
write(58520, {P0_time, P0_red_score, P0_blue_score, P0_score_lim, P0_group, P0_score, P0_acc_kill, P0_acc_die}) ->
    D_a_t_a = <<P0_time:32/signed, P0_red_score:32/signed, P0_blue_score:32/signed, P0_score_lim:32/signed, P0_group:8/signed, P0_score:32/signed, P0_acc_kill:32/signed, P0_acc_die:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58520:16,0:8, D_a_t_a/binary>>};


%% buff碰撞 
write(58521, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58521:16,0:8, D_a_t_a/binary>>};


%% 陷阱通知 
write(58522, {P0_time}) ->
    D_a_t_a = <<P0_time:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58522:16,0:8, D_a_t_a/binary>>};


%% 结算信息 
write(58523, {P0_ret, P0_index, P0_acc_kill, P0_acc_combo, P0_acc_die, P0_war_team_score, P0_score, P0_rank, P0_mvp_list, P0_goods_list}) ->
    D_a_t_a = <<P0_ret:8, P0_index:8, P0_acc_kill:32/signed, P0_acc_combo:32/signed, P0_acc_die:32/signed, P0_war_team_score:32/signed, P0_score:32/signed, P0_rank:32/signed, (length(P0_mvp_list)):16, (list_to_binary([<<P1_type:8, P1_sn:32, (proto:write_string(P1_nickname))/binary, P1_s_career:8/signed, P1_value:32/signed>> || [P1_type, P1_sn, P1_nickname, P1_s_career, P1_value] <- P0_mvp_list]))/binary, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32/signed, P1_type:8/signed>> || [P1_goods_id, P1_num, P1_type] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58523:16,0:8, D_a_t_a/binary>>};


%% 退出 
write(58524, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58524:16,0:8, D_a_t_a/binary>>};


%% 快捷聊天 
write(58525, {P0_pkey, P0_type}) ->
    D_a_t_a = <<P0_pkey:32/signed, P0_type:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58525:16,0:8, D_a_t_a/binary>>};


%% 连杀广播 
write(58526, {P0_pkey, P0_combo}) ->
    D_a_t_a = <<P0_pkey:32/signed, P0_combo:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58526:16,0:8, D_a_t_a/binary>>};


%% 一键拒绝 
write(58528, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58528:16,0:8, D_a_t_a/binary>>};


%% 赛事奖励 
write(58529, {P0_list}) ->
    D_a_t_a = <<(length(P0_list)):16, (list_to_binary([<<P1_id:32, (length(P1_goods_list)):16, (list_to_binary([<<P2_goods_id:32, P2_num:32/signed>> || [P2_goods_id, P2_num] <- P1_goods_list]))/binary>> || [P1_id, P1_goods_list] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58529:16,0:8, D_a_t_a/binary>>};


%% 查看赛程 
write(58530, {P0_goods_id, P0_bet_state, P0_list}) ->
    D_a_t_a = <<P0_goods_id:32, P0_bet_state:32, (length(P0_list)):16, (list_to_binary([<<P1_id:32/signed, (proto:write_string(P1_winkey))/binary, (proto:write_string(P1_wtkey1))/binary, (proto:write_string(P1_wtname1))/binary, P1_sn1:32, (proto:write_string(P1_wtkey2))/binary, (proto:write_string(P1_wtname2))/binary, P1_sn2:32>> || [P1_id, P1_winkey, P1_wtkey1, P1_wtname1, P1_sn1, P1_wtkey2, P1_wtname2, P1_sn2] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58530:16,0:8, D_a_t_a/binary>>};


%% 准备场景信息 
write(58531, {P0_id, P0_leave_time, P0_total_time}) ->
    D_a_t_a = <<P0_id:32, P0_leave_time:32, P0_total_time:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58531:16,0:8, D_a_t_a/binary>>};


%% 取消匹配 
write(58532, {P0_state}) ->
    D_a_t_a = <<P0_state:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58532:16,0:8, D_a_t_a/binary>>};


%% 审批处理同步 
write(58533, {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58533:16,0:8, D_a_t_a/binary>>};


%% 申请反馈 
write(58534, {P0_wtkey, P0_wtname, P0_ret}) ->
    D_a_t_a = <<(proto:write_string(P0_wtkey))/binary, (proto:write_string(P0_wtname))/binary, P0_ret:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58534:16,0:8, D_a_t_a/binary>>};


%% 查看投注信息 
write(58535, {P0_code, P0_leave_time, P0_bet_wtkey, P0_bet_wtname, P0_my_bet_id, P0_bet_goods_id, P0_bet_num, P0_wt_info_list, P0_bet_list}) ->
    D_a_t_a = <<P0_code:8, P0_leave_time:32, (proto:write_string(P0_bet_wtkey))/binary, (proto:write_string(P0_bet_wtname))/binary, P0_my_bet_id:32/signed, P0_bet_goods_id:32, P0_bet_num:32/signed, (length(P0_wt_info_list)):16, (list_to_binary([<<(proto:write_string(P1_wtkey))/binary, (proto:write_string(P1_wtname))/binary, (proto:write_string(P1_leader_name))/binary, P1_sn:32, P1_win:32, P1_lose:32, P1_score:32>> || [P1_wtkey, P1_wtname, P1_leader_name, P1_sn, P1_win, P1_lose, P1_score] <- P0_wt_info_list]))/binary, (length(P0_bet_list)):16, (list_to_binary([<<P1_bet_id:32/signed, P1_goods_id:32, P1_num:32/signed>> || [P1_bet_id, P1_goods_id, P1_num] <- P0_bet_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58535:16,0:8, D_a_t_a/binary>>};


%% 赛程下注 
write(58536, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58536:16,0:8, D_a_t_a/binary>>};


%% 原地复活次数 
write(58537, {P0_count}) ->
    D_a_t_a = <<P0_count:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58537:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------

pack_war_team_apply_list(P0_apply_list) ->
    D_a_t_a = <<(length(P0_apply_list)):16, (list_to_binary([<<P1_pkey:32, (proto:write_string(P1_pname))/binary, P1_vip:8, P1_career:8, P1_lv:8, P1_power:32, P1_rank:32>> || [P1_pkey, P1_pname, P1_vip, P1_career, P1_lv, P1_power, P1_rank] <- P0_apply_list]))/binary>>,
    <<D_a_t_a/binary>>.


pack_war_team_list(P0_war_team_list) ->
    D_a_t_a = <<(length(P0_war_team_list)):16, (list_to_binary([<<(proto:write_string(P1_name))/binary, P1_sn:32, (proto:write_string(P1_wtkey))/binary, (proto:write_string(P1_leader_name))/binary, P1_win:16, P1_lose:16, P1_count:16, P1_score:32, P1_rank:32>> || [P1_name, P1_sn, P1_wtkey, P1_leader_name, P1_win, P1_lose, P1_count, P1_score, P1_rank] <- P0_war_team_list]))/binary>>,
    <<D_a_t_a/binary>>.




