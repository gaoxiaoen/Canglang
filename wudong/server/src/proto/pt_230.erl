%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-09-21 10:37:41
%%----------------------------------------------------
-module(pt_230).
-export([read/2, write/2]).

-include("common.hrl").
-include("arena.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"竞技场数据不存在"; 
err(3) ->"你当前的会员等级没有购买资格"; 
err(4) ->"今日可购买次数已满"; 
err(5) ->"元宝不足以支付次数购买"; 
err(6) ->"挑战次数不足"; 
err(7) ->"挑战对手不存在"; 
err(8) ->"该玩家的排名不在你可挑战的范围"; 
err(9) ->"刷新冷却中，慢点"; 
err(10) ->"挑战冷却中"; 
err(11) ->"不能挑战自己"; 
err(12) ->"当前没有冷却可清除"; 
err(13) ->"元宝不足以支付冷却清除"; 
err(14) ->"护送中,不能挑战"; 
err(15) ->"野外场景才能挑战"; 
err(16) ->"有挑战次数,无需购买"; 
err(17) ->"积分奖励不存在"; 
err(18) ->"积分奖励未达成"; 
err(19) ->"积分奖励已领取"; 
err(20) ->"没有奖励可领取"; 
err(21) ->"排名奖励不存在"; 
err(22) ->"排名奖励未达成"; 
err(23) ->"排名奖励已领取"; 
err(24) ->"您正处于匹配队列中无法进入"; 
err(25) ->"巡游中,不能挑战"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(23001, _B0) ->
    {ok, {}};

read(23002, _B0) ->
    {ok, {}};

read(23003, _B0) ->
    {ok, {}};

read(23004, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_pkey}};

read(23005, _B0) ->
    {ok, {}};

read(23006, _B0) ->
    {ok, {}};

read(23007, _B0) ->
    {ok, {}};

read(23008, _B0) ->
    {ok, {}};

read(23009, _B0) ->
    {P0_id, _B1} = proto:read_int8(_B0),
    {ok, {P0_id}};

read(23010, _B0) ->
    {P0_page, _B1} = proto:read_int8(_B0),
    {ok, {P0_page}};

read(23011, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_pkey}};

