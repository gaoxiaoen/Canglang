%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-12-18 17:35:03
%%----------------------------------------------------
-module(pt_123).
-export([read/2, write/2]).

-include("common.hrl").
-include("dungeon.hrl").
-compile(export_all).

err(1) ->"成功"; 
err(2) ->"房间不存在"; 
err(3) ->"没有加入房间"; 
err(4) ->"野外普通场景才能挑战"; 
err(5) ->"你已经在房间中"; 
err(6) ->"副本不存在"; 
err(7) ->"该副本今日次数已用完"; 
err(8) ->"等级不足,不能挑战"; 
err(9) ->"护送中"; 
err(10) ->"房间人数已满"; 
err(11) ->"等级不足"; 
err(12) ->"你没有权限踢人"; 
err(13) ->"玩家不在您的房间中"; 
err(14) ->"密码不正确"; 
err(15) ->"战力不符合"; 
err(16) ->"房间已满人"; 
err(17) ->"您被请离房间"; 
err(18) ->"玩家离线了"; 
err(19) ->"招募冷却中,稍后重试"; 
err(20) ->"长时间未开启副本，房间关闭"; 
err(21) ->"你不是房主,不能开启"; 
err(22) ->"有玩家未准备好"; 
err(23) ->"不能踢自己"; 
err(24) ->"您正处于匹配队列中无法进入"; 
err(25) ->"巡游中"; 
err(26) ->"已经领取"; 
err(27) ->"次数不足"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(12300, _B0) ->
    {ok, {}};

read(12301, _B0) ->
    {P0_dungeon_id, _B1} = proto:read_int32(_B0),
    {ok, {P0_dungeon_id}};

read(12302, _B0) ->
    {P0_dungeon_id, _B1} = proto:read_int32(_B0),
    {P0_password, _B2} = proto:read_string(_B1),
    {P0_is_fast, _B3} = proto:read_int8(_B2),
    {ok, {P0_dungeon_id, P0_password, P0_is_fast}};

read(12303, _B0) ->
    {ok, {}};

read(12304, _B0) ->
    {ok, {}};

read(12305, _B0) ->
    {ok, {}};

read(12306, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_pkey}};

read(12307, _B0) ->
    {ok, {}};

read(12308, _B0) ->
    {P0_dungeon_id, _B1} = proto:read_int32(_B0),
    {P0_key, _B2} = proto:read_key(_B1),
    {P0_password, _B3} = proto:read_string(_B2),
    {P0_is_ready, _B4} = proto:read_int8(_B3),
    {ok, {P0_dungeon_id, P0_key, P0_password, P0_is_ready}};

read(12309, _B0) ->
    {ok, {}};

read(12310, _B0) ->
    {ok, {}};

read(12311, _B0) ->
    {P0_dungeon_id, _B1} = proto:read_int32(_B0),
    {P0_type, _B2} = proto:read_int8(_B1),
    {ok, {P0_dungeon_id, P0_type}};

read(12312, _B0) ->
    {P0_pkey, _B1} = proto:read_uint32(_B0),
    {ok, {P0_pkey}};

read(12313, _B0) ->
    {ok, {}};

read(12314, _B0) ->
    {ok, {}};

read(12315, _B0) ->
    {ok, {}};

read(12320, _B0) ->
    {ok, {}};

read(12321, _B0) ->
    {ok, {}};

read(12322, _B0) ->
    {ok, {}};

read(12323, _B0) ->
    {P0_dungeon_id, _B1} = proto:read_int32(_B0),
    {P0_key, _B2} = proto:read_key(_B1),
    {P0_password, _B3} = proto:read_string(_B2),
    {P0_is_fast, _B4} = proto:read_int8(_B3),
    {P0_is_ready, _B5} = proto:read_int8(_B4),
    {ok, {P0_dungeon_id, P0_key, P0_password, P0_is_fast, P0_is_ready}};

