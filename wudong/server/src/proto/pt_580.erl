%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-04-21 17:53:49
%%----------------------------------------------------
-module(pt_580).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"等级不足不能参赛"; 
err(3) ->"护送中"; 
err(4) ->"野外场景才能参加"; 
err(5) ->"活动未开启"; 
err(6) ->"没有报名比赛"; 
err(7) ->"没有在匹配中"; 
err(9) ->"不在跨服1v1场景中"; 
err(10) ->"您正处于匹配队列中无法进入"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(58001, _B0) ->
    {ok, {}};

read(58002, _B0) ->
    {ok, {}};

read(58003, _B0) ->
    {ok, {}};

read(58004, _B0) ->
    {ok, {}};

read(58005, _B0) ->
    {P0_page, _B1} = proto:read_int8(_B0),
    {ok, {P0_page}};

read(58006, _B0) ->
    {ok, {}};

read(58007, _B0) ->
    {ok, {}};

read(58008, _B0) ->
    {ok, {}};

read(58009, _B0) ->
    {ok, {}};

read(58010, _B0) ->
    {ok, {}};

read(58011, _B0) ->
    {ok, {}};

read(58012, _B0) ->
    {P0_id, _B1} = proto:read_int8(_B0),
    {ok, {P0_id}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 活动状态 
write(58001, {P0_state, P0_time}) ->
    D_a_t_a = <<P0_state:8, P0_time:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58001:16,0:8, D_a_t_a/binary>>};


%% 比赛信息 
write(58002, {P0_lv, P0_score, P0_score_lim, P0_pt_state, P0_times, P0_score_daily, P0_list}) ->
    D_a_t_a = <<P0_lv:8, P0_score:32, P0_score_lim:32, P0_pt_state:8, P0_times:8, P0_score_daily:32, (length(P0_list)):16, (list_to_binary([<<P1_id:8/signed, P1_state:32/signed>> || [P1_id, P1_state] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58002:16,0:8, D_a_t_a/binary>>};


%% 匹配挑战 
write(58003, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58003:16,0:8, D_a_t_a/binary>>};


%% 取消匹配 
write(58004, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58004:16,0:8, D_a_t_a/binary>>};


%% 排行榜 
write(58005, {P0_page, P0_max_page, P0_my_rank, P0_my_lv, P0_my_score, P0_rank_list}) ->
    D_a_t_a = <<P0_page:8/signed, P0_max_page:8/signed, P0_my_rank:8/signed, P0_my_lv:8/signed, P0_my_score:32/signed, (length(P0_rank_list)):16, (list_to_binary([<<P1_rank:8/signed, P1_sn:16/signed, (proto:write_string(P1_nickname))/binary, P1_lv:8/signed, P1_score:32/signed>> || [P1_rank, P1_sn, P1_nickname, P1_lv, P1_score] <- P0_rank_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58005:16,0:8, D_a_t_a/binary>>};


%% 匹配成功,对手数据 
write(58006, {P0_time, P0_nickname, P0_career, P0_sex, P0_lv, P0_cbp, P0_avatar, P0_pkey}) ->
    D_a_t_a = <<P0_time:8/signed, (proto:write_string(P0_nickname))/binary, P0_career:8/signed, P0_sex:8/signed, P0_lv:8/signed, P0_cbp:32/signed, (proto:write_string(P0_avatar))/binary, P0_pkey:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58006:16,0:8, D_a_t_a/binary>>};


%% 场景挑战信息 
write(58007, {P0_time, P0_key, P0_career, P0_sex, P0_hp, P0_avatar}) ->
    D_a_t_a = <<P0_time:8, P0_key:32/signed, P0_career:8/signed, P0_sex:8/signed, P0_hp:32/signed, (proto:write_string(P0_avatar))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58007:16,0:8, D_a_t_a/binary>>};


%% 单场次挑战结果 
write(58008, {P0_ret, P0_score, P0_lv}) ->
    D_a_t_a = <<P0_ret:8/signed, P0_score:32/signed, P0_lv:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58008:16,0:8, D_a_t_a/binary>>};


%% 退出场景 
write(58009, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58009:16,0:8, D_a_t_a/binary>>};


%% 活动总结算 
write(58010, {P0_rank, P0_lv, P0_old_lv, P0_fight_times, P0_win_times, P0_score, P0_des_id, P0_goods_list}) ->
    D_a_t_a = <<P0_rank:16/signed, P0_lv:8/signed, P0_old_lv:8/signed, P0_fight_times:32/signed, P0_win_times:32/signed, P0_score:32/signed, P0_des_id:32/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58010:16,0:8, D_a_t_a/binary>>};


%% 每日段位奖励 
write(58011, {P0_code, P0_goods_list}) ->
    D_a_t_a = <<P0_code:8, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58011:16,0:8, D_a_t_a/binary>>};


%% 每日挑战奖励 
write(58012, {P0_code, P0_goods_list}) ->
    D_a_t_a = <<P0_code:8, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 58012:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



