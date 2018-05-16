%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-10-30 14:22:47
%%----------------------------------------------------
-module(pt_403).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(1) ->"成功"; 
err(2) ->"护送中不能进入"; 
err(3) ->"巡游中不能进入"; 
err(4) ->"活动匹配中不能进入"; 
err(5) ->"不是野外场景"; 
err(6) ->"等级不足"; 
err(7) ->"跨服暂未开启"; 
err(8) ->"不在跨服深渊场景"; 
err(9) ->"服务器不存在"; 
err(10) ->"任务不存在"; 
err(11) ->"任务未达成"; 
err(12) ->"任务奖励已领取"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(40301, _B0) ->
    {ok, {}};

read(40302, _B0) ->
    {ok, {}};

read(40303, _B0) ->
    {ok, {}};

read(40304, _B0) ->
    {ok, {}};

read(40305, _B0) ->
    {P0_task_id, _B1} = proto:read_int32(_B0),
    {ok, {P0_task_id}};

read(40306, _B0) ->
    {P0_scene_id, _B1} = proto:read_int32(_B0),
    {P0_peace, _B2} = proto:read_uint8(_B1),
    {ok, {P0_scene_id, P0_peace}};

read(40307, _B0) ->
    {ok, {}};

read(40308, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 魔宫深渊面板 
write(40301, {P0_p_task_list, P0_s_task_list, P0_b_id, P0_rank_list, P0_local_val}) ->
    D_a_t_a = <<(length(P0_p_task_list)):16, (list_to_binary([<<P1_task_id:32/signed, P1_task_num:32/signed, P1_state:8>> || [P1_task_id, P1_task_num, P1_state] <- P0_p_task_list]))/binary, (length(P0_s_task_list)):16, (list_to_binary([<<P1_task_id:32/signed, P1_task_num:32/signed, P1_state:8>> || [P1_task_id, P1_task_num, P1_state] <- P0_s_task_list]))/binary, P0_b_id:16/signed, (length(P0_rank_list)):16, (list_to_binary([<<(proto:write_string(P1_server_name))/binary, P1_value:32/signed>> || [P1_server_name, P1_value] <- P0_rank_list]))/binary, P0_local_val:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40301:16,0:8, D_a_t_a/binary>>};


%% 魔宫深渊个人排名 
write(40302, {P0_p_rank_list, P0_my_rank}) ->
    D_a_t_a = <<(length(P0_p_rank_list)):16, (list_to_binary([<<P1_rank_id:16/signed, (proto:write_string(P1_nick_name))/binary, (proto:write_string(P1_server_name))/binary, P1_kill_p_num:32/signed, P1_kill_m_num:32/signed, P1_value:32/signed>> || [P1_rank_id, P1_nick_name, P1_server_name, P1_kill_p_num, P1_kill_m_num, P1_value] <- P0_p_rank_list]))/binary, P0_my_rank:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40302:16,0:8, D_a_t_a/binary>>};


%% 魔宫深渊服务器排名 
write(40303, {P0_p_rank_list, P0_server_rank}) ->
    D_a_t_a = <<(length(P0_p_rank_list)):16, (list_to_binary([<<P1_rank_id:16/signed, (proto:write_string(P1_server_name))/binary, P1_t_num:32/signed, P1_value:32/signed>> || [P1_rank_id, P1_server_name, P1_t_num, P1_value] <- P0_p_rank_list]))/binary, P0_server_rank:16/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40303:16,0:8, D_a_t_a/binary>>};


%% 场景等级信息 
write(40304, {P0_lv_info}) ->
    D_a_t_a = <<(length(P0_lv_info)):16, (list_to_binary([<<P1_scene_id:32/signed, P1_min_lv:16/signed, P1_max_lv:16/signed>> || [P1_scene_id, P1_min_lv, P1_max_lv] <- P0_lv_info]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40304:16,0:8, D_a_t_a/binary>>};


%% 领取奖励 
write(40305, {P0_err_code}) ->
    D_a_t_a = <<P0_err_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40305:16,0:8, D_a_t_a/binary>>};


%% 请求进入场景 
write(40306, {P0_err_code}) ->
    D_a_t_a = <<P0_err_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40306:16,0:8, D_a_t_a/binary>>};


%% 退出场景 
write(40307, {P0_err_code}) ->
    D_a_t_a = <<P0_err_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40307:16,0:8, D_a_t_a/binary>>};


%% 面板信息实时推送 
write(40308, {P0_p_task_list, P0_s_task_list, P0_b_id, P0_m_val, P0_s_val}) ->
    D_a_t_a = <<(length(P0_p_task_list)):16, (list_to_binary([<<P1_task_id:32/signed, P1_task_num:32/signed, P1_state:8>> || [P1_task_id, P1_task_num, P1_state] <- P0_p_task_list]))/binary, (length(P0_s_task_list)):16, (list_to_binary([<<P1_task_id:32/signed, P1_task_num:32/signed, P1_state:8>> || [P1_task_id, P1_task_num, P1_state] <- P0_s_task_list]))/binary, P0_b_id:16/signed, P0_m_val:32/signed, P0_s_val:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 40308:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



