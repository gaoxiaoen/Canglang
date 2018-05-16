%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-09-12 17:10:43
%%----------------------------------------------------
-module(pt_602).
-export([read/2, write/2]).

-include("common.hrl").
-include("lucky_pool.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"已经领取"; 
err(3) ->"送花次数不足"; 
err(4) ->"收花次数不足"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(60200, _B0) ->
    {ok, {}};

read(60201, _B0) ->
    {ok, {}};

read(60202, _B0) ->
    {P0_type, _B1} = proto:read_uint8(_B0),
    {P0_id, _B2} = proto:read_uint8(_B1),
    {ok, {P0_type, P0_id}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 获取鲜花榜信息 
write(60200, {P0_time, P0_my_give_num, P0_my_give_rank, P0_give_list, P0_give_reward_list, P0_my_get_num, P0_my_get_rank, P0_get_list, P0_get_reward_list, P0_give_limit, P0_get_limit}) ->
    D_a_t_a = <<P0_time:32, P0_my_give_num:32, P0_my_give_rank:32, (length(P0_give_list)):16, (list_to_binary([<<P1_sn:16, P1_pkey:32/signed, (proto:write_string(P1_name))/binary, P1_sex:32/signed, (proto:write_string(P1_avatar))/binary, P1_rank:32/signed, P1_num:32/signed>> || [P1_sn, P1_pkey, P1_name, P1_sex, P1_avatar, P1_rank, P1_num] <- P0_give_list]))/binary, (length(P0_give_reward_list)):16, (list_to_binary([<<P1_rank_top:32, P1_rank_down:32, (length(P1_award_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_award_list]))/binary>> || [P1_rank_top, P1_rank_down, P1_award_list] <- P0_give_reward_list]))/binary, P0_my_get_num:32, P0_my_get_rank:32, (length(P0_get_list)):16, (list_to_binary([<<P1_sn:16, P1_pkey:32/signed, (proto:write_string(P1_name))/binary, P1_sex:32/signed, (proto:write_string(P1_avatar))/binary, P1_rank:32/signed, P1_num:32/signed>> || [P1_sn, P1_pkey, P1_name, P1_sex, P1_avatar, P1_rank, P1_num] <- P0_get_list]))/binary, (length(P0_get_reward_list)):16, (list_to_binary([<<P1_rank_top:32, P1_rank_down:32, (length(P1_award_list)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_award_list]))/binary>> || [P1_rank_top, P1_rank_down, P1_award_list] <- P0_get_reward_list]))/binary, (length(P0_give_limit)):16, (list_to_binary([<<P1_limit:32>> || P1_limit <- P0_give_limit]))/binary, (length(P0_get_limit)):16, (list_to_binary([<<P1_limit:32>> || P1_limit <- P0_get_limit]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60200:16,0:8, D_a_t_a/binary>>};


%% 获取达标榜信息 
write(60201, {P0_time, P0_my_give_num, P0_give_list, P0_my_get_num, P0_get_list}) ->
    D_a_t_a = <<P0_time:32, P0_my_give_num:32/signed, (length(P0_give_list)):16, (list_to_binary([<<P1_id:32/signed, P1_whether:32/signed, P1_must:32/signed, (length(P1_award_list)):16, (list_to_binary([<<P2_goods_id:32/signed, P2_goods_num:32/signed>> || [P2_goods_id, P2_goods_num] <- P1_award_list]))/binary>> || [P1_id, P1_whether, P1_must, P1_award_list] <- P0_give_list]))/binary, P0_my_get_num:32/signed, (length(P0_get_list)):16, (list_to_binary([<<P1_id:32/signed, P1_whether:32/signed, P1_must:32/signed, (length(P1_award_list)):16, (list_to_binary([<<P2_goods_id:32/signed, P2_goods_num:32/signed>> || [P2_goods_id, P2_goods_num] <- P1_award_list]))/binary>> || [P1_id, P1_whether, P1_must, P1_award_list] <- P0_get_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60201:16,0:8, D_a_t_a/binary>>};


%% 领取达标榜奖励 
write(60202, {P0_error_code}) ->
    D_a_t_a = <<P0_error_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 60202:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



