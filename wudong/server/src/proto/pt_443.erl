%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2018-04-12 18:29:08
%%----------------------------------------------------
-module(pt_443).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"已领取"; 
err(3) ->"扫荡次数已满"; 
err(4) ->"已通关"; 
err(5) ->"请先挑战前置关卡"; 
err(6) ->"当前没有宠物出战"; 
err(7) ->"未达成"; 
err(8) ->"当前关卡未通关，不可扫荡"; 
err(9) ->"不可上阵相同类型宠物"; 
err(10) ->"最多上阵5只宠物"; 
err(11) ->"等级不足"; 
err(12) ->"该章节暂未解锁一键扫荡"; 
err(13) ->"已无关卡可扫荡"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(44301, _B0) ->
    {ok, {}};

read(44302, _B0) ->
    {P0_key, _B1} = proto:read_key(_B0),
    {P0_map_id, _B2} = proto:read_uint8(_B1),
    {P0_pos, _B3} = proto:read_uint8(_B2),
    {ok, {P0_key, P0_map_id, P0_pos}};

read(44303, _B0) ->
    {P0_key, _B1} = proto:read_key(_B0),
    {P0_map_id, _B2} = proto:read_uint8(_B1),
    {ok, {P0_key, P0_map_id}};

read(44304, _B0) ->
    {P0_key1, _B1} = proto:read_key(_B0),
    {P0_key2, _B2} = proto:read_key(_B1),
    {P0_map_id, _B3} = proto:read_uint8(_B2),
    {ok, {P0_key1, P0_key2, P0_map_id}};

read(44305, _B0) ->
    {ok, {}};

read(44306, _B0) ->
    {ok, {}};

read(44307, _B0) ->
    {P0_dun_id, _B1} = proto:read_uint32(_B0),
    {P0_map_id, _B2} = proto:read_uint8(_B1),
    {ok, {P0_dun_id, P0_map_id}};

read(44308, _B0) ->
    {P0_chapter, _B1} = proto:read_uint8(_B0),
    {P0_star, _B2} = proto:read_uint8(_B1),
    {ok, {P0_chapter, P0_star}};

read(44309, _B0) ->
    {P0_dun_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_dun_id}};

read(44310, _B0) ->
    {P0_use_map_id, _B1} = proto:read_uint8(_B0),
    {ok, {P0_use_map_id}};

read(44311, _B0) ->
    {P0_dun_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_dun_id}};

read(44312, _B0) ->
    {P0_dun_id, _B1} = proto:read_uint32(_B0),
    {ok, {P0_dun_id}};

read(44313, _B0) ->
    {P0_chapter, _B1} = proto:read_uint8(_B0),
    {ok, {P0_chapter}};

read(44314, _B0) ->
    {P0_chapter, _B1} = proto:read_uint8(_B0),
    {ok, {P0_chapter}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 战斗数据 
write(44301, {P0_result, P0_round, P0_aer_list, P0_der_list, P0_war_data}) ->
    D_a_t_a = zlib:compress(<<P0_result:8, P0_round:8, (length(P0_aer_list)):16, (list_to_binary([<<P1_sign:8, (proto:write_string(P1_key))/binary, (proto:write_string(P1_name))/binary, P1_war_pos:8, P1_star:8, P1_figure_id:32, P1_type_id:32>> || [P1_sign, P1_key, P1_name, P1_war_pos, P1_star, P1_figure_id, P1_type_id] <- P0_aer_list]))/binary, (length(P0_der_list)):16, (list_to_binary([<<P1_sign:8, (proto:write_string(P1_key))/binary, (proto:write_string(P1_name))/binary, P1_war_pos:8, P1_star:8, P1_figure_id:32, P1_type_id:32>> || [P1_sign, P1_key, P1_name, P1_war_pos, P1_star, P1_figure_id, P1_type_id] <- P0_der_list]))/binary, (length(P0_war_data)):16, (list_to_binary([<<P1_round:8, (proto:write_string(P1_key))/binary, P1_hurt:32, P1_hp:32, P1_hp_lim:32, P1_rage:16, P1_rage_lim:16, P1_skill_id:32, (length(P1_att_status_list)):16, (list_to_binary([<<(proto:write_string(P2_key))/binary, (length(P2_status_list)):16, (list_to_binary([<<P3_status:8>> || P3_status <- P2_status_list]))/binary>> || [P2_key, P2_status_list] <- P1_att_status_list]))/binary, (length(P1_def_list)):16, (list_to_binary([<<(proto:write_string(P2_key))/binary, P2_hurt:32, P2_hp:32, P2_hp_lim:32, P2_rage:16, P2_rage_lim:16, (length(P2_status_list)):16, (list_to_binary([<<P3_status:8>> || P3_status <- P2_status_list]))/binary>> || [P2_key, P2_hurt, P2_hp, P2_hp_lim, P2_rage, P2_rage_lim, P2_status_list] <- P1_def_list]))/binary>> || [P1_round, P1_key, P1_hurt, P1_hp, P1_hp_lim, P1_rage, P1_rage_lim, P1_skill_id, P1_att_status_list, P1_def_list] <- P0_war_data]))/binary>>),
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44301:16,1:8, D_a_t_a/binary>>};


