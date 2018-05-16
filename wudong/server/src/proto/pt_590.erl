%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-09-13 10:23:21
%%----------------------------------------------------
-module(pt_590).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"野外场景才能参加"; 
err(3) ->"护送中"; 
err(4) ->"好友没有在匹配中"; 
err(5) ->"好友不在线"; 
err(6) ->"没有在消消乐场景中"; 
err(7) ->"等级不足45级"; 
err(8) ->"没有奖励可领取"; 
err(9) ->"您正处于匹配队列中无法进入"; 
err(10) ->"巡游中"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(59001, _B0) ->
    {P0_page, _B1} = proto:read_int8(_B0),
    {ok, {P0_page}};

read(59002, _B0) ->
    {ok, {}};

read(59003, _B0) ->
    {ok, {}};

read(59004, _B0) ->
    {P0_key_list, _B3} = proto:read_array(_B0, fun(_B1) ->
        {P1_pkey, _B2} = proto:read_uint32(_B1),
        {P1_pkey, _B2}
    end),
    {ok, {P0_key_list}};

read(59005, _B0) ->
    {ok, {}};

read(59006, _B0) ->
    {P0_key, _B1} = proto:read_uint32(_B0),
    {ok, {P0_key}};

read(59007, _B0) ->
    {ok, {}};

read(59008, _B0) ->
    {ok, {}};

read(59009, _B0) ->
    {ok, {}};

read(59010, _B0) ->
    {ok, {}};

read(59011, _B0) ->
    {ok, {}};

read(59012, _B0) ->
    {ok, {}};

read(59013, _B0) ->
    {ok, {}};

read(59014, _B0) ->
    {P0_id, _B1} = proto:read_int32(_B0),
    {ok, {P0_id}};

read(59015, _B0) ->
    {ok, {}};

read(59016, _B0) ->
    {ok, {}};

