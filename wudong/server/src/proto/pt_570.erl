%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-10-31 17:11:03
%%----------------------------------------------------
-module(pt_570).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"野外普通场景才能进入首领场景"; 
err(3) ->"等级不足,不能进入"; 
err(4) ->" 护送中,不能进入"; 
err(5) ->"首领场景未开放"; 
err(6) ->"不在首领场景中"; 
err(7) ->"银两不足以支付鼓舞"; 
err(8) ->"元宝不足以支付鼓舞"; 
err(9) ->"银两鼓舞已达上限，请用元宝鼓舞可达100%"; 
err(10) ->"鼓舞已满，无需在鼓舞"; 
err(11) ->"您正处于匹配队列中无法进入"; 
err(12) ->"巡游中"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(57000, _B0) ->
    {ok, {}};

read(57001, _B0) ->
    {ok, {}};

read(57002, _B0) ->
    {ok, {}};

read(57003, _B0) ->
    {P0_layer, _B1} = proto:read_int8(_B0),
    {ok, {P0_layer}};

read(57004, _B0) ->
    {ok, {}};

read(57005, _B0) ->
    {ok, {}};

read(57006, _B0) ->
    {ok, {}};

read(57007, _B0) ->
    {ok, {}};

read(57008, _B0) ->
    {P0_score, _B1} = proto:read_int32(_B0),
    {ok, {P0_score}};

read(57009, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 世界服列表 
write(57000, {P0_server_list}) ->
    D_a_t_a = <<(length(P0_server_list)):16, (list_to_binary([<<(proto:write_string(P1_name))/binary, P1_sn:32>> || [P1_name, P1_sn] <- P0_server_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 57000:16,0:8, D_a_t_a/binary>>};


%% 活动状态 
write(57001, {P0_state, P0_time}) ->
    D_a_t_a = <<P0_state:8, P0_time:16>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 57001:16,0:8, D_a_t_a/binary>>};


%% 怪物全部击杀开始掉落宝箱 
write(57002, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 57002:16,0:8, D_a_t_a/binary>>};


%% 请求加入 
write(57003, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 57003:16,0:8, D_a_t_a/binary>>};


%% 退出 
write(57004, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 57004:16,0:8, D_a_t_a/binary>>};


%% 数据统计 
write(57005, {P0_myrank, P0_myscore, P0_myguildscore, P0_mykill_mon_num, P0_mykill_boss_num, P0_mykill_player_num, P0_myonline, P0_myrank2, P0_myguild_nickname, P0_myguild_main_nickname, P0_myplayer_num, P0_myguild_score, P0_rank_list, P0_rank_list2}) ->
    D_a_t_a = <<P0_myrank:16/signed, P0_myscore:32/signed, P0_myguildscore:32/signed, P0_mykill_mon_num:16/signed, P0_mykill_boss_num:16/signed, P0_mykill_player_num:16/signed, P0_myonline:16/signed, P0_myrank2:16/signed, (proto:write_string(P0_myguild_nickname))/binary, (proto:write_string(P0_myguild_main_nickname))/binary, P0_myplayer_num:8/signed, P0_myguild_score:32/signed, (length(P0_rank_list)):16, (list_to_binary([<<P1_rank:16/signed, (proto:write_string(P1_nickname))/binary, P1_kill_mon_num:16/signed, P1_kill_boss_num:16/signed, P1_kill_player_num:16/signed, P1_online:16/signed, P1_score:32/signed>> || [P1_rank, P1_nickname, P1_kill_mon_num, P1_kill_boss_num, P1_kill_player_num, P1_online, P1_score] <- P0_rank_list]))/binary, (length(P0_rank_list2)):16, (list_to_binary([<<P1_rank2:16/signed, (proto:write_string(P1_guild_nickname))/binary, (proto:write_string(P1_guild_main_nickname))/binary, P1_player_num:8/signed, P1_guild_score:32/signed>> || [P1_rank2, P1_guild_nickname, P1_guild_main_nickname, P1_player_num, P1_guild_score] <- P0_rank_list2]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 57005:16,0:8, D_a_t_a/binary>>};


%% 个人数据 
write(57006, {P0_myscore, P0_myguildscore, P0_recv_score, P0_my_has_drop_num, P0_base_has_drop_num}) ->
    D_a_t_a = <<P0_myscore:32/signed, P0_myguildscore:32/signed, P0_recv_score:32/signed, P0_my_has_drop_num:8, P0_base_has_drop_num:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 57006:16,0:8, D_a_t_a/binary>>};


%% boss数据 
write(57007, {P0_list, P0_list2}) ->
    D_a_t_a = <<(length(P0_list)):16, (list_to_binary([<<P1_id:32/signed, P1_hp_lim:32/signed, P1_hp:32/signed>> || [P1_id, P1_hp_lim, P1_hp] <- P0_list]))/binary, (length(P0_list2)):16, (list_to_binary([<<P1_id:32/signed, P1_pkey:32/signed, P1_sex:8/signed, P1_lv:16/signed, (proto:write_string(P1_avatar))/binary>> || [P1_id, P1_pkey, P1_sex, P1_lv, P1_avatar] <- P0_list2]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 57007:16,0:8, D_a_t_a/binary>>};


%% 领取奖励 
write(57008, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 57008:16,0:8, D_a_t_a/binary>>};


%% 当前活动状态 
write(57009, {P0_status, P0_time, P0_my_has_drop_num, P0_base_has_drop_num}) ->
    D_a_t_a = <<P0_status:8/signed, P0_time:32/signed, P0_my_has_drop_num:8, P0_base_has_drop_num:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 57009:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