%% 宠物上阵 
write(44302, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44302:16,0:8, D_a_t_a/binary>>};


%% 宠物下阵 
write(44303, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44303:16,0:8, D_a_t_a/binary>>};


%% 宠物位置交换 
write(44304, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44304:16,0:8, D_a_t_a/binary>>};


%% 获取宠物阵型 
write(44305, {P0_use_map_id, P0_map_list}) ->
    D_a_t_a = <<P0_use_map_id:8, (length(P0_map_list)):16, (list_to_binary([<<P1_map_id:8, (proto:write_string(P1_key))/binary, P1_pos:8>> || [P1_map_id, P1_key, P1_pos] <- P0_map_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44305:16,0:8, D_a_t_a/binary>>};


%% 宠物对战副本链 
write(44306, {P0_dun_id, P0_chapter, P0_is_challenge}) ->
    D_a_t_a = <<P0_dun_id:32, P0_chapter:8, P0_is_challenge:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44306:16,0:8, D_a_t_a/binary>>};


%% 对战怪物，发起挑战 
write(44307, {P0_code, P0_pass_reward}) ->
    D_a_t_a = <<P0_code:8, (length(P0_pass_reward)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_pass_reward]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44307:16,0:8, D_a_t_a/binary>>};


%% 领取星数奖励 
write(44308, {P0_code, P0_reward}) ->
    D_a_t_a = <<P0_code:8, (length(P0_reward)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_reward]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44308:16,0:8, D_a_t_a/binary>>};


%% 副本扫荡ID 
write(44309, {P0_code, P0_pass_reward}) ->
    D_a_t_a = <<P0_code:8, (length(P0_pass_reward)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_pass_reward]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44309:16,0:8, D_a_t_a/binary>>};


%% 更改当前使用阵型ID 
write(44310, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44310:16,0:8, D_a_t_a/binary>>};


%% 获取副本面板信息 
write(44311, {P0_saodang, P0_first_pass_reward, P0_daily_pass_reward}) ->
    D_a_t_a = <<P0_saodang:8, (length(P0_first_pass_reward)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_first_pass_reward]))/binary, (length(P0_daily_pass_reward)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_daily_pass_reward]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44311:16,0:8, D_a_t_a/binary>>};


%% 领取副本通关奖励 
write(44312, {P0_code}) ->
    D_a_t_a = <<P0_code:8>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44312:16,0:8, D_a_t_a/binary>>};


%% 章节星数信息 
write(44313, {P0_recv_star_list}) ->
    D_a_t_a = <<(length(P0_recv_star_list)):16, (list_to_binary([<<P1_star:16, P1_is_recv:8, (length(P1_reward)):16, (list_to_binary([<<P2_goods_id:32, P2_goods_num:32>> || [P2_goods_id, P2_goods_num] <- P1_reward]))/binary>> || [P1_star, P1_is_recv, P1_reward] <- P0_recv_star_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44313:16,0:8, D_a_t_a/binary>>};


%% 一键扫荡 
write(44314, {P0_code, P0_pass_reward}) ->
    D_a_t_a = <<P0_code:8, (length(P0_pass_reward)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_pass_reward]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 44314:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



