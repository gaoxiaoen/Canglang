%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-05-16 17:58:04
%%----------------------------------------------------
-module(pt_260).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"你已经在答题场景了"; 
err(3) ->"不能从该场景进入"; 
err(4) ->"答题活动还没开启"; 
err(5) ->"等级不足，不能进入答题"; 
err(6) ->"该题已使用其他道具"; 
err(7) ->"该道具的使用次数已达上限"; 
err(8) ->"活动还没开启"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(26000, _B0) ->
    {ok, {}};

read(26001, _B0) ->
    {ok, {}};

read(26002, _B0) ->
    {ok, {}};

read(26003, _B0) ->
    {ok, {}};

read(26004, _B0) ->
    {ok, {}};

read(26005, _B0) ->
    {P0_select, _B1} = proto:read_int8(_B0),
    {ok, {P0_select}};

read(26006, _B0) ->
    {P0_type, _B1} = proto:read_int8(_B0),
    {ok, {P0_type}};

read(26007, _B0) ->
    {ok, {}};

read(26008, _B0) ->
    {ok, {}};

read(26009, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 活动状态 
write(26000, {P0_state, P0_time}) ->
    D_a_t_a = <<P0_state:8/signed, P0_time:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 26000:16,0:8, D_a_t_a/binary>>};


%% 进入答题场景 
write(26001, {P0_res}) ->
    D_a_t_a = <<P0_res:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 26001:16,0:8, D_a_t_a/binary>>};


%% 退出答题场景 
write(26002, {P0_res}) ->
    D_a_t_a = <<P0_res:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 26002:16,0:8, D_a_t_a/binary>>};


%% 准备开始下一道题 服务端推动 
write(26003, {P0_leave_time}) ->
    D_a_t_a = <<P0_leave_time:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 26003:16,0:8, D_a_t_a/binary>>};


%% 题目信息 服务端推送 
write(26004, {P0_id, P0_leave_time, P0_leave_num, P0_right_num, P0_use_type, P0_type_list, P0_rank_list, P0_myrank, P0_mypoint, P0_myexp, P0_mycopy, P0_myselect}) ->
    D_a_t_a = <<P0_id:16/signed, P0_leave_time:8/signed, P0_leave_num:8/signed, P0_right_num:8/signed, P0_use_type:8/signed, (length(P0_type_list)):16, (list_to_binary([<<P1_type:8/signed, P1_leave_times:8/signed>> || [P1_type, P1_leave_times] <- P0_type_list]))/binary, (length(P0_rank_list)):16, (list_to_binary([<<P1_rank:8/signed, P1_pkey:32, (proto:write_string(P1_name))/binary, P1_point:32/signed, P1_right_times:32/signed>> || [P1_rank, P1_pkey, P1_name, P1_point, P1_right_times] <- P0_rank_list]))/binary, P0_myrank:8/signed, P0_mypoint:32/signed, P0_myexp:32/signed, P0_mycopy:8/signed, P0_myselect:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 26004:16,0:8, D_a_t_a/binary>>};


%% 答题 
write(26005, {P0_res}) ->
    D_a_t_a = <<P0_res:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 26005:16,0:8, D_a_t_a/binary>>};


%% 使用道具 
write(26006, {P0_res, P0_type}) ->
    D_a_t_a = <<P0_res:8/signed, P0_type:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 26006:16,0:8, D_a_t_a/binary>>};


%% 答题结果 服务端推送 
write(26007, {P0_id, P0_res, P0_get_point, P0_right_res}) ->
    D_a_t_a = <<P0_id:16/signed, P0_res:8/signed, P0_get_point:16/signed, P0_right_res:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 26007:16,0:8, D_a_t_a/binary>>};


%% 查看排名 
write(26008, {P0_copy_list, P0_reward_list}) ->
    D_a_t_a = <<(length(P0_copy_list)):16, (list_to_binary([<<P1_copy:8/signed, (length(P1_rank_list)):16, (list_to_binary([<<P2_rank:8/signed, P2_pkey:32, (proto:write_string(P2_name))/binary, P2_point:32/signed, P2_right_times:32/signed>> || [P2_rank, P2_pkey, P2_name, P2_point, P2_right_times] <- P1_rank_list]))/binary>> || [P1_copy, P1_rank_list] <- P0_copy_list]))/binary, (length(P0_reward_list)):16, (list_to_binary([<<P1_min_rank:8/signed, P1_max_rank:8/signed, (length(P1_reward_list)):16, (list_to_binary([<<P2_goods_id:32/signed, P2_goods_num:32/signed>> || [P2_goods_id, P2_goods_num] <- P1_reward_list]))/binary>> || [P1_min_rank, P1_max_rank, P1_reward_list] <- P0_reward_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 26008:16,0:8, D_a_t_a/binary>>};


%% 结算 
write(26009, {P0_max_num, P0_right_num, P0_point, P0_rank, P0_reward_list, P0_rank_list}) ->
    D_a_t_a = <<P0_max_num:8/signed, P0_right_num:8/signed, P0_point:32/signed, P0_rank:32/signed, (length(P0_reward_list)):16, (list_to_binary([<<P1_goods_id:32/signed, P1_goods_num:32/signed>> || [P1_goods_id, P1_goods_num] <- P0_reward_list]))/binary, (length(P0_rank_list)):16, (list_to_binary([<<P1_rank:8/signed, P1_pkey:32, (proto:write_string(P1_name))/binary, P1_point:32/signed, P1_right_times:32/signed>> || [P1_rank, P1_pkey, P1_name, P1_point, P1_right_times] <- P0_rank_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 26009:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