read(23012, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 竞技场信息 
write(23001, {P0_rank, P0_times, P0_buy_times, P0_reward_time, P0_goods_list, P0_in_cd, P0_cd, P0_score_reward, P0_arena_list}) ->
    D_a_t_a = <<P0_rank:32/signed, P0_times:8/signed, P0_buy_times:8/signed, P0_reward_time:32/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary, P0_in_cd:8/signed, P0_cd:32/signed, P0_score_reward:8/signed, (length(P0_arena_list)):16, (list_to_binary([<<P1_pkey:32, (proto:write_string(P1_name))/binary, P1_realm:8/signed, P1_career:8/signed, P1_sex:8/signed, P1_rank:32/signed, P1_power:32/signed, P1_wing_id:32, P1_wepon_id:32, P1_clothing_id:32, P1_light_wepon_id:32, P1_fashion_cloth_id:32, P1_fashion_footprint_id:32, P1_fashion_head_id:32/signed>> || [P1_pkey, P1_name, P1_realm, P1_career, P1_sex, P1_rank, P1_power, P1_wing_id, P1_wepon_id, P1_clothing_id, P1_light_wepon_id, P1_fashion_cloth_id, P1_fashion_footprint_id, P1_fashion_head_id] <- P0_arena_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 23001:16,0:8, D_a_t_a/binary>>};


%% 刷新挑战对手 
write(23002, {P0_code, P0_arena_list}) ->
    D_a_t_a = <<P0_code:8/signed, (length(P0_arena_list)):16, (list_to_binary([<<P1_pkey:32, (proto:write_string(P1_name))/binary, P1_realm:8/signed, P1_career:8/signed, P1_sex:8/signed, P1_rank:32/signed, P1_power:32/signed, P1_wing_id:32, P1_wepon_id:32, P1_clothing_id:32, P1_light_wepon_id:32, P1_fashion_cloth_id:32, P1_footprint_id:32, P1_fashion_head_id:32/signed>> || [P1_pkey, P1_name, P1_realm, P1_career, P1_sex, P1_rank, P1_power, P1_wing_id, P1_wepon_id, P1_clothing_id, P1_light_wepon_id, P1_fashion_cloth_id, P1_footprint_id, P1_fashion_head_id] <- P0_arena_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 23002:16,0:8, D_a_t_a/binary>>};


%% 竞技场购买次数 
write(23003, {P0_code, P0_times, P0_hadbuy}) ->
    D_a_t_a = <<P0_code:8/signed, P0_times:8/signed, P0_hadbuy:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 23003:16,0:8, D_a_t_a/binary>>};


%% 竞技场挑战 
write(23004, {P0_code, P0_time}) ->
    D_a_t_a = <<P0_code:8/signed, P0_time:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 23004:16,0:8, D_a_t_a/binary>>};


%% 竞技场挑战结果 
write(23005, {P0_ret, P0_rank_old, P0_rank_new, P0_goods_list}) ->
    D_a_t_a = <<P0_ret:8/signed, P0_rank_old:32/signed, P0_rank_new:32/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 23005:16,0:8, D_a_t_a/binary>>};


%% 竞技场清CD 
write(23006, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 23006:16,0:8, D_a_t_a/binary>>};


%% 竞技场日志 
write(23007, {P0_log_list}) ->
    D_a_t_a = <<(length(P0_log_list)):16, (list_to_binary([<<P1_time:32/signed, (proto:write_string(P1_msg))/binary>> || [P1_time, P1_msg] <- P0_log_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 23007:16,0:8, D_a_t_a/binary>>};


%% 获取积分奖励列表 
write(23008, {P0_now_score, P0_score_list}) ->
    D_a_t_a = <<P0_now_score:8/signed, (length(P0_score_list)):16, (list_to_binary([<<P1_id:8/signed, P1_score:8/signed, P1_state:8/signed, (length(P1_goods_list)):16, (list_to_binary([<<P2_goods_id:32/signed, P2_num:32/signed>> || [P2_goods_id, P2_num] <- P1_goods_list]))/binary>> || [P1_id, P1_score, P1_state, P1_goods_list] <- P0_score_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 23008:16,0:8, D_a_t_a/binary>>};


%% 领取积分奖励 
write(23009, {P0_code, P0_score_reward, P0_goods_list}) ->
    D_a_t_a = <<P0_code:8/signed, P0_score_reward:8/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 23009:16,0:8, D_a_t_a/binary>>};


%% 竞技场排行榜 
write(23010, {P0_page, P0_max_page, P0_my_rank, P0_list}) ->
    D_a_t_a = <<P0_page:8/signed, P0_max_page:8/signed, P0_my_rank:32/signed, (length(P0_list)):16, (list_to_binary([<<P1_rank:32/signed, P1_type:8/signed, P1_key:32, (proto:write_string(P1_nickname))/binary, P1_career:8/signed, P1_sex:8/signed, P1_cbp:32/signed, (proto:write_string(P1_guild_name))/binary, (proto:write_string(P1_avatar))/binary, (length(P1_goods_list)):16, (list_to_binary([<<P2_goods_id:32/signed, P2_num:32/signed>> || [P2_goods_id, P2_num] <- P1_goods_list]))/binary>> || [P1_rank, P1_type, P1_key, P1_nickname, P1_career, P1_sex, P1_cbp, P1_guild_name, P1_avatar, P1_goods_list] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 23010:16,0:8, D_a_t_a/binary>>};


%% 竞技场排行榜挑战 
write(23011, {P0_code, P0_time}) ->
    D_a_t_a = <<P0_code:8/signed, P0_time:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 23011:16,0:8, D_a_t_a/binary>>};


%% 竞技场目标 
write(23012, {P0_time, P0_list}) ->
    D_a_t_a = <<P0_time:16/signed, (length(P0_list)):16, (list_to_binary([<<P1_key:32/signed, (proto:write_string(P1_nickname))/binary, P1_career:8/signed, P1_sex:8/signed, (proto:write_string(P1_avatar))/binary, P1_hp_lim:32/signed, P1_cbp:32/signed>> || [P1_key, P1_nickname, P1_career, P1_sex, P1_avatar, P1_hp_lim, P1_cbp] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 23012:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