read(59017, _B0) ->
    {P0_key, _B1} = proto:read_uint32(_B0),
    {ok, {P0_key}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 排行榜 
write(59001, {P0_page, P0_max_page, P0_myrank, P0_mywins, P0_lastrank, P0_rank_list}) ->
    D_a_t_a = <<P0_page:8/signed, P0_max_page:8/signed, P0_myrank:16/signed, P0_mywins:16/signed, P0_lastrank:16/signed, (length(P0_rank_list)):16, (list_to_binary([<<P1_sn:32/signed, (proto:write_string(P1_nickname))/binary, P1_wins:32/signed, P1_rank:16/signed>> || [P1_sn, P1_nickname, P1_wins, P1_rank] <- P0_rank_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 59001:16,0:8, D_a_t_a/binary>>};


%% 个人匹配 
write(59002, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 59002:16,0:8, D_a_t_a/binary>>};


%% 取消匹配 
write(59003, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 59003:16,0:8, D_a_t_a/binary>>};


%% 邀请好友 
write(59004, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 59004:16,0:8, D_a_t_a/binary>>};


%% 收到邀请 
write(59005, {P0_key, P0_nickname, P0_avatar, P0_sex}) ->
    D_a_t_a = <<P0_key:32, (proto:write_string(P0_nickname))/binary, (proto:write_string(P0_avatar))/binary, P0_sex:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 59005:16,0:8, D_a_t_a/binary>>};


%% 回应邀请 
write(59006, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 59006:16,0:8, D_a_t_a/binary>>};


%% 匹配成功信息 
write(59007, {P0_sn, P0_pkey, P0_nickname, P0_career, P0_sex, P0_cbp, P0_vip, P0_fashion_cloth_id, P0_light_weaponid, P0_wing_id, P0_clothing_id, P0_weapon_id, P0_time, P0_avatar}) ->
    D_a_t_a = <<P0_sn:32/signed, P0_pkey:32, (proto:write_string(P0_nickname))/binary, P0_career:8/signed, P0_sex:8/signed, P0_cbp:32/signed, P0_vip:8/signed, P0_fashion_cloth_id:32/signed, P0_light_weaponid:32/signed, P0_wing_id:32/signed, P0_clothing_id:32/signed, P0_weapon_id:32/signed, P0_time:8/signed, (proto:write_string(P0_avatar))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 59007:16,0:8, D_a_t_a/binary>>};


%% 比分信息 
write(59008, {P0_time, P0_score_list}) ->
    D_a_t_a = <<P0_time:32/signed, (length(P0_score_list)):16, (list_to_binary([<<P1_key:32, P1_score:32/signed, P1_score_lim:32/signed>> || [P1_key, P1_score, P1_score_lim] <- P0_score_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 59008:16,0:8, D_a_t_a/binary>>};


%% 怪物BUFF信息 
write(59009, {P0_buff_list}) ->
    D_a_t_a = <<(length(P0_buff_list)):16, (list_to_binary([<<P1_id:8/signed, P1_buff_id:32/signed, P1_x:8/signed, P1_y:8/signed>> || [P1_id, P1_buff_id, P1_x, P1_y] <- P0_buff_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 59009:16,0:8, D_a_t_a/binary>>};


%% 中BUFF信息 
write(59010, {P0_key, P0_buff_list}) ->
    D_a_t_a = <<P0_key:32, (length(P0_buff_list)):16, (list_to_binary([<<P1_id:8/signed, P1_buff_id:32/signed, P1_x:8/signed, P1_y:8/signed>> || [P1_id, P1_buff_id, P1_x, P1_y] <- P0_buff_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 59010:16,0:8, D_a_t_a/binary>>};


%% 怪物消除信息 
write(59011, {P0_key, P0_doublehit, P0_mon_list}) ->
    D_a_t_a = <<P0_key:32, P0_doublehit:8/signed, (length(P0_mon_list)):16, (list_to_binary([<<P1_id:8/signed, P1_x:8/signed, P1_y:8/signed, P1_score:8/signed>> || [P1_id, P1_x, P1_y, P1_score] <- P0_mon_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 59011:16,0:8, D_a_t_a/binary>>};


%% 结算信息 
write(59012, {P0_mon_list}) ->
    D_a_t_a = <<(length(P0_mon_list)):16, (list_to_binary([<<P1_sn:32/signed, P1_pkey:32, (proto:write_string(P1_nickname))/binary, P1_career:8/signed, P1_sex:8/signed, (proto:write_string(P1_avatar))/binary, P1_vip:8/signed, P1_score:32/signed, P1_ret:8/signed, (length(P1_goods_list)):16, (list_to_binary([<<P2_goods_id:32/signed, P2_num:32/signed>> || [P2_goods_id, P2_num] <- P1_goods_list]))/binary>> || [P1_sn, P1_pkey, P1_nickname, P1_career, P1_sex, P1_avatar, P1_vip, P1_score, P1_ret, P1_goods_list] <- P0_mon_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 59012:16,0:8, D_a_t_a/binary>>};


%% 退出 
write(59013, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 59013:16,0:8, D_a_t_a/binary>>};


%% 发表情 
write(59014, {P0_pkey, P0_id}) ->
    D_a_t_a = <<P0_pkey:32, P0_id:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 59014:16,0:8, D_a_t_a/binary>>};


%% 次数查询 
write(59015, {P0_times, P0_max_times}) ->
    D_a_t_a = <<P0_times:8/signed, P0_max_times:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 59015:16,0:8, D_a_t_a/binary>>};


%% 领取上周排名奖励 
write(59016, {P0_ret, P0_goods_list}) ->
    D_a_t_a = <<P0_ret:8/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 59016:16,0:8, D_a_t_a/binary>>};


%% 拒绝邀请 
write(59017, {P0_nickname}) ->
    D_a_t_a = <<(proto:write_string(P0_nickname))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 59017:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



