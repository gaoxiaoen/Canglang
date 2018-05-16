%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2018-04-26 10:28:24
%%----------------------------------------------------
-module(pt_447).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"不能挑战自己"; 
err(3) ->"护送中,不能挑战"; 
err(4) ->"野外场景才能挑战"; 
err(5) ->"您正处于匹配队列中无法进入"; 
err(6) ->"巡游中,不能挑战"; 
err(7) ->"不可挑战自己仙盟"; 
err(8) ->"已领取"; 
err(9) ->"挑战数量已满"; 
err(10) ->"已挑战该仙盟"; 
err(11) ->"该玩家已战败，请挑战其他玩家"; 
err(12) ->"挑战次数已用完"; 
err(13) ->"CD时间限制"; 
err(14) ->"您不是掌门没有权限进行旗帜升级"; 
err(15) ->"仙盟拥有勋章不足"; 
err(16) ->"您不是掌门或掌教，没有权限进行该项操作"; 
err(17) ->"兑换次数不足"; 
err(18) ->"勋章数量不足，无法购买"; 
err(19) ->"仙盟等级不足"; 
err(20) ->"当前玩家正在被其他玩家攻击"; 
err(21) ->"旗帜已满级"; 
err(22) ->"还不可领"; 
err(23) ->"开服第二天开放此玩法"; 
err(24) ->"更换仙盟,24小时后才可使用仙盟商店"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(44701, _B0) ->
    {ok, {}};

read(44702, _B0) ->
    {ok, {}};

read(44703, _B0) ->
    {P0_lv, _B1} = proto:read_uint8(_B0),
    {ok, {P0_lv}};

read(44704, _B0) ->
    {P0_guild_key, _B1} = proto:read_key(_B0),
    {ok, {P0_guild_key}};

read(44705, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_pkey}};

read(44706, _B0) ->
    {ok, {}};

read(44707, _B0) ->
    {P0_guild_num, _B1} = proto:read_uint32(_B0),
    {ok, {P0_guild_num}};

read(44708, _B0) ->
    {ok, {}};

read(44709, _B0) ->
    {ok, {}};

read(44710, _B0) ->
    {P0_id, _B1} = proto:read_uint32(_B0),
    {P0_buy_time, _B2} = proto:read_uint32(_B1),
    {ok, {P0_id, P0_buy_time}};

read(44711, _B0) ->
    {ok, {}};

read(44712, _B0) ->
    {ok, {}};

