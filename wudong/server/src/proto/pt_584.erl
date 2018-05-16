%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-08-08 17:31:09
%%----------------------------------------------------
-module(pt_584).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"等级不足不能参赛"; 
err(3) ->"护送中"; 
err(4) ->"野外场景才能参加"; 
err(5) ->"活动未开启"; 
err(6) ->"没有在匹配中"; 
err(7) ->"您正处于匹配队列中"; 
err(8) ->"您没有组队,请使用个人匹配"; 
err(9) ->"请等待队长匹配"; 
err(10) ->"%s不在线,不能匹配"; 
err(11) ->"%s不在野外场景,不能匹配"; 
err(12) ->"%s正在匹配中"; 
err(13) ->"队伍确认超时"; 
err(14) ->"进入匹配"; 
err(15) ->"请等待成员确认 "; 
err(16) ->"%s取消了匹配"; 
err(17) ->"%s不同意开启匹配"; 
err(18) ->"%s离线,匹配取消"; 
err(19) ->"%s离开了队伍,匹配取消"; 
err(20) ->"巡游中 "; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(58401, _B0) ->
    {ok, {}};

read(58402, _B0) ->
    {ok, {}};

read(58403, _B0) ->
    {ok, {}};

read(58404, _B0) ->
    {ok, {}};

read(58405, _B0) ->
    {ok, {}};

read(58406, _B0) ->
    {P0_is_agree, _B1} = proto:read_uint8(_B0),
    {ok, {P0_is_agree}};

read(58407, _B0) ->
    {ok, {}};

read(58408, _B0) ->
    {ok, {}};

read(58409, _B0) ->
    {P0_mkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_mkey}};

read(58410, _B0) ->
    {ok, {}};

read(58411, _B0) ->
    {ok, {}};

read(58412, _B0) ->
    {ok, {}};

read(58413, _B0) ->
    {ok, {}};

read(58414, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {ok, {P0_type}};

read(58415, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 活动状态 
write(58401, {P0_state, P0_time}) ->
    D_a_t_a = <<P0_state:8, P0_time:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58401:16,0:8, D_a_t_a/binary>>};


%% 查询活动匹配状态 
write(58402, {P0_state, P0_times, P0_times_lim}) ->
    D_a_t_a = <<P0_state:8, P0_times:8, P0_times_lim:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58402:16,0:8, D_a_t_a/binary>>};


%% 个人匹配 
write(58403, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58403:16,0:8, D_a_t_a/binary>>};


%% 队长发起小队匹配 
write(58404, {P0_code, P0_nickname}) ->
    D_a_t_a = <<P0_code:8, (proto:write_string(P0_nickname))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58404:16,0:8, D_a_t_a/binary>>};


%% 队友收到匹配发起信息 
write(58405, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58405:16,0:8, D_a_t_a/binary>>};


%% 队员确认小队匹配 
write(58406, {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58406:16,0:8, D_a_t_a/binary>>};


%% 匹配成功,推送双方挑战信息 
write(58407, {P0_time, P0_list}) ->
    D_a_t_a = <<P0_time:16, (length(P0_list)):16, (list_to_binary([<<P1_sn:32, P1_pkey:32, (proto:write_string(P1_nickname))/binary, P1_career:8/signed, P1_sex:8/signed, (proto:write_string(P1_avatar))/binary, P1_s_career:8/signed, P1_group:8/signed>> || [P1_sn, P1_pkey, P1_nickname, P1_career, P1_sex, P1_avatar, P1_s_career, P1_group] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58407:16,0:8, D_a_t_a/binary>>};


%% 乱斗统计 
write(58408, {P0_time, P0_red_score, P0_blue_score, P0_score_lim, P0_group, P0_score, P0_acc_kill, P0_acc_die}) ->
    D_a_t_a = <<P0_time:32/signed, P0_red_score:32/signed, P0_blue_score:32/signed, P0_score_lim:32/signed, P0_group:8/signed, P0_score:32/signed, P0_acc_kill:32/signed, P0_acc_die:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58408:16,0:8, D_a_t_a/binary>>};


%% buff碰撞 
write(58409, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58409:16,0:8, D_a_t_a/binary>>};


%% 陷阱通知 
write(58410, {P0_time}) ->
    D_a_t_a = <<P0_time:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58410:16,0:8, D_a_t_a/binary>>};


%% 取消匹配 
write(58411, {P0_state}) ->
    D_a_t_a = <<P0_state:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58411:16,0:8, D_a_t_a/binary>>};


%% 结算信息 
write(58412, {P0_ret, P0_acc_kill, P0_acc_combo, P0_acc_die, P0_score, P0_rank, P0_mvp_list, P0_goods_list}) ->
    D_a_t_a = <<P0_ret:8, P0_acc_kill:32/signed, P0_acc_combo:32/signed, P0_acc_die:32/signed, P0_score:32/signed, P0_rank:32/signed, (length(P0_mvp_list)):16, (list_to_binary([<<P1_type:8, P1_sn:32, (proto:write_string(P1_nickname))/binary, P1_s_career:8/signed, P1_value:32/signed>> || [P1_type, P1_sn, P1_nickname, P1_s_career, P1_value] <- P0_mvp_list]))/binary, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32/signed, P1_type:8/signed>> || [P1_goods_id, P1_num, P1_type] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58412:16,0:8, D_a_t_a/binary>>};


%% 退出 
write(58413, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58413:16,0:8, D_a_t_a/binary>>};


%% 快捷聊天 
write(58414, {P0_pkey, P0_type}) ->
    D_a_t_a = <<P0_pkey:32/signed, P0_type:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58414:16,0:8, D_a_t_a/binary>>};


%% 连杀广播 
write(58415, {P0_pkey, P0_combo}) ->
    D_a_t_a = <<P0_pkey:32/signed, P0_combo:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58415:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