read(12325, _B0) ->
    {P0_times, _B1} = proto:read_int16(_B0),
    {ok, {P0_times}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 获取副本列表 
write(12300, {P0_times, P0_max_times, P0_repute, P0_dun_list, P0_times_list}) ->
    D_a_t_a = <<P0_times:16/signed, P0_max_times:16/signed, P0_repute:32/signed, (length(P0_dun_list)):16, (list_to_binary([<<P1_dungeon_id:32/signed, P1_state:8/signed>> || [P1_dungeon_id, P1_state] <- P0_dun_list]))/binary, (length(P0_times_list)):16, (list_to_binary([<<P1_times:32/signed, P1_state:8/signed, P1_type:8/signed, (length(P1_reward_list)):16, (list_to_binary([<<P2_goods_id:32/signed, P2_goods_num:32/signed>> || [P2_goods_id, P2_goods_num] <- P1_reward_list]))/binary>> || [P1_times, P1_state, P1_type, P1_reward_list] <- P0_times_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12300:16,0:8, D_a_t_a/binary>>};


%% 获取房间列表 
write(12301, {P0_room_list}) ->
    D_a_t_a = <<(length(P0_room_list)):16, (list_to_binary([<<(proto:write_string(P1_key))/binary, P1_sn:32/signed, (proto:write_string(P1_nickname))/binary, P1_career:8/signed, P1_sex:8/signed, (proto:write_string(P1_password))/binary, P1_is_fast:8/signed, P1_mb:8/signed, P1_mb_lim:8/signed, (proto:write_string(P1_avatar))/binary, P1_state:8/signed>> || [P1_key, P1_sn, P1_nickname, P1_career, P1_sex, P1_password, P1_is_fast, P1_mb, P1_mb_lim, P1_avatar, P1_state] <- P0_room_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12301:16,0:8, D_a_t_a/binary>>};


%% 创建房间 
write(12302, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12302:16,0:8, D_a_t_a/binary>>};


%% 更新玩家状态 
write(12303, {P0_cross_dun_state}) ->
    D_a_t_a = <<(proto:write_string(P0_cross_dun_state))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12303:16,0:8, D_a_t_a/binary>>};


%% 获取房间数据 
write(12304, {P0_dungeon_id, P0_key, P0_pkey, P0_is_fast, P0_password, P0_cd, P0_mb_list}) ->
    D_a_t_a = <<P0_dungeon_id:32/signed, (proto:write_string(P0_key))/binary, P0_pkey:32, P0_is_fast:8/signed, (proto:write_string(P0_password))/binary, P0_cd:8/signed, (length(P0_mb_list)):16, (list_to_binary([<<P1_sn:32/signed, P1_pkey1:32, (proto:write_string(P1_nickname))/binary, P1_career:8/signed, P1_sex:8/signed, P1_cbp:32/signed, P1_is_ready:8/signed, (proto:write_string(P1_avatar))/binary>> || [P1_sn, P1_pkey1, P1_nickname, P1_career, P1_sex, P1_cbp, P1_is_ready, P1_avatar] <- P0_mb_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12304:16,0:8, D_a_t_a/binary>>};


%% 退出房间 
write(12305, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12305:16,0:8, D_a_t_a/binary>>};


%% 房主踢人 
write(12306, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12306:16,0:8, D_a_t_a/binary>>};


%% 通知被踢 
write(12307, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12307:16,0:8, D_a_t_a/binary>>};


%% 加入房间 
write(12308, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12308:16,0:8, D_a_t_a/binary>>};


%% 准备 
write(12309, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12309:16,0:8, D_a_t_a/binary>>};


%% 房主开始副本倒计时 
write(12310, {P0_state, P0_time}) ->
    D_a_t_a = <<P0_state:8/signed, P0_time:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12310:16,0:8, D_a_t_a/binary>>};


%% 获取邀请列表 
write(12311, {P0_mb_list}) ->
    D_a_t_a = <<(length(P0_mb_list)):16, (list_to_binary([<<P1_pkey:32, (proto:write_string(P1_nickname))/binary, P1_lv:16/signed, P1_cbp:32/signed>> || [P1_pkey, P1_nickname, P1_lv, P1_cbp] <- P0_mb_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12311:16,0:8, D_a_t_a/binary>>};


%% 邀请玩家 
write(12312, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12312:16,0:8, D_a_t_a/binary>>};


%% 收到邀请 
write(12313, {P0_nickname, P0_dungeon_id, P0_key, P0_password}) ->
    D_a_t_a = <<(proto:write_string(P0_nickname))/binary, P0_dungeon_id:32/signed, (proto:write_string(P0_key))/binary, (proto:write_string(P0_password))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12313:16,0:8, D_a_t_a/binary>>};


%% 招募公告 
write(12314, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12314:16,0:8, D_a_t_a/binary>>};


%% 手动开启副本 
write(12315, {P0_code, P0_time}) ->
    D_a_t_a = <<P0_code:8/signed, P0_time:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12315:16,0:8, D_a_t_a/binary>>};


%% 退出副本 
write(12320, {}) ->
    D_a_t_a = <<>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12320:16,0:8, D_a_t_a/binary>>};


%% 副本目标 
write(12321, {P0_time, P0_mb_list}) ->
    D_a_t_a = <<P0_time:16/signed, (length(P0_mb_list)):16, (list_to_binary([<<P1_sn:32/signed, P1_pkey:32, (proto:write_string(P1_nickname))/binary, (proto:write_string(P1_hurt))/binary>> || [P1_sn, P1_pkey, P1_nickname, P1_hurt] <- P0_mb_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12321:16,0:8, D_a_t_a/binary>>};


%% 副本结算 
write(12322, {P0_ret, P0_dungeon_id, P0_key, P0_password, P0_is_fast, P0_is_ready, P0_goods_list}) ->
    D_a_t_a = <<P0_ret:8/signed, P0_dungeon_id:32/signed, (proto:write_string(P0_key))/binary, (proto:write_string(P0_password))/binary, P0_is_fast:8/signed, P0_is_ready:8/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_num:32/signed, P1_type:8/signed>> || [P1_goods_id, P1_num, P1_type] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12322:16,0:8, D_a_t_a/binary>>};


%% 有密码重回房间 
write(12323, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12323:16,0:8, D_a_t_a/binary>>};


%% 领取次数奖励 
write(12325, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12325:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