read(44713, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 仙盟对战信息 
write(44701, {P0_my_medal, P0_guild_medal, P0_guild_sum_lv, P0_guild_fight_num, P0_cd_time, P0_remain_challenge_num, P0_recv_box_list, P0_guild_list}) ->
    D_a_t_a = <<P0_my_medal:32, P0_guild_medal:32, P0_guild_sum_lv:8, P0_guild_fight_num:8, P0_cd_time:16, P0_remain_challenge_num:16, (length(P0_recv_box_list)):16, (list_to_binary([<<P1_guild_num:8, P1_is_recv:8>> || [P1_guild_num, P1_is_recv] <- P0_recv_box_list]))/binary, (length(P0_guild_list)):16, (list_to_binary([<<P1_challenge_num:8, P1_max_challenge_num:32, (proto:write_string(P1_guild_key))/binary, P1_guild_sn:32, (proto:write_string(P1_guild_name))/binary, P1_guild_lv:8, P1_guild_icon:32, P1_index:8, (length(P1_player_list)):16, (list_to_binary([<<P2_pkey:32, (proto:write_string(P2_player_name))/binary, P2_career:8, P2_sex:8, (proto:write_string(P2_avatar))/binary, P2_cbp:32, P2_base_medal:8, P2_is_challenge:8>> || [P2_pkey, P2_player_name, P2_career, P2_sex, P2_avatar, P2_cbp, P2_base_medal, P2_is_challenge] <- P1_player_list]))/binary>> || [P1_challenge_num, P1_max_challenge_num, P1_guild_key, P1_guild_sn, P1_guild_name, P1_guild_lv, P1_guild_icon, P1_index, P1_player_list] <- P0_guild_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44701:16,0:8, D_a_t_a/binary>>};


%% 个人对战日志 
write(44702, {P0_my_base_medal, P0_log_list}) ->
    D_a_t_a = <<P0_my_base_medal:8, (length(P0_log_list)):16, (list_to_binary([<<P1_pkey:32, (proto:write_string(P1_player_name))/binary, P1_career:8, P1_sex:8, (proto:write_string(P1_avatar))/binary, P1_cbp:32, P1_result:8, P1_base_medal:8, P1_time:32>> || [P1_pkey, P1_player_name, P1_career, P1_sex, P1_avatar, P1_cbp, P1_result, P1_base_medal, P1_time] <- P0_log_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44702:16,0:8, D_a_t_a/binary>>};


%% 仙盟列表 
write(44703, {P0_guild_max_lv, P0_guild_list}) ->
    D_a_t_a = <<P0_guild_max_lv:8, (length(P0_guild_list)):16, (list_to_binary([<<(proto:write_string(P1_guild_key))/binary, P1_guild_lv:8, (proto:write_string(P1_guild_name))/binary, P1_guild_num:8, P1_guild_max_num:8>> || [P1_guild_key, P1_guild_lv, P1_guild_name, P1_guild_num, P1_guild_max_num] <- P0_guild_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44703:16,0:8, D_a_t_a/binary>>};


%% 挑战仙盟 
write(44704, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44704:16,0:8, D_a_t_a/binary>>};


%% 挑战玩家 
write(44705, {P0_code, P0_time}) ->
    D_a_t_a = <<P0_code:8/signed, P0_time:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44705:16,0:8, D_a_t_a/binary>>};


%% 仙盟对战目标 
write(44706, {P0_time, P0_list}) ->
    D_a_t_a = <<P0_time:16/signed, (length(P0_list)):16, (list_to_binary([<<P1_key:32/signed, (proto:write_string(P1_nickname))/binary, P1_career:8/signed, P1_sex:8/signed, (proto:write_string(P1_avatar))/binary, P1_hp_lim:32/signed, P1_cbp:32/signed>> || [P1_key, P1_nickname, P1_career, P1_sex, P1_avatar, P1_hp_lim, P1_cbp] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44706:16,0:8, D_a_t_a/binary>>};


%% 领取宝箱奖励 
write(44707, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44707:16,0:8, D_a_t_a/binary>>};


%% 仙盟结算 
write(44708, {P0_ret, P0_reward_list}) ->
    D_a_t_a = <<P0_ret:8, (length(P0_reward_list)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32>> || [P1_goods_id, P1_num] <- P0_reward_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44708:16,0:8, D_a_t_a/binary>>};


%% 勋章兑换商城 
write(44709, {P0_my_medal, P0_list}) ->
    D_a_t_a = <<P0_my_medal:32, (length(P0_list)):16, (list_to_binary([<<P1_id:32, P1_goods_id:32, P1_num:32, P1_price:32, P1_remain_buy_num:32>> || [P1_id, P1_goods_id, P1_num, P1_price, P1_remain_buy_num] <- P0_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44709:16,0:8, D_a_t_a/binary>>};


%% 兑换 
write(44710, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44710:16,0:8, D_a_t_a/binary>>};


%% 获取旗帜信息 
write(44711, {P0_lv, P0_exp, P0_add_exp}) ->
    D_a_t_a = <<P0_lv:8, P0_exp:32, P0_add_exp:32>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44711:16,0:8, D_a_t_a/binary>>};


%% 旗帜升级 
write(44712, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44712:16,0:8, D_a_t_a/binary>>};


%% 领地信息 
write(44713, {P0_guild_lv, P0_guild_flag_lv, P0_guild_name, P0_guild_num, P0_guild_base_num, P0_nickname, P0_career, P0_sex, P0_avatar}) ->
    D_a_t_a = <<P0_guild_lv:8, P0_guild_flag_lv:8, (proto:write_string(P0_guild_name))/binary, P0_guild_num:8, P0_guild_base_num:8, (proto:write_string(P0_nickname))/binary, P0_career:8/signed, P0_sex:8/signed, (proto:write_string(P0_avatar))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44713:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



