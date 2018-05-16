%%----------------------------------------------------
%% 通讯协议编码、解码处理
%% author by 苍狼工作室
%% createtime 2017-11-15 17:57:44
%%----------------------------------------------------
-module(pt_126).
-export([read/2, write/2]).

-include("common.hrl").
-compile(export_all).

err(0) ->"失败"; 
err(1) ->"成功"; 
err(2) ->"对方不在线"; 
err(3) ->"元宝不足"; 
err(4) ->"今日已经重置次数用完"; 
err(5) ->"请先寻找伴侣吧"; 
err(6) ->"已扫荡过"; 
err(_) ->"未定义错误" .

%%----------------------------------------------------
%% 解包命令
%%----------------------------------------------------

read(12600, _B0) ->
    {ok, {}};

read(12601, _B0) ->
    {P0_pkey, _B1} = proto:read_int32(_B0),
    {ok, {P0_pkey}};

read(12602, _B0) ->
    {ok, {}};

read(12603, _B0) ->
    {P0_type, _B1} = proto:read_int8(_B0),
    {P0_pkey, _B2} = proto:read_int32(_B1),
    {ok, {P0_type, P0_pkey}};

read(12604, _B0) ->
    {ok, {}};

read(12605, _B0) ->
    {ok, {}};

read(12606, _B0) ->
    {ok, {}};

read(12607, _B0) ->
    {ok, {}};

read(12608, _B0) ->
    {ok, {}};

read(12609, _B0) ->
    {P0_id, _B1} = proto:read_int8(_B0),
    {P0_result, _B2} = proto:read_int8(_B1),
    {ok, {P0_id, P0_result}};

read(12610, _B0) ->
    {ok, {}};

read(12611, _B0) ->
    {ok, {}};

read(_Cmd, _Bin) ->
    {error, {unknown_command, _Cmd}}.

%%----------------------------------------------------
%% 打包命令
%%----------------------------------------------------

%% 爱情试炼面板信息 
write(12600, {P0_status, P0_reward_list}) ->
    D_a_t_a = <<P0_status:8/signed, (length(P0_reward_list)):16, (list_to_binary([<<P1_goods_id:32, P1_goods_num:32>> || [P1_goods_id, P1_goods_num] <- P0_reward_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12600:16,0:8, D_a_t_a/binary>>};


%% 发起组队邀请 
write(12601, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12601:16,0:8, D_a_t_a/binary>>};


%% 收到组队邀请 
write(12602, {P0_pkey}) ->
    D_a_t_a = <<P0_pkey:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12602:16,0:8, D_a_t_a/binary>>};


%% 回应组队邀请 
write(12603, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12603:16,0:8, D_a_t_a/binary>>};


%% 收到邀请回应 
write(12604, {P0_type, P0_pkey}) ->
    D_a_t_a = <<P0_type:8/signed, P0_pkey:32/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12604:16,0:8, D_a_t_a/binary>>};


%% 副本重置 
write(12605, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12605:16,0:8, D_a_t_a/binary>>};


%% 爱情试炼副本结算 
write(12606, {P0_ret, P0_goods_list}) ->
    D_a_t_a = <<P0_ret:8/signed, (length(P0_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32>> || [P1_goods_id, P1_num] <- P0_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12606:16,0:8, D_a_t_a/binary>>};


%% 副本扫荡 
write(12607, {P0_code, P0_reward_list}) ->
    D_a_t_a = <<P0_code:8/signed, (length(P0_reward_list)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32>> || [P1_goods_id, P1_num] <- P0_reward_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12607:16,0:8, D_a_t_a/binary>>};


%% 副本任务信息 
write(12608, {P0_round, P0_kill_mon_num, P0_collect_num, P0_collect_num_max, P0_drop_goods_list}) ->
    D_a_t_a = <<P0_round:8, P0_kill_mon_num:16, P0_collect_num:8, P0_collect_num_max:8, (length(P0_drop_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32>> || [P1_goods_id, P1_num] <- P0_drop_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12608:16,0:8, D_a_t_a/binary>>};


%% 副本答题 
write(12609, {P0_code}) ->
    D_a_t_a = <<P0_code:8/signed>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12609:16,0:8, D_a_t_a/binary>>};


%% 答题信息（推送及更新） 
write(12610, {P0_id, P0_problem_list, P0_reward_list}) ->
    D_a_t_a = <<P0_id:8/signed, (length(P0_problem_list)):16, (list_to_binary([<<P1_pkey:32, P1_result:8>> || [P1_pkey, P1_result] <- P0_problem_list]))/binary, (length(P0_reward_list)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32>> || [P1_goods_id, P1_num] <- P0_reward_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12610:16,0:8, D_a_t_a/binary>>};


%% 副本结算 
write(12611, {P0_code, P0_pass_goods_list, P0_sp_goods_list, P0_answer_goods_list}) ->
    D_a_t_a = <<P0_code:8/signed, (length(P0_pass_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32>> || [P1_goods_id, P1_num] <- P0_pass_goods_list]))/binary, (length(P0_sp_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32>> || [P1_goods_id, P1_num] <- P0_sp_goods_list]))/binary, (length(P0_answer_goods_list)):16, (list_to_binary([<<P1_goods_id:32, P1_num:32>> || [P1_goods_id, P1_num] <- P0_answer_goods_list]))/binary>>,
    {ok, <<(byte_size(D_a_t_a) + 7):32, 12611:16,0:8, D_a_t_a/binary>>};


write(_Cmd, _Data) ->
    {error, {unknown_command, _Cmd}}.


%% --------------------------------------------------
%% 二进制函数
%% --------------------------------------------------



