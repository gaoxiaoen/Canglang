%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-05-09 10:24:01
%%----------------------------------------------------
-module(pt_131).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"奖励不存在"; 
err(3) ->"奖励未解锁"; 
err(4) ->"奖励已领取"; 
err(5) ->"成就不存在"; 
err(6) ->"成就未达成"; 
err(7) ->"成就已领取"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(13100, _B0) ->
    {ok, {}};

read(13101, _B0) ->
    {ok, {}};

read(13102, _B0) ->
    {P0_type, _B1} = proto:read_int32(_B0),
    {ok, {P0_type}};

read(13103, _B0) ->
    {P0_id, _B1} = proto:read_int32(_B0),
    {ok, {P0_id}};

read(13104, _B0) ->
    {P0_ach_id, _B1} = proto:read_int32(_B0),
    {ok, {P0_ach_id}};

read(13105, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 成就概略 
write(13100, {P0_lv, P0_score, P0_score_lim, P0_is_reward, P0_score_list}) ->
    D_a_t_a = <<P0_lv:16/signed, P0_score:32/signed, P0_score_lim:32/signed, P0_is_reward:8/signed, (length(P0_score_list)):16, (list_to_binary([<<P1_type:8/signed, P1_score:32, P1_score_total:32>> || [P1_type, P1_score, P1_score_total] <- P0_score_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13100:16,0:8, D_a_t_a/binary>>};


%% 成就总览 
write(13101, {P0_lv, P0_score, P0_score_lim, P0_lv_reward_list, P0_type_state_list}) ->
    D_a_t_a = <<P0_lv:16/signed, P0_score:32/signed, P0_score_lim:32/signed, (length(P0_lv_reward_list)):16, (list_to_binary([<<P1_id:32/signed, P1_id_state:8>> || [P1_id, P1_id_state] <- P0_lv_reward_list]))/binary, (length(P0_type_state_list)):16, (list_to_binary([<<P1_type:32/signed, P1_state:8>> || [P1_type, P1_state] <- P0_type_state_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13101:16,0:8, D_a_t_a/binary>>};


%% 成就子类 
write(13102, {P0_subtype_list}) ->
    D_a_t_a = <<(length(P0_subtype_list)):16, (list_to_binary([<<P1_subtype:32/signed, P1_count:8/signed, P1_count_lim:8/signed, P1_ach_id:32/signed, P1_value1:32/signed, P1_value2:32/signed, P1_state:8>> || [P1_subtype, P1_count, P1_count_lim, P1_ach_id, P1_value1, P1_value2, P1_state] <- P0_subtype_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13102:16,0:8, D_a_t_a/binary>>};


%% 领取等级奖励 
write(13103, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13103:16,0:8, D_a_t_a/binary>>};


%% 领取成就奖励 
write(13104, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13104:16,0:8, D_a_t_a/binary>>};


%% 成就达成通知 
write(13105, {P0_ach_id}) ->
    D_a_t_a = <<P0_ach_id:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 13105:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



