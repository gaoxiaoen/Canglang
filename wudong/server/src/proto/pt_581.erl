%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-03-09 17:35:26
%%----------------------------------------------------
-module(pt_581).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"活动还没开启"; 
err(3) ->"你不在战斗场景"; 
err(4) ->"已加入了其他战斗"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(58101, _B0) ->
    {ok, {}};

read(58102, _B0) ->
    {ok, {}};

read(58103, _B0) ->
    {ok, {}};

read(58104, _B0) ->
    {ok, {}};

read(58105, _B0) ->
    {ok, {}};

read(58106, _B0) ->
    {ok, {}};

read(58107, _B0) ->
    {ok, {}};

read(58108, _B0) ->
    {ok, {}};

read(58109, _B0) ->
    {ok, {}};

read(58110, _B0) ->
    {ok, {}};

read(58111, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 活动状态 
write(58101, {P0_state, P0_time}) ->
    D_a_t_a = <<P0_state:8, P0_time:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58101:16,0:8, D_a_t_a/binary>>};


%% 获取个人比赛信息 
write(58102, {P0_my_poind, P0_battle_times, P0_pk_state, P0_succeed_list, P0_fail_list, P0_top10_list}) ->
    D_a_t_a = <<P0_my_poind:32/signed, P0_battle_times:32/signed, P0_pk_state:8/signed, (length(P0_succeed_list)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32>> || [P1_goods_id, P1_num] <- P0_succeed_list]))/binary, (length(P0_fail_list)):16, (list_to_binary([<<P1_f_goods_id:32, P1_f_num:32>> || [P1_f_goods_id, P1_f_num] <- P0_fail_list]))/binary, (length(P0_top10_list)):16, (list_to_binary([<<P1_t_goods_id:32, P1_t_num:32>> || [P1_t_goods_id, P1_t_num] <- P0_top10_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58102:16,0:8, D_a_t_a/binary>>};


%% 匹配挑战 
write(58103, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58103:16,0:8, D_a_t_a/binary>>};


%% 取消匹配 
write(58104, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58104:16,0:8, D_a_t_a/binary>>};


%% 获取当前比赛信息 
write(58105, {P0_team_life1, P0_team_life2, P0_leave_time, P0_player_list}) ->
    D_a_t_a = <<P0_team_life1:8/signed, P0_team_life2:8/signed, P0_leave_time:32/signed, (length(P0_player_list)):16, (list_to_binary([<<P1_pkey:32, P1_sn:32, P1_pf:32, (proto:write_string(P1_name))/binary, P1_lv:16, P1_sex:8, P1_career:8, (proto:write_string(P1_avatar))/binary, P1_cbp:32/signed, P1_kill:8/signed, P1_die:8/signed, P1_team:8/signed>> || [P1_pkey, P1_sn, P1_pf, P1_name, P1_lv, P1_sex, P1_career, P1_avatar, P1_cbp, P1_kill, P1_die, P1_team] <- P0_player_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58105:16,0:8, D_a_t_a/binary>>};


%% 单场战斗结算 
write(58106, {P0_player_list, P0_goods_list}) ->
    D_a_t_a = <<(length(P0_player_list)):16, (list_to_binary([<<P1_win:8, P1_is_mvp:8, P1_pkey:32, P1_sn:32, P1_pf:32, (proto:write_string(P1_name))/binary, P1_kill:8/signed, P1_point:32/signed>> || [P1_win, P1_is_mvp, P1_pkey, P1_sn, P1_pf, P1_name, P1_kill, P1_point] <- P0_player_list]))/binary, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58106:16,0:8, D_a_t_a/binary>>};


%% 退出战斗 
write(58107, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58107:16,0:8, D_a_t_a/binary>>};


%% 获取积分排行 
write(58108, {P0_my_rank, P0_my_times, P0_my_point, P0_rank_list}) ->
    D_a_t_a = <<P0_my_rank:16, P0_my_times:16, P0_my_point:32, (length(P0_rank_list)):16, (list_to_binary([<<P1_rank:16, P1_pkey:32, (proto:write_string(P1_name))/binary, P1_sn:32, P1_times:16, P1_point:32>> || [P1_rank, P1_pkey, P1_name, P1_sn, P1_times, P1_point] <- P0_rank_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58108:16,0:8, D_a_t_a/binary>>};


%% 查看积分奖励 
write(58109, {P0_rank_list}) ->
    D_a_t_a = <<(length(P0_rank_list)):16, (list_to_binary([<<P1_st_rank:16, P1_et_rank:16, (length(P1_rank_list)):16, (list_to_binary([<<P2_goods_id:32, P2_num:32>> || [P2_goods_id, P2_num] <- P1_rank_list]))/binary>> || [P1_st_rank, P1_et_rank, P1_rank_list] <- P0_rank_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58109:16,0:8, D_a_t_a/binary>>};


%% 即将进入战斗 
write(58110, {P0_leave_time}) ->
    D_a_t_a = <<P0_leave_time:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58110:16,0:8, D_a_t_a/binary>>};


%% 活动倒计时通知 
write(58111, {P0_leave_time}) ->
    D_a_t_a = <<P0_leave_time:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58111:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



